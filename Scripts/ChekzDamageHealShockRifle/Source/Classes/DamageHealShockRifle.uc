//=============================================================================
// Absolute size of this class. Ho Lee.
//
// DamageHealShockRifle (DHR) - Inspired by Bunneh`.
//
// Author: chekz
//=============================================================================
class DamageHealShockRifle extends ShockRifle;

//=============================================================================
// Textures
//=============================================================================
#exec OBJ LOAD FILE=Textures\ChekzDamageHealShockRifle.utx PACKAGE=ChekzDamageHealShockRifle

//=============================================================================
// Mesh - First Person
//=============================================================================
#exec MESH IMPORT MESH=DHR_ASMD2M ANIVFILE=MODELS\DHR_ASMD2M_a.3d DATAFILE=MODELS\DHR_ASMD2M_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=DHR_ASMD2M X=0 Y=0 Z=0 YAW=64 PITCH=0
#exec MESHMAP SCALE MESHMAP=DHR_ASMD2M X=0.004 Y=0.003 Z=0.008

#exec MESH SEQUENCE MESH=DHR_ASMD2M SEQ=All       STARTFRAME=0  NUMFRAMES=52
#exec MESH SEQUENCE MESH=DHR_ASMD2M SEQ=Select    STARTFRAME=0  NUMFRAMES=15 RATE=30 GROUP=Select
#exec MESH SEQUENCE MESH=DHR_ASMD2M SEQ=Still     STARTFRAME=15 NUMFRAMES=1
#exec MESH SEQUENCE MESH=DHR_ASMD2M SEQ=Down      STARTFRAME=17 NUMFRAMES=7  RATE=27
#exec MESH SEQUENCE MESH=DHR_ASMD2M SEQ=Still2    STARTFRAME=28 NUMFRAMES=2
#exec MESH SEQUENCE MESH=DHR_ASMD2M SEQ=Fire1     STARTFRAME=30 NUMFRAMES=10  RATE=22
#exec MESH SEQUENCE MESH=DHR_ASMD2M SEQ=Fire2     STARTFRAME=40 NUMFRAMES=10  RATE=24

#exec MESHMAP SETTEXTURE MESHMAP=DHR_ASMD2M NUM=0 TEXTURE=ChekzDamageHealShockRifle.Skins.DHR_SASMD_t1
#exec MESHMAP SETTEXTURE MESHMAP=DHR_ASMD2M NUM=1 TEXTURE=ChekzDamageHealShockRifle.Skins.DHR_SASMD_t2
#exec MESHMAP SETTEXTURE MESHMAP=DHR_ASMD2M NUM=2 TEXTURE=ChekzDamageHealShockRifle.Skins.DHR_SASMD_t3
#exec MESHMAP SETTEXTURE MESHMAP=DHR_ASMD2M NUM=3 TEXTURE=ChekzDamageHealShockRifle.Skins.DHR_SASMD_t3
#exec MESHMAP SETTEXTURE MESHMAP=DHR_ASMD2M NUM=4 TEXTURE=ChekzDamageHealShockRifle.Skins.DHR_SASMD_t4

//=============================================================================
// Mesh - Pickup
//=============================================================================
#exec MESH IMPORT MESH=DHR_ASMD2pick ANIVFILE=MODELS\DHR_ASMD2pick_a.3d DATAFILE=MODELS\DHR_ASMD2pick_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=DHR_ASMD2pick X=0 Y=0 Z=0 YAW=64
#exec MESHMAP SCALE MESHMAP=DHR_ASMD2pick X=0.07 Y=0.07 Z=0.14

#exec MESH SEQUENCE MESH=DHR_ASMD2pick SEQ=All   STARTFRAME=0  NUMFRAMES=1
#exec MESH SEQUENCE MESH=DHR_ASMD2pick SEQ=Still STARTFRAME=0  NUMFRAMES=1

#exec MESHMAP SETTEXTURE MESHMAP=DHR_ASMD2pick NUM=0 TEXTURE=ChekzDamageHealShockRifle.Skins.DHR_SASMD_t

//=============================================================================
// Mesh - Third Person
//=============================================================================
#exec MESH IMPORT MESH=DHR_ASMD2hand ANIVFILE=MODELS\DHR_ASMD2hand_a.3d DATAFILE=MODELS\DHR_ASMD2hand_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=DHR_ASMD2hand X=25 Y=600 Z=-40 YAW=64 PITCH=0
#exec MESHMAP SCALE MESHMAP=DHR_ASMD2hand X=0.004 Y=0.003 Z=0.008

#exec MESH SEQUENCE MESH=DHR_ASMD2hand SEQ=All   STARTFRAME=0  NUMFRAMES=10
#exec MESH SEQUENCE MESH=DHR_ASMD2hand SEQ=Still STARTFRAME=0  NUMFRAMES=1
#exec MESH SEQUENCE MESH=DHR_ASMD2hand SEQ=Fire1 STARTFRAME=1  NUMFRAMES=9  RATE=24
#exec MESH SEQUENCE MESH=DHR_ASMD2hand SEQ=Fire2 STARTFRAME=1  NUMFRAMES=9  RATE=24

#exec MESHMAP SETTEXTURE MESHMAP=DHR_ASMD2hand NUM=0 TEXTURE=ChekzDamageHealShockRifle.Skins.DHR_SASMD_t

//=============================================================================
// Non-Configurable Properties
//=============================================================================
var bool bHealBeamFired;
var bool bDamageBeamFired;

var vector HealFog;
var float HealFlashScale;

var playerpawn DHROwner;

//=============================================================================
// Fires damage beam
// Damages Owner
//
// param Value Value is 0???
//=============================================================================
function Fire( float Value )
{
	local vector EmptyVector;
	local pawn EmptyPawn;

	bDamageBeamFired = True;

	GotoState('NormalFire');
	bCanClientFire = true;
	bPointing=True;
	ClientFire(class'DamageHealShockRifleMutator'.default.DamageBeamHitDamage);
	if ( bRapidFire || (class'DamageHealShockRifleMutator'.default.DamageBeamFireSpeed > 0) )
		DHROwner.PlayRecoil(class'DamageHealShockRifleMutator'.default.DamageBeamFireSpeed);
	if ( bInstantHit )
		TraceFire(0.0);

	DHROwner.TakeDamage(
		class'DamageHealShockRifleMutator'.default.DamageAmount,
		EmptyPawn,
		EmptyVector,
		EmptyVector,
		MyDamageType
	);
	// Updating Owner Speed when Pawn Takes Damage is handled in DamageHealShockRifleMutator.MutatorTakeDamage
}

//=============================================================================
// Calls PlayDHRFiring(sound FireSound, float FireSpeed)
//=============================================================================
simulated function PlayFiring()
{
	PlayDHRFiring(FireSound, class'DamageHealShockRifleMutator'.default.DamageBeamFireSpeed);
}

//=============================================================================
// Calls PlayDHRFiring(sound FireSound, float FireSpeed)
//=============================================================================
simulated function PlayAltFiring()
{
	PlayDHRFiring(AltFireSound, class'DamageHealShockRifleMutator'.default.HealBeamFireSpeed);
}

//=============================================================================
// PlayDHRFiring is simulated to run on Client.
//
// Plays a fire sound
// Performs fire animation
//
// param FireSound The Sound to play when firing
// param FireSpeed The speed at which to fire
//=============================================================================
simulated function PlayDHRFiring(sound FireSound, float FireSpeed)
{
	PlayOwnedSound(FireSound, SLOT_None, 2);
	LoopAnim('Fire1', (0.20 + 0.20 * FireAdjust) * FireSpeed ,0.05);
}

//=============================================================================
// Fires heal beam
// Heals Owner
// Updates player speed if possible
//
// param Value Value is 0???
//=============================================================================
function AltFire( float Value )
{
	bHealBeamFired = True;

	GotoState('AltFiring');
	DHROwner.PlayRecoil(class'DamageHealShockRifleMutator'.default.HealBeamFireSpeed);
	bCanClientFire = true;
	bPointing=True;
	TraceFire(0.0);
	ClientAltFire(class'DamageHealShockRifleMutator'.default.HealBeamHitDamage);

	DHROwner.ClientFlash(HealFlashScale, HealFog);

	UpdateHealthAndSpeed();
}

//=============================================================================
// Heals Owner
// Updates Owner Speed
//=============================================================================
function UpdateHealthAndSpeed()
{
	local int HealAmount;
	local int MaxHealth;

	MaxHealth = class'DamageHealShockRifleMutator'.default.MaxHealth;

	if (DHROwner.Health == MaxHealth)
		return;

	HealAmount = class'DamageHealShockRifleMutator'.default.HealAmount;
	HealAmount = class'DamageHealShockRifleUtils'.static.GetHealAmount(DHROwner, HealAmount, MaxHealth);

	DHROwner.Health += HealAmount;

	class'DamageHealShockRifleUtils'.static.UpdatePlayerSpeed(
		DHROwner,
		HealAmount,
		-class'DamageHealShockRifleMutator'.default.SpeedMultiplier
	);
}

//=============================================================================
// Spawns H_UT_SuperRing2 (the heal beam ring and explosions effect) if heal beam is fired
// Spawns D_UT_SuperRing2 (the damage beam ring and explosions effect) if damage beam is fired
//
// param Other Actor shot hits
// param HitLocation Location of Hit
// param HitNormal
// param X
// param Y
// param Z
//=============================================================================
function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	if (Other==None)
	{
		HitNormal = -X;
		HitLocation = Owner.Location + X*10000.0;
	}

	SpawnEffect(HitLocation, Owner.Location + CalcDrawOffset() + (FireOffset.X + 20) * X + FireOffset.Y * Y + FireOffset.Z * Z);

	if (bHealBeamFired)
	{
		Spawn(class'H_UT_SuperRing2',,, HitLocation+HitNormal*8,rotator(HitNormal));
		bHealBeamFired = False;
	} else
	{
		Spawn(class'D_UT_SuperRing2',,, HitLocation+HitNormal*8,rotator(HitNormal));
		bDamageBeamFired = False;
	}

	if ( (Other != self) && (Other != Owner) && (Other != None) ) 
		Other.TakeDamage(HitDamage, Pawn(Owner), HitLocation, 60000.0*X, MyDamageType);
}

//=============================================================================
// Spawns DamageBeam if normal Fire
// Spawns HealBeam if AltFire
//
// param HitLocation Location of shot
// param SmokeLocation Smoke location
//=============================================================================
function SpawnEffect(vector HitLocation, vector SmokeLocation)
{
	local HealBeam HealBeamSmoke;
	local DamageBeam DamageBeamSmoke;
	local Vector DVector;
	local int NumPoints;
	local rotator SmokeRotation;

	DVector = HitLocation - SmokeLocation;
	NumPoints = VSize(DVector)/135.0;
	if ( NumPoints < 1 )
		return;
	SmokeRotation = rotator(DVector);
	SmokeRotation.roll = Rand(65535);

	if (bHealBeamFired)
	{
		HealBeamSmoke = Spawn(class'HealBeam',,,SmokeLocation,SmokeRotation);
		HealBeamSmoke.MoveAmount = DVector/NumPoints;
		HealBeamSmoke.NumPuffs = NumPoints - 1;
	} else
	{
		DamageBeamSmoke = Spawn(class'DamageBeam',,,SmokeLocation,SmokeRotation);
		DamageBeamSmoke.MoveAmount = DVector/NumPoints;
		DamageBeamSmoke.NumPuffs = NumPoints - 1;
	}
}

//=============================================================================
// Resets Owner's AirSpeed, GroundSpeed and WaterSpeed to the Owners defaults
//=============================================================================
function ResetDHROwner()
{
	DHROwner.AirSpeed = DHROwner.Default.AirSpeed;
	DHROwner.GroundSpeed = DHROwner.Default.GroundSpeed;
	DHROwner.WaterSpeed = DHROwner.Default.WaterSpeed;
}

//=============================================================================
// Resets DHROwner
//=============================================================================
function Destroyed()
{
	Super.Destroyed();

	if (class'DamageHealShockRifleMutator'.default.bCanUpdateOwnerSpeed)
		ResetDHROwner();
}

//=============================================================================
// Sets DHROwner
//=============================================================================
state Active
{
	ignores animend;

	function ForceFire()
	{
		bForceFire = true;
	}

	function ForceAltFire()
	{
		bForceAltFire = true;
	}

	function EndState()
	{
		Super.EndState();
		bForceFire = false;
		bForceAltFire = false;
	}

Begin:
	DHROwner = PlayerPawn(Owner);
	DHROwner.Health = class'DamageHealShockRifleMutator'.default.StartingHealth;
	FinishAnim();
	if ( bChangeWeapon )
		GotoState('DownWeapon');
	bWeaponUp = True;
	PlayPostSelect();
	FinishAnim();
	bCanClientFire = true;
	
	if ( (Level.Netmode != NM_Standalone) && Owner.IsA('TournamentPlayer')
		&& (PlayerPawn(Owner).Player != None)
		&& !PlayerPawn(Owner).Player.IsA('ViewPort') )
	{
		if ( bForceFire || (Pawn(Owner).bFire != 0) )
			TournamentPlayer(Owner).SendFire(self);
		else if ( bForceAltFire || (Pawn(Owner).bAltFire != 0) )
			TournamentPlayer(Owner).SendAltFire(self);
		else if ( !bChangeWeapon )
			TournamentPlayer(Owner).UpdateRealWeapon(self);
	} 
	Finish();
}

defaultproperties
{
      HealFog=(X=0.000000,Y=255.000000,Z=50.000000)
      bHealBeamFired=False
      bDamageBeamFired=False
      DHROwner=None
      FireSound=Sound'ChekzDamageHealShockRifle.FireSounds.DamageBeamFireSound'
      AltFireSound=Sound'ChekzDamageHealShockRifle.FireSounds.HealBeamFireSound'
      PickupMessage="You got the Damage Heal Rifle."
      ItemName="Damage Heal Rifle"
      Mesh=LodMesh'DHR_ASMD2pick'
      PickupViewMesh=LodMesh'DHR_ASMD2pick'
      PlayerViewMesh=LodMesh'DHR_ASMD2M'
      ThirdPersonMesh=LodMesh'DHR_ASMD2hand'
}
