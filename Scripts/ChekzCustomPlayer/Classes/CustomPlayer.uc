//=============================================================================
// CustomPlayer: This is it, this is where the magic happens. All those fancy
// properties that come from CPSpawnNotify and CPTrigger. Well they end up
// here and maniuplate the players movement based off of those.
//
// Author: ch3kz
//=============================================================================
class CustomPlayer extends TournamentPlayer;

//=============================================================================
// Class properties.
//=============================================================================
var bool bEnableDodgeBot;
var bool bEnableWallDodge;

var bool bWasWallDodge;
var int WallDodgeLimit;
var int WallDodgesRemaining;

var bool bDisableDodge;
var bool bDisableWalk;
var bool bDisableJump;

var bool bEnableDodgeLimit;
var int DodgeLimit;

var bool bEnableCrouchDodge;
var bool bEnableAirDodge;

replication
{
	//=============================================================================
	// Properties replicated from the server to the client.
	//=============================================================================
	reliable if ( Role == ROLE_Authority )
		bEnableDodgeBot,
		bEnableWallDodge,
		WallDodgeLimit,
		bDisableDodge,
		bDisableWalk,
		bDisableJump,
		bEnableDodgeLimit,
		DodgeLimit,
		bEnableCrouchDodge,
		bEnableAirDodge;
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
	}

	function Landed(vector HitNormal)
	{
		Global.Landed(HitNormal);
		if (DodgeDir == DODGE_Active)
		{
			DodgeDir = DODGE_Done;
			DodgeClickTimer = 0.0;
			Velocity *= 0.1;
		}
		else
			DodgeDir = DODGE_None;

		// Resets variables for the next wall dodge.
		if (bEnableWallDodge && bWasWallDodge) 
		{
			WallDodgesRemaining = WallDodgeLimit;
			bWasWallDodge = False;
		}
	}

	function Dodge(eDodgeDir DodgeMove)
	{
		local vector X,Y,Z;

		// Wall dodge variables.
		local vector TraceStart, TraceEnd, HitLocation, HitNormal;

		// Crouch dodge check.
		if (bIsCrouching && !bEnableCrouchDodge)
			return;

		// Air dodge check.
		if (bEnableAirDodge)
		{
			if (Physics != PHYS_Walking && Physics != PHYS_FALLING)
				return;
		} 	
		// Wall dodge check.
		else if (bEnableWallDodge)
		{
			if (Physics != PHYS_Walking && Physics != PHYS_FALLING && WallDodgesRemaining != 0)
				return;

			if (Physics == PHYS_Falling)
			{
				GetAxes(Rotation, X, Y, Z);

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
				if ((HitActor == none) || (HitActor != Level && Mover(HitActor) == none))
					return;

				bWasWallDodge = True;
				TakeFallingDamage();
			}
		}
		// Normal dodge check.
		else if (Physics != PHYS_Walking)
			return;

		GetAxes(Rotation,X,Y,Z);
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

		Velocity.Z = 160;

		PlaySound(JumpSound, SLOT_Talk, 1.0, true, 800, 1.0 );
		PlayDodge(DodgeMove);
		DodgeDir = DODGE_Active;
		SetPhysics(PHYS_Falling);
	}

	function ProcessMove(float DeltaTime, vector NewAccel, eDodgeDir DodgeMove, rotator DeltaRot)
	{
		local vector OldAccel;

		OldAccel = Acceleration;
		Acceleration = NewAccel;
		bIsTurning = ( Abs(DeltaRot.Yaw/DeltaTime) > 5000 );

		if ( (DodgeMove == DODGE_Active) && (Physics == PHYS_Falling) )
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

		// Update WallDodgesRemaining. Move to dodge function?
		if (bEnableWallDodge
			&& DodgeDir == DODGE_Active
			&& WallDodgesRemaining > 0
			&& Physics == PHYS_Falling
			&& bWasWallDodge
		)
		{
			WallDodgesRemaining -= 1;
			DodgeDir = DODGE_None;
		}

		// DodgeBot check.
		if (bEnableDodgeBot && bPressedJump && bIsWalking)
		{
			// Dodge limit check
			if (bEnableDodgeLimit && DodgeLimit > 0)
				Dodge(DODGE_Forward);
			else if (!bEnableDodgeLimit)
				Dodge(DODGE_Forward);
		}
			

		// Disable jump check.
		if (bPressedJump && !bDisableJump)
			DoJump();

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

	//Player Jumped
	function DoJump( optional float F )
	{
		if ( CarriedDecoration != None )
			return;
		if ( !bIsCrouching && (Physics == PHYS_Walking) )
		{
			if ( !bUpdating ) {
				PlaySound(JumpSound, SLOT_Talk, 1.5, true, 1200, 1.0 );
			}
				
			if ( (Level.Game != None) && (Level.Game.Difficulty > 0) )
				MakeNoise(0.1 * Level.Game.Difficulty);
			PlayInAir();
			if ( bCountJumps && (Role == ROLE_Authority) && (Inventory != None) )
				Inventory.OwnerJumped();
			Velocity.Z = JumpZ;
			if ( (Base != Level) && (Base != None) )
				Velocity.Z += Base.Velocity.Z;
			SetPhysics(PHYS_Falling);
		}
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

		if ( bPressedJump && (AnimGroupName == 'Dodge') )
		{
			bSaveJump = true;
			bPressedJump = false;
		}
		else
			bSaveJump = false;

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			ReplicateMove(DeltaTime, NewAccel, DodgeMove, OldRotation - Rotation);
		else
			ProcessMove(DeltaTime, NewAccel, DodgeMove, OldRotation - Rotation);
		
		bPressedJump = bSaveJump;
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

defaultproperties
{
      bWasWallDodge=false
}
