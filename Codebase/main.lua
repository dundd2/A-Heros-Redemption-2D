-- This is a Lua script for a 2D game called "A Hero's Redemption"
-- This script contains the game's story, character definitions, level dialogues,
-- and other game-related text in both English and Chinese.
-- Build with love-12.0-win64 Beta (Bestest Friend)
-- Created by Dundd2, 2025/1 ,Last update: 2025/6

local GameData = require("game_data")
local GameLogic = require("game_logic") -- New: Require game_logic.lua
local GameHelpers = require("game_helpers") -- New: Require game_helpers.lua

gameState = "loading" -- Initial state
previousGameState = "menu" -- For inventory screen toggle
currentGameLanguage = GameData.getCurrentLanguage() -- Get initial language from GameData

player = {}
enemy = {}
resources = {}
animations = {}
battleState = {}
uiState = {}
pauseState = {}
resultState = {}
menuState = {}
optionsState = {}
storyPageState = {}
aboutPageState = {}
inventoryState = {}
questLogState = {}
statsScreenState = {}
howToPlayState = {}

-- Global Constants (can be accessed directly)
GAME_CONSTANTS = {
    MIN_DAMAGE = 1,
    MAX_DAMAGE_MULTIPLIER = 3.0,
    DAMAGE_RANDOM_MIN = -0.1,
    DAMAGE_RANDOM_MAX = 0.1,
    DEFENSE_SCALING = 100,
    BASE_CRIT_RATE = 5,
    MAX_CRIT_RATE = 100,
    BASE_CRIT_DAMAGE = 1.5,
    MAX_CRIT_DAMAGE = 3.0,
    COOLDOWN = {
        ATTACK = 0,
        DEFEND = 2,
        SPECIAL = 3,
        HEAL = 4
    },
    HP = {
        BASE = 100,
        MIN = 1,
        MAX = 9999,
        HEAL_PERCENT = 0.2
    },
    FONT_SIZES = {
        UI = 16,
        BATTLE = 24,
        DAMAGE = 32,
        UI_CHINESE = 16,
        BATTLE_CHINESE = 24,
    },
    FONT_SIZE_OPTIONS = {0.8, 1.0, 1.2, 1.5},
    currentFontSizeIndex = 2,
    TIMER = {
        ACTION_DELAY = 2.0,
        EFFECT_DURATION = 0.5,
        MESSAGE_DURATION = 2.0
    }
}

playerSettings = {
    isCheatMode = false,
    isInfiniteHP = false,
    fontScale = 1.0,
    isFullScreen = false,
}

audioState = {
  isMutedBGM = false,
  isMutedSFX = false
}

-- Screen and Resolution
screenWidth = 1880
screenHeight = 720
local availableResolutions = {
    {width = 1920, height = 1080, name = "1920x1080 (Full HD)"},
    {width = 1280, height = 720, name = "1280x720 (HD)"},
    {width = 854, height = 480, name = "854x480 (SD)"},
    {width = 640, height = 360, name = "640x360 (Low)"}
}
local currentResolutionIndex = 1

-- UI Messages (for temporary pop-ups)
uiMessage = ""
uiMessageTimer = 0

-- Loading screen specific resources
local loadingFont = nil
local creatorLogo = nil
local engineLogo = nil
local gameGroupLogo = nil

-- LÖVE2D Callbacks
function love.load()
  print("[GAME] love.load() - Game loading started")
  screenWidth = availableResolutions[currentResolutionIndex].width
  screenHeight = availableResolutions[currentResolutionIndex].height
  love.window.setMode(screenWidth, screenHeight, {resizable = false, vsync = true, fullscreen = playerSettings.isFullScreen})
  print("[GAME] Set window mode to " .. screenWidth .. "x" .. screenHeight)

  -- Load loading screen assets first
  loadingFont = GameLogic.loadFont("assets/ui-font.ttf", 24)
  creatorLogo = GameLogic.loadImage("assets/author_portrait.png")
  engineLogo = GameLogic.loadImage("assets/love2d_logo.png")
  gameGroupLogo = GameLogic.loadImage("assets/game_group_logo.png")

  -- Draw initial loading screen
  GameHelpers.drawLoadingScreen(loadingFont, creatorLogo, engineLogo, gameGroupLogo)
  love.graphics.present()
  love.timer.sleep(0.5) -- Give a moment for the user to see the loading screen

  -- Initialize global tables (important for GameLogic and GameHelpers to access them)
  -- These must be fully defined before passing to GameLogic.setGlobals and GameHelpers.setGlobals
  player = {
    x = 100, y = 300, speed = 200, image = nil,
    hp = 100, maxHp = 100, mp = 50, maxMp = 50,
    level = 1, exp = 0, expToNextLevel = 100,
    attack = 10, critRate = 10, critDamage = 1.5, defense = 5,
    isDefending = false, status = {}, combo = 0,
    activeQuests = {}, completedQuests = {},
    inventoryCapacity = 20, inventory = {},
    equipment = {
        head = nil, chest = nil, legs = nil,
        weapon = nil, accessory1 = nil, accessory2 = nil
    }
  }
  for i = 1, player.inventoryCapacity do player.inventory[i] = nil end

  enemy = {
    x = 600, y = 300, image = nil,
    hp = 80, maxHp = 80, attack = 8, critRate = 5, critDamage = 1.2, defense = 3,
    isDefending = false, status = {}, combo = 0,
    displayNameKey = nil, attackImageKey = nil
  }

  resources = {
    images = {},
    sounds = {},
    fonts = {},
    particleSystems = {}
  }

  animations = {
    player = { current = "stand", timer = 0, x = 0, y = 0, originalX = 0 },
    enemy = { current = "stand", timer = 0, x = 0, y = 0, originalX = 0 },
    effects = {}
  }

  battleState = {
    phase = "select", turn = "player", message = "", messageTimer = 0,
    options = {
      {name = "Attack", description = "Deal damage to enemy"},
      {name = "Defend", description = "Reduce incoming damage"},
      {name = "Special", description = "Powerful attack with delay"},
      {name = "Heal", description = "Restore health"},
    },
    currentOption = 1, buttonAreas = {}, effects = {},
    victoryTriggered = false, defeatTriggered = false, leaveGrindingButtonArea = nil
  }

  uiState = { showSkillInfo = false, selectedSkill = 1 }

  pauseState = {
    isPaused = false,
    options = {
      {textKey = "pause_continue", action = function() GameHelpers.resumeBattle() end},
      {textKey = "pause_restart", action = function() GameHelpers.restartGame() end},
      {textKey = "pause_main_menu", action = function() GameHelpers.transitionGameState(gameState, "menu") end},
      {textKey = "pause_quit_game", action = function() love.event.quit() end}
    },
    currentOption = 1, buttonAreas = {}, navDelay = 0.3,
  }

  resultState = {
    options = {
      {textKey = "result_restart", action = function() GameHelpers.restartGame() end},
      {textKey = "result_main_menu", action = function() GameHelpers.transitionGameState(gameState, "menu") end}
    },
    currentOption = 1, buttonAreas = {}
  }

  menuState = {
    options = {
      {textKey = "menu_select_level", action = function() GameHelpers.transitionGameState(gameState, "levelSelect") end, descriptionKey = "menu_select_level_desc"},
      {textKey = "menu_options", action = function() GameHelpers.transitionGameState(gameState, "options") end, descriptionKey = "menu_options_desc"},
      {textKey = "menu_story_page", action = function() GameHelpers.transitionGameState(gameState, "storyPage") end, descriptionKey = "menu_story_page_desc"},
      {textKey = "menu_about", action = function() GameHelpers.transitionGameState(gameState, "aboutPage") end, descriptionKey = "menu_about_desc"},
      {
          textKey = "menu_how_to_play",
          action = function() GameHelpers.transitionGameState(gameState, "howToPlay") end,
          descriptionKey = "menu_how_to_play_desc"
      },
      {textKey = "menu_quest_log", action = function() GameHelpers.transitionGameState(gameState, "questLogScreen") end, descriptionKey = "menu_quest_log_desc"},
      {textKey = "menu_statistics", action = function() GameHelpers.transitionGameState(gameState, "statsScreen") end, descriptionKey = "menu_statistics_desc"},
      {textKey = "menu_save_game", action = function() GameHelpers.saveGame() end, descriptionKey = "menu_save_game_desc"},
      {textKey = "menu_load_game", action = function() GameHelpers.loadGame() end, descriptionKey = "menu_load_game_desc"},
      {textKey = "menu_exit", action = function() love.event.quit() end, descriptionKey = "menu_exit_desc"}
    },
    currentOption = 1, navTimer = 0, navDelay = 0.6, buttonAreas = {},
    levelSelect = {
        currentLevel = 1, maxLevel = 10, navTimer = 0, navDelay = 0.6,
        buttonAreas = {}, backButtonArea = {}, grindingLevelIds = {}, selectedGrindingLevelKey = nil
    }
  }

  optionsState = {
    options = {
      {textKey = "options_language", type = "language", currentOption = 1, languageOptions = {"en", "zh"}},
      {textKey = "options_resolution", type = "resolution", currentOption = currentResolutionIndex, resolutionOptions = availableResolutions},
      {textKey = "options_fullscreen", type = "toggle", state = "isFullScreen", targetState = playerSettings},
      {textKey = "options_font_size", type = "font_size", currentOption = GAME_CONSTANTS.currentFontSizeIndex, fontSizeOptions = GAME_CONSTANTS.FONT_SIZE_OPTIONS},
      {textKey = "options_bgm", type = "toggle", state = "isMutedBGM", targetState = audioState},
      {textKey = "options_sfx", type = "toggle", state = "isMutedSFX", targetState = audioState},
      {textKey = "options_cheat", type = "toggle", state = "isCheatMode", targetState = playerSettings},
      {textKey = "options_infinite_hp", type = "toggle", state = "isInfiniteHP", targetState = playerSettings},
      {textKey = "options_back_to_menu", action = function() GameHelpers.transitionGameState(gameState, "menu") end},
    },
    currentOption = 1, navTimer = 0, navDelay = 0.6,
    buttonAreas = {}, backButtonArea = {}, languageButtonAreas = {} ,
    resolutionButtonAreas = {}, fontSizeButtonAreas = {}
  }

  storyPageState = {
    storyText = "", scrollPosition = 0, backButtonArea = {}, navDelay = 0.3,
  }

  aboutPageState = {
    scrollPosition = 0, backButtonArea = {},
  }

  inventoryState = {
    selectedSlot = 1, slotCols = 5, slotRows = 4,
    slotWidth = 100, slotHeight = 80, slotPadding = 10, padding = 15,
    gridStartX = 50, gridStartY = 100, detailsX = 0, detailsY = 100,
    uiMessage = "", uiMessageTimer = 0,
    currentFocus = "inventory", selectedEquipmentSlotKey = nil,
    equipmentSlotOrder = {"weapon", "head", "chest", "legs", "accessory1", "accessory2"},
    equipmentSlotDisplayAreas = {}, equipmentPanel = { x = 0, y = 0, width = 0, height = 0 }
  }
  inventoryState.slotRows = math.ceil(player.inventoryCapacity / inventoryState.slotCols)
  inventoryState.detailsX = inventoryState.gridStartX + (inventoryState.slotWidth + inventoryState.slotPadding) * inventoryState.slotCols + 20

  questLogState = {
    currentTab = "active", selectedQuestId = nil,
    activeQuestScrollOffset = 0, completedQuestScrollOffset = 0,
    questsPerPage = 5, tabAreas = {}, questListArea = {}, detailsArea = {},
    lineHeight = 0, padding = 10, selectedQuestIndex = 1,
    navDelayTimer = 0, navDelay = 0.15
  }

  statsScreenState = {
    padding = 20, lineHeight = 0, labelColumnWidth = 0, valueColumnX = 0
  }

  -- Expose global variables to GameLogic and GameHelpers (important for cross-file access)
  -- This must happen AFTER all global tables are initialized.
  GameLogic.setGlobals(
      player, enemy, resources, animations, battleState, uiState, pauseState,
      resultState, menuState, optionsState, storyPageState, aboutPageState, howToPlayState,
      inventoryState, questLogState, statsScreenState,
      GAME_CONSTANTS, playerSettings, audioState,
      screenWidth, screenHeight, availableResolutions, currentResolutionIndex,
      uiMessage, uiMessageTimer
  )
  GameHelpers.setGlobals(
      player, enemy, resources, animations, battleState, uiState, pauseState,
      resultState, menuState, optionsState, storyPageState, aboutPageState, howToPlayState,
      inventoryState, questLogState, statsScreenState,
      GAME_CONSTANTS, playerSettings, audioState,
      screenWidth, screenHeight, availableResolutions, currentResolutionIndex,
      uiMessage, uiMessageTimer,
      GameLogic, GameData, currentGameLanguage, previousGameState
  )

  -- Now load all other resources (GameLogic.loadAllResources now uses the global references)
  GameLogic.loadAllResources(resources, GameLogic.positions)
  GameHelpers.initFonts() -- Initialize fonts after resources are loaded

  -- Populate grinding levels
  if GameData and GameData.grindingLevels then
      for id, _ in pairs(GameData.grindingLevels) do
          table.insert(menuState.levelSelect.grindingLevelIds, id)
      end
      table.sort(menuState.levelSelect.grindingLevelIds)
  end

  -- Set initial story/about page text
  storyPageState.storyText = GameData.getText(currentGameLanguage, "game_full_story")
  aboutPageState.storyText = GameData.getText(currentGameLanguage, "about_project")
  aboutPageState.staffText = GameData.getText(currentGameLanguage, "about_staff")

  -- Final check for critical resources
  local criticalResources = {
    resources.images.background, resources.images.dialogBox, resources.images.uiFrame,
    resources.images.playerStand, resources.images.playerAttack, resources.images.battleBgForest,
    resources.images.battleBgCave, resources.images.battleBgDungeon, resources.images.battleBgCastle,
    resources.images.hitEffect, resources.images.defendEffect, resources.images.skillDefend,
    resources.images.skillSpecial, resources.images.skillHeal, resources.images.skillAttack,
    resources.images.cooldownOverlay, resources.images.portraitHero, resources.images.portraitKing,
    resources.images.portraitPrincess, resources.images.portraitDemonKing, resources.images.enemyDemonKing,
    resources.fonts.ui, resources.fonts.battle, resources.fonts.damage,
  }
  local allCriticalResourcesLoaded = true
  for _, resource in ipairs(criticalResources) do
    if not resource then
      print("[CRITICAL ERROR] A critical resource failed to load. The game cannot continue.")
      allCriticalResourcesLoaded = false
      break
    end
  end
  if not allCriticalResourcesLoaded then
    love.graphics.clear(0, 0, 0)
    love.graphics.setColor(1, 0, 0)
    love.graphics.setFont(resources.fonts.battle)
    love.graphics.print("Critical resources failed to load.\nPlease check the console for details.", 100, 100)
    love.event.quit()
  end

  print("[GAME] love.load() - Game loading complete")
  GameHelpers.transitionGameState(nil, "menu") -- Transition to main menu after loading
end

function love.update(dt)
    GameLogic.TimerSystem.update(dt)

    if uiMessageTimer > 0 then
        uiMessageTimer = uiMessageTimer - dt
        if uiMessageTimer <= 0 then
            uiMessage = ""
        end
    end

    if gameState == "menu" then
        GameLogic.handleMenuInput(dt, menuState, GameData, currentGameLanguage)
    elseif gameState == "levelSelect" then
        GameLogic.handleLevelSelectInput(dt, menuState)
    elseif gameState == "story" then
        GameData.updateTextEffect(dt)
        -- Story input handled in love.keypressed for now
    elseif gameState == "battle" then
        GameLogic.updateAnimations(dt, animations, GameLogic.positions)
        GameLogic.updateEffects(dt, battleState)
        if battleState.messageTimer > 0 then
            battleState.messageTimer = battleState.messageTimer - dt
        end
        GameLogic.checkBattleEnd(player, enemy, battleState, GameData.story.currentState, GAME_CONSTANTS, GameLogic.TimerSystem, GameHelpers.transitionGameState, GameHelpers.restartGame, GameData, currentGameLanguage)
    elseif gameState == "pause" then
        -- No continuous update needed for pause menu
    elseif gameState == "ending" then
        -- No continuous update needed for ending
    elseif gameState == "options" then
        GameLogic.handleOptionsInput(dt, optionsState, GameData, currentGameLanguage, GameHelpers.applyResolutionChange, GameHelpers.applyFontSizeChange, availableResolutions, GAME_CONSTANTS, playerSettings, audioState, currentResolutionIndex)
    elseif gameState == "storyPage" then
        GameLogic.handleStoryPageInput(dt, storyPageState)
    elseif gameState == "aboutPage" then
        GameLogic.handleAboutPageInput(dt, aboutPageState)
    elseif gameState == "inventoryScreen" then
        -- uiMessageTimer is handled globally
    elseif gameState == "questLogScreen" then
        GameLogic.handleQuestLogInput(dt, questLogState, player, GameData, currentGameLanguage)
    elseif gameState == "statsScreen" then
        -- No continuous update needed for stats screen
    elseif gameState == "howToPlay" then
        -- No continuous updates needed for this page yet
        -- GameLogic.handleHowToPlayInput(dt, howToPlayState) -- If scrolling or other updates were needed
    end
end

function love.draw()
  if gameState == "loading" then
    GameHelpers.drawLoadingScreen(loadingFont, creatorLogo, engineLogo, gameGroupLogo)
    return
  end

  love.graphics.push()
  -- Camera is not used in this game, so scale/translate are not needed
  -- love.graphics.scale(camera.scale, camera.scale)
  -- love.graphics.translate(-camera.x, -camera.y)

  if gameState == "menu" then
    GameHelpers.drawMainMenu(resources, menuState, GameData, currentGameLanguage, GAME_CONSTANTS)
  elseif gameState == "levelSelect" then
    GameHelpers.drawLevelSelect(resources, menuState, GameData, currentGameLanguage)
  elseif gameState == "story" then
    GameHelpers.drawStoryDialogue(resources, GameData, currentGameLanguage, GameLogic.enemyData, GameData.story.currentState)
  elseif gameState == "battle" then
    GameLogic.drawBattleScene(resources, GameData.story.currentState, GameLogic.battleBackgrounds)
    GameHelpers.drawCharacters(animations, resources, GameLogic.positions, enemy)
    GameHelpers.drawBattleUI(resources, player, enemy, battleState, uiState, GameData, currentGameLanguage, GAME_CONSTANTS, GameLogic.skillInfo, GameLogic.skillSystem)
    GameLogic.drawEffects(battleState)
    GameHelpers.drawBattleMessage(battleState, player, enemy, GameData, currentGameLanguage)
    if uiState.showSkillInfo then
      GameHelpers.drawSkillInfoUI(uiState, GameLogic.skillInfo, GameData, currentGameLanguage, resources)
    end
  elseif gameState == "pause" then
    GameLogic.drawBattleScene(resources, GameData.story.currentState, GameLogic.battleBackgrounds)
    GameHelpers.drawCharacters(animations, resources, GameLogic.positions, enemy)
    GameHelpers.drawBattleUI(resources, player, enemy, battleState, uiState, GameData, currentGameLanguage, GAME_CONSTANTS, GameLogic.skillInfo, GameLogic.skillSystem)
    GameHelpers.drawPauseUI(pauseState, GameData, currentGameLanguage, resources)
  elseif gameState == "victory" then
    GameHelpers.drawVictoryUI(resultState, GameData, currentGameLanguage, resources)
  elseif gameState == "defeat" then
    GameHelpers.drawDefeatUI(resultState, GameData, currentGameLanguage, resources)
  elseif gameState == "options" then
    GameHelpers.drawOptionsUI(optionsState, GameData, currentGameLanguage, resources, availableResolutions, GAME_CONSTANTS, playerSettings, audioState)
  elseif gameState == "storyPage" then
    GameHelpers.drawStoryPageUI(storyPageState, GameData, currentGameLanguage, resources)
  elseif gameState == "aboutPage" then
    GameHelpers.drawAboutPageUI(aboutPageState, GameData, currentGameLanguage, resources)
  elseif gameState == "inventoryScreen" then
    GameHelpers.drawInventoryScreen(inventoryState, player, GameData, currentGameLanguage, resources, uiMessage, uiMessageTimer)
  elseif gameState == "questLogScreen" then
    GameHelpers.drawQuestLogScreen(questLogState, player, GameData, currentGameLanguage, resources)
  elseif gameState == "statsScreen" then
    GameHelpers.drawStatsScreen(statsScreenState, player, GameData, currentGameLanguage, resources)
  elseif gameState == "howToPlay" then
    GameHelpers.drawHowToPlayPageUI(resources, howToPlayState, GameData, currentGameLanguage)
  end
  love.graphics.pop()
end

function love.keypressed(key)
  if gameState == "menu" then
    if key == "return" or key == "space" then
      local option = menuState.options[menuState.currentOption]
      print("[MENU] Option selected: " .. GameData.getText(currentGameLanguage, option.textKey))
      option.action()
    end
  elseif gameState == "levelSelect" then
    local totalOptions = menuState.levelSelect.maxLevel + #menuState.levelSelect.grindingLevelIds
    if key == "return" then
        local selectedIdx = menuState.levelSelect.currentLevel
        if selectedIdx >= 1 and selectedIdx <= menuState.levelSelect.maxLevel then
            GameData.story.currentState.isGrinding = false
            GameData.startLevelDialogue(selectedIdx)
            GameHelpers.transitionGameState(gameState, "story")
            print("[LEVEL SELECT] Regular Level " .. selectedIdx .. " selected")
        elseif selectedIdx > menuState.levelSelect.maxLevel and selectedIdx <= totalOptions then
            local grindingIndex = selectedIdx - menuState.levelSelect.maxLevel
            local grindingId = menuState.levelSelect.grindingLevelIds[grindingIndex]
            if grindingId then
                GameData.story.currentState.isGrinding = true
                GameData.story.currentState.currentGrindingLevelId = grindingId
                menuState.levelSelect.selectedGrindingLevelKey = grindingId
                print("[LEVEL SELECT] Grinding Level " .. grindingId .. " selected. isGrinding: " .. tostring(GameData.story.currentState.isGrinding))
                GameHelpers.restartGame()
                GameHelpers.transitionGameState(gameState, "battle")
            else
                print("[LEVEL SELECT] Error: Could not find grindingId for index: " .. grindingIndex)
            end
        else
            print("[LEVEL SELECT] Error: selectedIdx out of bounds: " .. selectedIdx)
        end
    elseif key == "escape" then
      GameHelpers.transitionGameState(gameState, "menu")
    elseif key == "up" or key == "w" then
      menuState.levelSelect.currentLevel = math.max(1, menuState.levelSelect.currentLevel - 1)
      if menuState.levelSelect.currentLevel > menuState.levelSelect.maxLevel and menuState.levelSelect.currentLevel <= totalOptions then
           menuState.levelSelect.selectedGrindingLevelKey = menuState.levelSelect.grindingLevelIds[menuState.levelSelect.currentLevel - menuState.levelSelect.maxLevel]
      else
           menuState.levelSelect.selectedGrindingLevelKey = nil
      end
      print("[LEVEL SELECT] Level selected: " .. menuState.levelSelect.currentLevel .. " Grinding Key: " .. tostring(menuState.levelSelect.selectedGrindingLevelKey))
    elseif key == "down" or key == "s" then
      menuState.levelSelect.currentLevel = math.min(totalOptions, menuState.levelSelect.currentLevel + 1)
      if menuState.levelSelect.currentLevel > menuState.levelSelect.maxLevel and menuState.levelSelect.currentLevel <= totalOptions then
           menuState.levelSelect.selectedGrindingLevelKey = menuState.levelSelect.grindingLevelIds[menuState.levelSelect.currentLevel - menuState.levelSelect.maxLevel]
      else
           menuState.levelSelect.selectedGrindingLevelKey = nil
      end
      print("[LEVEL SELECT] Level selected: " .. menuState.levelSelect.currentLevel .. " Grinding Key: " .. tostring(menuState.levelSelect.selectedGrindingLevelKey))
    end
  elseif gameState == "story" then
    if key == "return" then
      print("[STORY] Continue dialogue key pressed")
      GameData.nextDialogue()
      if not GameData.story.currentState.isPlaying then
        if GameData.story.currentState.isEnding then
          GameHelpers.transitionGameState(gameState, "menu")
        else
          GameHelpers.transitionGameState(gameState, "battle")
          GameHelpers.restartGame()
        end
      end
    elseif key == "escape" then
      print("[STORY] Skip dialogue key pressed")
      GameData.skipDialogue()
      GameHelpers.transitionGameState(gameState, "battle")
      GameHelpers.restartGame()
    end
  elseif gameState == "battle" then
    if key == "up" or key == "down" or key == "w" or key == "s" then
      GameLogic.handleBattleInput(battleState)
    elseif key == "return" or key == "space" then
      if battleState.phase == "select" and battleState.turn == "player" then
        local option = battleState.options[battleState.currentOption]
        print("[BATTLE MENU] Option chosen: " .. option.name)
        if option.name == "Attack" then
          GameLogic.performPlayerAttack(player, enemy, battleState, animations, resources, GameLogic.positions, GameLogic.skillSystem, GameLogic.TimerSystem, GameData, currentGameLanguage, GAME_CONSTANTS, playerSettings)
        elseif option.name == "Defend" then
          GameLogic.performPlayerDefend(player, enemy, battleState, animations, resources, GameLogic.positions, GameLogic.skillSystem, GameLogic.TimerSystem, GameData, currentGameLanguage, GAME_CONSTANTS)
        elseif option.name == "Special" then
          GameLogic.performPlayerSpecial(player, enemy, battleState, animations, resources, GameLogic.positions, GameLogic.skillSystem, GameLogic.TimerSystem, GameData, currentGameLanguage, GAME_CONSTANTS, playerSettings)
        elseif option.name == "Heal" then
          GameLogic.performPlayerHeal(player, enemy, battleState, animations, resources, GameLogic.positions, GameLogic.skillSystem, GameData, currentGameLanguage, GAME_CONSTANTS)
        end
      end
    elseif key == "escape" then
        GameHelpers.handleBattlePause()
    elseif key == "x" and GameData.story.currentState.isGrinding then
        GameHelpers.exitGrindingMode()
    end
  elseif gameState == "pause" then
      if key == "up" or key == "w" then
        GameLogic.handlePauseInput(pauseState, "up", GameData, currentGameLanguage)
      elseif key == "down" or key == "s" then
        GameLogic.handlePauseInput(pauseState, "down", GameData, currentGameLanguage)
      elseif key == "return" or key == "space" then
        local selectedPauseOption = pauseState.options[pauseState.currentOption]
        print("[PAUSE MENU] Option selected: " .. GameData.getText(currentGameLanguage, selectedPauseOption.textKey))
        selectedPauseOption.action()
      end
  elseif gameState == "defeat" or gameState == "victory" then
    if key == "up" or key == "w" then
      GameLogic.handleResultInput(resultState, "up", GameData, currentGameLanguage)
    elseif key == "down" or key == "s" then
      GameLogic.handleResultInput(resultState, "down", GameData, currentGameLanguage)
    elseif key == "return" or key == "space" then
      local selectedResultOption = resultState.options[resultState.currentOption]
      print("[" .. gameState:upper() .. " MENU] Option selected: " .. GameData.getText(currentGameLanguage, selectedResultOption.textKey))
      selectedResultOption.action()
    end
  elseif gameState == "options" then
    if key == "escape" then
      GameHelpers.transitionGameState(gameState, "menu")
    elseif key == "return" or key == "space" then
      GameLogic.handleOptionsInputReturn(optionsState, GameData, currentGameLanguage, GameHelpers.transitionGameState, GameHelpers.applyResolutionChange)
    end
  elseif gameState == "storyPage" then
    if key == "escape" then
      GameHelpers.transitionGameState(gameState, "menu")
      storyPageState.scrollPosition = 0
      print("[GAME STATE] Game state changed to 'menu' from storyPage")
    end
  elseif gameState == "aboutPage" then
    if key == "escape" then
      GameHelpers.transitionGameState(gameState, "menu")
      aboutPageState.scrollPosition = 0
      print("[GAME STATE] Game state changed to 'menu' from aboutPage")
    end
  elseif gameState == "inventoryScreen" then
        if key == "tab" then
            if inventoryState.currentFocus == "inventory" then
                inventoryState.currentFocus = "equipment"
                inventoryState.selectedEquipmentSlotKey = inventoryState.equipmentSlotOrder[1]
            else
                inventoryState.currentFocus = "inventory"
            end
        elseif inventoryState.currentFocus == "inventory" then
            if key == "up" then
                inventoryState.selectedSlot = inventoryState.selectedSlot - inventoryState.slotCols
            elseif key == "down" then
                inventoryState.selectedSlot = inventoryState.selectedSlot + inventoryState.slotCols
            elseif key == "left" then
                inventoryState.selectedSlot = inventoryState.selectedSlot - 1
            elseif key == "right" then
                inventoryState.selectedSlot = inventoryState.selectedSlot + 1
            elseif key == "return" or key == "space" then
                local itemInSlot = player.inventory[inventoryState.selectedSlot]
                if itemInSlot then
                    local itemData = GameData.items[itemInSlot.itemId]
                    if itemData and itemData.type == "equipment" then
                        GameLogic.equipItem(inventoryState.selectedSlot)
                    elseif itemData and itemData.type == "consumable" then
                        GameLogic.useItem(inventoryState.selectedSlot)
                    end
                end
            end
            -- Clamp selectedSlot for inventory
            if inventoryState.selectedSlot < 1 then
                inventoryState.selectedSlot = inventoryState.selectedSlot + player.inventoryCapacity -- Wrap to bottom
            elseif inventoryState.selectedSlot > player.inventoryCapacity then
                inventoryState.selectedSlot = inventoryState.selectedSlot - player.inventoryCapacity -- Wrap to top
            end

        elseif inventoryState.currentFocus == "equipment" then
            local currentIdx = -1
            for i, slotKey in ipairs(inventoryState.equipmentSlotOrder) do
                if slotKey == inventoryState.selectedEquipmentSlotKey then
                    currentIdx = i
                    break
                end
            end

            if key == "up" or key == "w" then
                if currentIdx > 1 then
                    inventoryState.selectedEquipmentSlotKey = inventoryState.equipmentSlotOrder[currentIdx - 1]
                else -- Wrap to bottom
                    inventoryState.selectedEquipmentSlotKey = inventoryState.equipmentSlotOrder[#inventoryState.equipmentSlotOrder]
                end
            elseif key == "down" or key == "s" then
                if currentIdx < #inventoryState.equipmentSlotOrder and currentIdx ~= -1 then
                    inventoryState.selectedEquipmentSlotKey = inventoryState.equipmentSlotOrder[currentIdx + 1]
                else -- Wrap to top or select first if none selected
                    inventoryState.selectedEquipmentSlotKey = inventoryState.equipmentSlotOrder[1]
                end
            elseif key == "return" or key == "space" then
                if inventoryState.selectedEquipmentSlotKey and player.equipment[inventoryState.selectedEquipmentSlotKey] then
                    GameLogic.unequipItem(inventoryState.selectedEquipmentSlotKey)
                end
            end
        end

        -- Escape key to close inventory (applies to both focus states)
        if key == "escape" or key == "i" then
            if previousGameState then
                GameHelpers.transitionGameState(gameState, previousGameState)
                previousGameState = nil
            else
                GameHelpers.transitionGameState(gameState, "menu")
            end
        end
    elseif gameState == "questLogScreen" then
        if key == "escape" then
            if previousGameState then
                GameHelpers.transitionGameState(gameState, previousGameState)
                previousGameState = nil
            else
                GameHelpers.transitionGameState(gameState, "menu")
            end
        end
    elseif gameState == "statsScreen" then
        if key == "escape" then
            if previousGameState then
                GameHelpers.transitionGameState(gameState, previousGameState)
                previousGameState = nil
            else
                GameHelpers.transitionGameState(gameState, "menu")
            end
        end
    elseif gameState == "howToPlay" then
        if key == "escape" then
            GameHelpers.transitionGameState(gameState, "menu")
            -- Optionally, reset scroll position if any: howToPlayState.scrollPosition = 0
            print("[GAME STATE] Game state changed to 'menu' from howToPlay")
        end
    end

  if key == "i" then -- Hotkey to open/close inventory
    if gameState == "inventoryScreen" then
      -- This is now handled by the escape key logic within inventoryScreen block
    elseif gameState == "battle" or gameState == "menu" or gameState == "questLogScreen" or gameState == "statsScreen" then
      previousGameState = gameState
      GameHelpers.transitionGameState(gameState, "inventoryScreen")
    end
  end

  if key == "j" then
    if gameState == "questLogScreen" then
        if previousGameState then
            GameHelpers.transitionGameState(gameState, previousGameState)
            previousGameState = nil
        else
            GameHelpers.transitionGameState(gameState, "menu")
        end
    elseif gameState == "menu" or gameState == "battle" or gameState == "options" or gameState == "levelSelect" or gameState == "storyPage" or gameState == "aboutPage" or gameState == "inventoryScreen" then
        previousGameState = gameState
        GameHelpers.transitionGameState(gameState, "questLogScreen")
    end
  end

  if key == "c" then
    if gameState == "statsScreen" then
        if previousGameState then
            GameHelpers.transitionGameState(gameState, previousGameState)
            previousGameState = nil
        else
            GameHelpers.transitionGameState(gameState, "menu")
        end
    elseif gameState == "menu" or gameState == "battle" or gameState == "options" or gameState == "levelSelect" or gameState == "storyPage" or gameState == "aboutPage" or gameState == "inventoryScreen" or gameState == "questLogScreen" then
        previousGameState = gameState
        GameHelpers.transitionGameState(gameState, "statsScreen")
    end
  end

  if key == "p" then
    if GameLogic.addItemToInventory("potion_health_1", 1) then
        print("[CHEAT] Added 1 Health Potion to inventory.")
        uiMessage = GameData.getText(currentGameLanguage, "cheat_potion_added")
        uiMessageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
    else
        print("[CHEAT] Failed to add Health Potion (Inventory full?).")
        uiMessage = GameData.getText(currentGameLanguage, "cheat_potion_failed")
        uiMessageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
    end
  end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button ~= 1 then return end
    local handled = false

    if gameState == "menu" then
        if menuState.buttonAreas then
            for i, area in ipairs(menuState.buttonAreas) do
                if GameLogic.isPointInRect(x, y, area) then
                    menuState.currentOption = i
                    local option = menuState.options[i]
                    print("[MENU] Option clicked: " .. GameData.getText(currentGameLanguage, option.textKey))
                    option.action()
                    handled = true
                    break
                end
            end
        end
    elseif gameState == "levelSelect" then
        local totalOptions = menuState.levelSelect.maxLevel + #menuState.levelSelect.grindingLevelIds
        if menuState.levelSelect.buttonAreas then
            for i = 1, totalOptions do
                local buttonRect = menuState.levelSelect.buttonAreas[i]
                if buttonRect and GameLogic.isPointInRect(x, y, buttonRect) then
                    menuState.levelSelect.currentLevel = i

                    if i >= 1 and i <= menuState.levelSelect.maxLevel then
                        GameData.story.currentState.isGrinding = false
                        menuState.levelSelect.selectedGrindingLevelKey = nil
                        print("[LEVEL SELECT] Regular Level " .. i .. " selected by mouse")
                        GameData.startLevelDialogue(i)
                        GameHelpers.transitionGameState(gameState, "story")
                    elseif i > menuState.levelSelect.maxLevel and i <= totalOptions then
                        local grindingIndex = i - menuState.levelSelect.maxLevel
                        local grindingId = menuState.levelSelect.grindingLevelIds[grindingIndex]
                        if grindingId then
                            GameData.story.currentState.isGrinding = true
                            GameData.story.currentState.currentGrindingLevelId = grindingId
                            menuState.levelSelect.selectedGrindingLevelKey = grindingId
                            print("[LEVEL SELECT] Grinding Level " .. grindingId .. " selected by mouse. isGrinding: " .. tostring(GameData.story.currentState.isGrinding))
                            GameHelpers.restartGame()
                            GameHelpers.transitionGameState(gameState, "battle")
                        end
                    end
                    handled = true
                    break
                end
            end
        end

        if menuState.levelSelect.backButtonArea then
          local backButtonRect = menuState.levelSelect.backButtonArea
          if GameLogic.isPointInRect(x, y, backButtonRect) then
            GameHelpers.transitionGameState(gameState, "menu")
            print("[LEVEL SELECT] Back button clicked, returning to main menu")
            handled = true
          end
        end
    elseif gameState == "battle" and not pauseState.isPaused then
        if battleState.buttonAreas then
            for i, area in ipairs(battleState.buttonAreas) do
                if GameLogic.isPointInRect(x, y, area) and battleState.phase == "select" then
                    battleState.currentOption = i
                    local option = battleState.options[i]
                    print("[BATTLE MENU] Option clicked: " .. option.name)
                    if option.name == "Attack" then
                        GameLogic.performPlayerAttack()
                    elseif option.name == "Defend" then
                        GameLogic.performPlayerDefend()
                    elseif option.name == "Special" then
                        GameLogic.performPlayerSpecial()
                    elseif option.name == "Heal" then
                        GameLogic.performPlayerHeal()
                    end
                    handled = true
                    break
                end
            end
        end
        if GameData.story.currentState.isGrinding and battleState.leaveGrindingButtonArea and GameLogic.isPointInRect(x, y, battleState.leaveGrindingButtonArea) then
            GameHelpers.exitGrindingMode()
            handled = true
        end
    elseif gameState == "pause" then
        if pauseState.buttonAreas then
            for i, area in ipairs(pauseState.buttonAreas) do
                if GameLogic.isPointInRect(x, y, area) then
                    pauseState.currentOption = i
                    local option = pauseState.options[i]
                    print("[PAUSE MENU] Option clicked: " .. GameData.getText(currentGameLanguage, option.textKey))
                    option.action()
                    handled = true
                    break
                end
            end
        end
    elseif gameState == "victory" or gameState == "defeat" then
      if resultState.buttonAreas then
        for i, buttonRect in ipairs(resultState.buttonAreas) do
          if GameLogic.isPointInRect(x, y, buttonRect) then
            resultState.currentOption = i
            local option = resultState.options[i]
            print("[" .. gameState:upper() .. " MENU] Option clicked: " .. GameData.getText(currentGameLanguage, option.textKey))
            option.action()
            handled = true
            break
          end
        end
      end
    elseif gameState == "options" then
      if optionsState.buttonAreas then
        for i, buttonRect in ipairs(optionsState.buttonAreas) do
          if GameLogic.isPointInRect(x, y, buttonRect) then
            optionsState.currentOption = i
            local option = optionsState.options[i]
            print("[OPTIONS MENU] Option clicked: " .. GameData.getText(currentGameLanguage, option.textKey))
            if option.type == "toggle" or option.type == "font_size" or option.type == "resolution" then
              GameLogic.handleOptionsInputReturn(optionsState, GameData, currentGameLanguage, GameHelpers.transitionGameState, GameHelpers.applyResolutionChange)
            elseif option.action then
              option.action()
            end
            handled = true
            break
          end
        end
      end
      if optionsState.options[optionsState.currentOption].type == "language" and optionsState.languageButtonAreas then
        for areaType, areaRect in pairs(optionsState.languageButtonAreas) do
          if GameLogic.isPointInRect(x, y, areaRect) then
            if areaType == "left" then
              local currentOption = optionsState.options[optionsState.currentOption]
              currentOption.currentOption = currentOption.currentOption - 1
              if currentOption.currentOption < 1 then
                currentOption.currentOption = #currentOption.languageOptions
              end
              currentGameLanguage = currentOption.languageOptions[currentOption.currentOption]
              GameData.setCurrentLanguage(currentGameLanguage)
              storyPageState.storyText = GameData.getText(currentGameLanguage, "game_full_story")
              aboutPageState.storyText = GameData.getText(currentGameLanguage, "about_project")
              aboutPageState.staffText = GameData.getText(currentGameLanguage, "about_staff")
              print("[OPTIONS MENU] Language changed to: " .. currentGameLanguage .. " (Left Arrow Click)")
            elseif areaType == "right" then
              local currentOption = optionsState.options[optionsState.currentOption]
              currentOption.currentOption = currentOption.currentOption + 1
              if currentOption.currentOption > #currentOption.languageOptions then
                currentOption.currentOption = 1
              end
              currentGameLanguage = currentOption.languageOptions[currentOption.currentOption]
              GameData.setCurrentLanguage(currentGameLanguage)
              storyPageState.storyText = GameData.getText(currentGameLanguage, "game_full_story")
              aboutPageState.storyText = GameData.getText(currentGameLanguage, "about_project")
              aboutPageState.staffText = GameData.getText(currentGameLanguage, "about_staff")
              print("[OPTIONS MENU] Language changed to: " .. currentGameLanguage .. " (Right Arrow Click)")
            end
            handled = true
            break
          end
        end
      end
        if optionsState.options[optionsState.currentOption].type == "resolution" and optionsState.resolutionButtonAreas then
            for areaType, areaRect in pairs(optionsState.resolutionButtonAreas) do
                if GameLogic.isPointInRect(x, y, areaRect) then
                    if areaType == "left" then
                        local currentOption = optionsState.options[optionsState.currentOption].currentOption
                        currentOption = currentOption - 1
                        if currentOption < 1 then
                            currentOption = #availableResolutions
                        end
                        optionsState.options[optionsState.currentOption].currentOption = currentOption
                        currentResolutionIndex = currentOption
                        GameHelpers.applyResolutionChange()
                        print("[OPTIONS MENU] Resolution changed (Left Arrow Click)")
                    elseif areaType == "right" then
                        local currentOption = optionsState.options[optionsState.currentOption].currentOption
                        currentOption = currentOption + 1
                        if currentOption > #availableResolutions then
                            currentOption = 1
                        end
                        optionsState.options[optionsState.currentOption].currentOption = currentOption
                        currentResolutionIndex = currentOption
                        GameHelpers.applyResolutionChange()
                        print("[OPTIONS MENU] Resolution changed (Right Arrow Click)")
                    end
                    handled = true
                    break
                end
            end
        end
        if optionsState.options[optionsState.currentOption].type == "font_size" and optionsState.fontSizeButtonAreas then
            for areaType, areaRect in pairs(optionsState.fontSizeButtonAreas) do
                if GameLogic.isPointInRect(x, y, areaRect) then
                    if areaType == "left" then
                        local currentOption = optionsState.options[optionsState.currentOption]
                        currentOption.currentOption = currentOption.currentOption - 1
                        if currentOption.currentOption < 1 then
                            currentOption.currentOption = #currentOption.fontSizeOptions
                        end
                        GAME_CONSTANTS.currentFontSizeIndex = currentOption.currentOption
                        GameHelpers.applyFontSizeChange()
                        print("[OPTIONS MENU] Font size changed (Left Arrow Click)")
                    elseif areaType == "right" then
                        local currentOption = optionsState.options[optionsState.currentOption]
                        currentOption.currentOption = currentOption.currentOption + 1
                        if currentOption.currentOption > #currentOption.fontSizeOptions then
                            currentOption.currentOption = 1
                        end
                        GAME_CONSTANTS.currentFontSizeIndex = currentOption.currentOption
                        GameHelpers.applyFontSizeChange()
                        print("[OPTIONS MENU] Font size changed (Right Arrow Click)")
                    end
                    handled = true
                    break
                end
            end
        end
      if optionsState.backButtonArea then
        local backButtonRect = optionsState.backButtonArea
        if GameLogic.isPointInRect(x, y, backButtonRect) then
          GameHelpers.transitionGameState(gameState, "menu")
          print("[OPTIONS MENU] Back button clicked")
          handled = true
        end
      end
    elseif gameState == "storyPage" then
        if storyPageState.backButtonArea then
          local backButtonRect = storyPageState.backButtonArea
          if GameLogic.isPointInRect(x, y, backButtonRect) then
            GameHelpers.transitionGameState(gameState, "menu")
            storyPageState.scrollPosition = 0
            print("[STORY PAGE] Back button clicked, returning to main menu")
            handled = true
          end
        end
    elseif gameState == "aboutPage" then
        if aboutPageState.backButtonArea then
          local backButtonRect = aboutPageState.backButtonArea
          if GameLogic.isPointInRect(x, y, backButtonRect) then
            GameHelpers.transitionGameState(gameState, "menu")
            aboutPageState.scrollPosition = 0
            print("[ABOUT PAGE] Back button clicked, returning to main menu")
            handled = true
          end
        end
    elseif gameState == "story" then
      local windowWidth = love.graphics.getWidth()
      local windowHeight = love.graphics.getHeight()
      local bottomMargin = windowHeight * 0.05
      local dialogBoxHeight = windowHeight * 0.2
      local dialogBoxWidth = windowWidth * 0.8
      local dialogBoxX = (windowWidth - dialogBoxWidth) / 2
      local dialogBoxY = windowHeight - dialogBoxHeight - bottomMargin

      if GameLogic.isPointInRect(x, y, {x = dialogBoxX, y = dialogBoxY, width = dialogBoxWidth, height = dialogBoxHeight}) then
        if GameData.isTextComplete() then
            GameLogic.handleStoryInput(0.61, GameData.story.currentState, GameHelpers.transitionGameState, GameHelpers.restartGame)
            print("[STORY] Dialogue box clicked, continuing story")
            handled = true
        end
      end
    elseif gameState == "inventoryScreen" then
        -- Mouse interaction for equipment slots
        if inventoryState.equipmentSlotDisplayAreas then
            for slotKey, area in pairs(inventoryState.equipmentSlotDisplayAreas) do
                if GameLogic.isPointInRect(x, y, area) then
                    if inventoryState.currentFocus == "equipment" and inventoryState.selectedEquipmentSlotKey == slotKey and player.equipment[slotKey] then
                        GameLogic.unequipItem(slotKey)
                    else
                        inventoryState.currentFocus = "equipment"
                        inventoryState.selectedEquipmentSlotKey = slotKey
                    end
                    handled = true
                    break
                end
            end
        end

        -- Mouse interaction for inventory grid (modified for equip on second click)
        if not handled then -- Only if not handled by equipment panel
            for i = 1, player.inventoryCapacity do
                local row = math.floor((i - 1) / inventoryState.slotCols)
                local col = (i - 1) % inventoryState.slotCols
                local itemX = inventoryState.gridStartX + col * (inventoryState.slotWidth + inventoryState.slotPadding)
                local itemY = inventoryState.gridStartY + row * (inventoryState.slotHeight + inventoryState.slotPadding)
                local area = {x = itemX, y = itemY, width = inventoryState.slotWidth, height = inventoryState.slotHeight}

                if GameLogic.isPointInRect(x, y, area) then
                    local itemInSlot = player.inventory[i]
                    if inventoryState.currentFocus == "inventory" and inventoryState.selectedSlot == i and itemInSlot then
                        local itemData = GameData.items[itemInSlot.itemId]
                        if itemData and itemData.type == "equipment" then
                            GameLogic.equipItem(i)
                        elseif itemData and itemData.type == "consumable" then
                            GameLogic.useItem(i)
                        end
                    else
                        inventoryState.currentFocus = "inventory"
                        inventoryState.selectedSlot = i
                    end
                    handled = true
                    break
                end
            end
        end
    elseif gameState == "questLogScreen" then
        -- Tab clicks
        if GameLogic.isPointInRect(x, y, questLogState.tabAreas.active) then
            questLogState.currentTab = "active"
            questLogState.selectedQuestIndex = 1
            questLogState.activeQuestScrollOffset = 0
            local tempActiveQuests = {}
            if player.activeQuests then
                for id, _ in pairs(player.activeQuests) do table.insert(tempActiveQuests, {id=id}) end
            end
            table.sort(tempActiveQuests, function(a,b) return a.id < b.id end)
            questLogState.selectedQuestId = (#tempActiveQuests > 0) and tempActiveQuests[1].id or nil
            handled = true
        elseif GameLogic.isPointInRect(x, y, questLogState.tabAreas.completed) then
            questLogState.currentTab = "completed"
            questLogState.selectedQuestIndex = 1
            questLogState.completedQuestScrollOffset = 0
            local tempCompletedQuests = {}
            if player.completedQuests then
                for id, _ in pairs(player.completedQuests) do table.insert(tempCompletedQuests, {id=id}) end
            end
            table.sort(tempCompletedQuests, function(a,b) return a.id < b.id end)
            questLogState.selectedQuestId = (#tempCompletedQuests > 0) and tempCompletedQuests[1].id or nil
            handled = true
        end

        -- Quest list clicks
        if not handled and GameLogic.isPointInRect(x, y, questLogState.questListArea) then
            local listX = questLogState.questListArea.x
            local listY = questLogState.questListArea.y
            local currentScrollOffset = (questLogState.currentTab == "active") and questLogState.activeQuestScrollOffset or questLogState.completedQuestScrollOffset
            local questsToDisplay = {}
            if questLogState.currentTab == "active" then
                if player.activeQuests then
                    for id, data in pairs(player.activeQuests) do table.insert(questsToDisplay, {id = id, data = data}) end
                end
            else
                if player.completedQuests then
                    for id, _ in pairs(player.completedQuests) do table.insert(questsToDisplay, {id = id, data = GameData.quests[id]}) end
                end
            end
            table.sort(questsToDisplay, function(a,b) return a.id < b.id end)

            for i, questEntry in ipairs(questsToDisplay) do
                local itemY = listY + (i - 1 - currentScrollOffset) * questLogState.lineHeight + questLogState.padding
                local itemArea = {x = listX, y = itemY - questLogState.padding/2, width = questLogState.questListArea.width, height = questLogState.lineHeight}
                if GameLogic.isPointInRect(x, y, itemArea) then
                    questLogState.selectedQuestId = questEntry.id
                    questLogState.selectedQuestIndex = i
                    handled = true
                    break
                end
            end
        end
    elseif gameState == "howToPlay" then
        if howToPlayState.backButtonArea and GameLogic.isPointInRect(x, y, howToPlayState.backButtonArea) then
            GameHelpers.transitionGameState(gameState, "menu")
            -- Optionally, reset scroll position if any: howToPlayState.scrollPosition = 0
            print("[HOW TO PLAY] Back button clicked, returning to main menu")
            handled = true
        end
    end

    if handled and not audioState.isMutedSFX then
        if resources.sounds.menuSelect then
            resources.sounds.menuSelect:play()
        else
            print("[AUDIO] Warning: resources.sounds.menuSelect is missing or not loaded. Please add assets/menu_select.wav")
        end
    end
end

function love.touchpressed(id, x, y)
    love.mousepressed(x, y, 1, true, 1)
end