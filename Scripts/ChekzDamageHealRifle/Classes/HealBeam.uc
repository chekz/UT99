//=============================================================================
// Made By ch3kz
//=============================================================================

class HealBeam extends ShockBeam;

simulated function Timer()
{
	local HealBeam r;
	
	if (NumPuffs>0)
	{
		r = Spawn(class'HealBeam',,,Location+MoveAmount);
		r.RemoteRole = ROLE_None;
		r.NumPuffs = NumPuffs -1;
		r.MoveAmount = MoveAmount;
	}
}

defaultproperties
{
      Texture=Texture'ChekzDamageHealRifle.Effects.h_jenergy2'
}
