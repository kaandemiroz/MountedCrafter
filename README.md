# MountedCrafter
Mounted Crafter is a simple lightweight addon to let you stay mounted when you click on a crafting bench.

## How does it work?
Crafting benches by default dismount the player when clicked to open the crafting UI. While this makes sense to actually craft an item, it becomes annoying if you only want to view orders and go somewhere else or use the Auction House or buy items from the nearby vendor and come back.

However, being next to a crafting bench and then manually opening your crafting UI opens the same interface without dismounting you; and this still retains all of the regular functionalities like crafting requirements or crafting orders.

What this addon does is simply detecting if your mouse is over a crafting bench and then placing an invisible button under your cursor which will instead open your crafting UI without actually making you click the bench itself.

This also has a few extra benefits:

- You can now move away from the crafting bench, and the UI will not auto close.
- You can now click on the bench while still far away from it (if you are still running to it for example)
- You can now click on the crafting bench with other menus open (like a vendor or mail or AH), and these menus will not auto close (as long as your screen has enough space).
- You can actually craft slightly further away than what the game normally allows you if you tried to interact with the actual object. This is because the game will gray out the interact gear icon, but you are technically still within crafting range if you manually opened the UI. This addon will let you automatically do that.

## Limitations
This addon is still in development and thus includes certain bugs and inconveniences.
- Currently only English game clients are supported, as the addon does detection based on tooltip object names. However you could simply open the main .lua file and add or replace existing names with any localized names. You can also open an issue to me on GitHub with the crafting bench names in your game language and I can add them in for the next update!
- While the mouse is over the crafting bench you will not be able to right-click drag on the screen, as the invisible button will be blocking the actual right mouse button event in the game world. This is the main issue I'm hoping to resolve as it can be annoying while turning around with the mouse if the player happens to start dragging from on top of the bench. Other mouse buttons are unaffected.
- If the player places their mouse over the bench, and then the player moves or turns without moving their mouse at all, the invisible button may linger at the same location until the player actually moves the mouse slightly.
