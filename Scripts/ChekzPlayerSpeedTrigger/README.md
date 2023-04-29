Description
===============

Will activate Trigger based off of the players Horizontal AND OR Vertical Speed.

Default Values
===============

**PlayerSpeedTrigger**
- FailMessage=""
- HorizontalThreshold=0
- VerticalThreshold=0

Uses
===============

- FailMessage will perform a ClientMessage to the player if FailMessage is not empty, Trigger.Event is not empty and the Horizontal AND OR Vertical Threshold was not met.
- HorizontalThreshold of 650 and VerticalThreshold of 0 will Trigger the Event if Trigger.Event is not empty and the players Horizontal Speed is greater than 650.
- VerticalThreshold of 650 and VerticalThreshold of 200 will Trigger the Event if Trigger.Event is not empty, the players Horizontal Speed is greater than 650 AND the players Vertical Speed is greater than 200.

How To Install
===============

- Copy ChekzPlayerSpeedTrigger.u into your UnrealTournament\\System folder
- In UnrealEd click on View -> Actor Class Browser
- Click on File -> Open Package
- Click on ChekzPlayerSpeedTrigger.u and Open
- Expand Actor -> Triggers -> Trigger and Click on ChekzPlayerSpeedTrigger.PlayerSpeedTrigger
- Right Click in UnrealEd and Click on 'Add ChekzPlayerSpeedTrigger.PlayerSpeedTrigger here'
