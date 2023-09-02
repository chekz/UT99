//=============================================================================
// Author: chekz
//=============================================================================
class DHR_HealthPack extends DHR_TournamentHealth;

defaultproperties
{
      HealingAmount=100
      PickupMessage="You picked up the Big Keg O' Health"
      ItemName="Super Health Pack"
      RespawnTime=100.000000
      PickupViewMesh=LodMesh'Botpack.hbox'
      MaxDesireability=2.000000
      PickupSound=Sound'Botpack.Pickups.UTSuperHeal'
      Mesh=LodMesh'Botpack.hbox'
      DrawScale=0.800000
      CollisionRadius=26.000000
      CollisionHeight=19.500000
}