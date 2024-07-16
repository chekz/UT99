//=============================================================================
// Player must be going at a certain speed Horizontally AND OR Vertically
// to Trigger.
// 
// Author: chekz
//=============================================================================
class PlayerSpeedTriggerV2 extends Trigger;

//=============================================================================
// Chekz Trigger Texture.
//=============================================================================
#exec Texture Import File=Textures\S_Trigger_Chekz.pcx Name=S_Trigger_Chekz Mips=Off Flags=2

//=============================================================================
// Configurable Properties.
//=============================================================================
var() int HorizontalTreshold;
var() int VerticalTreshold;
var() bool IsBelowTreshold;

var() sound FailSound;
var() string FailMessage;
var() name FailEvent;

//=============================================================================
// Is called when Trigger is touched.
//=============================================================================
function Touch( actor Other )
{
	local actor A;

	if ( IsRelevant( Other ) )
	{
		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
				return;
			TriggerTime = Level.TimeSeconds;
		}

		if ( IsThresholdHit(Other) )
		{
			if( Event != '' ) 
			{
				foreach AllActors( class 'Actor', A, Event )
					A.Trigger( Other, Other.Instigator );

				if( Message != "" )
					Other.Instigator.ClientMessage( Message );
			}
		}
		else
		{
			if ( FailMessage != "" )
				Other.Instigator.ClientMessage( FailMessage );

			if ( FailEvent != '' )
				foreach AllActors( class 'Actor', A, FailEvent )
					A.Trigger( Other, Other.Instigator );
		}

		if ( Other.IsA('Pawn') && (Pawn(Other).SpecialGoal == self) )
			Pawn(Other).SpecialGoal = None;

		if( bTriggerOnceOnly )
			SetCollision(False);
		else if ( RepeatTriggerTime > 0 )
			SetTimer(RepeatTriggerTime, false);
	}
}

//=============================================================================
// Is called when Trigger takes damage.
//=============================================================================
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

		if ( IsThresholdHit(instigatedBy) )
		{
			if( Event != '' ) 
			{
				foreach AllActors( class 'Actor', A, Event )
					A.Trigger( instigatedBy, instigatedBy );

				if( Message != "" )
					instigatedBy.Instigator.ClientMessage( Message );
			}
		}
		else
		{
			if ( FailMessage != "" )
				instigatedBy.Instigator.ClientMessage( FailMessage );

			if ( FailEvent != '' )
				foreach AllActors( class 'Actor', A, FailEvent )
					A.Trigger( instigatedBy, instigatedBy );

			if ( FailSound != None )
				PlaySound( FailSound );
		}

		if( bTriggerOnceOnly )
			SetCollision(False);
	}
}

//=============================================================================
// Checks to see if Horizontal AND OR Vertical Treshold is hit
//=============================================================================
function bool IsThresholdHit( actor Other )
{
	local Vector VelocityCopy; 
	local int InstigatorHorizontalSpeed;
	local int InstigatorVerticalSpeed;

	if ( HorizontalTreshold == 0 && VerticalTreshold == 0 )
		return False;

	VelocityCopy = Other.Instigator.Velocity;

	//=============================================================================
	// Code to calculate horizontal and vertical speed was made by Melle.
	//=============================================================================
	InstigatorHorizontalSpeed = Sqrt(VelocityCopy.X * VelocityCopy.X + VelocityCopy.Y * VelocityCopy.Y);
	InstigatorVerticalSpeed = Abs(VelocityCopy.Z);

	if ( IsBelowTreshold )
	{
		if ( HorizontalTreshold != 0 && ( InstigatorHorizontalSpeed > HorizontalTreshold ) )
			return False;

		if ( VerticalTreshold != 0 && ( InstigatorVerticalSpeed > VerticalTreshold ) )
			return False;
	} else
	{
		if ( HorizontalTreshold != 0 && ( InstigatorHorizontalSpeed < HorizontalTreshold ) )
			return False;

		if ( VerticalTreshold != 0 && ( InstigatorVerticalSpeed < VerticalTreshold ) )
			return False;
	}

	return True;
}

defaultproperties
{
      Texture=Texture'Engine.S_Trigger_Chekz'
      bEdShouldSnap=True
      HorizontalTreshold=0
      VerticalTreshold=0
      IsBelowTreshold=False
      FailMessage=""
      FailEvent=None
      FailSound=None
}