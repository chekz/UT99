//=============================================================================
// DiscreetTeleporter.
//
// Thanks Sapphire... Legend... NuLL :D 
//=============================================================================
class NuLLDiscreetTeleporter extends Teleporter;

#exec Texture Import File=Textures\S_TeleNew.pcx Name=S_TeleNew Mips=Off Flags=2

function PlayTeleportEffect(actor Incoming, bool bOut);

defaultproperties
{
	bEdShouldSnap=True
	Texture=Texture'S_TeleNew'
}