//=============================================================================
// NuLLTeleportZone: A normal zone with teleport information
//
// Author: ch3kz
//=============================================================================

class NuLLTeleportZoneInfo extends ZoneInfo;

struct FogRGB {
	var() float R;
	var() float G;
	var() float B;
};

var() Name Parent;
var() Name Destination;
var() float FlashScale;
var() FogRGB FlashColour;
var() Sound TransitionSound;

defaultproperties
{
	Parent=None
	Destination=None
	FlashScale=0.000000
	TransitionSound=None

	bEdShouldSnap=True
}