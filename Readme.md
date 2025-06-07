# A Hero's Redemption 2D

A Hero's Redemption 2D is a simple RPG battle game built using the LÖVE 12 Beta game Framework.
It serves as a personal proof-of-concept and learning exercise to understand better the mechanics, systems, and potential complexities involved in game development, Specifically, in preparation for my **Year 2 G6078: Game Design and Development** Assignments 2 and 3, which will be larger Unity 3D group projects taking place between January and May 2025. This 2D project aims to provide insights into code volume, game architecture, and overall development effort. Ultimately, it helps assess the feasibility of achieving our ambitious 3D game goals within a few months of part-time development.

## ScreenShot (V0.01)
![ScreenShot1](https://github.com/dundd2/A-Heros-Redemption-2D/blob/main/assets/Screenshot/SC(1).gif)

## Project Overview

This demo focuses on implementing a turn-based battle system and core RPG elements. Therefore, this 2D version intentionally simplifies the scope and concentrates on:

*   **Turn-Based Combat:** Implementing a system where the player and enemy take turns to perform actions.
*   **Basic Skills:** Creating a skill system with different actions like attack, defend, special attack, and heal.
*   **Enemy AI:** Developing a basic AI for enemies to make decisions in combat.
*   **Story System:** Adding a basic dialogue system to give the game context and narrative.
*   **Game States:** Managing different game states (menu, level select, story, battle, victory, defeat, ending).

## Scope and Excluded Features

This 2D demo is intentionally simplified and **does not include** features planned for our future 3D project, such as:

- **Movement**: This 2D game restricts player movement to direct transitions into duel states after the story mode, lacking free-roam exploration. A movement script is not included.  
- **Weapon Switching**  
- **Leveling System**: Character progression and EXP management  
- **Respawn System**  
- **Room Event Triggers**: Events within rooms, such as traps, treasure, or monster encounters.  
- **Equipment System**  
- **Item Pickup (Collectible Object)**  
- **Treasure/Loot System**  
- **NPC Quest and Trading System**  
- **Map Display**  
- **Mini-Map**  
- **Quest Page** : Show players’ mission

Despite these simplifications, the 2D game codebase already consists of approximately **5500+ lines of code** (V0.01+). This provides a tangible reference point for understanding the scale and complexity even of a reduced-scope game and highlights potential challenges in developing a more feature-rich 3D project within our timeframe.

For more detailed features and information about our current (Jan 2025) plans for the 3D project, please check the [A Hero's Redemption Game Plan](A%20Hero's%20Redemption%20Game%20Plan.pdf)
 file.

## Built With

*   [LÖVE2D 12.0 (Bestest Friend)](https://love2d.org/): A free, open-source 2D game Framework.

## How to Play

### Option 1: Download the Executable (Windows)
1. Go to the [Releases](https://github.com/dundd2/A-Heros-Redemption-2D/releases) page
2. Download the latest .exe file
3. Run the downloaded executable to play the game

### Option 2: Run with LÖVE
1.  **Download Love:** Download and install LÖVE from [https://love2d.org/](https://love2d.org/).
2.  **Download or Clone the Project:** Clone or download this repository to your local machine.
3.  **Run the Game:** Drag and drop the project folder (the folder containing `main.lua`) onto the `love.exe` executable (on Windows) or run from the terminal.

### Controls:

*Note: Most UI interactions (buttons, selections) also support **Mouse Click**.*

*   **General Hotkeys (available in most game states):**
    *   `I`: Toggle Inventory screen.
    *   `J`: Toggle Quest Log screen.
    *   `C`: Toggle Character Stats screen.

*   **Main Menu:**
    *   **Up/Down Arrow Keys or W/S:** Navigate menu options.
    *   **Enter/Space:** Select menu option.
    *   **Mouse Click:** Select menu option.

*   **Level Select:**
    *   **Up/Down Arrow Keys or W/S:** Choose a level or grinding mission.
    *   **Enter/Space:** Start the selected level/mission.
    *   **Esc:** Return to the main menu.
    *   **Mouse Click:** Select level/mission or back button.

*   **Story Mode (Dialogue):**
    *   **Enter/Space:** Continue to the next dialogue line.
    *   **Esc:** Skip the entire dialogue sequence and proceed to the next game state (e.g., battle).
    *   **Mouse Click (on dialogue box):** Continue dialogue.

*   **Battle:**
    *   **Up/Down Arrow Keys or W/S:** Navigate action/skill options.
    *   **Enter/Space:** Select and perform the chosen action/skill.
    *   **Esc:** Pause the game, opening the Pause Menu.
    *   `X`: Exit Grinding mode (only available if in a grinding level).
    *   **Mouse Click:** Select action/skill buttons, or "Leave Training" button (if applicable).

*   **Pause Menu:**
    *   **Up/Down Arrow Keys or W/S:** Navigate options (Continue, Restart, Main Menu, Quit).
    *   **Enter/Space:** Select option.
    *   **Mouse Click:** Select option.

*   **Victory/Defeat Screen:**
    *   **Up/Down Arrow Keys or W/S:** Navigate options (Restart, Main Menu).
    *   **Enter/Space:** Select option.
    *   **Mouse Click:** Select option.

*   **Options Menu:**
    *   **Up/Down Arrow Keys or W/S:** Navigate options.
    *   **Left/Right Arrow Keys or A/D:** Change value for selected option (Language, Resolution, Font Size, Toggles).
    *   **Enter/Space:** Apply change (for Resolution) or toggle option. For "Back to Main Menu", selects it.
    *   **Esc:** Return to the main menu.
    *   **Mouse Click:** Select option, use on-screen arrows to change values, or click the back button.

*   **Story Page / About Page / How to Play Page:**
    *   **Mouse Wheel:** Scroll text (for Story and About pages).
    *   **Esc:** Return to the main menu.
    *   **Mouse Click (on Back button):** Return to the main menu.

*   **Inventory Screen:**
    *   **Arrow Keys or W/A/S/D:** Navigate inventory slots or equipment panel.
    *   **Tab:** Switch focus between the inventory grid and the equipment panel.
    *   **Enter/Space:**
        *   In inventory: Equip selected item (if equippable), or use item (if consumable).
        *   In equipment panel: Unequip selected item.
    *   **Esc or I:** Close the Inventory screen and return to the previous game state.
    *   **Mouse Click:** Select inventory slot or equipment slot. Double-click or select then use on-screen prompt (if available) to equip/unequip/use.

*   **Quest Log Screen:**
    *   **Up/Down Arrow Keys or W/S:** Navigate quests in the current list.
    *   **Left/Right Arrow Keys or A/D:** Switch between "Active" and "Completed" quest tabs.
    *   **Esc or J:** Close the Quest Log screen and return to the previous game state.
    *   **Mouse Click:** Select a tab or a quest from the list.

*   **Character Stats Screen:**
    *   **Esc or C:** Close the Stats screen and return to the previous game state.

### Game Mechanics

*   **Main Menu:** Navigate options to start a new game (via Level Select), load a saved game, adjust settings, view game story/about/how-to-play information, or exit.
*   **Level Select:** Choose from story-based levels or repeatable grinding missions to engage in battles.
*   **Story Mode:** Experience dialogues and narrative before battles. These can be advanced or skipped.
*   **Battle System:**
    *   Engage in turn-based combat against enemies.
    *   Player and enemy alternate turns.
    *   Utilize skills: Attack, Defend, Special Attack, and Heal.
    *   Skills have cooldown periods and some may consume MP.
    *   Enemies operate with basic AI for their actions.
    *   Combat concludes when either player or enemy HP is depleted.
    *   Gain EXP after successful battles.
*   **Character Progression (Leveling):**
    *   Earn Experience Points (EXP) from battles.
    *   Level up upon reaching EXP thresholds, potentially improving stats (details not explicitly shown to player beyond stat numbers).
*   **Inventory System:**
    *   Manage items collected during gameplay.
    *   Accessible via the 'I' key.
    *   Use consumable items like health potions.
*   **Equipment System:**
    *   Equip weapons and armor to enhance player stats (Attack, Defense, HP, etc.).
    *   Items can be equipped/unequipped through the inventory screen.
    *   Player stats in battle reflect equipped items.
*   **Quest Log:**
    *   Track active and completed quests.
    *   Accessible via the 'J' key.
    *   View quest objectives and rewards.
*   **Character Statistics:**
    *   View detailed player stats (Level, EXP, HP, MP, Attack, Defense, Crit Rate, Crit Damage).
    *   Accessible via the 'C' key.
*   **Game States & UI:**
    *   Managed states include Menu, Level Select, Story, Battle, Pause, Victory, Defeat, Options, Inventory, Quest Log, Stats Screen, Story/About/How-To-Play Pages.
    *   Interactive UI elements for navigation and actions, supporting both keyboard and mouse.
*   **Pause Menu:**
    *   Accessible during battle by pressing Esc.
    *   Options: Continue, Restart battle, Return to Main Menu, Quit Game.
*   **Victory/Defeat Screens:**
    *   Displayed after battle resolution.
    *   Options: Restart battle or Return to Main Menu.
*   **Save/Load System:**
    *   Save game progress from the Main Menu.
    *   Load previously saved games from the Main Menu.
*   **Options:**
    *   Adjust settings like language (English/Chinese), screen resolution, fullscreen mode, font size scaling, and toggle audio (BGM/SFX) and cheat modes.
*   **Grinding Levels:**
    *   Special repeatable levels for gaining EXP and potentially items.
    *   Can be exited mid-battle using the 'X' key.

## Skills Used

This project utilizes the following skills and concepts:

*   **Lua Programming:** The entire game logic is written in Lua.
*   **Love2D API:** Utilizes Love2D's core functionalities for:
    *   **Graphics:** Drawing images, text, and shapes.
    *   **Audio:** Playing sound effects and background music.
    *   **Input:** Handling keyboard and mouse input.
    *   **Timer:** Implementing delay and cooldown systems.
    *   **Particle System:** Creating simple visual effects.
*   **Game Design:** Implementing core game concepts such as:
    *   Turn-based combat mechanics
    *   Skill and cooldown systems
    *   Basic enemy AI
    *   UI/UX design
    *   Level design
*   **Data Structures:** Using Lua tables to manage game data.
*   **Object-Oriented Concepts:** Implemented in Lua using tables and functions.
*   **Game Logic:** Implementing game state logic, battle logic, and story progression logic.

## External Resources

This project utilizes various free resources from the game development community, including artwork, sound effects, and music. I'm grateful to all the creators who make their work available for others to use. For a detailed list of all resources used and their respective credits, please check the [Resource Credits List.md](Resource%20Credits%20List.md) file.

## Thanks

I would like to express my gratitude to the Love2D team for providing such a fantastic, free, and open-source game Framework.
