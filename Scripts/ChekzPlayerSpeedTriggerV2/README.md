Description
===============

Will activate Trigger based off of the players Horizontal AND OR Vertical Speed.

Default Values
===============

**PlayerSpeedTriggerV2**
- FailEvent=None
- FailMessage=""
- HorizontalThreshold=0
- VerticalThreshold=0

Uses
===============

- FailEvent will Trigger if FailEvent is not None AND Horizontal AND OR Vertical Treshold was not met.
- FailMessage will perform a ClientMessage to the player if FailMessage is not empty, Trigger. Event is not None and the Horizontal AND OR Vertical Threshold was not met.
- HorizontalThreshold of 650 and VerticalThreshold of 0 will Trigger the Event if the players Horizontal Speed is greater than 650.
- HorizontalThreshold of 650 and VerticalThreshold of 200 will Trigger the Event if the players Horizontal Speed is greater than 650 AND the players Vertical Speed is greater than 200.

How To Install
===============

- Copy ChekzPlayerSpeedTriggerV2.u into your UnrealTournament\\System folder
- In UnrealEd click on View -> Actor Class Browser
- Click on File -> Open Package
- Click on ChekzPlayerSpeedTriggerV2.u and Open
- Expand Actor -> Triggers -> Trigger and Click on ChekzPlayerSpeedTriggerV2.PlayerSpeedTriggerV2
- Right Click in UnrealEd and Click on 'Add ChekzPlayerSpeedTriggerV2.PlayerSpeedTriggerV2 here'