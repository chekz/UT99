//=============================================================================
// Author: chekz
//
// A copy of TournamentHealth with an addition for updating player speed
//=============================================================================
class DHR_TournamentHealth extends PickUp
	abstract;

//=============================================================================
// Configurable Properties
//=============================================================================
var() int HealingAmount;
var() bool bSuperHeal;

//=============================================================================
// Bot Desireability code
//=============================================================================
event float BotDesireability(Pawn Bot)
{
	local float desire;
	local int HealMax;

	HealMax = Bot.Default.Health;
	if (bSuperHeal) HealMax = Min(199, HealMax * 2.0);
	desire = Min(HealingAmount, HealMax - Bot.Health);

	if ( (Bot.Weapon != None) && (Bot.Weapon.AIRating > 0.5) )
		desire *= 1.7;
	if ( Bot.Health < 45 )
		return ( FMin(0.03 * desire, 2.2) );
	else
	{
		if ( desire > 6 )
			desire = FMax(desire,25);
		return ( FMin(0.017 * desire, 2.0) ); 
	}
}

//=============================================================================
// Play pickup message
//=============================================================================
function PlayPickupMessage(Pawn Other)
{
	Other.ReceiveLocalizedMessage( class'PickupMessageHealthPlus', 0, None, None, Self.Class );
}

//=============================================================================
// Enter Pickup state
//=============================================================================
auto state Pickup
{	
	//=============================================================================
	// Heals player
	// Updates player speed
	//=============================================================================
	function Touch( actor Other )
	{
		local int HealMax;
		local Pawn P;

		if ( ValidTouch(Other) ) 
		{	
			P = Pawn(Other);	
			HealMax = P.default.health;
			if (bSuperHeal) HealMax = Min(199, HealMax * 2.0);
			if (P.Health < HealMax) 
			{
				if (Level.Game.LocalLog != None)
					Level.Game.LocalLog.LogPickup(Self, P);
				if (Level.Game.WorldLog != None)
					Level.Game.WorldLog.LogPickup(Self, P);
				P.Health += HealingAmount;

				class'DamageHealShockRifleUtils'.static.UpdatePlayerSpeed(P,
					HealingAmount,
					-class'DamageHealShockRifleMutator'.default.SpeedMultiplier
				);
				if (P.Health > HealMax) P.Health = HealMax;
				PlayPickupMessage(P);
				PlaySound (PickupSound,,2.5);
				Other.MakeNoise(0.2);		
				SetRespawn();
			}
		}
	}
}

defaultproperties
{
      HealingAmount=20
      bSuperHeal=False
      PickupMessage="You picked up a Health Pack"
      RespawnTime=20.000000
      MaxDesireability=0.500000
      PickupSound=Sound'UnrealShare.Pickups.Health2'
      Icon=Texture'UnrealShare.Icons.I_Health'
      RemoteRole=ROLE_DumbProxy
      AmbientGlow=64
      CollisionRadius=22.000000
      CollisionHeight=8.000000
      Mass=10.000000
}