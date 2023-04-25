Description:
A normal kicker with an option to kick the player using the players velocity and a multiplier

Uses:
- A Multiplier of 0.500000 in the X direction will kick the player with half it's current X velocity
- A Multiplier of 1.000000 in the Y direction will kick the player with it's current Y velocity
- A Multiplier of 2.000000 in the Z direction will kick the player with twice it's current Z velocity
- bUseKickerXVelocity set to False will kick the player with it's current velocity * Multiplier.X
- bUseKickerYVelocity set to False will kick the player with it's current velocity * Multiplier.Y
- bUseKickerZVelocity set to True will ignore the Z Multiplier and will Kick using the Kicker Z velocity

Default Values:
- Multiplier=(X=1.000000,Y=1.000000,Z=1.000000)
- bUseKickerXVelocity=False
- bUseKickerYVelocity=False
- bUseKickerZVelocity=True

How To Install:
- Copy ChekzMultiplyKicker.u into your <UnrealTournament>/System folder
- In UnrealEd click on View -> Actor Class Browser
- Click on File -> Open Package
- Click on ChekzMultiplyKicker.u and Open
- Expand Actor -> Triggers -> Kicker and Click on ChekzMultiplyKicker.MultiplyKicker
- Right Click in UnrealEd and Click on 'Add ChekzMultiplyKicker.MultiplyKicker here'