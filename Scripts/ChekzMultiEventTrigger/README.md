Description
===============

A normal trigger which an option to trigger up to 8 additional events with optional delays.

Default Values
===============
**ChekzMultiEventTrigger**
- OutDelays[0]=0.000000
- OutDelays[1]=0.000000
- OutDelays[2]=0.000000
- OutDelays[3]=0.000000
- OutDelays[4]=0.000000
- OutDelays[5]=0.000000
- OutDelays[6]=0.000000
- OutDelays[7]=0.000000
- OutEvents[0]=None
- OutEvents[1]=None
- OutEvents[2]=None
- OutEvents[3]=None
- OutEvents[4]=None
- OutEvents[5]=None
- OutEvents[6]=None
- OutEvents[7]=None

Uses
===============

- Setting OutDelay[0] to 1.000000 and OutEvent[0] to a valid event tag will trigger OutEvent[0] after 1 second.
- Setting OutDelay[0] to 0.000000 and OutEvent[0] to a valid event tag will trigger OutEvent[0] immediatly.

How To Install
===============

- Copy ChekzMultiEventTrigger.u into your UnrealTournament\\System folder
- In UnrealEd click on View -> Actor Class Browser
- Click on File -> Open Package
- Click on ChekzMultiEventTrigger.u and Open
- Expand Actor -> Triggers -> Trigger and Click on ChekzMultiEventTrigger.MultiEventTrigger
- Right Click in UnrealEd and Click on 'Add ChekzMultiEventTrigger.MultiEventTrigger here'
