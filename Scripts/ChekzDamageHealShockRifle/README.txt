//=============================================================================
// Installation
//=============================================================================


//=============================================================================
// Lore & Ramblings
//=============================================================================
This project was inspired by Bunneh`.

I was streaming on Twitch, looking through some random ass UT mods, having a good time, and it inspired the Bun guy to go and look at some mods as well. He found one called SpeedRacer and after the stream finished he sent me a message on Discord describing said mod. Well, here is how the conversation went.

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

Pog indeed Bun. Pog indeed. Well the idea stuck with me for a couple of days and I decided to give making this gun a go. And go did I give it. Whole thing took me like 4 days start to finish. I spent more time on code comments and Texture editing than I did actual functionality of the DHR (DamageHealShockRifle). Functionality was ez. Making the Gun look pretty and making the code look pretty (or as pretty as I could) was the hard part. I decided to leave in the scuffed naming conventions of meshes, textures and models, prefixing similar items with DHR_. I think it's better when a code base remains consistent (as much as possible) even if things are named awfully.

We are both BunnyTrackers so if this creation is going to be used anywhere it's going to be used there. The potential for new and interesting obstacles is pretty high in my opinion. Maybe some trigger could be made so one would have to Damage Fire to activate a trigger or one would have to have a certain amount of health to trigger, all the while speeding up and slowing down while trying to run the map as fast as possible. Fun, right?

I also see a potential Instagibish mode with this. So there is a Damage Beam and Heal Beam. Let's forget about the movement updating speed here, we can turn that off. Heal Beam hits for 33% health but you gain 33% health on a sucessful shot. If you Damage Beam you hit for 66% health but you damage yourself by 33% health. See where I am going with this? You Damage Beam when you are sure you can and Heal Beam when you cannot. Sounds fun to me.