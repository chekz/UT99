//=============================================================================
// 
// CountDownTrigger: Will perform a countdown before triggering specified event
// 
// Author: ch3kz
//=============================================================================

class CountDownTrigger extends Trigger;

#exec Texture Import File=Textures\S_Trigger_Chekz.pcx Name=S_Trigger_Chekz Mips=Off Flags=2

var() int MessageInterval;
var() int TimeToTrigger;
var() string CountDownMessage;
var() bool bShowCountDownMessage;
var string UpdatedCountDownMessage;
var int i;
var bool bTriggered;

var actor TouchActor;
var int InitialTimeToTrigger;

function PreBeginPlay()
{
	InitialTimeToTrigger = TimeToTrigger;
}

function Touch( actor Other )
{
	if( IsRelevant( Other ) )
	{
		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
				return;
			TriggerTime = Level.TimeSeconds;
		}

		if ( !bTriggered )
		{
			if( Event != '' )
			{
				TouchActor = Other;
				gotostate('Dispatch');
				bTriggered = True;
			}
		}

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

		if ( !bTriggered )
		{
			if( Event != '' )
			{
				TouchActor = instigatedBy;
				gotostate('Dispatch');
				bTriggered = True;
			}
		}

		if( Message != "" )
			// Send a string message to the toucher.
			instigatedBy.Instigator.ClientMessage( Message );

		if( bTriggerOnceOnly )
			// Ignore future touches.
			SetCollision(False);
	}
}

state Dispatch
{
Begin:

	while ( TimeToTrigger > 0 )
	{
		UpdatedCountDownMessage = CountDownMessage;
		while( InStr(UpdatedCountDownMessage, "%i") >= 0 )
		{
			i = InStr(UpdatedCountDownMessage, "%i");
			UpdatedCountDownMessage = Left(UpdatedCountDownMessage,i) $ TimeToTrigger $ Mid(UpdatedCountDownMessage,i+2);
		}

		if ( bShowCountDownMessage )
			TouchActor.Instigator.ClientMessage( UpdatedCountDownMessage );

		Sleep( MessageInterval );
		TimeToTrigger -= MessageInterval;
	}

	foreach AllActors( class 'Actor', Target, Event )
		Target.Trigger( Self, TouchActor.Instigator );

	TimeToTrigger = InitialTimeToTrigger;
	bTriggered = False;
}

defaultproperties
{
	Texture=Texture'Engine.S_Trigger_Chekz'
	MessageInterval=1
	TimeToTrigger=5
	CountDownMessage="%i..."
	bShowCountDownMessage=True
	bTriggered=False
	bEdShouldSnap=True
}