//=============================================================================
// CPTrigger: A Trigger which also updates custom player properties.
//
// Author: ch3kz
//=============================================================================
class CPTrigger extends Trigger;

//=============================================================================
// Class and UED properties.
//=============================================================================
var(CPWallDodge) bool bEnableWallDodge;
var(CPWallDodge) int WallDodgeLimit;
var(CPWallDodge) bool bEnableBounceAfterWallDodge;

var(CPAirDodge) bool bEnableAirDodge;
var(CPAirDodge) int AirDodgeLimit;
var(CPAirDodge) bool bEnableBounceAfterAirDodge;

var(CPDodgeBot) bool bEnableDodgeBot;

var(CPMovement) bool bDisableDodge;
var(CPMovement) bool bDisableWalk;
var(CPMovement) bool bDisableJump;
var(CPMovement) bool bEnableCrouchDodge;
var(CPMovement) bool bEnableBounceAfterGroundDodge;
var(CPMovement) bool bEnableDodgeLimit;
var(CPMovement) int DodgeLimit;

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
			UpdateCPMoveProps(CustomPlayer(Other));
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
		UpdateCPMoveProps(CustomPlayer(instigatedBy));
	}
}

//=============================================================================
// Updates custom player movement properties.
//
// param CP - The custom player to set movement properties on.
//=============================================================================
function UpdateCPMoveProps(CustomPlayer CP)
{
	CP.bEnableDodgeBot = bEnableDodgeBot;
	CP.bEnableWallDodge = bEnableWallDodge;
	CP.WallDodgeLimit = WallDodgeLimit;
	CP.WallDodgesRemaining = WallDodgeLimit;
	CP.bDisableDodge = bDisableDodge;
	CP.bDisableJump = bDisableJump;
	CP.bDisableWalk = bDisableWalk;
	CP.bEnableCrouchDodge = bEnableCrouchDodge;
	CP.bEnableAirDodge = bEnableAirDodge;
	CP.AirDodgeLimit = AirDodgeLimit;
	CP.AirDodgesRemaining = AirDodgeLimit;
	CP.bEnableDodgeLimit = bEnableDodgeLimit;
	CP.DodgeLimit = DodgeLimit;
	CP.bEnableBounceAfterGroundDodge = bEnableBounceAfterGroundDodge;
	CP.bEnableBounceAfterWallDodge = bEnableBounceAfterWallDodge;
	Cp.bEnableBounceAfterAirDodge = bEnableBounceAfterAirDodge;
	CP.bTriggerEnabled = true;
}

defaultproperties
{
      bEnableWallDodge=False
      WallDodgeLimit=1
      bEnableBounceAfterWallDodge=True
      bEnableAirDodge=False
      AirDodgeLimit=1
      bEnableBounceAfterAirDodge=True
      bEnableDodgeBot=False
      bDisableDodge=False
      bDisableWalk=False
      bDisableJump=False
      bEnableCrouchDodge=False
      bEnableBounceAfterGroundDodge=False
      bEnableDodgeLimit= False
      DodgeLimit=5
      bEdShouldSnap=True
}