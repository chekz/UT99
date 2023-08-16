Description
===============

ProjectileSpawner2. Same functionality as ProjectileSpawner with an option to get projectile to move to Instigator location.

Default Values
===============

**ProjectileSpawner2**
- bFollowInstigator=False

Uses
===============

- If bFollowInstigator=False the projectile will not move to Instigator location.
- If bFollowInstigator=True the projectile will move to Instigator location.

How To Install
===============

- Copy ProjectileSpawner2.u into your UnrealTournament\\System folder
- In UnrealEd click on View -> Actor Class Browser
- Click on File -> Open Package
- Click on ProjectileSpawner2.u and Open
- Expand Actor -> Effects -> and Click on ProjectileSpawner2.ProjectileSpawner2
- Right Click in UnrealEd and Click on 'Add ProjectileSpawner2.ProjectileSpawner2 here'

Example Map
===============
**CTF-BT-ProjectileSpawner2.unr**
- Touching the white platform in the middle of the room will spawn a Shock Projectile which chases the Instigator