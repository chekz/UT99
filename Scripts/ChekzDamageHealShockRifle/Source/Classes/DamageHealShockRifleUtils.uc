//=============================================================================
// Author: chekz
//=============================================================================
class DamageHealShockRifleUtils extends Object;

//=============================================================================
// Updates Player Speed
//
// param P The player to update speed to
// param SpeedAmount The amount of speed
// param Multiplier Multipler to be applied to SpeedAmount
//=============================================================================
static function UpdatePlayerSpeed(pawn P, float SpeedAmount, float Multiplier)
{
	local float UpdatedGroundSpeed;
	local float UpdatedAirSpeed;
	local float UpdatedWaterSpeed;

	UpdatedAirSpeed = P.AirSpeed + (SpeedAmount * Multiplier);
	UpdatedGroundSpeed = P.GroundSpeed + (SpeedAmount * Multiplier);
	UpdatedWaterSpeed = P.WaterSpeed + (SpeedAmount * Multiplier);

	if (UpdatedAirSpeed < 0)
		UpdatedAirSpeed = 0;

	if (UpdatedGroundSpeed < 1)
		UpdatedGroundSpeed = 1;

	if (UpdatedWaterSpeed < 0)
		UpdatedWaterSpeed = 0;

	if (class'DamageHealShockRifleMutator'.default.bChangeAirSpeed)
		P.AirSpeed = UpdatedAirSpeed;

	if (class'DamageHealShockRifleMutator'.default.bChangeGroundSpeed)
		P.GroundSpeed = UpdatedGroundSpeed;

	if (class'DamageHealShockRifleMutator'.default.bChangeWaterSpeed)
		P.WaterSpeed = UpdatedWaterSpeed;
}

//=============================================================================
// Returns HealAmount based off MaxHealth
//=============================================================================
static function int GetHealAmount(pawn P, int HealAmount, int MaxHealth)
{
	local int UpdatedHealth;

	UpdatedHealth = P.Health + HealAmount;

	if (UpdatedHealth > MaxHealth)
		return MaxHealth - P.Health;

	return HealAmount;
}