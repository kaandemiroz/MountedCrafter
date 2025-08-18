# MountedCrafter
World of Warcraft AddOn to allow clicking on a Crafting Bench without auto-dismounting

## How does it work?
Crafting benches by default dismount the player when clicked to open the crafting UI. While this makes sense to actually craft an item, it becomes annoying if you for example only want to view orders and go somewhere else or use the Auction House. However, being next to a crafting bench and then manually opening your crafting UI opens the same interface without dismounting you; while still preserving all of the bench functionalities like crafting requirements or crafting orders.

What this addon does is simply detecting if your mouse is over a crafting bench and then placing an invisible button under your cursor which will instead open your crafting UI without actually making you click the bench itself.

This also has the extra benefit of being able to click and open the menu while not being directly next to the bench yet.

## Limitations
This addon is still in development and thus includes certain bugs and inconveniences.
- When the button is active, it prevents dragging with the right mouse button held down, due to it blocking the actual right mouse button event in the game world. This is the main issue I'm hoping to resolve as it can be annoying while turning around with the mouse if the player happens to start dragging from on top of the bench. Other mouse buttons are unaffected.
- If the player places their mouse over the bench, and then the player moves or turns without moving their mouse at all, the invisible button may linger at the same location until the player actually moves the mouse slightly.
- Currently only English game clients are supported, as the addon does detection based on tooltip object names. However you could simply open the main .lua file and add or replace existing names with any localized names.
