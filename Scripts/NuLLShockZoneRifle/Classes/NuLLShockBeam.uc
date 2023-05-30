//=============================================================================
// NullShockBeam.
// Made by >@tack!<
//=============================================================================
class NullShockBeam expands ShockBeam;

var float ShockBeamScale;
var float ShockBeamSpeedScale;

replication
{
	// Things the server should send to the client.
	unreliable if( Role==ROLE_Authority )
		ShockBeamScale, ShockBeamSpeedScale;
}

simulated function PostNetBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer )
	{
		SetTimer(0.05 / ShockBeamSpeedScale, false);
	}
}

simulated function Initialize(float BeamScale, float BeamSpeedScale)
{
	ShockBeamScale = BeamScale;
	ShockBeamSpeedScale = BeamSpeedScale;
	DrawScale = ShockBeamScale;

	if(Level.NetMode == NM_Client)
	{
		SetTimer(0.05 / ShockBeamSpeedScale, false);
	}
}

simulated function Timer()
{
	local NullShockBeam r;

	if (NumPuffs>0)
	{
		r = Spawn(class'NullShockbeam',,,Location+MoveAmount);
		r.RemoteRole = ROLE_None;
		r.NumPuffs = NumPuffs -1;
		r.MoveAmount = MoveAmount;
		r.Initialize(ShockBeamScale, ShockBeamSpeedScale);
	}
}
