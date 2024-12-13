//=============================================================================
// CPTrigger: A Trigger which also updates custom player properties.
//
// Author: ch3kz
//=============================================================================
class CPTrigger extends Trigger;

#exec AUDIO IMPORT FILE="Sounds\SamusSpaceJumpStart.wav" NAME="SamusSpaceJumpStart" GROUP="SpaceJump"

//=============================================================================
// Class and UED properties.
//=============================================================================
var CustomPlayer CP;

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

var bool bEnableSpaceJump;
var float SpaceJumpFallThreshold;
var float SpaceJumpUpTreshold;

var(CPMovement) bool bDisableDodge;
var(CPMovement) bool bDisableWalk;
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

//
// Called when something touches the trigger.
//
function Touch( actor Other )
{
	local actor A;
	if( IsRelevant( Other ) )
	{
		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
				return;
			TriggerTime = Level.TimeSeconds;
		}
		// Broadcast the Trigger message to all matching actors.
		if( Event != '' )
			foreach AllActors( class 'Actor', A, Event )
				A.Trigger( Other, Other.Instigator );

		if ( Other.IsA('Pawn') && (Pawn(Other).SpecialGoal == self) )
			Pawn(Other).SpecialGoal = None;
				
		if( Message != "" )
			// Send a string message to the toucher.
			Other.Instigator.ClientMessage( Message );

		if( bTriggerOnceOnly )
			// Ignore future touches.
			SetCollision(False);
		else if ( RepeatTriggerTime > 0 )
			SetTimer(RepeatTriggerTime, false);

		// Update Player Movement.
		if (Other.IsA('Pawn'))
		{
			CP = CustomPlayer(Other);
			UpdateCPProps();
		}
	}
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
{
	local actor A;

	if ( bInitiallyActive && (TriggerType == TT_Shoot) && (Damage >= DamageThreshold) && (instigatedBy != None) )
	{
		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
				return;
			TriggerTime = Level.TimeSeconds;
		}
		// Broadcast the Trigger message to all matching actors.
		if( Event != '' )
			foreach AllActors( class 'Actor', A, Event )
				A.Trigger( instigatedBy, instigatedBy );

		if( Message != "" )
			// Send a string message to the toucher.
			instigatedBy.Instigator.ClientMessage( Message );

		if( bTriggerOnceOnly )
			// Ignore future touches.
			SetCollision(False);

		// Update Player Movement.
		CP = CustomPlayer(instigatedBy);
		UpdateCPProps();
	}
}

//=============================================================================
// Updates custom player movement properties.
//
// param CP - The custom player to set movement properties on.
//=============================================================================
function UpdateCPProps()
{
	UpdateCPWallDodgeProps();
	UpdateCPAirDodgeProps();
	UpdateCPLiftDodgeProps();
	UpdateCPDodgeBotProps();
	UpdateCPSpaceJumpProps();
	UpdateCPMovementProps();
	UpdateCPSpeedProps();
	UpdateCPAssProjectileProps();

	CP.bTriggerEnabled = true;
}

function UpdateCPWallDodgeProps()
{
	CP.bEnableWallDodge = bEnableWallDodge;
	CP.WallDodgeLimit = WallDodgeLimit;
	CP.WallDodgesRemaining = WallDodgeLimit;
	CP.bEnableMoverWallDodge = bEnableMoverWallDodge;
	CP.bEnableBounceAfterWallDodge = bEnableBounceAfterWallDodge;
}

function UpdateCPAirDodgeProps()
{
	CP.bEnableAirDodge = bEnableAirDodge;
	CP.AirDodgeLimit = AirDodgeLimit;
	CP.AirDodgesRemaining = AirDodgeLimit;
	CP.bEnableBounceAfterAirDodge = bEnableBounceAfterAirDodge;
}

function UpdateCPLiftDodgeProps()
{
	CP.bEnableLiftDodge = bEnableLiftDodge;
}

function UpdateCPDodgeBotProps()
{
	CP.bEnableDodgeBot = bEnableDodgeBot;
	CP.bEnableDodgeBotCall = bEnableDodgeBotCall;
}

function UpdateCPSpaceJumpProps()
{
	CP.bEnableSpaceJump = bEnableSpaceJump;
	CP.SpaceJumpFallThreshold = SpaceJumpFallThreshold;
}

function UpdateCPMovementProps()
{
	CP.bDisableDodge = bDisableDodge;
	CP.bDisableJump = bDisableJump;
	CP.bDisableWalk = bDisableWalk;
	CP.bEnableDodgeLimit = bEnableDodgeLimit;
	CP.DodgeLimit = DodgeLimit;
	CP.bEnableBounceAfterGroundDodge = bEnableBounceAfterGroundDodge;
	CP.bEnableCrouchDodge = bEnableCrouchDodge;
}

function UpdateCPSpeedProps()
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
}

function UpdateCPAssProjectileProps()
{
	CP.bEnableAssProjectile = bEnableAssProjectile;
	CP.bEnableAssProjectileCall = bEnableAssProjectileCall;
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
      bEnableLiftDodge=False
      bEnableDodgeBot=False
      bEnableDodgeBotCall=False
      bEnableSpaceJump=False
      SpaceJumpFallThreshold=-275.000000
      bDisableDodge=False
      bDisableWalk=False
      bDisableJump=False
      bUpdateGroundSpeed=False
      NewGroundSpeed=400.000000
      bUpdateWaterSpeed=False
      NewWaterSpeed=200.000000
      bUpdateJumpHeight=False
      NewJumpHeight=357.500000
      bUpdateWalkJumpHeight=False
      NewWalkJumpHeight=325.000000
      bEnableCrouchDodge=False
      bEnableBounceAfterGroundDodge=False
      bEnableDodgeLimit= False
      DodgeLimit=5
      bEdShouldSnap=True
}