Description
===============
The Damage Heal Shock Rifle (DHR). Primary Fire shoots a damage beam which damages the shooter. Alt Fire shoots a heal beam which heals the shooter. Player air, ground and water speed can be adjusted independantly depening on how much health they have.


How To Install
===============
A sample map has been added to show how to setup the DamageHealShockRifle.

- Download CTF-BT-ChekzDamageHealShockRifle.zip
- Extract the contents of this folder
- Copy Maps and System to your UnrealTournament Folder
- Open UnrealED
- File -> Open -> CTF-BT-ChekzDamageHealShockRifle.unr
- Click on Play Map!

Here is the step by step guide on a blank map.
- In UnrealED Open Actor Class Browser
- File -> Open Package -> BTME_v4.u
- File -> Open Package -> ChekzDamageHealShockRifle.u
- Add BTME_Mutator to your map (Actor -> Info -> Mutator -> BTME_Mutator)
- Add DamageHealShockRifleMutator to your map (Actor -> Info -> Mutator -> Arena -> DamageHealShockRifleMutator)
- Set Default Weapon in BTME_Mutator to Class'ChekzDamageHealShockRifle.DamageHealShockRifle'
- Configure Settings in DamageHealShockRifleMutator to suit your needs
- (OPTIONAL) Add DHR_Health Pickups to your map (Actor -> Inventory -> Pickups -> DHR_TournamentHealth -> (DHR_HealthPack, DHR_HealthVial, DHR_MedBox))

Default Values
===============
**DamageHealShockRifleMutator**
- DamageAmount=20
- DamageBeamHitDamage=100.000000
- DamageBeamFireSpeed=1.000000

- HealAmount=20
- HealBeamHitDamage=50.000000
- HealBeamFireSpeed=1.000000

- bChangeAirSpeed=True
- bChangeGroundSpeed=True
- bChangeWaterSpeed=True

- SpeedMultiplier=5.000000

- HealBeamFireSound=Sound'ChekzDamageHealShockRifle.FireSounds.HealBeamFireSound'
- DamageBeamFireSound=Sound'ChekzDamageHealShockRifle.FireSounds.DamageBeamFireSound'

The Lore
===============
This project was inspired by Bunneh`.

I was streaming on Twitch, testing out some random UT99 mods, having a good time, and it inspired the Bun guy to go and look at some mods as well. He found one called SpeedRacer and after the stream finished he sent me a message on Discord describing said mod. Here is how the conversation went.

Bunneh — 25/08/2023 23:12
Another one
[SpeedRacer.txt]
damaging oneself in order to pass an obstacle and then regen elsewhere
kinda nice

chekz — 25/08/2023 23:15
that is interesting!

Bunneh — 25/08/2023 23:16
could a damage / regen gun be made? I think I've seen one somewhere
which incorporates the above

chekz — 25/08/2023 23:17
could be made yeah, could modify shock rife, Primary Fire damage self, Alt Fire Regen self.

Bunneh — 25/08/2023 23:17
pog

And that's all it takes. Now this exists. Pog.