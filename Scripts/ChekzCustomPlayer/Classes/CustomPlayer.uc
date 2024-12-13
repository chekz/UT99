//=============================================================================
// CustomPlayer: This is it, this is where the magic happens. All those fancy
// properties that come from CPSpawnNotify and CPTrigger. Well they end up
// here and maniuplate the players movement based off of those.
//
// Author: ch3kz
//=============================================================================
class CustomPlayer extends TournamentPlayer;

#exec AUDIO IMPORT FILE="Sounds\QuickReverbFart.wav" NAME="QuickReverbFart" GROUP="Farts"
#exec AUDIO IMPORT FILE="Sounds\SamusSpaceJumpStart.wav" NAME="SamusSpaceJumpStart" GROUP="SpaceJump"
#exec AUDIO IMPORT FILE="Sounds\SamusFlip.wav" NAME="SamusFlip" GROUP="SpaceJump"

var class<projectile> ProjectileToSpawn;
var projectile Projectile;
var sound QuickReverbFartSound;
//=============================================================================
// Class properties.
//=============================================================================
var bool bEnableWallDodge;
var bool bEnableWallDodgeOrig;
var bool bWasWallDodge;
var int WallDodgeLimit;
var int WallDodgeLimitOrig;
var int WallDodgesRemaining;
var bool bEnableMoverWallDodge;
var bool bEnableMoverWallDodgeOrig;
var bool bEnableBounceAfterWallDodge;
var bool bEnableBounceAfterWallDodgeOrig;

var bool bEnableAirDodge;
var bool bEnableAirDodgeOrig;
var int AirDodgeLimit;
var int AirDodgeLimitOrig;
var int AirDodgesRemaining;
var bool bWasAirDodge;
var bool bEnableBounceAfterAirDodge;
var bool bEnableBounceAfterAirDodgeOrig;

var bool bEnableLiftDodge;
var bool bEnableLiftDodgeOrig;

var bool bEnableDodgeBot;
var bool bEnableDodgeBotOrig;
var bool bEnableDodgeBotCall;
var bool bEnableDodgeBotCallOrig;

var sound SamusSpaceJumpStart;
var sound SamusFlip;
var bool bIsSpaceJumping;
var bool bEnableSpaceJump;
var bool bEnableSpaceJumpOrig;
var float SpaceJumpFallThreshold;
var float SpaceJumpFallThresholdOrig;
var float SpaceJumpUpThreshold;
var float SpaceJumpUpThresholdOrig;

var bool bDisableDodge;
var bool bDisableDodgeOrig;
var bool bDisableWalk;
var bool bDisableWalkOrig;
var bool bDisableForward;
var bool bDisableForwardOrig;
var bool bDisableBackward;
var bool bDisableBackwardOrig;
var bool bDisableLeft;
var bool bDisableLeftOrig;
var bool bDisableRight;
var bool bDisableRightOrig;
var sound JumpSoundOrig;
var bool bDisableJump;
var bool bDisableJumpOrig;
var float GroundSpeedOrig;
var float WaterSpeedOrig;
var float JumpZOrig;
var bool bUpdateWalkJumpHeight;
var bool bUpdateWalkJumpHeightOrig;
var float WalkJumpZ;
var float WalkJumpZOrig;
var bool bEnableDodgeLimit;
var bool bEnableDodgeLimitOrig;
var int DodgeLimit;
var int DodgeLimitOrig;
var bool bEnableCrouchDodge;
var bool bEnableCrouchDodgeOrig;
var bool bEnableWaterDodge;
var bool bWasGroundDodge;
var bool bEnableBounceAfterGroundDodge;
var bool bEnableBounceAfterGroundDodgeOrig;

var bool bEnableAssProjectile;
var bool bEnableAssProjectileOrig;
var bool bEnableAssProjectileCall;
var bool bEnableAssProjectileCallOrig;

var bool bTriggerEnabled;

replication
{
	//=============================================================================
	// Properties replicated from the server to the client.
	//=============================================================================
	reliable if ( Role == ROLE_Authority )
		bEnableWallDodge, WallDodgeLimit, bEnableMoverWallDodge,
		bEnableBounceAfterWallDodge,

		bEnableAirDodge, AirDodgeLimit, bEnableBounceAfterAirDodge,

		bEnableLiftDodge,

		bEnableDodgeBot, bEnableDodgeBotCall,

		bEnableSpaceJump, SpaceJumpFallThreshold, SpaceJumpUpThreshold,

		bDisableDodge, bDisableWalk, bDisableJump, GroundSpeedOrig,
		WaterSpeedOrig, JumpZOrig, bUpdateWalkJumpHeight,
		WalkJumpZ, WalkJumpZOrig, bEnableDodgeLimit, DodgeLimit,
		bEnableCrouchDodge, bEnableBounceAfterGroundDodge,

		bTriggerEnabled,

		ProjectileToSpawn, Projectile, QuickReverbFartSound,
		bEnableAssProjectile, bEnableAssProjectileCall;
}

// Player movement.
// Player Standing, walking, running, falling.
simulated state PlayerWalking
{
ignores SeePlayer, HearNoise, Bump;
	exec function FeignDeath()
	{
		if ( Physics == PHYS_Walking )
		{
			ServerFeignDeath();
			Acceleration = vect(0,0,0);
			GotoState('FeigningDeath');
		}
	}

	function ServerFeignDeath()
	{
		local Weapon W;

		W = Weapon;
		PendingWeapon = None;
		if ( Weapon != None )
			Weapon.PutDown();
		PendingWeapon = W;
		GotoState('FeigningDeath');
	}

	exec function OLOL()
	{
		if (bEnableDodgeBotCall)
		{
			if (bEnableDodgeBot == true)
				bEnableDodgeBot = false;
			else if (!bEnableDodgeBot)
				bEnableDodgeBot = true;
		}
	}

	// FIXME - Only works client side
	exec function Fart()
	{
		if (bEnableAssProjectileCall)
			bEnableAssProjectile = true;
	}

	event PlayerTick( float DeltaTime )
	{
		if ( bUpdatePosition )
			ClientUpdatePosition();

		PlayerMove(DeltaTime);
	}

	function PlayerMove( float DeltaTime )
	{
		local vector X,Y,Z, NewAccel;
		local EDodgeDir OldDodge;
		local eDodgeDir DodgeMove;
		local rotator OldRotation;
		local float Speed2D;
		local bool	bSaveJump;
		local name AnimGroupName;

		GetAxes(Rotation,X,Y,Z);

		if (bDisableWalk)
		{
			aForward = 0;
			aStrafe  = 0;
		} else
		{
			aForward *= 0.4;
			aStrafe  *= 0.4;
		}

		aLookup  *= 0.24;
		aTurn    *= 0.24;		

		// Update acceleration.
		NewAccel = aForward*X + aStrafe*Y;
		NewAccel.Z = 0;

		// Check for Dodge move
		if ( DodgeDir == DODGE_Active )
			DodgeMove = DODGE_Active;
		else
			DodgeMove = DODGE_None;
		if (DodgeClickTime > 0.0)
		{
			if ( DodgeDir < DODGE_Active )
			{
				OldDodge = DodgeDir;
				DodgeDir = DODGE_None;
				if (bEdgeForward && bWasForward)
					DodgeDir = DODGE_Forward;
				if (bEdgeBack && bWasBack)
					DodgeDir = DODGE_Back;
				if (bEdgeLeft && bWasLeft)
					DodgeDir = DODGE_Left;
				if (bEdgeRight && bWasRight)
					DodgeDir = DODGE_Right;
				if ( DodgeDir == DODGE_None)
					DodgeDir = OldDodge;
				else if ( DodgeDir != OldDodge )
					DodgeClickTimer = DodgeClickTime + 0.5 * DeltaTime;
				else
					DodgeMove = DodgeDir;
			}

			if (DodgeDir == DODGE_Done)
			{
				DodgeClickTimer -= DeltaTime;
				if (DodgeClickTimer < -0.35)
				{
					DodgeDir = DODGE_None;
					DodgeClickTimer = DodgeClickTime;
				}
			}
			else if ((DodgeDir != DODGE_None) && (DodgeDir != DODGE_Active))
			{
				DodgeClickTimer -= DeltaTime;
				if (DodgeClickTimer < 0)
				{
					DodgeDir = DODGE_None;
					DodgeClickTimer = DodgeClickTime;
				}
			}
		}

		AnimGroupName = GetAnimGroup(AnimSequence);
		if ( (Physics == PHYS_Walking) && (AnimGroupName != 'Dodge') )
		{
			//if walking, look up/down stairs - unless player is rotating view
			if ( !bKeyboardLook && (bLook == 0) )
			{
				if ( bLookUpStairs )
					ViewRotation.Pitch = FindStairRotation(deltaTime);
				else if ( bCenterView )
				{
					ViewRotation.Pitch = ViewRotation.Pitch & 65535;
					if (ViewRotation.Pitch > 32768)
						ViewRotation.Pitch -= 65536;
					ViewRotation.Pitch = ViewRotation.Pitch * (1 - 12 * FMin(0.0833, deltaTime));
					if ( Abs(ViewRotation.Pitch) < 1000 )
						ViewRotation.Pitch = 0;
				}
			}

			Speed2D = Sqrt(Velocity.X * Velocity.X + Velocity.Y * Velocity.Y);
			//add bobbing when walking
			if ( !bShowMenu )
				CheckBob(DeltaTime, Speed2D, Y);
		}
		else if ( !bShowMenu )
		{
			BobTime = 0;
			WalkBob = WalkBob * (1 - FMin(1, 8 * deltatime));
		}

		// Update rotation.
		OldRotation = Rotation;
		UpdateRotation(DeltaTime, 1);

		if (bEnableDodgeBot)
		{
			if (aForward > 0)
				DodgeMove = DODGE_Forward;
			else if (aForward < 0)
				DodgeMove = DODGE_BACK;
			else if (aStrafe < 0)
				DodgeMove = DODGE_RIGHT;
			else if (aStrafe > 0)
				DodgeMove = DODGE_LEFT;
		}

		if ( bPressedJump && (AnimGroupName == 'Dodge') )
		{
			bSaveJump = true;
			bPressedJump = false;
		}
		else
			bSaveJump = false;

		if ( Role < ROLE_Authority )
			ReplicateMove(DeltaTime, NewAccel, DodgeMove, OldRotation - Rotation);
		else
			ProcessMove(DeltaTime, NewAccel, DodgeMove, OldRotation - Rotation);
		
		bPressedJump = bSaveJump;
	}

	function ProcessMove(float DeltaTime, vector NewAccel, eDodgeDir DodgeMove, rotator DeltaRot)
	{
		local vector OldAccel;

		OldAccel = Acceleration;
		Acceleration = NewAccel;
		bIsTurning = ( Abs(DeltaRot.Yaw/DeltaTime) > 5000 );

		if ( (DodgeMove == DODGE_Active) && (Physics == PHYS_Falling) && !bEnableWallDodge  && !bEnableAirDodge )
			DodgeDir = DODGE_Active;
		else if ( (DodgeMove != DODGE_None) && (DodgeMove < DODGE_Active))
		{
			// Disable dodge check.
			if (!bDisableDodge)
			{
				// Dodge limit check.
				if (bEnableDodgeLimit && DodgeLimit > 0)
					Dodge(DodgeMove);
					
				// Normal dodge check.
				else if (!bEnableDodgeLimit)
					Dodge(DodgeMove);
			}
		}

		// FIXME - Only Works Client Side
		if (bEnableAssProjectile)
			FartAssRocket();

		// Disable jump check.
		if (bPressedJump && !bDisableJump)
		{
			DoJump();

			if (bEnableSpaceJump)
				DoSpaceJump();
		}

		if (bIsSpaceJumping)
		{
			ClientMessage("WE SPACE JUMPIN");
			PlaySound(SamusFlip, SLOT_Talk, 1.5, true, 1200, 1.0 );
		}

		if ( (Physics == PHYS_Walking) && (GetAnimGroup(AnimSequence) != 'Dodge') )
		{
			if (!bIsCrouching)
			{
				if (bDuck != 0)
				{
					bIsCrouching = true;
					PlayDuck();
				}
			}
			else if (bDuck == 0)
			{
				OldAccel = vect(0,0,0);
				bIsCrouching = false;
				TweenToRunning(0.1);
			}

			if ( !bIsCrouching )
			{
				if ( (!bAnimTransition || (AnimFrame > 0)) && (GetAnimGroup(AnimSequence) != 'Landing') )
				{
					if ( Acceleration != vect(0,0,0) )
					{
						if ( (GetAnimGroup(AnimSequence) == 'Waiting') || (GetAnimGroup(AnimSequence) == 'Gesture') || (GetAnimGroup(AnimSequence) == 'TakeHit') )
						{
							bAnimTransition = true;
							TweenToRunning(0.1);
						}
					}
			 		else if ( (Velocity.X * Velocity.X + Velocity.Y * Velocity.Y < 1000)
						&& (GetAnimGroup(AnimSequence) != 'Gesture') )
			 		{
			 			if ( GetAnimGroup(AnimSequence) == 'Waiting' )
			 			{
							if ( bIsTurning && (AnimFrame >= 0) )
							{
								bAnimTransition = true;
								PlayTurning();
							}
						}
			 			else if ( !bIsTurning )
						{
							bAnimTransition = true;
							TweenToWaiting(0.2);
						}
					}
				}
			}
			else
			{
				if ( (OldAccel == vect(0,0,0)) && (Acceleration != vect(0,0,0)) )
					PlayCrawling();
			 	else if ( !bIsTurning && (Acceleration == vect(0,0,0)) && (AnimFrame > 0.1) )
					PlayDuck();
			}
		}
	}

	function Dodge(eDodgeDir DodgeMove)
	{
		local vector X,Y,Z;

		// Wall dodge variables.
		local vector TraceStart, TraceEnd, HitLocation, HitNormal;

		local float VelocityZ;

		// Crouch dodge check.
		if (bIsCrouching && !bEnableCrouchDodge)
			return;

		GetAxes(Rotation, X, Y, Z);

		// Allows for almost perfect dodges
		// GetAxes(Rotation.Yaw*rot(0,1,0),X,Y,Z);

		// Air dodge check.
		if (bEnableAirDodge && Physics == PHYS_FALLING)
		{
			if (AirDodgesRemaining == 0)
				return;

			bWasAirDodge = True;
		} 	
		// Wall dodge check.
		else if (bEnableWallDodge && Physics == PHYS_FALLING)
		{
			if (WallDodgesRemaining == 0)
				return;

			if (DodgeMove == DODGE_Forward)
				TraceEnd = -X;
			else if (DodgeMove == DODGE_Back)
				TraceEnd = X;
			else if (DodgeMove == DODGE_Left)
				TraceEnd = -Y;
			else if (DodgeMove == DODGE_Right)
				TraceEnd = Y;
			TraceStart = Location - CollisionHeight*vect(0,0,1) + TraceEnd*CollisionRadius;
			TraceEnd = TraceStart + TraceEnd*32.0;
			HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, false, vect(1,1,1));

			if (!bEnableMoverWallDodge && Mover(HitActor) != None)
				return;

			if ((HitActor == none) || (HitActor != Level && Mover(HitActor) == none))
				return;

			bWasWallDodge = True;
			TakeFallingDamage();
		}
		// Normal dodge check.
		else if (Physics == PHYS_Walking)
			bWasGroundDodge = True;
		else
			return;

		if (bEnableLiftDodge)
		{
			VelocityZ = Velocity.Z;

			if (Mover(Base) != None)
				VelocityZ += Base.Velocity.Z;
		}

		if (DodgeMove == DODGE_Forward)
			Velocity = 1.5*GroundSpeed*X + (Velocity Dot Y)*Y;
		else if (DodgeMove == DODGE_Back)
			Velocity = -1.5*GroundSpeed*X + (Velocity Dot Y)*Y;
		else if (DodgeMove == DODGE_Left)
			Velocity = 1.5*GroundSpeed*Y + (Velocity Dot X)*X;
		else if (DodgeMove == DODGE_Right)
			Velocity = -1.5*GroundSpeed*Y + (Velocity Dot X)*X;

		// Update dodge limit
		if (bEnableDodgeLimit)
		{
			DodgeLimit -= 1;
			ClientMessage("Dodges Remaining: "$DodgeLimit);
		}

		if (bWasWallDodge)
		{
			DodgeDir = DODGE_Done;
			DodgeClickTimer = 0.0;
			WallDodgesRemaining -= 1;
		}
		else if (bWasAirDodge)
		{
			DodgeDir = DODGE_Done;
			DodgeClickTimer = 0.0;
			AirDodgesRemaining -= 1;
		}

		Velocity.Z = FMax(210, VelocityZ + 210);

		PlaySound(JumpSound, SLOT_Talk, 1.0, true, 800, 1.0 );
		PlayDodge(DodgeMove);

		if (!bWasWallDodge && !bWasAirDodge)
			DodgeDir = DODGE_Active;
		SetPhysics(PHYS_Falling);
	}

	function PlayDodge(eDodgeDir DodgeMove)
	{
		// Velocity.Z = 210;
		if ( DodgeMove == DODGE_Left )
			TweenAnim('DodgeL', 0.25);
		else if ( DodgeMove == DODGE_Right )
			TweenAnim('DodgeR', 0.25);
		else if ( DodgeMove == DODGE_Back )
			TweenAnim('DodgeB', 0.25);
		else 
			PlayAnim('Flip', 1.35 * FMax(0.35, Region.Zone.ZoneGravity.Z/Region.Zone.Default.ZoneGravity.Z), 0.06);
	}

	function DoSpaceJump()
	{
		if (Physics == PHYS_Falling)
		{
			PlayInAir();
			DoSpaceJumpAnim();

			if (bPressedJump && !bDisableJump && (Velocity.Z < -100 && Velocity.Z > SpaceJumpFallThreshold))
			{
				Velocity.Z = (-1 * Velocity.Z) + JumpZ /2;
			}
		}
	}

	function DoSpaceJumpAnim()
	{
		LoopAnim('Flip', 5 * FMax(0.35, Region.Zone.ZoneGravity.Z/Region.Zone.Default.ZoneGravity.Z), 0.0);
	}

	//Player Jumped
	function DoJump( optional float F )
	{
		if ( CarriedDecoration != None )
			return;
		if ( !bIsCrouching && (Physics == PHYS_Walking) )
		{
			if ( !bUpdating )
			{
				if ( bEnableSpaceJump && JumpSound != None )
				{
					bIsSpaceJumping = true;
					PlaySound(SamusSpaceJumpStart, SLOT_Talk, 1.5, true, 1200, 1.0 );
				}
				else
				{
					PlaySound(JumpSound, SLOT_Talk, 1.5, true, 1200, 1.0 );
				}
			}
			if ( (Level.Game != None) && (Level.Game.Difficulty > 0) )
				MakeNoise(0.1 * Level.Game.Difficulty);
			PlayInAir();
			if ( bCountJumps && (Role == ROLE_Authority) && (Inventory != None) )
				Inventory.OwnerJumped();
			if ( bIsWalking && !bUpdateWalkJumpHeight)
				Velocity.Z = WalkJumpZOrig;
			else if ( bIsWalking && bUpdateWalkJumpHeight )
				Velocity.Z = WalkJumpZ;
			else
				Velocity.Z = JumpZ;

			if ( (Base != Level) && (Base != None) )
				Velocity.Z += Base.Velocity.Z;
			SetPhysics(PHYS_Falling);
		}
	}

	function Landed(vector HitNormal)
	{
		Global.Landed(HitNormal);

		if (bWasGroundDodge)
		{
			DodgeDir = DODGE_Done;
			DodgeClickTimer = 0.0;

			if (!bWasAirDodge && !bWasWallDodge && !bEnableBounceAfterGroundDodge)
				Velocity *= 0.1;
			
			bWasGroundDodge = false;
		}
		else if (bWasWallDodge)
		{
			DodgeDir = DODGE_Done;
			DodgeClickTimer = 0.0;

			if (!bEnableBounceAfterWallDodge)
				Velocity *= 0.1;
		}
		else if (bWasAirDodge)
		{
			DodgeDir = DODGE_Done;
			DodgeClickTimer = 0.0;

			if (!bEnableBounceAfterAirDodge)
				Velocity *= 0.1;
		}
		else
			DodgeDir = DODGE_None;

		// Resets variables for the next wall dodge.
		if (bWasWallDodge) 
		{
			WallDodgesRemaining = WallDodgeLimit;
			bWasWallDodge = false;
		}

		// Resets variables for the next air dodge.
		if (bWasAirDodge)
		{
			AirDodgesRemaining = AirDodgeLimit;
			bWasAirDodge = false;
		}

		if (bEnableSpaceJump && bIsSpaceJumping)
			bIsSpaceJumping = false;
	}

	function FartAssRocket()
	{
		local vector ProjectileOffSet;
		local rotator BackwardsRotation;

		ProjectileOffSet.Y -= 20;
		ProjectileOffSet = vector(Rotation) * - 50;
		BackwardsRotation = Rotation;
		// Adding 32768 to the yaw is 180 degrees behind the players current rotation in space.
		BackwardsRotation.Yaw += 32768;

		PlaySound(QuickReverbFartSound, SLOT_NONE, 100, true, 1200, 1.0 );

		Projectile=Spawn(Class'Botpack.Warshell',Instigator,'',Location + ProjectileOffSet, BackwardsRotation);
		Projectile.Speed=600.000000;
		Projectile.Damage=0.000000;
		Projectile.Drawscale=0.200000;
		Projectile.MomentumTransfer=100000;
		Projectile.MaxSpeed=2000.000000;
		Projectile.LifeSpan = 10.000000;
		Projectile.ImpactSound=Sound'UnrealShare.General.Expla02';
		Projectile.MiscSound=None;
		Projectile.SpawnSound=None;
		Projectile.ExplosionDecal=Class'Botpack.NuclearMark';

		bEnableAssProjectile = false;
	}

	function ZoneChange( ZoneInfo NewZone )
	{
		if (NewZone.bWaterZone)
		{
			setPhysics(PHYS_Swimming);
			GotoState('PlayerSwimming');
		}
	}

	function AnimEnd()
	{
		local name MyAnimGroup;

		bAnimTransition = false;
		if (Physics == PHYS_Walking)
		{
			if (bIsCrouching)
			{
				if ( !bIsTurning && ((Velocity.X * Velocity.X + Velocity.Y * Velocity.Y) < 1000) )
					PlayDuck();
				else
					PlayCrawling();
			}
			else
			{
				MyAnimGroup = GetAnimGroup(AnimSequence);
				if ((Velocity.X * Velocity.X + Velocity.Y * Velocity.Y) < 1000)
				{
					if ( MyAnimGroup == 'Waiting' )
						PlayWaiting();
					else
					{
						bAnimTransition = true;
						TweenToWaiting(0.2);
					}
				}
				else if (bIsWalking)
				{
					if ( (MyAnimGroup == 'Waiting') || (MyAnimGroup == 'Landing') || (MyAnimGroup == 'Gesture') || (MyAnimGroup == 'TakeHit')  )
					{
						TweenToWalking(0.1);
						bAnimTransition = true;
					}
					else
						PlayWalking();
				}
				else
				{
					if ( (MyAnimGroup == 'Waiting') || (MyAnimGroup == 'Landing') || (MyAnimGroup == 'Gesture') || (MyAnimGroup == 'TakeHit')  )
					{
						bAnimTransition = true;
						TweenToRunning(0.1);
					}
					else
						PlayRunning();
				}
			}
		}
		else
			PlayInAir();

		if (bEnableSpaceJump && Physics == PHYS_Falling)
		{
			DoSpaceJumpAnim();
		}
	}

	function BeginState()
	{
		if ( Mesh == None )
			SetMesh();
		WalkBob = vect(0,0,0);
		DodgeDir = DODGE_None;
		bIsCrouching = false;
		bIsTurning = false;
		bPressedJump = false;

		WallDodgesRemaining = WallDodgeLimit;
		AirDodgesRemaining = AirDodgeLimit;

		if (Physics != PHYS_Falling) SetPhysics(PHYS_Walking);
		if ( !IsAnimating() )
			PlayWaiting();
	}

	function EndState()
	{
		WalkBob = vect(0,0,0);
		bIsCrouching = false;
	}
}

// Player movement.
// Player Swimming
simulated state PlayerSwimming
{
ignores SeePlayer, HearNoise, Bump;

	event UpdateEyeHeight(float DeltaTime)
	{
		local float smooth, bound;

		// smooth up/down stairs
		if( !bJustLanded )
		{
			smooth = FMin(1.0, 10.0 * DeltaTime/Level.TimeDilation);
			EyeHeight = (EyeHeight - Location.Z + OldLocation.Z) * (1 - smooth) + ( ShakeVert + BaseEyeHeight) * smooth;
			bound = -0.5 * CollisionHeight;
			if (EyeHeight < bound)
				EyeHeight = bound;
			else
			{
				bound = CollisionHeight + FClamp((OldLocation.Z - Location.Z), 0.0, MaxStepHeight);
				 if ( EyeHeight > bound )
					EyeHeight = bound;
			}
		}
		else
		{
			smooth = FClamp(10.0 * DeltaTime/Level.TimeDilation, 0.35, 1.0);
			bJustLanded = false;
			EyeHeight = EyeHeight * ( 1 - smooth) + (BaseEyeHeight + ShakeVert) * smooth;
		}

		// teleporters affect your FOV, so adjust it back down
		if ( FOVAngle != DesiredFOV )
		{
			if ( FOVAngle > DesiredFOV )
				FOVAngle = FOVAngle - FMax(7, 0.9 * DeltaTime * (FOVAngle - DesiredFOV));
			else
				FOVAngle = FOVAngle - FMin(-7, 0.9 * DeltaTime * (FOVAngle - DesiredFOV));
			if ( Abs(FOVAngle - DesiredFOV) <= 10 )
				FOVAngle = DesiredFOV;
		}

		// adjust FOV for weapon zooming
		if ( bZooming )
		{
			ZoomLevel += DeltaTime * 1.0;
			if (ZoomLevel > 0.9)
				ZoomLevel = 0.9;
			DesiredFOV = FClamp(90.0 - (ZoomLevel * 88.0), 1, 170);
		}
	}

	function Landed(vector HitNormal)
	{
		if ( !bUpdating )
		{
			PlayLanded(Velocity.Z);
			TakeFallingDamage();
			bJustLanded = true;
		}
		if ( Region.Zone.bWaterZone )
			SetPhysics(PHYS_Swimming);
		else
		{
			GotoState('PlayerWalking');
			AnimEnd();
		}
	}

	function AnimEnd()
	{
		local vector X,Y,Z;
		GetAxes(Rotation, X,Y,Z);
		if ( (Acceleration Dot X) <= 0 )
		{
			if ( GetAnimGroup(AnimSequence) == 'TakeHit' )
			{
				bAnimTransition = true;
				TweenToWaiting(0.2);
			}
			else
				PlayWaiting();
		}
		else
		{
			if ( GetAnimGroup(AnimSequence) == 'TakeHit' )
			{
				bAnimTransition = true;
				TweenToSwimming(0.2);
			}
			else
				PlaySwimming();
		}
	}

	function ZoneChange( ZoneInfo NewZone )
	{
		local actor HitActor;
		local vector HitLocation, HitNormal, checkpoint;

		if (!NewZone.bWaterZone)
		{
			SetPhysics(PHYS_Falling);
			if (bUpAndOut && CheckWaterJump(HitNormal)) //check for waterjump
			{
				velocity.Z = 330 + 2 * CollisionRadius; //set here so physics uses this for remainder of tick
				PlayDuck();
				GotoState('PlayerWalking');
			}
			else if (!FootRegion.Zone.bWaterZone || (Velocity.Z > 160) )
			{
				GotoState('PlayerWalking');
				AnimEnd();
			}
			else //check if in deep water
			{
				checkpoint = Location;
				checkpoint.Z -= (CollisionHeight + 6.0);
				HitActor = Trace(HitLocation, HitNormal, checkpoint, Location, false);
				if (HitActor != None)
				{
					GotoState('PlayerWalking');
					AnimEnd();
				}
				else
				{
					Enable('Timer');
					SetTimer(0.7,false);
				}
			}
			//log("Out of water");
		}
		else
		{
			Disable('Timer');
			SetPhysics(PHYS_Swimming);
		}
	}

	function ProcessMove(float DeltaTime, vector NewAccel, eDodgeDir DodgeMove, rotator DeltaRot)
	{
		local vector X,Y,Z, Temp;

		GetAxes(ViewRotation,X,Y,Z);
		Acceleration = NewAccel;

		SwimAnimUpdate( (X Dot Acceleration) <= 0 );

		bUpAndOut = ((X Dot Acceleration) > 0) && ((Acceleration.Z > 0) || (ViewRotation.Pitch > 2048));
		if ( bUpAndOut && !Region.Zone.bWaterZone && CheckWaterJump(Temp) ) //check for waterjump
		{
			velocity.Z = 330 + 2 * CollisionRadius; //set here so physics uses this for remainder of tick
			PlayDuck();
			GotoState('PlayerWalking');
		}
	}

	event PlayerTick( float DeltaTime )
	{
		if ( bUpdatePosition )
			ClientUpdatePosition();

		PlayerMove(DeltaTime);
	}

	function PlayerMove(float DeltaTime)
	{
		local rotator oldRotation;
		local vector X,Y,Z, NewAccel;
		local float Speed2D;

		GetAxes(ViewRotation,X,Y,Z);

		aForward *= 0.2;
		aStrafe  *= 0.1;
		aLookup  *= 0.24;
		aTurn    *= 0.24;
		aUp		 *= 0.1;

		NewAccel = aForward*X + aStrafe*Y + aUp*vect(0,0,1);

		//add bobbing when swimming
		if ( !bShowMenu )
		{
			Speed2D = Sqrt(Velocity.X * Velocity.X + Velocity.Y * Velocity.Y);
			WalkBob = Y * Bob *  0.5 * Speed2D * sin(4.0 * Level.TimeSeconds);
			WalkBob.Z = Bob * 1.5 * Speed2D * sin(8.0 * Level.TimeSeconds);
		}

		// Update rotation.
		oldRotation = Rotation;
		UpdateRotation(DeltaTime, 2);

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			ReplicateMove(DeltaTime, NewAccel, DODGE_None, OldRotation - Rotation);
		else
			ProcessMove(DeltaTime, NewAccel, DODGE_None, OldRotation - Rotation);
		bPressedJump = false;
	}

	function Timer()
	{
		if ( !Region.Zone.bWaterZone && (Role == ROLE_Authority) )
		{
			//log("timer out of water");
			GotoState('PlayerWalking');
			AnimEnd();
		}

		Disable('Timer');
	}

	function BeginState()
	{
		Disable('Timer');
		if ( !IsAnimating() )
			TweenToWaiting(0.3);
	}
}

simulated state Dying
{
ignores SeePlayer, HearNoise, KilledBy, Bump, HitWall, HeadZoneChange, FootZoneChange, ZoneChange, SwitchWeapon, Falling, PainTimer;

	function ViewFlash(float DeltaTime)
	{
		if ( Carcass(ViewTarget) != None )
		{
			InstantFlash = -0.3;
			InstantFog = vect(0.25, 0.03, 0.03);
		}
		Super.ViewFlash(DeltaTime);
	}

	function BeginState()
	{
		Super.BeginState();
		
		bEnableWallDodge = bEnableWallDodgeOrig;
		WallDodgeLimit = WallDodgeLimitOrig;
		bEnableMoverWallDodge = bEnableMoverWallDodgeOrig;
		bEnableBounceAfterWallDodge = bEnableBounceAfterWallDodgeOrig;

		bEnableAirDodge = bEnableAirDodgeOrig;
		AirDodgeLimit = AirDodgeLimitOrig;
		bEnableBounceAfterAirDodge = bEnableBounceAfterAirDodgeOrig;

		bEnableLiftDodge = bEnableLiftDodgeOrig;

		bEnableDodgeBot = bEnableDodgeBotOrig;
		bEnableDodgeBotCall = bEnableDodgeBotCallOrig;

		bIsSpaceJumping = false;
		bEnableSpaceJump = bEnableSpaceJumpOrig;
		SpaceJumpFallThreshold = SpaceJumpFallThresholdOrig;
		SpaceJumpUpThreshold = SpaceJumpUpThresholdOrig;

		bDisableDodge = bDisableDodgeOrig;
		bDisableWalk = bDisableWalkOrig;
		bDisableJump = bDisableJumpOrig;
		GroundSpeed = GroundSpeedOrig;
		WaterSpeed = WaterSpeedOrig;
		JumpZ = JumpZOrig;
		WalkJumpZ = WalkJumpZOrig;
		bEnableCrouchDodge = bEnableCrouchDodgeOrig;
		bEnableBounceAfterGroundDodge = bEnableBounceAfterGroundDodgeOrig;
		bEnableDodgeLimit = bEnableDodgeLimitOrig;
		DodgeLimit = DodgeLimitOrig;

		bEnableAssProjectile = bEnableAssProjectileOrig;
		bEnableAssProjectileCall = bEnableAssProjectileOrig;

		bTriggerEnabled = false;

		LastKillTime = 0;
	}
}

defaultproperties
{
      QuickReverbFartSound=Sound'ChekzCustomPlayer.Farts.QuickReverbFart'
      SamusSpaceJumpStart=Sound'ChekzCustomPlayer.SpaceJump.SamusSpaceJumpStart'
      SamusFlip=Sound'ChekzCustomPlayer.SpaceJump.SamusFlip'
      bIsSpaceJumping=False;
      bWasWallDodge=False
      bWasAirDodge=False
      bTriggerEnabled=False
      WallDodgesRemaining=1
      AirDodgesRemaining=1
}
