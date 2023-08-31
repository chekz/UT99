//=============================================================================
// Author: chekz
//=============================================================================
class DamageBeam extends ShockBeam;

//=============================================================================
// Spawns Damage Beam
//=============================================================================
simulated function Timer()
{
	local DamageBeam r;
	
	if (NumPuffs>0)
	{
		r = Spawn(class'DamageBeam',,,Location+MoveAmount);
		r.RemoteRole = ROLE_None;
		r.NumPuffs = NumPuffs -1;
		r.MoveAmount = MoveAmount;
	}
}

defaultproperties
{
      Texture=Texture'ChekzDamageHealShockRifle.Effects.d_jenergy2'
}
