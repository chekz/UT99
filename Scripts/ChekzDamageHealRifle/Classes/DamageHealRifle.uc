//=============================================================================
// Made by ch3kz
// TODO: 
// - Option for stopping shooting when at max health.
// - Play Recoil, No Beam, Can't Work Sound
// - Custom Death Message when gun deals too much damage
// - Put meshes into .u file
// - On suicide and weapon drop put player speed back to what it was
//=============================================================================

class DamageHealRifle extends SuperShockRifle;

#exec OBJ LOAD FILE=Textures\ChekzDamageHealRifle.utx PACKAGE=ChekzDamageHealRifle

#exec AUDIO IMPORT FILE="Sounds\HealBeamSound.wav" NAME="HealBeamSound"
#exec AUDIO IMPORT FILE="Sounds\DamageBeamSound.wav" NAME="DamageBeamSound"

//=============================================================================
// PlayerView Mesh
//=============================================================================
#exec MESH IMPORT MESH=DHR_sshockm ANIVFILE=MODELS\DHR_sshockm_a.3D DATAFILE=MODELS\DHR_sshockm_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=DHR_sshockm X=0 Y=0 Z=0 YAW=64 PITCH=0
#exec MESH SEQUENCE MESH=DHR_sshockm SEQ=All       STARTFRAME=0  NUMFRAMES=52
#exec MESH SEQUENCE MESH=DHR_sshockm SEQ=Select    STARTFRAME=0  NUMFRAMES=15 RATE=30 GROUP=Select
#exec MESH SEQUENCE MESH=DHR_sshockm SEQ=Still     STARTFRAME=15 NUMFRAMES=1
#exec MESH SEQUENCE MESH=DHR_sshockm SEQ=Down      STARTFRAME=17 NUMFRAMES=7  RATE=27
#exec MESH SEQUENCE MESH=DHR_sshockm SEQ=Still2    STARTFRAME=28 NUMFRAMES=2
#exec MESH SEQUENCE MESH=DHR_sshockm SEQ=Fire1     STARTFRAME=30 NUMFRAMES=10  RATE=22
#exec MESH SEQUENCE MESH=DHR_sshockm SEQ=Fire2     STARTFRAME=40 NUMFRAMES=10  RATE=24

#exec TEXTURE IMPORT NAME=DHR_SASMD_t1 FILE=MODELS\DHR_SASMD_t1.bmp GROUP="Skins" LODSET=2
#exec TEXTURE IMPORT NAME=DHR_SASMD_t2 FILE=MODELS\DHR_SASMD_t2.bmp GROUP="Skins" LODSET=2
#exec TEXTURE IMPORT NAME=DHR_SASMD_t3 FILE=MODELS\DHR_SASMD_t3.bmp GROUP="Skins" LODSET=2
#exec TEXTURE IMPORT NAME=DHR_SASMD_t4 FILE=MODELS\DHR_SASMD_t4.bmp GROUP="Skins" LODSET=2
#exec MESHMAP SCALE MESHMAP=DHR_sshockm X=0.004 Y=0.003 Z=0.008
#exec MESHMAP SETTEXTURE MESHMAP=DHR_sshockm NUM=0 TEXTURE=DHR_SASMD_t1
#exec MESHMAP SETTEXTURE MESHMAP=DHR_sshockm NUM=1 TEXTURE=DHR_SASMD_t2
#exec MESHMAP SETTEXTURE MESHMAP=DHR_sshockm NUM=2 TEXTURE=DHR_SASMD_t3
#exec MESHMAP SETTEXTURE MESHMAP=DHR_sshockm NUM=3 TEXTURE=DHR_SASMD_t3
#exec MESHMAP SETTEXTURE MESHMAP=DHR_sshockm NUM=4 TEXTURE=DHR_SASMD_t4

//=============================================================================
// PickupView Mesh
//=============================================================================
#exec MESH IMPORT MESH=DHR_ASMD2pick ANIVFILE=MODELS\DHR_ASMD2pick_a.3D DATAFILE=MODELS\DHR_ASMD2pick_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=DHR_ASMD2pick X=0 Y=0 Z=0 YAW=64 
#exec MESH SEQUENCE MESH=DHR_ASMD2pick SEQ=All   STARTFRAME=0  NUMFRAMES=1
#exec MESH SEQUENCE MESH=DHR_ASMD2pick SEQ=Still STARTFRAME=0  NUMFRAMES=1
#exec MESHMAP SCALE MESHMAP=DHR_ASMD2pick X=0.07 Y=0.07 Z=0.14
#exec TEXTURE IMPORT NAME=DHR_SASMD_t FILE=MODELS\DHR_SASMD_t.bmp GROUP="Skins" LODSET=2
#exec MESHMAP SETTEXTURE MESHMAP=DHR_ASMD2pick NUM=0 TEXTURE=DHR_SASMD_t

//=============================================================================
// Third Person View Mesh
//=============================================================================
#exec MESH IMPORT MESH=DHR_SASMD2hand ANIVFILE=MODELS\DHR_SASMD2hand_a.3D DATAFILE=MODELS\DHR_SASMD2hand_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=DHR_SASMD2hand X=25 Y=600 Z=-40 YAW=64 PITCH=0
#exec MESH SEQUENCE MESH=DHR_SASMD2hand SEQ=All   STARTFRAME=0  NUMFRAMES=10
#exec MESH SEQUENCE MESH=DHR_SASMD2hand SEQ=Still STARTFRAME=0  NUMFRAMES=1
#exec MESH SEQUENCE MESH=DHR_SASMD2hand SEQ=Fire1 STARTFRAME=1  NUMFRAMES=9  RATE=24
#exec MESH SEQUENCE MESH=DHR_SASMD2hand SEQ=Fire2 STARTFRAME=1  NUMFRAMES=9  RATE=24
#exec MESHMAP SCALE MESHMAP=DHR_SASMD2hand X=0.004 Y=0.003 Z=0.008
#exec MESHMAP SETTEXTURE MESHMAP=DHR_SASMD2hand NUM=0 TEXTURE=DHR_SASMD_t

var() float HealBeamDamage;
var() float DamageBeamDamage;

var() float HealBeamFireSpeed;
var() float DamageBeamFireSpeed;

var() int HealAmount;
var() int DamageAmount;

struct FogRGB {
	var() float R;
	var() float G;
	var() float B;
};

var(DamageHealRifleClientFlash) bool bDisplayClientFlash;

var(DamageHealRifleClientFlash) FogRGB HealFlashColor;
var(DamageHealRifleClientFlash) float HealFlashScale;

var(DamageHealRifleClientFlash) FogRGB DamageFlashColor;
var(DamageHealRifleClientFlash) float DamageFlashScale;

var(DamageHealRiflePlayerSpeed) bool bChangeGroundSpeed;
var(DamageHealRiflePlayerSpeed) bool bChangeAirSpeed;
var(DamageHealRiflePlayerSpeed) bool bChangeWaterSpeed;
var(DamageHealRiflePlayerSpeed) float HealSpeedMultiplier;
var(DamageHealRiflePlayerSpeed) float DamageSpeedMultiplier;

var(DamageHealRifleSound) sound HealBeamFireSound;
var(DamageHealRifleSound) sound DamageBeamFireSound;

var bool bHealBeamFired;
var bool bDamageBeamFired;

var playerpawn DHROwner;

function inventory SpawnCopy( pawn Other )
{
	local DamageHealRifle Copy;
	if( Level.Game.ShouldRespawn(self) )
	{
		Copy = spawn(Class,Other,,,rot(0,0,0));
		Copy.Tag = Tag;
		Copy.Event = Event;

		Copy.HealAmount = HealAmount;
		Copy.DamageAmount = DamageAmount;

		Copy.HealBeamDamage = HealBeamDamage;
		Copy.DamageBeamDamage = DamageBeamDamage;

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

function Fire( float Value )
{
	bDamageBeamFired = True;

	GotoState('NormalFire');
	bCanClientFire = true;
	bPointing=True;
	ClientFire(DamageBeamDamage);
	if ( bRapidFire || (DamageBeamFireSpeed > 0) )
		DHROwner.PlayRecoil(DamageBeamFireSpeed);
	if ( bInstantHit )
		TraceFire(0.0);

	DamageOwner();
}

simulated function PlayFiring()
{
	PlayDHRFiring(DamageFlashColor, DamageFlashScale, DamageBeamFireSound, DamageBeamFireSpeed);
}

simulated function PlayAltFiring()
{
	PlayDHRFiring(HealFlashColor, HealFlashScale, HealBeamFireSound, HealBeamFireSpeed);
}

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

function AltFire( float Value )
{
	bHealBeamFired = True;

	GotoState('AltFiring');
	DHROwner.PlayRecoil(HealBeamFireSpeed);
	bCanClientFire = true;
	bPointing=True;
	TraceFire(0.0);
	ClientAltFire(HealBeamDamage);

	HealOwner();
}

function HealOwner()
{
	if (DHROwner.Health == 100)
		return;

	if (DHROwner.Health + HealAmount > 100)
		DHROwner.Health = 100;
	else
		DHROwner.Health += HealAmount;

	UpdateSpeed(HealAmount, HealSpeedMultiplier);
}

function DamageOwner()
{
	DHROwner.Health -= DamageAmount;

	if (DHROwner.Health <= 0)
	{
		DHROwner.Suicide();
		ResetDHROwner();
		return;
	}

	UpdateSpeed(DamageAmount, DamageSpeedMultiplier);
}

function UpdateSpeed(float HealthChange, float Multiplier)
{
	local float UpdatedGroundSpeed;
	local float UpdatedAirSpeed;
	local float UpdatedWaterSpeed;

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

function ResetDHROwner()
{
	DHROwner.GroundSpeed = DHROwner.Default.GroundSpeed;
	DHROwner.AirSpeed = DHROwner.Default.AirSpeed;
	DHROwner.WaterSpeed = DHROwner.Default.WaterSpeed;
}

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
      HealBeamDamage=40.000000
      DamageBeamDamage=100.000000
      HealBeamFireSpeed=1.000000
      DamageBeamFireSpeed=1.000000
      HealAmount=20
      DamageAmount=20
      bDisplayClientFlash=False
      HealFlashColor=(R=0.000000,G=255.000000,B=102.000000)
      HealFlashScale=-0.250000
      DamageFlashColor=(R=255.000000,G=0.000000,B=51.000000)
      DamageFlashScale=-0.250000
      bChangeGroundSpeed=True
      bChangeAirSpeed=True
      bChangeWaterSpeed=True
      HealSpeedMultiplier=-5.000000
      DamageSpeedMultiplier=5.000000
      HealBeamFireSound=Sound'ChekzDamageHealRifle.HealBeamSound'
      DamageBeamFireSound=Sound'ChekzDamageHealRifle.DamageBeamSound'
      bHealBeamFired=False
      bDamageBeamFired=False
      DHROwner=None
      PickupMessage="You got the Heal Damage Rifle."
      ItemName="Heal Damage Rifle"
      Mesh=LodMesh'DHR_ASMD2pick'
      PickupViewMesh=LodMesh'DHR_ASMD2pick'
      PlayerViewMesh=LodMesh'DHR_sshockm'
	  ThirdPersonMesh=LodMesh'DHR_SASMD2hand'
	  InstFog=(X=800.000000,Z=0.000000)
      RemoteRole=ROLE_DumbProxy
}
