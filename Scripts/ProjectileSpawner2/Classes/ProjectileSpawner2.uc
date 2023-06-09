//=============================================================================
// used for LSoNP
// class by FXD|Shadow
// ProjectileSpawner,damn.. this 5 year ol' thingy.. I was just a bad coder xD
//
// Edited by ch3kz
// Added ability to get projectile to follow player
class ProjectileSpawner2 expands Effects;

var() class<projectile> ProjToSpawn;
var() bool bOnceOnly;
var() bool bFollowInstigator;
var() float RepeatDelay,ProjDrawscale,ProjectileVelocity,ProjectileDamage;		
var() int ProjMomentumTrans,SpawnLocForward; 	
var() float MaxProjVelo,ProjLifeSpan;
var() sound ProjSpawnSound,ProjImpactSound,ProjMiscSound; 
var() class<decal> ExploDecalClass;

var Projectile p;
var float ProjectileEndTime;

simulated function BeginPlay()
{
	Super.BeginPlay();
	Disable('Tick');
}

function Trigger( actor Other, pawn EventInstigator )
{
	Instigator = EventInstigator;
	settimer(repeatdelay,bonceonly);
}

simulated function Tick(float DeltaTime)
{
	if (bFollowInstigator && p != None)
		UpdateProjectile();

	if (Level.TimeSeconds > ProjectileEndTime)
		Disable('Tick');
}

function UpdateProjectile()
{
	local vector SeekingDir;

	SeekingDir = Normal(Instigator.Location - p.Location);

	p.Velocity =  p.Speed * Normal(SeekingDir * 0.47 * p.Speed + p.Velocity);
	SetRotation(rotator(p.Velocity));
}

simulated function Timer()
{
	p=Spawn(projtospawn,,'', Location+vector(Rotation)*SpawnLocForward);
	p.Speed=ProjectileVelocity;	
	p.Damage=ProjectileDamage;
	p.Drawscale=ProjDrawscale;
	p.MomentumTransfer=ProjMomentumTrans;
	p.MaxSpeed=MaxProjVelo;
	p.lifespan = ProjLifeSpan;
	p.impactsound=ProjImpactSound;
	p.MiscSound=ProjMiscSound;
	p.SpawnSound=ProjSpawnSound;
	p.explosiondecal=ExploDecalClass;

	if (bFollowInstigator)
	{
		ProjectileEndTime = Level.TimeSeconds + ProjLifeSpan;
		Enable('Tick');
	}
}

defaultproperties
{
	bFollowInstigator=False
	bEdShouldSnap=True
	DrawType=DT_Sprite
}
