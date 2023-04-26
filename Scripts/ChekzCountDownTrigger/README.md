Description
===============

Will perform a countdown before triggering specified event

Default Values
===============

**ChekzCountDownTrigger**
- MessageInterval=1
- TimeToTrigger=5
- CountDownMessage="%i..."
- bShowCountDownMessage=True

Uses
===============

- MessageInterval of 1 sets the CountDownMessage to print every 1 second
- TimeToTrigger of 5 sets the Trigger to activate after 5 seconds
- CountDownMessage of %i... sets CountDownMessage to the time remaining on the countdown followed by ...
- bShowCountDownMessage of True will print the CountDownMessage

How To Install
===============

- Copy ChekzCountDownTrigger.u into your UnrealTournament\\System folder
- In UnrealEd click on View -> Actor Class Browser
- Click on File -> Open Package
- Click on ChekzCountDownTrigger.u and Open
- Expand Actor -> Triggers -> Trigger and Click on ChekzCountDownTrigger.CountDownTrigger
- Right Click in UnrealEd and Click on 'Add ChekzCountDownTrigger.CountDownTrigger here'