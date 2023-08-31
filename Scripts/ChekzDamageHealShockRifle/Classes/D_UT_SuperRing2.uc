//=============================================================================
// Author: chekz
//=============================================================================
class D_UT_SuperRing2 extends D_UT_SuperRing;

simulated function PreBeginPlay()
{
	bExtraEffectsSpawned = false;
}

//=============================================================================
// Spawns Damage Shock Explosion
// Spawns D_UT_SuperRing (Damage Ring animation from blast site) if configured
//=============================================================================
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