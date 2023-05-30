//=============================================================================
// NullShockRifle.
// Made by >@tack!<
// Edited by ch3kz
//=============================================================================
class NullShockZoneRifle expands ShockRifle;

var() float ShockBeamScale;
var() float ShockBeamSpeedScale;
var() float FireSpeed;
var() float AltFireSpeed;

struct FogRGB {
	var float R;
	var float G;
	var float B;
};

var Name Parent;
var Name Destination;
var float FlashScale;
var FogRGB FlashColour;
var Sound TransitionSound;

var NuLLTeleportZoneInfo ntzi;

function inventory SpawnCopy( pawn Other )
{
	local NullShockZoneRifle Copy;
	if( Level.Game.ShouldRespawn(self) )
	{
		Copy = spawn(Class,Other,,,rot(0,0,0));
		Copy.Tag           = Tag;
		Copy.Event         = Event;

		Copy.ShockBeamScale = ShockBeamScale;
		Copy.FireSpeed = FireSpeed;
		Copy.AltFireSpeed = AltFireSpeed;
		Copy.ShockBeamSpeedScale = ShockBeamSpeedScale;
		Copy.Parent = Parent;
		Copy.Destination = Destination;
		Copy.FlashScale = FlashScale;
		Copy.FlashColour = FlashColour;
		Copy.TransitionSound = TransitionSound;

		GotoState('Sleeping');
	}
	else
		Copy = self;

	Copy.RespawnTime = 0.0;
	Copy.bHeldItem = true;
	Copy.bTossedOut = false;
	Copy.GiveTo( Other );
	Copy.Instigator = Other;
	Copy.GiveAmmo(Other);
	Copy.SetSwitchPriority(Other);
	if ( !Other.bNeverSwitchOnPickup )
		Copy.WeaponSet(Other);
	Copy.AmbientGlow = 0;
	return Copy;
}

function Fire( float Value )
{
	GotoState('NormalFire');
	bCanClientFire = true;
	bPointing=True;
	ClientFire(value);
	if ( bRapidFire || (FiringSpeed > 0) )
		Pawn(Owner).PlayRecoil(FiringSpeed);
	if ( bInstantHit )
		TraceFire(0.0);
	else
		ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
}

function AltFire( float Value )
{
	local NuLLTeleportZoneInfo NZTI;

	foreach AllActors( class 'NuLLTeleportZoneInfo', NZTI )
	{
		if (NZTI.ZoneTag == Region.Zone.ZoneTag)
		{
			SetTeleporterVariables(NZTI);
			break;
		}
	}

	if (Parent == '' || Destination == '')
		return;

	GotoState('AltFiring');

	ClientAltFire(value);

	Pawn(Owner).PlayRecoil(AltFireSpeed);
	bPointing=True;

	TeleporterPlayer(Pawn(Owner));

	Parent = '';
	Destination = '';
}

function SetTeleporterVariables(NuLLTeleportZoneInfo NZTI)
{
	Parent = NZTI.Parent;
	Destination = NZTI.Destination;
	FlashScale = NZTI.FlashScale;
	FlashColour.R = NZTI.FlashColour.R;
	FlashColour.G = NZTI.FlashColour.G;
	FlashColour.B = NZTI.FlashColour.B;
	TransitionSound = NZTI.TransitionSound;
}

function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local int i;
	local PlayerPawn PlayerOwner;

	if (Other==None)
	{
		HitNormal = -X;
		HitLocation = Owner.Location + X*10000.0;
	}

	PlayerOwner = PlayerPawn(Owner);
	if ( PlayerOwner != None )
		PlayerOwner.ClientInstantFlash( -0.4, vect(450, 190, 650));
	SpawnEffect(HitLocation, Owner.Location + CalcDrawOffset() + (FireOffset.X + 20) * X + FireOffset.Y * Y + FireOffset.Z * Z);

	if ( ShockProj(Other)!=None )
	{ 
		ShockProj(Other).SuperExplosion();
	}
	else
		Spawn(class'ut_RingExplosion5',,, HitLocation+HitNormal*8,rotator(HitNormal));

	if ( (Other != self) && (Other != Owner) && (Other != None) ) 
		Other.TakeDamage(HitDamage, Pawn(Owner), HitLocation, 60000.0*X, MyDamageType);
}

function SpawnEffect(vector HitLocation, vector SmokeLocation)
{
	local NullShockBeam Smoke;
	local Vector DVector;
	local int NumPoints;
	local rotator SmokeRotation;

	DVector = HitLocation - SmokeLocation;
	NumPoints = VSize(DVector)/(135.0);
	if ( NumPoints < 1 )
		return;
	SmokeRotation = rotator(DVector);
	SmokeRotation.roll = Rand(65535);
	
	Smoke = Spawn(class'NullShockBeam',,,SmokeLocation,SmokeRotation);
	Smoke.MoveAmount = DVector/NumPoints;
	Smoke.NumPuffs = NumPoints - 1;	
	Smoke.Initialize(ShockBeamScale,ShockBeamSpeedScale);
}

simulated function PlayFiring()
{
	PlayOwnedSound(FireSound, SLOT_None, Pawn(Owner).SoundDampening*4.0);
	LoopAnim('Fire1', (0.30 + 0.30 * FireAdjust) * FireSpeed ,0.05);
}

simulated function PlayAltFiring()
{
	LoopAnim('Fire2',(0.30 + 0.30 * FireAdjust) * AltFireSpeed,0.05);
}

function TeleporterPlayer(Pawn P) {
	local actor A;
	local vector From, To, Fog;
	local PlayerPawn PP;

	if (Parent != '' && Destination != '') {
		// Get location of parent/destination teleporters
		foreach AllActors( class 'Actor', A, Parent ) {
			From = A.Location;
			break;
		}

		foreach AllActors( class 'Actor', A, Destination ) {
			To = A.Location;
			break;
		}

		// Attempt to move player
		if (!P.SetLocation(To - (From - P.Location))) {
			P.ClientMessage("[UNABLE TO SET PLAYER LOCATION]");
			return;
		}

		// Success - handle visual/audio cues if set
		PP = PlayerPawn(P);

		if (PP != none) {
			// Colour flash
			Fog.X = FlashColour.R;
			Fog.Y = FlashColour.G;
			Fog.Z = FlashColour.B;

			PP.ClientFlash(self.FlashScale, Fog);

			// Play sound
			if (self.TransitionSound != none) {
				PP.ClientPlaySound(self.TransitionSound);
			}
		}
	}
}

defaultproperties
{
	FireSpeed=2.000000
	AltFireSpeed=1.000000
	ShockBeamScale=0.180000
	ShockBeamSpeedScale=2.000000

	bEdShouldSnap=True
}
