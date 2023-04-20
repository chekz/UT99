//=============================================================================
// FurryDelayedTrigger.
// By furry (FBT)
//
// A combination of a triggered light and a trigger. Can be used to temporarily
// enable a trigger and illuminate the area around it (the trigger lights up).
// FurryDelayedTriggerTurnsOn - Only enables this trigger for RemainOnTime
// FurryDelayedTriggerControl - Enables this trigger as long as ther isntagating
//								trigger is active (eg playerproximity).
//								RemainOnTime is not used.
// When using a TriggerLight, set its InitialState to TriggerControl.
// 
// Modified by ch3kz.
// - Blank message in Trigger no longer displays a blank ClientMessage.
// - Added bEdShouldSnap=True.
// - Added an option to play a Sound on Trigger activated.
//=============================================================================
class FurryDelayedTrigger4 expands Trigger;

var() float ChangeTime;			// Time light takes to change from on to off.
var bool bInitiallyOn;			// Whether it's initially on.
var bool bDelayFullOn;			// Delay then go full-on.
var() float RemainOnTime;		// How long the TriggerPound effect lasts
var() name TriggerLightTag;		// Tag of a triggered light to use (optional)
var() name FailEvent;			// Event called on failure (when player is too late)
var() enum ESoundType
{
	PlaySoundEffect,
	PlayersPlaySoundEffect,
} SoundType;
var() sound Sound;

var   float InitialBrightness; // Initial brightness.
var   float Alpha, Direction;
var   actor SavedTrigger;
var   pawn  SavedPawn;
var   float poundTime;

var   float startTime;
var   bool  active;
var   bool  disableMe;
var   bool  triggerHit;

//-----------------------------------------------------------------------------
// Light related functions

// Called at start of gameplay.
simulated function BeginPlay()
{
	// Remember initial light type and set new one.
	triggerHit = false;
	Disable( 'Tick' );
	InitialBrightness = LightBrightness;
	if( bInitiallyOn )
	{
		Alpha     = 1.0;
		Direction = 1.0;
	}
	else
	{
		Alpha     = 0.0;
		Direction = -1.0;
	}
	DrawType = DT_None;
}
// Called whenever time passes.
function Tick( float DeltaTime )
{
	local actor A;
	Alpha += Direction * DeltaTime / ChangeTime;
	if( Alpha > 1.0 )
	{
		Alpha = 1.0;
		active = true;
		Disable( 'Tick' );
		if( SavedTrigger != None )
			SavedTrigger.EndEvent();

		if ( TriggerLightTag != '')
			foreach AllActors( class 'Actor', A, TriggerLightTag )
				A.Trigger( SavedTrigger, SavedPawn );
	}
	else if( Alpha < 0.0 )
	{
		Alpha = 0.0;
		active = false;
		Disable( 'Tick' );
		if( SavedTrigger != None )
			SavedTrigger.EndEvent();

		if ( TriggerLightTag != '')
			foreach AllActors( class 'Actor', A, TriggerLightTag )
				A.UnTrigger( SavedTrigger, SavedPawn );
	}
	if( !bDelayFullOn )
		LightBrightness = Alpha * InitialBrightness;
	else if( (Direction>0 && Alpha!=1) || Alpha==0 )
		LightBrightness = 0;
	else
		LightBrightness = InitialBrightness;
}
// Trigger turns the light on.
state() FurryDelayedTriggerTurnsOn
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		if( SavedTrigger!=None )
			SavedTrigger.EndEvent();
		SavedTrigger = Other;
		SavedTrigger.BeginEvent();
		SavedPawn = EventInstigator;
		Direction = 1.0;
		Enable( 'Tick' );
		disableMe = true;
		SetTimer(RemainOnTime + ChangeTime, false);
	}
}
// Trigger controls the light.
state() FurryDelayedTriggerControl
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		if( SavedTrigger!=None )
			SavedTrigger.EndEvent();
		SavedTrigger = Other;
		SavedTrigger.BeginEvent();
		SavedPawn = EventInstigator;
		if( bInitiallyOn ) Direction = -1.0;
		else               Direction = 1.0;
		Enable( 'Tick' );
	}
	function UnTrigger( actor Other, pawn EventInstigator )
	{
		if( SavedTrigger!=None )
			SavedTrigger.EndEvent();
		SavedTrigger = Other;
		SavedTrigger.BeginEvent();
		SavedPawn = EventInstigator;
		if( bInitiallyOn ) Direction = 1.0;
		else               Direction = -1.0;
		Enable( 'Tick' );
	}
}

//---------------------------------------------
// TRIGGER STUFF
function Touch( actor Other )
{
	local actor A;

	if (!active)
		return;

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
		triggerHit = true;
		if ( Other.IsA('Pawn') && (Pawn(Other).SpecialGoal == self) )
			Pawn(Other).SpecialGoal = None;
				
		if( Message != "" )
			// Send a string message to the toucher.
			Other.Instigator.ClientMessage(Message);

		if ( Sound != None ) {
			DoSound();
		}

		if( bTriggerOnceOnly )
			// Ignore future touches.
			SetCollision(False);
		else if ( RepeatTriggerTime > 0 )
			SetTimer(RepeatTriggerTime, false);
	}
}

function Timer()
{
	local bool bKeepTiming;
	local int i;
	local Actor A;

	if (disableMe)
	{
		disableMe = false;
		Direction = -1;
		Alpha = -10;
		Enable('Tick');
		if( FailEvent != ''  && !triggerHit)
			foreach AllActors( class 'Actor', A, FailEvent)
				A.Trigger( SavedTrigger, SavedPawn );
		triggerHit = false;
		return;
	}

	if (!active)
		return;

	bKeepTiming = false;

	for (i=0;i<4;i++)
		if ( (Touching[i] != None) && IsRelevant(Touching[i]) )
		{
			bKeepTiming = true;
			Touch(Touching[i]);
		}

	if ( bKeepTiming )
		SetTimer(RepeatTriggerTime, false);
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
{
	local actor A;

	if (!active)
		return;

	if ( bInitiallyActive && (TriggerType == TT_Shoot) && (Damage >= DamageThreshold) && (instigatedBy != None) )
	{
		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
				return;
			TriggerTime = Level.TimeSeconds;
		}
		triggerHit = true;

		// Broadcast the Trigger message to all matching actors.
		if( Event != '' )
			foreach AllActors( class 'Actor', A, Event )
				A.Trigger( instigatedBy, instigatedBy );

		if( Message != "" )
			// Send a string message to the toucher.
			instigatedBy.Instigator.ClientMessage(Message);

		if ( Sound != None ) {
			DoSound();
		}

		if( bTriggerOnceOnly )
			// Ignore future touches.
			SetCollision(False);
	}
}

//
// When something untouches the trigger.
//
function UnTouch( actor Other )
{
	local actor A;

	if (!active)
		return;

	if( IsRelevant( Other ) )
	{
		// Untrigger all matching actors.
		if( Event != '' )
			foreach AllActors( class 'Actor', A, Event )
				A.UnTrigger( Other, Other.Instigator );
	}
}

function DoSound()
{
	local pawn P;

	if (SoundType == PlaySoundEffect)
		PlaySound( Sound );
	else if (SoundType == PlayersPlaySoundEffect) {
		for ( P=Level.PawnList; P!=None; P=P.NextPawn )
			if ( P.bIsPlayer && P.IsA('PlayerPawn') )
				PlayerPawn(P).PlaySound( Sound );
	}
}

defaultproperties
{
	TriggerType=TT_Shoot
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
	Texture=Texture'Engine.S_Trigger'

	bEdShouldSnap=True

	TriggerLightTag=None
	RemainOnTime=0.000000
	FailEvent=None
	ChangeTime=0.000000
	Sound=None
	SoundType=PlaySoundEffect
}

