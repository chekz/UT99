//=============================================================================
// CPTournamentFemale: A copy of TournamentFemale for custom player.
//=============================================================================
class CPTournamentFemale extends CustomPlayer
	abstract;

function PlayRightHit(float tweentime)
{
	if ( AnimSequence == 'RightHit' )
		TweenAnim('GutHit', tweentime);
	else
		TweenAnim('RightHit', tweentime);
}	

function PlayDying(name DamageType, vector HitLoc)
{
	local carcass carc;

	BaseEyeHeight = Default.BaseEyeHeight;
	PlayDyingSound();
			
	if ( DamageType == 'Suicided' )
	{
		PlayAnim('Dead3',, 0.1);
		return;
	}

	// check for head hit
	if ( (DamageType == 'Decapitated') && !class'GameInfo'.Default.bVeryLowGore )
	{
		PlayDecap();
		return;
	}

	if ( FRand() < 0.15 )
	{
		PlayAnim('Dead7',,0.1);
		return;
	}

	// check for big hit
	if ( (Velocity.Z > 250) && (FRand() < 0.75) )
	{
		if ( (HitLoc.Z < Location.Z) && !class'GameInfo'.Default.bVeryLowGore && (FRand() < 0.6) )
		{
			PlayAnim('Dead5',,0.05);
			if ( Level.NetMode != NM_Client )
			{
				carc = Spawn(class 'UT_FemaleFoot',,, Location - CollisionHeight * vect(0,0,0.5));
				if (carc != None)
				{
					carc.Initfor(self);
					carc.Velocity = Velocity + VSize(Velocity) * VRand();
					carc.Velocity.Z = FMax(carc.Velocity.Z, Velocity.Z);
				}
			}
		}
		else
			PlayAnim('Dead2',, 0.1);
		return;
	}

	// check for repeater death
	if ( (Health > -10) && ((DamageType == 'shot') || (DamageType == 'zapped')) )
	{
		PlayAnim('Dead9',, 0.1);
		return;
	}
		
	if ( (HitLoc.Z - Location.Z > 0.7 * CollisionHeight) && !class'GameInfo'.Default.bVeryLowGore )
	{
		if ( FRand() < 0.5 )
			PlayDecap();
		else
			PlayAnim('Dead3',, 0.1);
		return;
	}
	
	//then hit in front or back	
	if ( FRand() < 0.5 ) 
		PlayAnim('Dead4',, 0.1);
	else
		PlayAnim('Dead1',, 0.1);
}

function PlayDecap()
{
	local carcass carc;

	PlayAnim('Dead6',, 0.1);
	if ( Level.NetMode != NM_Client )
	{
		carc = Spawn(class 'UT_HeadFemale',,, Location + CollisionHeight * vect(0,0,0.8), Rotation + rot(3000,0,16384) );
		if (carc != None)
		{
			carc.Initfor(self);
			carc.Velocity = Velocity + VSize(Velocity) * VRand();
			carc.Velocity.Z = FMax(carc.Velocity.Z, Velocity.Z);
		}
	}
}

defaultproperties
{
      Deaths(0)=Sound'Botpack.FemaleSounds.(All).death1d'
      Deaths(1)=Sound'Botpack.FemaleSounds.(All).death2a'
      Deaths(2)=Sound'Botpack.FemaleSounds.(All).death3c'
      Deaths(3)=Sound'Botpack.FemaleSounds.(All).decap01'
      Deaths(4)=Sound'Botpack.FemaleSounds.(All).death41'
      Deaths(5)=Sound'Botpack.FemaleSounds.(All).death42'
      drown=Sound'UnrealShare.Female.mdrown2fem'
      breathagain=Sound'Botpack.FemaleSounds.(All).hgasp3'
      HitSound3=Sound'Botpack.FemaleSounds.(All).linjur4'
      HitSound4=Sound'Botpack.FemaleSounds.(All).hinjur4'
      GaspSound=Sound'Botpack.FemaleSounds.(All).lgasp1'
      UWHit1=Sound'Botpack.FemaleSounds.(All).UWhit01'
      UWHit2=Sound'UnrealShare.Male.MUWHit2'
      LandGrunt=Sound'Botpack.FemaleSounds.(All).lland1'
      StatusDoll=Texture'Botpack.Icons.Woman'
      StatusBelt=Texture'Botpack.Icons.WomanBelt'
      VoicePackMetaClass="BotPack.VoiceFemale"
      CarcassType=Class'Botpack.TFemale1Carcass'
      JumpSound=Sound'Botpack.FemaleSounds.(All).Fjump1'
      bIsFemale=True
      HitSound1=Sound'Botpack.FemaleSounds.(All).linjur2'
      HitSound2=Sound'Botpack.FemaleSounds.(All).linjur3'
      Die=Sound'Botpack.FemaleSounds.(All).death1d'
}
