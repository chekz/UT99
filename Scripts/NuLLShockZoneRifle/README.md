Description
===============

A normal NuLLShockRifle but ALT fire teleports player to desired location.

Default Values
===============

**NuLLShockZoneRifle**
- FireSpeed=2.000000
- AltFireSpeed=1.000000
- ShockBeamScale=0.180000
- ShockBeamSpeedScale=2.000000

**NuLLTeleportZoneInfo**
- Parent=None
- Destination=None
- FlashScale=0.000000
- TransitionSound=None

Uses
===============

Some basic notes as a proper explanation of combining all components and all it's different options would be too wordy for a README.

- NuLLShockZoneRifle, Two NuLLDiscreetTeleporter's and a NuLLTeleportZoneInfo work together to teleport player to desired location.
- All NuLLTeleportZoneInfo.ZoneInfo.ZoneTag must be unique.
- NuLLTeleportZoneInfo.NuLLTeleportZoneInfo.Parent and NuLLTeleportZoneInfo.NuLLTeleportZoneInfo.Destination must be set to NuLLDiscreetTeleporter's.
- NuLLTeleportZoneInfo.FlashColour and NuLLTeleportZoneInfo.FlashScale create a flash effect when player is teleported.
- NuLLTeleportZoneInfo.TransitionSound will play a sound when player is teleported. If set to None no sound will play.
- URL in NuLLDiscreetTeleporter must be set and point to another NuLLDiscreetTeleporter.

How To Install
===============

- Copy NuLLShockZoneRifle.u into your UnrealTournament\\System folder
- In UnrealEd click on View -> Actor Class Browser
- Click on File -> Open Package
- Click on NuLLShockZoneRifle.u and Open
- Expand Actor -> Inventory -> TournamentWeapon -> ShockRifle and Click on NuLLShockZoneRifle.NuLLShockZoneRifle
- Right Click in UnrealEd and Click on 'Add NuLLShockZoneRifle.NuLLShockZoneRifle here'
- Expand Actor -> Info -> ZoneInfo and Click on NuLLShockZoneRifle.NuLLTeleportZoneInfo
- Right Click in UnrealEd and Click on 'Add NuLLShockZoneRifle.NuLLTeleportZoneInfo here'
- Expand Actor -> NavigationPoint -> Teleporter and Click on NuLLShockZoneRifle.NuLLDiscreetTeleporter
- Right Click in UnrealEd and Click on 'Add NuLLShockZoneRifle.NuLLDiscreetTeleporter here'