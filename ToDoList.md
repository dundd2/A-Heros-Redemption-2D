# A Hero's Redemption 2D TO DO LIST Before V1.0

III. Gameplay Systems - Character & Interaction
Skill Unlocking:
Inside checkLevelUp(), after incrementing player.level, check GameData.skillUnlocks[player.level].
For each skill key found, make it available (e.g., add to a player.unlockedSkills table, or simply allow its use if skillInfo is the master list).
Update UI to reflect new skills.
Visual/Audio Feedback: Add TimerSystem.create for a brief particle effect at player position and a sound effect.
Integration Points: Monster kills, Quest System (for EXP rewards).
Save/Load Impact: player stats, player.unlockedSkills (if used).

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

NPC Interaction, Quest Giving & Trading System
(Note: A Quest Log UI for viewing active/completed quests is implemented. This section focuses on NPC interaction for obtaining and turning in quests, and trading.)
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

pdf check
____________________
Turn-based RPG using Love2D Framework. Personal demo for better understand the challenges in a larger Unity 3D group project later this year

-- This is a Lua script for a 2D game called "A Hero's Redemption"
-- This script contains the game's story, character definitions, level dialogues,
-- and other game-related text in both English and Chinese.
-- Build with love-12.0-win64 Beta
-- Created by Dundd2, 2025/1
