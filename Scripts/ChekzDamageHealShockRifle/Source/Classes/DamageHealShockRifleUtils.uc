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

	if (class'DamageHealShockRifleMutator'.default.bChangeAirSpeed)
		if ((UpdatedAirSpeed >= P.default.AirSpeed))
			P.AirSpeed = UpdatedAirSpeed;
		else
			P.GroundSpeed = P.default.GroundSpeed;

	if (class'DamageHealShockRifleMutator'.default.bChangeGroundSpeed)
		if ((UpdatedGroundSpeed >= P.default.GroundSpeed))
			P.GroundSpeed = UpdatedGroundSpeed;
		else
			P.GroundSpeed = P.default.GroundSpeed;

	if (class'DamageHealShockRifleMutator'.default.bChangeWaterSpeed)
		if ((UpdatedWaterSpeed >= P.default.WaterSpeed))
			P.WaterSpeed = UpdatedWaterSpeed;
		else
			P.GroundSpeed = P.default.GroundSpeed;
}