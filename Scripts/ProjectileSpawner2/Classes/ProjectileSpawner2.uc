//=============================================================================
// used for LSoNP
// class by FXD|Shadow
// ProjectileSpawner,damn.. this 5 year ol' thingy.. I was just a bad coder xD
//
// Edited by ch3kz
// Renamed some variables
// Added ability to get projectile to chase player
// Set bEdShouldSnap, bDirectional and bHidden to True
class ProjectileSpawner2 extends Effects;

var() class<projectile> ProjToSpawn;
var() bool bOnceOnly;
var() bool bFollowInstigator;
var() float RepeatDelay,ProjDrawScale,ProjSpeed,ProjDamage;
var() int ProjMomentumTransfer,ProjSpawnLocForward; 	
var() float ProjMaxSpeed, ProjLifeSpan;
var() sound ProjSpawnSound,ProjImpactSound,ProjMiscSound; 
var() class<decal> ProjExplosionDecal;

var projectile Proj;
var pawn PawnInstigator;
var float ProjEndTime;

var vector SeekingDir;

function Trigger( actor Other, pawn EventInstigator )
{
	PawnInstigator = EventInstigator;
	SetTimer(RepeatDelay,bOnceOnly);
}

function Timer()
{
	Proj=Spawn(ProjToSpawn,,'', Location+vector(Rotation)*ProjSpawnLocForward);
	SetupProjectile();
}

function Tick(float DeltaTime)
{
	if (bFollowInstigator && Proj != None)
		UpdateProjectile();

	if (Proj.bDeleteMe || Level.TimeSeconds > ProjEndTime)
		Disable('Tick');
}

function SetupProjectile()
{
	Proj.Speed=ProjSpeed;	
	Proj.Damage=ProjDamage;
	Proj.DrawScale=ProjDrawScale;
	Proj.MomentumTransfer=ProjMomentumTransfer;
	Proj.MaxSpeed=ProjMaxSpeed;
	Proj.LifeSpan = ProjLifeSpan;
	Proj.ImpactSound=ProjImpactSound;
	Proj.MiscSound=ProjMiscSound;
	Proj.SpawnSound=ProjSpawnSound;
	Proj.ExplosionDecal=ProjExplosionDecal;
	Proj.RemoteRole=ROLE_DumbProxy;

	if (bFollowInstigator)
	{
		ProjEndTime = Level.TimeSeconds + ProjLifeSpan;
		Enable('Tick');
	}
}

function UpdateProjectile()
{
	SeekingDir = Normal(PawnInstigator.Location - Proj.Location);
	Proj.Velocity =  Proj.Speed * Normal(SeekingDir * 0.47 * Proj.Speed + Proj.Velocity);
	SetRotation(rotator(Proj.Velocity));
}

defaultproperties
{
	ProjToSpawn=None
	bOnceOnly=False
	bFollowInstigator=False
	RepeatDelay=0.000000
	ProjDrawScale=0.000000
	ProjSpeed=0.000000
	ProjDamage=0.000000
	ProjMomentumTransfer=0
	ProjSpawnLocForward=0
	ProjMaxSpeed=0.000000
	ProjLifeSpan=0.000000
	ProjSpawnSound=None
	ProjImpactSound=None
	ProjMiscSound=None
	ProjExplosionDecal=None
	Proj=None
	ProjEndTime=0.000000

	bHidden=True
	bDirectional=True
	DrawType=DT_Sprite
	bEdShouldSnap=True
}
