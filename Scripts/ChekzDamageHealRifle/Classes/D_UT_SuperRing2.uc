//=============================================================================
// Made by ch3kz
//=============================================================================
class D_UT_SuperRing2 extends D_UT_SuperRing;

simulated function PreBeginPlay()
{
	bExtraEffectsSpawned = false;
}

simulated function SpawnExtraEffects()
{
	local actor a;

	bExtraEffectsSpawned = true;
	a = Spawn(class'DamageShockExplo');
	a.RemoteRole = ROLE_None;

	Spawn(class'EnergyImpact');

	if ( Level.bHighDetailMode && !Level.bDropDetail )
	{
		a = Spawn(class'D_UT_SuperRing');
		a.RemoteRole = ROLE_None;
	}
}

defaultproperties
{
}
