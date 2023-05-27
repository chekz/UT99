//=============================================================================
//
// VolumetricLightingZone: Ensures player has VolumetricLighting=True in
// GameRenderDevice
//
// Author: ch3kz
//=============================================================================

class VolumetricLightingZone extends ZoneInfo;

var string VolumetricLighting;
var playerpawn CurrentPlayerPawn;
var() string DeathMessage;
var() float VolumetricLightingCheckInterval;

function Timer()
{
	VolumetricLighting = CurrentPlayerPawn.ConsoleCommand("get ini:Engine.Engine.GameRenderDevice VolumetricLighting");

	if (VolumetricLighting != "True")
	{
		KillPlayer();
		SetTimer(0, False);
	}
}

function KillPlayer()
{
	if (DeathMessage != "")
		CurrentPlayerPawn.ClientMessage(DeathMessage);

	CurrentPlayerPawn.Suicide();
}

event ActorEntered( actor Other )
{
	super.ActorEntered(Other);

	if (Other.IsA('PlayerPawn'))
		CurrentPlayerPawn = PlayerPawn(Other);
	else
		return;

	// ActorEntered is called on player death before respawn so ensure CurrentPlayerPawn Health > 0
	if (CurrentPlayerPawn.Health > 0)
		SetTimer(VolumetricLightingCheckInterval, True);
}

event ActorLeaving( actor Other )
{
	super.ActorLeaving(Other);

	SetTimer(0,False);
}

defaultproperties
{
	bEdShouldSnap=True
	bStatic=False
	VolumetricLighting=""
	CurrentPlayerPawn=None

	DeathMessage=""
	VolumetricLightingCheckInterval=0.1
}