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
// Sounds
//=============================================================================
#exec AUDIO IMPORT FILE="Sounds\HealBeamFireSound.wav" NAME="HealBeamFireSound" GROUP="FireSounds"
#exec AUDIO IMPORT FILE="Sounds\DamageBeamFireSound.wav" NAME="DamageBeamFireSound" Group="FireSounds"

//=============================================================================
// Mesh - First Person
//=============================================================================
#exec MESH IMPORT MESH=DHR_sshockm ANIVFILE=MODELS\DHR_sshockm_a.3D DATAFILE=MODELS\DHR_sshockm_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=DHR_sshockm X=0 Y=0 Z=0 YAW=64 PITCH=0
#exec MESHMAP SCALE MESHMAP=DHR_sshockm X=0.004 Y=0.003 Z=0.008

#exec MESH SEQUENCE MESH=DHR_sshockm SEQ=All       STARTFRAME=0  NUMFRAMES=52
#exec MESH SEQUENCE MESH=DHR_sshockm SEQ=Select    STARTFRAME=0  NUMFRAMES=15 RATE=30 GROUP=Select
#exec MESH SEQUENCE MESH=DHR_sshockm SEQ=Still     STARTFRAME=15 NUMFRAMES=1
#exec MESH SEQUENCE MESH=DHR_sshockm SEQ=Down      STARTFRAME=17 NUMFRAMES=7  RATE=27
#exec MESH SEQUENCE MESH=DHR_sshockm SEQ=Still2    STARTFRAME=28 NUMFRAMES=2
#exec MESH SEQUENCE MESH=DHR_sshockm SEQ=Fire1     STARTFRAME=30 NUMFRAMES=10  RATE=22
#exec MESH SEQUENCE MESH=DHR_sshockm SEQ=Fire2     STARTFRAME=40 NUMFRAMES=10  RATE=24

#exec MESHMAP SETTEXTURE MESHMAP=DHR_sshockm NUM=0 TEXTURE=ChekzDamageHealShockRifle.Skins.DHR_SASMD_t1
#exec MESHMAP SETTEXTURE MESHMAP=DHR_sshockm NUM=1 TEXTURE=ChekzDamageHealShockRifle.Skins.DHR_SASMD_t2
#exec MESHMAP SETTEXTURE MESHMAP=DHR_sshockm NUM=2 TEXTURE=ChekzDamageHealShockRifle.Skins.DHR_SASMD_t3
#exec MESHMAP SETTEXTURE MESHMAP=DHR_sshockm NUM=3 TEXTURE=ChekzDamageHealShockRifle.Skins.DHR_SASMD_t3
#exec MESHMAP SETTEXTURE MESHMAP=DHR_sshockm NUM=4 TEXTURE=ChekzDamageHealShockRifle.Skins.DHR_SASMD_t4

//=============================================================================
// Mesh - Pickup
//=============================================================================
#exec MESH IMPORT MESH=DHR_ASMD2pick ANIVFILE=MODELS\DHR_ASMD2pick_a.3D DATAFILE=MODELS\DHR_ASMD2pick_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=DHR_ASMD2pick X=0 Y=0 Z=0 YAW=64
#exec MESHMAP SCALE MESHMAP=DHR_ASMD2pick X=0.07 Y=0.07 Z=0.14

#exec MESH SEQUENCE MESH=DHR_ASMD2pick SEQ=All   STARTFRAME=0  NUMFRAMES=1
#exec MESH SEQUENCE MESH=DHR_ASMD2pick SEQ=Still STARTFRAME=0  NUMFRAMES=1

#exec MESHMAP SETTEXTURE MESHMAP=DHR_ASMD2pick NUM=0 TEXTURE=ChekzDamageHealShockRifle.Skins.DHR_SASMD_t

//=============================================================================
// Mesh - Third Person
//=============================================================================
#exec MESH IMPORT MESH=DHR_SASMD2hand ANIVFILE=MODELS\DHR_SASMD2hand_a.3D DATAFILE=MODELS\DHR_SASMD2hand_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=DHR_SASMD2hand X=25 Y=600 Z=-40 YAW=64 PITCH=0
#exec MESHMAP SCALE MESHMAP=DHR_SASMD2hand X=0.004 Y=0.003 Z=0.008

#exec MESH SEQUENCE MESH=DHR_SASMD2hand SEQ=All   STARTFRAME=0  NUMFRAMES=10
#exec MESH SEQUENCE MESH=DHR_SASMD2hand SEQ=Still STARTFRAME=0  NUMFRAMES=1
#exec MESH SEQUENCE MESH=DHR_SASMD2hand SEQ=Fire1 STARTFRAME=1  NUMFRAMES=9  RATE=24
#exec MESH SEQUENCE MESH=DHR_SASMD2hand SEQ=Fire2 STARTFRAME=1  NUMFRAMES=9  RATE=24

#exec MESHMAP SETTEXTURE MESHMAP=DHR_SASMD2hand NUM=0 TEXTURE=ChekzDamageHealShockRifle.Skins.DHR_SASMD_t

//=============================================================================
// Configurable Properties
//=============================================================================
var() int DamageAmount;
var() float DamageBeamHitDamage;
var() float DamageBeamFireSpeed;

var() int HealAmount;
var() float HealBeamHitDamage;
var() float HealBeamFireSpeed;

struct FogRGB {
	var() float R;
	var() float G;
	var() float B;
};

var(DamageHealShockRifleClientFlash) bool bDisplayClientFlash;

var(DamageHealShockRifleClientFlash) FogRGB DamageFlashColor;
var(DamageHealShockRifleClientFlash) float DamageFlashScale;

var(DamageHealShockRifleClientFlash) FogRGB HealFlashColor;
var(DamageHealShockRifleClientFlash) float HealFlashScale;

var(DamageHealShockRiflePlayerSpeed) bool bChangeAirSpeed;
var(DamageHealShockRiflePlayerSpeed) bool bChangeGroundSpeed;
var(DamageHealShockRiflePlayerSpeed) bool bChangeWaterSpeed;

var(DamageHealShockRiflePlayerSpeed) float HealSpeedMultiplier;
var(DamageHealShockRiflePlayerSpeed) float DamageSpeedMultiplier;

var(DamageHealShockRifleSound) sound HealBeamFireSound;
var(DamageHealShockRifleSound) sound DamageBeamFireSound;

//=============================================================================
// Non-Configurable Properties
//=============================================================================
var bool bHealBeamFired;
var bool bDamageBeamFired;

var bool bCanUpdateOwnerSpeed;

var playerpawn DHROwner;

function PostBeginPlay()
{
	bCanUpdateOwnerSpeed = bChangeAirSpeed || bChangeGroundSpeed || bChangeWaterSpeed;
}

//=============================================================================
// Adds DamageHealShockRifle properties to DHR instance
// 
// param Other The PlayerPawn who spawned the DHR
//=============================================================================
function inventory SpawnCopy( pawn Other )
{
	local DamageHealShockRifle Copy;
	if( Level.Game.ShouldRespawn(self) )
	{
		Copy = spawn(Class,Other,,,rot(0,0,0));
		Copy.Tag = Tag;
		Copy.Event = Event;

		Copy.HealAmount = HealAmount;
		Copy.DamageAmount = DamageAmount;

		Copy.HealBeamHitDamage = HealBeamHitDamage;
		Copy.DamageBeamHitDamage = DamageBeamHitDamage;

		Copy.HealBeamFireSpeed = HealBeamFireSpeed;
		Copy.DamageBeamFireSpeed = DamageBeamFireSpeed;

		Copy.HealFlashColor = HealFlashColor;
		Copy.DamageFlashColor = DamageFlashColor;

		Copy.HealFlashScale = HealFlashScale;
		Copy.DamageFlashScale = DamageFlashScale;

		Copy.HealBeamFireSound = HealBeamFireSound;
		Copy.DamageBeamFireSound = DamageBeamFireSound;

		GotoState('Sleeping');
	}
	else
		Copy = self;

	Copy.RespawnTime = 0.0;
	Copy.bHeldItem = true;
	Copy.bTossedOut = false;
	Copy.GiveTo( Other );
	Copy.PickupAmmoCount = PickupAmmoCount;
	Copy.Instigator = Other;
	Copy.GiveAmmo(Other);
	Copy.SetSwitchPriority(Other);
	if ( !Other.bNeverSwitchOnPickup )
		Copy.WeaponSet(Other);
	Copy.AmbientGlow = 0;
	return Copy;
}

//=============================================================================
// Fires damage beam
// Damages Owner
// Updates player speed if possible
//
// param Value Value is 0???
//=============================================================================
function Fire( float Value )
{
	bDamageBeamFired = True;

	GotoState('NormalFire');
	bCanClientFire = true;
	bPointing=True;
	ClientFire(DamageBeamHitDamage);
	if ( bRapidFire || (DamageBeamFireSpeed > 0) )
		DHROwner.PlayRecoil(DamageBeamFireSpeed);
	if ( bInstantHit )
		TraceFire(0.0);

	DamageOwner();

	UpdateOwnerSpeed(DamageAmount, DamageSpeedMultiplier);
}

//=============================================================================
// Calls PlayDHRFiring(FogRGB FlashColor, float FlashScale, sound FireSound, float FireSpeed)
//=============================================================================
simulated function PlayFiring()
{
	PlayDHRFiring(DamageFlashColor, DamageFlashScale, FireSound, DamageBeamFireSpeed);
}

//=============================================================================
// Calls PlayDHRFiring(FogRGB FlashColor, float FlashScale, sound FireSound, float FireSpeed)
//=============================================================================
simulated function PlayAltFiring()
{
	PlayDHRFiring(HealFlashColor, HealFlashScale, AltFireSound, HealBeamFireSpeed);
}

//=============================================================================
// PlayDHRFiring is simulated to run on Client.
//
// Displays Client flash if configured
// Plays a fire sound
// Performs fire animation
//
// param FlashColor R,G,B values of Client Flash
// param FlashScale Intensity of Client Flash
// param FireSound The Sound to play when firing
// param FireSpeed The speed at which to fire
//=============================================================================
simulated function PlayDHRFiring(FogRGB FlashColor, float FlashScale, sound FireSound, float FireSpeed)
{
	local vector Fog;

	if (bDisplayClientFlash)
	{
		Fog.X = FlashColor.R;
		Fog.Y = FlashColor.G;
		Fog.Z = FlashColor.B;
		DHROwner.ClientFlash(FlashScale, Fog);
	}

	PlaySound(FireSound, SLOT_None, 2);
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
	DHROwner.PlayRecoil(HealBeamFireSpeed);
	bCanClientFire = true;
	bPointing=True;
	TraceFire(0.0);
	ClientAltFire(HealBeamHitDamage);

	HealOwner();
	UpdateOwnerSpeed(HealAmount, HealSpeedMultiplier);
}

//=============================================================================
// Heals Owner
//=============================================================================
function HealOwner()
{
	if (DHROwner.Health == 100)
		return;

	if (DHROwner.Health + HealAmount > 100)
		DHROwner.Health = 100;
	else
		DHROwner.Health += HealAmount;
}

//=============================================================================
// Damages Owner
//=============================================================================
function DamageOwner()
{
	DHROwner.Health -= DamageAmount;

	if (DHROwner.Health <= 0)
	{
		DHROwner.Suicide();
		ResetDHROwner();
	}
}

//=============================================================================
// Update Owner speed
//=============================================================================
function UpdateOwnerSpeed( float HealthChange, float Multiplier )
{
	local float UpdatedGroundSpeed;
	local float UpdatedAirSpeed;
	local float UpdatedWaterSpeed;
	
	if (!bCanUpdateOwnerSpeed)
		return;

	UpdatedGroundSpeed = DHROwner.GroundSpeed + (HealthChange * Multiplier);
	UpdatedAirSpeed = DHROwner.AirSpeed + (HealthChange * Multiplier);
	UpdatedWaterSpeed = DHROwner.WaterSpeed + (HealthChange * Multiplier);

	if ((UpdatedGroundSpeed >= DHROwner.Default.GroundSpeed) && bChangeGroundSpeed)
		DHROwner.GroundSpeed = UpdatedGroundSpeed;
	
	if ((UpdatedAirSpeed >= DHROwner.Default.AirSpeed) && bChangeAirSpeed)
		DHROwner.AirSpeed = UpdatedAirSpeed;

	if ((UpdatedWaterSpeed >= DHROwner.Default.WaterSpeed) && bChangeWaterSpeed)
		DHROwner.WaterSpeed = UpdatedWaterSpeed;
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
// Resets 
//=============================================================================
function Destroyed()
{
	Super.Destroyed();

	if (bCanUpdateOwnerSpeed)
		ResetDHROwner();
}

function TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
{
	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
	BroadCastMessage("Inside Take Damage");
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
	FinishAnim();
	DHROwner = PlayerPawn(Owner);
	ResetDHROwner();
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
      DamageAmount=20
      DamageBeamHitDamage=100.000000
      DamageBeamFireSpeed=1.000000
      HealAmount=20
      HealBeamHitDamage=50.000000
      HealBeamFireSpeed=1.000000
      bDisplayClientFlash=False
      DamageFlashColor=(R=255.000000,G=0.000000,B=25.000000)
      DamageFlashScale=-0.250000
      HealFlashColor=(R=0.000000,G=255.000000,B=50.000000)
      HealFlashScale=-0.250000
      bChangeAirSpeed=True
      bChangeGroundSpeed=True
      bChangeWaterSpeed=True
      DamageSpeedMultiplier=5.000000
      HealSpeedMultiplier=-5.000000
      FireSound=Sound'ChekzDamageHealShockRifle.FireSounds.DamageBeamFireSound'
      AltFireSound=Sound'ChekzDamageHealShockRifle.FireSounds.HealBeamFireSound'
      bHealBeamFired=False
      bDamageBeamFired=False
      bCanUpdateOwnerSpeed=False
      DHROwner=None
      PickupMessage="You got the Damage Heal Rifle."
      ItemName="Damage Heal Rifle"
      Mesh=LodMesh'DHR_ASMD2pick'
      PickupViewMesh=LodMesh'DHR_ASMD2pick'
      PlayerViewMesh=LodMesh'DHR_sshockm'
      ThirdPersonMesh=LodMesh'DHR_SASMD2hand'
      RemoteRole=ROLE_DumbProxy // Needed for sounds to play online
}
