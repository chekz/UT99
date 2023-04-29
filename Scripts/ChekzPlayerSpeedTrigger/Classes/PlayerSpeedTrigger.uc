class PlayerSpeedTrigger extends Trigger;

#exec Texture Import File=Textures\S_Trigger_Chekz.pcx Name=S_Trigger_Chekz Mips=Off Flags=2

var() int HorizontalThreshold;
var() int VerticalThreshold;

var() string FailMessage;

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
		else if ( FailMessage != "" )
		{
			Other.Instigator.ClientMessage( FailMessage );
		}

		if ( Other.IsA('Pawn') && (Pawn(Other).SpecialGoal == self) )
			Pawn(Other).SpecialGoal = None;

		if( bTriggerOnceOnly )
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
		else if ( FailMessage != "" )
		{
			instigatedBy.Instigator.ClientMessage( FailMessage );
		}

		if( bTriggerOnceOnly )
			SetCollision(False);
	}
}

function bool IsThresholdHit( actor Other )
{
	local Vector VelocityCopy; 
	local int HorizontalSpeed;
	local int VerticalSpeed;

	if ( HorizontalThreshold == 0 && VerticalThreshold == 0 )
		return False;

	VelocityCopy = Other.Instigator.Velocity;

	HorizontalSpeed = Sqrt(VelocityCopy.X * VelocityCopy.X + VelocityCopy.Y * VelocityCopy.Y);
	VerticalSpeed = Abs(VelocityCopy.Z);

	if ( HorizontalSpeed < HorizontalThreshold )
		return False;

	if ( VerticalSpeed < VerticalThreshold )
		return False;

	return True;
}

defaultproperties
{
	Texture=Texture'Engine.S_Trigger_Chekz'
	bEdShouldSnap=True

	HorizontalThreshold=0
	VerticalThreshold=0
	FailMessage=""
}