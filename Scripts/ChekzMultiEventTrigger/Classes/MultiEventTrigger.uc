//=============================================================================
// 
// MultiEventTrigger: A normal trigger which triggers a set of specified events
// with optional delays.
// 
// Author: ch3kz
//=============================================================================

class MultiEventTrigger extends Trigger;

#exec Texture Import File=Textures\S_Trigger_Chekz.pcx Name=S_Trigger_Chekz Mips=Off Flags=2

var() float OutDelays[8];
var() name OutEvents[8];
var int i;

function Trigger( actor Other, pawn EventInstigator )
{
	Instigator = EventInstigator;
	gotostate('Dispatch');
}

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

		gotostate('Dispatch');
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

		gotostate('Dispatch');
	}
}

state Dispatch
{
Begin:
	for( i=0; i<ArrayCount(OutEvents); i++ )
	{
		if( OutEvents[i] != '' )
		{
			Sleep( OutDelays[i] );
			foreach AllActors( class 'Actor', Target, OutEvents[i] )
				Target.Trigger( Self, Instigator );
		}
	}
}

defaultproperties
{
	TriggerType=TT_PlayerProximity
	Message=""
	bTriggerOnceOnly=False
	bInitiallyActive=True
	ClassProximityType=None
	RepeatTriggerTime=0.000000
	ReTriggerDelay=0.000000
	TriggerTime=0.000000
	DamageThreshold=0.000000
	TriggerActor=None
	TriggerActor2=None
	InitialState="NormalTrigger"
	Texture=Texture'Engine.S_Trigger_Chekz'

	bEdShouldSnap=True
	i=0
}