//=============================================================================
// Author: chekz
//=============================================================================
class DamageHealShockRifleMutator extends Arena;

//=============================================================================
// Sounds
//=============================================================================
#exec AUDIO IMPORT FILE="Sounds\HealBeamFireSound.wav" NAME="HealBeamFireSound" GROUP="FireSounds"
#exec AUDIO IMPORT FILE="Sounds\DamageBeamFireSound.wav" NAME="DamageBeamFireSound" Group="FireSounds"

//=============================================================================
// Configurable Properties
//=============================================================================
var(DamageHealShockRiflePlayerSettings) int MaxHealth;
var(DamageHealShockRiflePlayerSettings) int StartingHealth;

var(DamageHealShockRilfeSettings) int DamageAmount;
var(DamageHealShockRilfeSettings) float DamageBeamHitDamage;
var(DamageHealShockRilfeSettings) float DamageBeamFireSpeed;

var(DamageHealShockRilfeSettings) int HealAmount;
var(DamageHealShockRilfeSettings) float HealBeamHitDamage;
var(DamageHealShockRilfeSettings) float HealBeamFireSpeed;

var(DamageHealShockRilfeSettings) sound HealBeamFireSound;
var(DamageHealShockRilfeSettings) sound DamageBeamFireSound;

var(DamageHealShockRilfeSpeedSettings) bool bChangeAirSpeed;
var(DamageHealShockRilfeSpeedSettings) bool bChangeGroundSpeed;
var(DamageHealShockRilfeSpeedSettings) bool bChangeWaterSpeed;
var(DamageHealShockRilfeSpeedSettings) float SpeedMultiplier;

//=============================================================================
// Non-Configurable Properties
//=============================================================================
var bool Initialized;
var bool bCanUpdateOwnerSpeed;

//=============================================================================
// Register Damage Mutator
//=============================================================================
function PostBeginPlay()
{
	if (Initialized)
		return;
	Initialized = True;
	SetDefaults();
	
	Level.Game.RegisterDamageMutator(Self);
}

//=============================================================================
// Set default value to any changed one from DamageHealShockRifleMutator
//
// This is a bit of a hack so class'DamageHealShockRifleMutator'.default.<var>
// can be called with updated values. : )
//=============================================================================
function SetDefaults()
{
	default.MaxHealth = MaxHealth;
	default.StartingHealth = StartingHealth;

	default.DamageBeamFireSpeed = DamageBeamFireSpeed;
	default.DamageBeamHitDamage = DamageBeamHitDamage;
	default.DamageBeamFireSpeed = DamageBeamFireSpeed;

	default.HealAmount = HealAmount;
	default.HealBeamHitDamage = HealBeamHitDamage;
	default.HealBeamFireSpeed = HealBeamFireSpeed;

	default.HealBeamFireSound = HealBeamFireSound;
	default.DamageBeamFireSound = DamageBeamFireSound;

	default.bChangeAirSpeed = bChangeAirSpeed;
	default.bChangeGroundSpeed = bChangeGroundSpeed;
	default.bChangeWaterSpeed = bChangeWaterSpeed;

	default.SpeedMultiplier = SpeedMultiplier;

	bCanUpdateOwnerSpeed = (bChangeAirSpeed || bChangeGroundSpeed || bChangeWaterSpeed);
	default.bCanUpdateOwnerSpeed = bCanUpdateOwnerSpeed;
}

//=============================================================================
// Removes unwanted items
// Replaces MedBox, HealthVial and HealthPack with DHR_ equivalents
//=============================================================================
function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	if (Other.IsA('UT_Shieldbelt')
		|| Other.IsA('Armor2')
		|| Other.IsA('ThighPads')
		|| Other.IsA('UT_Invisibility')
		|| Other.IsA('UDamage'))
			return false;

	if ( !Other.IsA('DHR_MedBox') && Other.IsA('MedBox'))
	{
		ReplaceWith(Other, "ChekzDamageHealShockRifle.DHR_MedBox");
		return false;
	}
	if ( !Other.IsA('DHR_HealthVial') && Other.IsA('HealthVial'))
	{
		ReplaceWith( Other, "ChekzDamageHealShockRifle.DHR_HealthVial");
		return false;
	}
	if ( !Other.IsA('DHR_HealthPack') && Other.IsA('HealthPack') )
	{
		ReplaceWith(Other, "ChekzDamageHealShockRifle.DHR_HealthPack");
		return false;
	}

	return Super.CheckReplacement(Other, bSuperRelevant);
}

//=============================================================================
// Update player speed when damage taken
//=============================================================================
function MutatorTakeDamage(out int ActualDamage, Pawn Victim, Pawn InstigatedBy, out Vector HitLocation, out Vector Momentum, name DamageType)
{
	if (bCanUpdateOwnerSpeed)
		class'DamageHealShockRifleUtils'.static.UpdatePlayerSpeed(
			Victim,
			ActualDamage,
			SpeedMultiplier
		);

	if ( NextDamageMutator != None )
		NextDamageMutator.MutatorTakeDamage(ActualDamage, Victim, InstigatedBy, HitLocation, Momentum, DamageType);
}

defaultproperties
{
      MaxHealth=100
      StartingHealth=100
      DamageAmount=20
      DamageBeamHitDamage=100.000000
      DamageBeamFireSpeed=1.000000
      HealAmount=20
      HealBeamHitDamage=50.000000
      HealBeamFireSpeed=1.000000
      HealBeamFireSound=Sound'ChekzDamageHealShockRifle.FireSounds.HealBeamFireSound'
      DamageBeamFireSound=Sound'ChekzDamageHealShockRifle.FireSounds.DamageBeamFireSound'
      bChangeAirSpeed=True
      bChangeGroundSpeed=True
      bChangeWaterSpeed=True
      SpeedMultiplier=5.000000
      WeaponName=DamageHealShockRifle
      DefaultWeapon=Class'ChekzDamageHealShockRifle.DamageHealShockRifle'
}