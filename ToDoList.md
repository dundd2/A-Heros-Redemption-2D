# A Hero's Redemption 2D TO DO LIST Before V1.0
I. Core Engine & Setup
Game Loading Screen

II. Story Mode & Content
Story Mode - Content Development & Implementation
Goal: Implement the actual story, dialogues, events, and progression.
Key Data Structures:
GameData.story.levelIntros and GameData.story.ending are good.
Extend GameData.story for mid-level story beats or events if needed.
Core Logic:
Dialogue System Integration:
Your existing GameData.startLevelDialogue, nextDialogue, getCurrentDialogue is a strong base.
Dialogue choices (currentDialogue.choices in GameData) can:
Set flags: GameData.storyFlags.met_character_X = true.
Start quests: QuestSystem.startQuest("quest_id").
Change relationships: GameData.changeRelationship().
Levels/Scenes:
If story requires non-battle exploration:
New gameState = "exploration".
Level data would include layout, NPCs, triggers.
Story-Specific NPCs, Items, Triggers:
Define NPCs in GameData.characters or a new GameData.npcs.
Story items use the new Item System.
Triggers use the Room Event Trigger system (see IV.3).
Cutscenes:
Text-based: Use the dialogue system with sequences of dialogue lines.
In-engine: A function that controls character movement (animations table), camera, and dialogue calls over time. Use TimerSystem for sequencing.
Integration Points: Quest System, NPC System, Room Event Triggers.
Save/Load Impact: currentState (level, dialogue index), GameData.storyFlags, quest progress.


III. Gameplay Systems - Character & Interaction
Character Progression & Leveling System
Goal: Refine and extend the existing leveling system.
Key Data Structures:
player table: Already has most necessary fields (Level, EXP, EXPToNextLevel, stats).
GameData.skillUnlocks = { [level_number] = {"skill_key1", "skill_key2"}, ... }
Core Logic:
EXP Gain: grantExp() is good. Ensure it's called by monster kills and Quest System rewards.
Level Up Event (checkLevelUp()):
Stat increases: Already implemented.
Skill Unlocking:
Inside checkLevelUp(), after incrementing player.level, check GameData.skillUnlocks[player.level].
For each skill key found, make it available (e.g., add to a player.unlockedSkills table, or simply allow its use if skillInfo is the master list).
Update UI to reflect new skills.
Visual/Audio Feedback: Add TimerSystem.create for a brief particle effect at player position and a sound effect.
Integration Points: Monster kills, Quest System (for EXP rewards).
Save/Load Impact: player stats, player.unlockedSkills (if used).


Weapon Switching System
Goal: Allow the player to equip different weapons affecting their combat abilities.
Key Data Structures:
GameData.items: Add type="weapon" items.
Example weapon item: { name_key="weapon_iron_sword_name", description_key="...", icon_key="icon_sword", type="weapon", slot="main_hand", stats={attack=5, critRate=2}, model_key_player="player_sword_sprite" (optional) }
player.equipment.weapon = "item_id_of_equipped_weapon" (see Equipment System).
Core Logic:
Equipping/Unequipping: Handled by the Equipment System.
Stat Calculation: The Equipment System will be responsible for updating player.attack, player.critRate, etc., based on player.baseAttack + equippedWeapon.stats.attack.
Visual Change:
If player.image should change: When a weapon is equipped, check its model_key_player and update resources.images.playerStand/Attack or add a weapon sprite layer.
UI Components: Part of Equipment/Inventory UI.
Integration Points: Equipment System, Combat System (calculateDamage uses player.attack).
Save/Load Impact: player.equipment (handled by Equipment System).

Equipment System
Goal: Allow player to equip items to enhance stats and potentially change appearance.
Key Data Structures:
player.equipment = { head=nil, chest="armor_id", legs=nil, weapon="weapon_id", accessory1=nil, accessory2=nil } (values are itemIds or nil).
GameData.items: Equippable items need a slot property (e.g., slot="head") and a stats = { attack=5, defense=10 } property.
player.baseStats = { attack=10, defense=5, ... } (stats without equipment).
Core Logic:
equipItem(inventorySlotIndex):
Get itemId from player.inventory[inventorySlotIndex].
Get itemData from GameData.items[itemId].
Check itemData.slot. If player.equipment[itemData.slot] is not nil (something already equipped), call unequipItem(itemData.slot) first (moves old item to inventory).
Move item from inventory to player.equipment[itemData.slot].
Call recalculatePlayerStats().
unequipItem(equipmentSlotKey):
Get itemId from player.equipment[equipmentSlotKey].
Try to add item back to inventory (use addItemToInventory). If inventory full, drop or prevent unequip.
Set player.equipment[equipmentSlotKey] = nil.
Call recalculatePlayerStats().
recalculatePlayerStats():
player.attack = player.baseStats.attack, player.defense = player.baseStats.defense, etc.
Iterate through player.equipment. For each equipped itemId:
Get itemData from GameData.items[itemId].
Add itemData.stats to player's current stats.
Update HP/MP if maxHP/maxMP changed.
UI Components:
Part of inventoryScreen or a dedicated equipmentScreen.
drawEquipmentScreen():
Show character silhouette/sprite.
Display equipment slots around it with icons of equipped items.
Allow interaction (click slot to unequip, or drag from inventory).
Integration Points: Inventory System, Stat Display UI, Combat System.
Save/Load Impact: player.equipment. player.baseStats if they can change (e.g. from permanent buffs).

Item Pickup (Collectible Object)
Goal: Allow player to collect items found in the game world.
Key Data Structures:
If explorable levels: levelData[levelNum].collectibleItems = { {itemId="potion_hp", x=100, y=200, instanceId="unique_item1", collected=false}, ... }.
Core Logic:
Visuals: In explorable levels, draw sprites for uncollected items.
Interaction:
Proximity check + key press (e.g., "E").
On interaction: Call addItemToInventory(itemId).
If successful, mark item as collected (collectibleItems[i].collected = true) so it doesn't respawn or get picked up again.
Feedback: Sound effect, message ("Picked up [Item Name]").
Inventory Full: Display message "Inventory full." Item remains.
UI Components: None directly, but interacts with inventory UI messages.
Integration Points: Inventory System.
Save/Load Impact: levelData.collectibleItems.collected status for each item instance.

Treasure/Loot System
Goal: Generate item drops from monsters and chests.
Key Data Structures:
GameData.lootTables = { [tableId] = { {itemId="potion_hp", chance=0.8, minQty=1, maxQty=2}, {itemId="gold_small", type="currency", chance=1.0, minQty=5, maxQty=10}, ... } }
enemyData[level].lootTableId = "goblin_loot"
chestData[chestId].lootTableId = "dungeon_chest_common"
Core Logic:
generateLoot(lootTableId):
Takes lootTableId, returns a list of items: {{itemId="id", quantity=n}, ...}.
Iterate GameData.lootTables[lootTableId].
For each entry, if math.random() <= entry.chance then, add item (with random quantity between minQty and maxQty) to results.
Monster Drops:
When enemy HP <= 0 (in love.update or performPlayerAttack):
local loot = generateLoot(enemyData[currentLevel].lootTableId).
Display loot window or automatically add to inventory.
Chest Loot: (See Room Event Triggers)
UI Components:
Loot Window: (Optional, if not auto-loot)
drawLootWindow(lootItems): Display items from generateLoot.
Allow player to click "Take All" or individual items.
Integration Points: Inventory System, Monster System, Room Event Triggers (Chests).
Save/Load Impact: None directly, but interacts with systems that are saved (inventory).

IV. Gameplay Systems - World & NPCs
Small Monsters for Leveling (Grinding)
Goal: Create a dedicated level for repeatable monster fights for EXP grinding, with auto-saving of EXP/level progress.
Key Data Structures:
GameData.grindingLevels = { [levelId] = { name_key="grind_forest_name", enemyPool={"enemy_goblin_weak", "enemy_slime"}, battleBg="battleBgForest" } }
New enemy definitions in enemyData for "weaker" or specific grinding monsters.
Core Logic:
Access: Add an option in menuState.options or levelSelect to enter a grinding level.
Level Setup:
When entering a grinding level:
currentGrindingLevelId = "grind_forest".
transitionGameState(..., "battle").
restartGame() modified:
Instead of enemyData[menuState.levelSelect.currentLevel], pick a random enemy from GameData.grindingLevels[currentGrindingLevelId].enemyPool.
Use the specified battleBg.
Continuous Spawning:
In love.update() where victory is checked (enemy.hp <= 0):
If in a grinding level (check a flag like currentState.isGrinding = true):
Grant EXP (grantExp()).
Short delay (TimerSystem.create).
Then, effectively call restartGame() again to spawn the next monster for the grinding level (reset player HP/MP partially or fully as desired for grinding, spawn new random enemy from pool).
Exiting:
Provide a UI button in the battle screen (only for grinding mode) or an Escape key option to "Leave Training" which transitionGameState("battle", "menu") and sets currentState.isGrinding = false.
Auto-Save EXP/Level:
Inside checkLevelUp(): If player.level actually increased, call saveGame(autosave_slot_or_main_slot).
Alternatively, save only when the player chooses to exit the grinding level. This is less frequent and might be preferred.
UI Components:
Option in menu/level select.
"Leave Training" button during grinding battles.
Integration Points: restartGame(), love.update() (victory check), checkLevelUp(), saveGame().
Save/Load Impact: Relies on the main save system. Frequent auto-saving needs care.


Respawn System (for non-grinding, explorable levels)
Goal: Make monsters reappear in explorable areas after being defeated.
Key Data Structures:
levelData[levelNum].monsters = { {monsterId="goblin_1", templateId="goblin", x=100, y=150, lastDefeatedTime=nil, respawnDelay=60}, ... }
Core Logic (if explorable areas are implemented):
When a monster is defeated, set its lastDefeatedTime = love.timer.getTime().
In love.update() for gameState == "exploration":
Iterate levelData[levelNum].monsters.
If monster.lastDefeatedTime is set and love.timer.getTime() - monster.lastDefeatedTime > monster.respawnDelay:
Respawn the monster (reset its HP, position, set lastDefeatedTime = nil).
Integration Points: Monster defeat logic, exploration game state.
Save/Load Impact: levelData.monsters.lastDefeatedTime for each monster instance.

Room Event Triggers (for explorable levels)
Goal: Create interactive elements and events within levels.
Key Data Structures:
levelData[levelNum].triggers = { {triggerId="trap_ spikes_1", type="damage_trap", rect={x,y,w,h}, damage=10, cooldown=5, lastTriggered=0, active=true}, {triggerId="chest_A", type="treasure_chest", rect={x,y,w,h}, lootTableId="dungeon_chest_1", isOpen=false}, ... }
Core Logic (if explorable areas are implemented):
In love.update() for gameState == "exploration":
Check player collision with trigger.rect.
Damage Trap: If player collides and trigger.active and love.timer.getTime() - trigger.lastTriggered > trigger.cooldown:
Deal damage to player.
Play sound/effect.
trigger.lastTriggered = love.timer.getTime().
Treasure Chest: If player collides and presses "interact" key and !trigger.isOpen:
trigger.isOpen = true.
local loot = generateLoot(trigger.lootTableId).
Show loot window or add to inventory.
Change chest sprite to "open".
Monster Ambush: If player collides:
Spawn specific monsters.
trigger.active = false (so it doesn't re-trigger).
Narrative Trigger: If player collides:
GameData.startDialogue("narrative_key").
trigger.active = false.
UI Components: Visuals for traps, chests. Loot window.
Integration Points: Player movement/collision, Loot System, Dialogue System.
Save/Load Impact: trigger.isOpen, trigger.active for each trigger instance.

NPC Quest and Trading System
Goal: Allow NPCs to give quests and trade items with the player.
Key Data Structures:
GameData.npcs = { [npcId] = { name_key, portrait_key, dialogue_greeting_key, quests_available={"q1","q2"}, trades_items_table_id, ...} }
GameData.quests = { [questId] = { title_key, description_key, objectives={{type="kill", target_enemy_key="goblin", count=5, currentProgress=0}, {type="collect", item_id="herb", count=3, currentProgress=0}, {type="talk", npc_id="elder"}}, prerequisites={quests={"q_prev"}, level=5}, rewards={exp=100, gold=50, items={"item_id1"}}, giver_npc_id, receiver_npc_id } }
player.activeQuests = { [questId] = {obj1_progress, obj2_progress, ...} }
player.completedQuests = { [questId] = true }
player.gold = 0
GameData.tradeTables = { [tableId] = { {itemId="potion_hp", buyPrice=10, sellPrice=5, stock=10}, ...} } (NPC's perspective for prices)
Core Logic:
NPC Interaction (if explorable areas):
Proximity + "interact" key.
Open dialogue with NPC. Dialogue options for "Quests", "Trade".
Quest System:
canStartQuest(questId): Checks player.level, player.completedQuests against prerequisites.
startQuest(questId): Adds questId to player.activeQuests with initial progress.
updateQuestProgress(questId, objectiveIndex, amount): Increments progress.
isQuestComplete(questId): Checks if all objectives in player.activeQuests[questId] are met.
turnInQuest(questId): Grant rewards, move from player.activeQuests to player.completedQuests.
Objective Tracking:
On monster kill: Iterate player.activeQuests. If "kill" objective matches, update progress.
On item pickup: Check "collect" objectives. (Note: "collect" might mean "have in inventory when turning in" or "actively gather specific quest items").
Trading System:
New gameState = "tradeScreen".
drawTradeScreen(npcId):
Show player inventory & gold.
Show NPC inventory (from GameData.tradeTables[npc.trades_items_table_id]) & prices.
Buttons to Buy/Sell.
buyItem(itemId, npcId): Check player gold, NPC stock. Update gold, inventories.
sellItem(playerInventorySlotIndex, npcId): Update gold, inventories.
UI Components:
Quest Log (gameState="questLogScreen").
Trade Screen.
Dialogue UI extended for quest/trade options.
"!" / "?" icons above NPCs.
Integration Points: Dialogue System, Inventory System, Monster System (for kill quests), Item System.
Save/Load Impact: player.activeQuests, player.completedQuests, player.gold. NPC stock (if persistent).

V. User Interface (UI) & User Experience (UX)
Map Display & Mini-Map (for explorable levels)
Goal: Provide navigation aids.
Key Data Structures:
levelData[levelNum].mapImage = "path/to/map.png"
levelData[levelNum].mapScale = 0.1 (pixels per map unit)
player.mapFog[levelNum] = { {true, false, ...}, ... } (2D grid for fog of war)
Core Logic:
Full Map (gameState="mapScreen"):
Draw levelData.mapImage.
Draw player icon at player.x * mapScale, player.y * mapScale.
Draw quest markers, key locations.
Overlay fog of war using player.mapFog.
Update player.mapFog as player explores (reveal nearby cells).
Mini-Map (HUD):
In drawExplorationUI():
Draw a clipped portion of levelData.mapImage centered on player.
Draw icons for player, nearby entities.
UI Components: Full map screen, Mini-map HUD element.
Save/Load Impact: player.mapFog.

MC’s Statistics Page
Goal: Show detailed character statistics.
Core Logic:
New gameState = "statsScreen" (or part of Inventory/Equipment screen).
drawStatsScreen():
List all relevant stats from player table (HP, MP, Attack, Defense, CritRate, etc.).
Distinguish between base stats and stats modified by equipment/buffs (requires player.baseStats and recalculatePlayerStats() from Equipment System).
UI Components: Stats screen.
Integration Points: player table, Equipment System.

Quest Page (Journal)
Goal: Allow player to review active and completed quests.
Core Logic:
New gameState = "questLogScreen".
drawQuestLogScreen():
Tabs for "Active" / "Completed".
List quests from player.activeQuests or player.completedQuests.
When a quest is selected, display its title, description, objectives, and progress from GameData.quests and player.activeQuests.
UI Components: Quest log screen.
Integration Points: Quest System.

PDF Check

____________________
Turn-based RPG using Love2D Framework. Personal demo for better understand the challenges in a larger Unity 3D group project later this year

-- This is a Lua script for a 2D game called "A Hero's Redemption"
-- This script contains the game's story, character definitions, level dialogues,
-- and other game-related text in both English and Chinese.
-- Build with love-12.0-win64 Beta
-- Created by Dundd2, 2025/1

