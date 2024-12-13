//=============================================================================
// CPSpawnNotify: Replaces current player with custom player.
//
// Author: ch3kz
// Note: The idea and skeleton of this project was made by slade see
// sldPlayerExt at
// https://discord.com/channels/818071527144554497/945009319294926848/1212817775656177664)
//=============================================================================
class CPSpawnNotify expands SpawnNotify;

//=============================================================================
// Class and UED properties.
//=============================================================================
var(CPWallDodge) bool bEnableWallDodge;
var(CPWallDodge) int WallDodgeLimit;
var(CPWallDodge) bool bEnableBounceAfterWallDodge;
var(CPWallDodge) bool bEnableMoverWallDodge;

var(CPAirDodge) bool bEnableAirDodge;
var(CPAirDodge) int AirDodgeLimit;
var(CPAirDodge) bool bEnableBounceAfterAirDodge;

var(CPLiftDodge) bool bEnableLiftDodge;

var(CPDodgeBot) bool bEnableDodgeBot;
var(CPDodgeBot) bool bEnableDodgeBotCall;

var sound SamusSpaceJumpStart;
var bool bEnableSpaceJump;
var float SpaceJumpFallThreshold;
var float SpaceJumpUpTreshold;

var(CPMovement) bool bDisableDodge;
var(CPMovement) bool bDisableWalk;
var(CPMovement) bool bDisableForward;
var(CPMovement) bool bDisableBack;
var(CPMovement) bool bDisableRight;
var(CPMovement) bool bDisableLeft;

var(CPMovement) bool bDisableJump;
var(CPMovement) bool bEnableCrouchDodge;
var(CPMovement) bool bEnableBounceAfterGroundDodge;
var(CPMovement) bool bEnableDodgeLimit;
var(CPMovement) int DodgeLimit;

var(CPPawnSpeed) bool bUpdateGroundSpeed;
var(CPPawnSpeed) float NewGroundSpeed;
var(CPPawnSpeed) bool bUpdateWaterSpeed;
var(CPPawnSpeed) float NewWaterSpeed;
var(CPPawnSpeed) bool bUpdateJumpHeight;
var(CPPawnSpeed) float NewJumpHeight;
var(CPPawnSpeed) bool bUpdateWalkJumpHeight;
var(CPPawnSpeed) float NewWalkJumpHeight;

var bool bEnableAssProjectile;
var bool bEnableAssProjectileCall;
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
	SetCPWallDodgeProps();
	SetCPAirDodgeProps();
	SetCPLiftDodgeProps();
	SetCPDodgeBotProps();
	SetCPSpaceJumpProps();
	SetCPMovementProps();
	SetCPSpeedProps();
	SetCPAssProjectileProps();
	SetCPSoundProps(A);
}

function SetCPWallDodgeProps()
{
	CP.bEnableWallDodge = bEnableWallDodge;
	CP.bEnableWallDodgeOrig = bEnableWallDodge;
	CP.WallDodgeLimit = WallDodgeLimit;
	CP.WallDodgeLimitOrig = WallDodgeLimit;
	CP.bEnableMoverWallDodge = bEnableMoverWallDodge;
	CP.bEnableMoverWallDodgeOrig = bEnableMoverWallDodge;
	CP.bEnableBounceAfterWallDodge = bEnableBounceAfterWallDodge;
	CP.bEnableBounceAfterWallDodgeOrig = bEnableBounceAfterWallDodge;
}

function SetCPAirDodgeProps()
{
	CP.bEnableAirDodge = bEnableAirDodge;
	CP.bEnableAirDodgeOrig = bEnableAirDodge;
	CP.AirDodgeLimit = AirDodgeLimit;
	CP.AirDodgeLimitOrig = AirDodgeLimit;
	CP.bEnableBounceAfterAirDodge = bEnableBounceAfterAirDodge;
	CP.bEnableBounceAfterAirDodgeOrig = bEnableBounceAfterAirDodge;
}

function SetCPLiftDodgeProps()
{
	CP.bEnableLiftDodge = bEnableLiftDodge;
	CP.bEnableLiftDodgeOrig = bEnableLiftDodge;
}

function SetCPDodgeBotProps()
{
	CP.bEnableDodgeBot = bEnableDodgeBot;
	CP.bEnableDodgeBotOrig = bEnableDodgeBot;
	CP.bEnableDodgeBotCall = bEnableDodgeBotCall;
	CP.bEnableDodgeBotCallOrig = bEnableDodgeBotCall;
}

function SetCPSpaceJumpProps()
{
	CP.JumpSoundOrig = CP.JumpSound;
	CP.bEnableSpaceJump = bEnableSpaceJump;
	CP.bEnableSpaceJumpOrig = bEnableSpaceJump;
	CP.SpaceJumpFallThreshold = SpaceJumpFallThreshold;
	CP.SpaceJumpFallThresholdOrig = SpaceJumpFallThreshold;
}

function SetCPMovementProps()
{
	CP.bDisableDodge = bDisableDodge;
	CP.bDisableDodgeOrig = bDisableDodge;
	CP.bDisableWalk = bDisableWalk;
	CP.bDisableWalkOrig = bDisableWalk;
	CP.bDisableJump = bDisableJump;
	CP.bDisableJumpOrig = bDisableJump;
	CP.bEnableDodgeLimit = bEnableDodgeLimit;
	CP.bEnableDodgeLimitOrig = bEnableDodgeLimit;
	CP.DodgeLimit = DodgeLimit;
	CP.DodgeLimitOrig = DodgeLimit;
	CP.bEnableBounceAfterGroundDodge = bEnableBounceAfterGroundDodge;
	CP.bEnableBounceAfterGroundDodgeOrig = bEnableBounceAfterGroundDodge;
	CP.bEnableCrouchDodge = bEnableCrouchDodge;
	CP.bEnableCrouchDodgeOrig = bEnableCrouchDodge;
}

function SetCPSpeedProps()
{
	if (bUpdateGroundSpeed)
		CP.GroundSpeed = NewGroundSpeed;

	if (bUpdateWaterSpeed)
		CP.WaterSpeed = NewWaterSpeed;

	if (bUpdateJumpHeight)
		CP.JumpZ = NewJumpHeight;

	if (bUpdateWalkJumpHeight)
		CP.WalkJumpZ = NewWalkJumpHeight;

	CP.bUpdateWalkJumpHeight = bUpdateWalkJumpHeight;
	CP.bUpdateWalkJumpHeightOrig = bUpdateWalkJumpHeight;

	CP.GroundSpeedOrig = CP.GroundSpeed;
	CP.WaterSpeedOrig = CP.WaterSpeed;
	CP.JumpZOrig = CP.JumpZ;
	CP.WalkJumpZOrig = CP.default.JumpZ;
}

function SetCPAssProjectileProps()
{
	CP.bEnableAssProjectile = bEnableAssProjectile;
	CP.bEnableAssProjectileOrig = bEnableAssProjectile;
	CP.bEnableAssProjectileCall = bEnableAssProjectileCall;
	CP.bEnableAssProjectileCallOrig = bEnableAssProjectileCall;
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
      bEnableWallDodge=False
      WallDodgeLimit=1
      bEnableBounceAfterWallDodge=True
      bEnableMoverWallDodge=False
      bEnableAirDodge=False
      AirDodgeLimit=1
      bEnableBounceAfterAirDodge=True
      bEnableDodgeBot=False
      bEnableDodgeBotCall=False
      bEnableLiftDodge=False
      bEnableSpaceJump=False
      SpaceJumpFallThreshold=-275.000000
      bDisableDodge=False
      bDisableWalk=False
      bDisableJump=False
      bEnableCrouchDodge=False
      bUpdateGroundSpeed=False
      NewGroundSpeed=400.000000
      bUpdateWaterSpeed=False
      NewWaterSpeed=200.000000
      bUpdateJumpHeight=False
      NewJumpHeight=357.500000
      bUpdateWalkJumpHeight=False
      NewWalkJumpHeight=325.000000
      bEnableBounceAfterGroundDodge=False
      bEnableDodgeLimit= False
      DodgeLimit=5
      CP=None
      bEdShouldSnap=True
}
