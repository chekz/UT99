Description
===============

Ensures player has VolumetricLighting=True in GameRenderDevice. If player enters a Zone with VolumetricLighting=False or sets VolumetricLighting=False while in the Zone a suicide event will be called for that player.

Default Values
===============

**VolumetricLightingZone**
- DeathMessage=""
- VolumetricLightingCheckInterval=0.1

Uses
===============

- If DeathMessage is Empty and GameRenderDevice VolumetricLighting=False the player will die if they enter the Zone and No DeathMessage will display.
- If DeathMessage is "Ya Ded Breh" and GameRenderDevice VolumetricLighting=False the player will die if they enter the Zone and "Ya Ded Breh" will be printed to their client.
- If GameRenderDevice VolumetricLighting=True the player will not die and will
be allowed to see the beautiful map the way it was intended.

How To Install
===============

- Copy ChekzVolumetricLightingZone.u into your UnrealTournament\\System folder
- In UnrealEd click on View -> Actor Class Browser
- Click on File -> Open Package
- Click on ChekzVolumetricLightingZone.u and Open
- Expand Actor -> Info -> ZoneInfo and Click on ChekzVolumetricLightingZone.VolumetricLightingZone
- Right Click in UnrealEd and Click on 'Add ChekzVolumetricLightingZone.VolumetricLightingZone here'
