//=============================================================================
// Made By ch3kz
//=============================================================================

class DamageBeam extends ShockBeam;

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
      Texture=Texture'ChekzDamageHealRifle.Effects.d_jenergy2'
}
