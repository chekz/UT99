//=============================================================================
//
// MultiplyKicker: A normal kicker with an option to kick the player using the
// players velocity and a multiplier.
//
// Author: ch3kz
//=============================================================================

class MultiplyKicker extends Kicker;

#exec Texture Import File=Textures\S_Actor_Chekz.pcx Name=S_Actor_Chekz Mips=Off Flags=2

var() Vector Multiplier;
var() bool bUseKickerXVelocity;
var() bool bUseKickerYVelocity;
var() bool bUseKickerZVelocity;
var bool bMultiplierAdded;

simulated function PostTouch( Actor Other )
{
	local bool bWasFalling;
	local vector Push;
	local float PMag;
	local Pawn P;
	local PlayerPawn CurrentPlayer;

	if ( !bMultiplierAdded )
	{
		for ( P=Level.PawnList; P!=None; P=P.NextPawn )
		{
			if ( P.bIsPlayer && P.IsA('PlayerPawn') )
			{
				CurrentPlayer = PlayerPawn(P);
				
				if ( !bUseKickerXVelocity )
					KickVelocity.X = CurrentPlayer.Velocity.X * Multiplier.X;

				if ( !bUseKickerYVelocity )
					KickVelocity.Y = CurrentPlayer.Velocity.Y * Multiplier.Y;

				if ( !bUseKickerZVelocity )
					KickVelocity.Z = CurrentPlayer.Velocity.Z * Multiplier.Z;
			}
		}

		bMultiplierAdded = True;
	}

	bWasFalling = ( Other.Physics == PHYS_Falling );
	if ( bKillVelocity )
		Push = -1 * Other.Velocity;
	else
		Push.Z = -1 * Other.Velocity.Z;
	if ( bRandomize )
	{
		PMag = VSize(KickVelocity);
		Push += PMag * Normal(KickVelocity + 0.5 * PMag * VRand());
	}
	else
		Push += KickVelocity;
	if ( Other.IsA('Bot') )
	{
		if ( bWasFalling )
			Bot(Other).bJumpOffPawn = true;
		Bot(Other).SetFall();
	}

	Other.SetPhysics(PHYS_Falling);
	Other.Velocity += Push;
}

function UnTouch(Actor Other)
{
	bMultiplierAdded = False;
}

defaultproperties
{
	KickVelocity=(X=0.000000,Y=0.000000,Z=0.000000)
	KickedClasses="Pawn"
	bKillVelocity=False
	bRandomize=False
	bAlwaysRelevant=True
	RemoteRole=ROLE_SimulatedProxy
	bDirectional=True

	bEdShouldSnap=True

	Multiplier=(X=1.000000,Y=1.000000,Z=1.000000)
	bUseKickerXVelocity=False
	bUseKickerYVelocity=False
	bUseKickerZVelocity=True
	Texture=Texture'S_Actor_Chekz'
}