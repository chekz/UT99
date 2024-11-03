Description
===============

Will replace any spawned player with a custom player, which has normal player movement with options to activate addtional capabilties, e.g., Wall Dodging. The skeleton code and idea behind this project was made by slade and can be found here, ([SladePlayerExt](https://discord.com/channels/818071527144554497/945009319294926848/1212817775656177664)). To use it place ChekzCustomPlayer.CPSpawnNotify inside of a map and update PlayerMovement properties to suit required needs. There is also an option to update PlayerMovement properties via a Trigger, ChekzCustomPlayer.CPTrigger.

Default Values
===============

**CPSpawnNotify**

- bEnableDodgeBot=False
- bEnableWallDodge=False
- WallDodgeLimit=1
- bDisableDodge=False
- bDisableWalk=False
- bDisableJump=False
- bEnableCrouchDodge=False
- bEnableAirDodge=False
- bEnableDodgeLimit= False
- DodgeLimit=5

**CPTrigger**
- bEnableDodgeBot=False
- bEnableWallDodge=False
- WallDodgeLimit=1
- bDisableDodge=False
- bDisableWalk=False
- bDisableJump=False
- bEnableCrouchDodge=False
- bEnableAirDodge=False
- bEnableDodgeLimit= False
- DodgeLimit=5

Uses
===============

- bEnableDodgeBot to True enables the player to dodge with no dodge delay. Hold walk and jump to activate.
- bEnableWallDodge to True enables the player to dodge off of walls.
- WallDodgeLimit is the number of continuous wall dodges remaining. Note that one can bounce after a wall dodge.
- bDisableDodge to True disables the ability to dodge.
- bDisableWalk to True disables the ability to walk or run.
- bDisableJump to True disables the ability to jump.
- bEnableCrouchDodge to True enables the ability to dodge when crouched.
- bEnableAirDodge to True enables the ability to dodge while in the air (when falling).
- bEnableDodgeLimit to True activates a dodge limit on the player.
- DodgeLimit is the number of dodges a player can do if bEnableDodgeLimit is set to True. Resets on player death.

How To Install
===============

- Copy ChekzCustomPlayer.u into your UnrealTournament\\System folder.
- In UnrealEd click on View -> Actor Class Browser.
- Click on File -> Open Package.
- Click on ChekzCustomPlayer.u and Open.
- Expand Actor -> SpawnNotify -> and Click on ChekzCustomPlayer.SCPSpawnNotify
- Right Click in UnrealEd and Click on 'Add ChekzCustomPlayer.SCPSpawnNotify here'
- Expand Actor -> Triggers -> Trigger and click on ChekzCustomPlayer.CPTrigger 
- Right Click in UnrealEd and Click on 'Add ChekzCustomPlayer.CPTrigger here'