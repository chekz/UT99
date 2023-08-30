//=============================================================================
// Made by ch3kz
//=============================================================================
class H_UT_SuperRing2 extends H_UT_SuperRing;

simulated function PreBeginPlay()
{
	bExtraEffectsSpawned = false;
}

simulated function SpawnExtraEffects()
{
	local actor a;

	bExtraEffectsSpawned = true;
	a = Spawn(class'HealShockExplo');
	a.RemoteRole = ROLE_None;

	Spawn(class'EnergyImpact');

	if ( Level.bHighDetailMode && !Level.bDropDetail )
	{
		a = Spawn(class'H_UT_SuperRing');
		a.RemoteRole = ROLE_None;
	}
}

defaultproperties
{
}
