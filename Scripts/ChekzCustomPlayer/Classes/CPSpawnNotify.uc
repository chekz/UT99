//=============================================================================
// CPSpawnNotify: Replaces current player with custom player.
//
// Author: ch3kz
// Note: The idea and skelton of this project was made by slade see
// sldPlayerExt at
// https://discord.com/channels/818071527144554497/945009319294926848/1212817775656177664)
//=============================================================================
class CPSpawnNotify expands SpawnNotify;

//=============================================================================
// Class and UED properties.
//=============================================================================
var(PlayerMovement) bool bEnableDodgeBot;
var(PlayerMovement) bool bEnableWallDodge;
var(PlayerMovement) int WallDodgeLimit;
var(PlayerMovement) bool bDisableDodge;
var(PlayerMovement) bool bDisableWalk;
var(PlayerMovement) bool bDisableJump;
var(PlayerMovement) bool bEnableDodgeLimit;
var(PlayerMovement) int DodgeLimit;
var(PlayerMovement) bool bEnableCrouchDodge;
var(PlayerMovement) bool bEnableAirDodge;

//=============================================================================
// Class properties.
//=============================================================================
var CustomPlayer CP;

//=============================================================================
// Checks if Actor spawned was the player and replaces with custom player if
// yes.
//
// param A - The current actor being spawned.
//=============================================================================
simulated event Actor SpawnNotification(Actor A) 
{
	local class<CustomPlayer> CPSpawnClass;
	CPSpawnClass = SetCPSpawnClass(A);

	if (CPSpawnClass != None && PlayerPawn(A) != None)
	{
		A.bHidden = True;
		Pawn(A).bIsPlayer = False;
		A.SetCollision(False,False,False);

		CPSpawnClass.default.PlayerReplicationInfoClass = PlayerPawn(A).PlayerReplicationInfoClass;
		CP = Spawn(CPSpawnClass,A.Owner,A.Tag,A.Location,A.Rotation);
		SetCPProps(A);

		A.Destroy();

		return CP;
	}

	return A;
}

//=============================================================================
// Sets custom player spawn class or None if non-applicable.
//
// param A - The Actor to check against for CPSpawnClass.
//=============================================================================
function class<CustomPlayer> SetCPSpawnClass(Actor A)
{
	if (A.Class == class'TFemale1')
		return class'CPTFemale1';
	else if (A.Class == class'TFemale2')
		return class'CPTFemale2';
	else if (A.Class == class'TMale1')
		return class'CPTMale1';
	else if (A.Class == class'TMale2')
		return class'CPTMale2';
	else if (A.Class == class'TBoss')
		return class'CPTBoss';
	else
		return None;
}

//=============================================================================
// Sets custom player properties.
//
// param A - The Actor to get properties from.
//=============================================================================
function SetCPProps(Actor A)
{
	SetCPMoveProps();
	SetCPSoundProps(A);
}

//=============================================================================
// Sets custom player movement properties.
//=============================================================================
function SetCPMoveProps()
{
	CP.bEnableDodgeBot = bEnableDodgeBot;
	CP.bEnableWallDodge = bEnableWallDodge;
	CP.WallDodgeLimit = WallDodgeLimit;
	CP.bDisableDodge = bDisableDodge;
	CP.bDisableWalk = bDisableWalk;
	CP.bDisableJump = bDisableJump;
	CP.bEnableDodgeLimit = bEnableDodgeLimit;
	CP.DodgeLimit = DodgeLimit;
	CP.bEnableCrouchDodge = bEnableCrouchDodge;
	CP.bEnableAirDodge = bEnableAirDodge;
}

//=============================================================================
// Sets custom player sound properties.
//
// param A - The Actor to get properties from.
//=============================================================================
function SetCPSoundProps(Actor A)
{
	local TournamentPlayer ATP;
	ATP = TournamentPlayer(A);

	CP.JumpSound = PlayerPawn(A).JumpSound;
	CP.Deaths[0]= ATP.Deaths[0];
	CP.Deaths[1]= ATP.Deaths[1];
	CP.Deaths[2]= ATP.Deaths[2];
	CP.Deaths[3]= ATP.Deaths[3];
	CP.Deaths[4]= ATP.Deaths[4];
	CP.Deaths[5]= ATP.Deaths[5];
	CP.drown = ATP.drown;
	CP.breathagain = ATP.breathagain;
	CP.HitSound3 = ATP.HitSound3;
	CP.HitSound4 = ATP.HitSound4;
	CP.GaspSound = ATP.GaspSound;
	CP.UWHit1 = ATP.UWHit1;
	CP.UWHit2 = ATP.UWHit2;
	CP.LandGrunt = ATP.LandGrunt;
	CP.VoicePackMetaClass = ATP.VoicePackMetaClass;
	CP.HitSound1 = ATP.HitSound1;
	CP.HitSound2 = ATP.HitSound2;
	CP.Die = ATP.Die;
}

defaultproperties
{
      bEnableDodgeBot=False
      bEnableWallDodge=False
      WallDodgeLimit=1
      bDisableDodge=False
      bDisableWalk=False
      bDisableJump=False
      bEnableCrouchDodge=False
      bEnableAirDodge=False
      bEnableDodgeLimit= False
      DodgeLimit=5
      CP=None
      bEdShouldSnap=True
}
