-- This is a Lua script for a 2D game called "A Hero's Redemption"
-- This script contains the game's story, character definitions, level dialogues,
-- and other game-related text in both English and Chinese.
-- Build with love-12.0-win64 Beta
-- Created by Dundd2, 2025/1 ,Last update: 2025/5

local loadingState = true

-- Loading screen specific resources (declared globally or at least before love.load)
local loadingFont = nil
local creatorLogo = nil
local engineLogo = nil
local gameGroupLogo = nil -- New variable for game group logo

-- Function to draw the loading screen
local function drawLoadingScreen()
    love.graphics.clear(0, 0, 0) -- Black background
    love.graphics.setColor(1, 1, 1) -- White text/images

    -- Fallback if font somehow not loaded (though it should be in love.load)
    if not loadingFont then
        loadingFont = love.graphics.newFont(24)
    end
    love.graphics.setFont(loadingFont)

    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()
    local centerX = windowWidth / 2

    local yOffset = windowHeight * 0.15 -- Starting Y position, adjusted for more space

    -- Creator Info
    local creatorText = "Created by Dundd2"
    love.graphics.printf(creatorText, 0, yOffset, windowWidth, "center")
    yOffset = yOffset + loadingFont:getHeight() + 10
    if creatorLogo then
        local logoWidth = creatorLogo:getWidth()
        local logoHeight = creatorLogo:getHeight()
        local targetHeight = 100
        local scale = targetHeight / logoHeight
        love.graphics.draw(creatorLogo, centerX - (logoWidth * scale) / 2, yOffset, 0, scale, scale)
        yOffset = yOffset + targetHeight + 30
    else
        -- Placeholder if logo not found
        love.graphics.setColor(0.5, 0.5, 0.5) -- Grey placeholder
        love.graphics.rectangle("fill", centerX - 50, yOffset, 100, 100)
        love.graphics.setColor(1,1,1) -- White text on placeholder
        love.graphics.printf("Creator\nLogo", centerX - 50, yOffset + 30, 100, "center")
        yOffset = yOffset + 100 + 30
    end

    -- Game Engine Info
    local engineText = "Built with LÖVE2D"
    love.graphics.printf(engineText, 0, yOffset, windowWidth, "center")
    yOffset = yOffset + loadingFont:getHeight() + 10
    if engineLogo then
        local logoWidth = engineLogo:getWidth()
        local logoHeight = engineLogo:getHeight()
        local targetHeight = 100
        local scale = targetHeight / logoHeight
        love.graphics.draw(engineLogo, centerX - (logoWidth * scale) / 2, yOffset, 0, scale, scale)
        yOffset = yOffset + targetHeight + 30
    else
        -- Placeholder if logo not found
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.rectangle("fill", centerX - 50, yOffset, 100, 100)
        love.graphics.setColor(1,1,1)
        love.graphics.printf("Engine\nLogo", centerX - 50, yOffset + 30, 100, "center")
        yOffset = yOffset + 100 + 30
    end

    -- Game Group Logo (using game title as placeholder for now)
    local gameTitle = "A Hero's Redemption"
    love.graphics.printf(gameTitle, 0, yOffset, windowWidth, "center")
    yOffset = yOffset + loadingFont:getHeight() + 10
    if gameGroupLogo then
        local logoWidth = gameGroupLogo:getWidth()
        local logoHeight = gameGroupLogo:getHeight()
        local targetHeight = 100
        local scale = targetHeight / logoHeight
        love.graphics.draw(gameGroupLogo, centerX - (logoWidth * scale) / 2, yOffset, 0, scale, scale)
        yOffset = yOffset + targetHeight + 30
    else
        -- Placeholder if logo not found
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.rectangle("fill", centerX - 50, yOffset, 100, 100)
        love.graphics.setColor(1,1,1)
        love.graphics.printf("Group\nLogo", centerX - 50, yOffset + 30, 100, "center")
        yOffset = yOffset + 100 + 30
    end

    -- Loading text at the bottom
    love.graphics.printf("Loading...", 0, windowHeight - 50, windowWidth, "center")
end
local GameData = require("game_data") -- Require the new file

-- Global access to GameData's story state (for convenience)
local currentState = GameData.story.currentState
local currentGameLanguage = GameData.getCurrentLanguage() -- Get initial language from GameData

local function initText()
  GameData.initText() -- Call the initText from GameData
  currentGameLanguage = GameData.getCurrentLanguage() -- Sync the local variable
end

local function validateLanguage(lang)
  -- This function is now effectively managed by GameData.getText, no need for a local version.
  -- It's included here just to satisfy any lingering direct calls, but ideally,
  -- all text retrieval should go through GameData.getText.
  return GameData.getText(lang, "dummy_key", nil, lang) -- Use GameData's validation logic indirectly
end

local function getText(language, key, params, defaultValue)
  return GameData.getText(language, key, params, defaultValue)
end

local function setCurrentLanguage(language)
  GameData.setCurrentLanguage(language)
  currentGameLanguage = GameData.getCurrentLanguage() -- Sync local variable
end

-- Function to get the current language for `main.lua`'s use
function getCurrentLanguage()
  return currentGameLanguage
end

-- Functions that are now part of GameData and will be called directly
-- function updateTextEffect(dt) -- Call GameData.updateTextEffect(dt)
-- function setTargetText(text) -- Call GameData.setTargetText(text)
-- function getCurrentText() -- Call GameData.getCurrentText()
-- function isTextComplete() -- Call GameData.isTextComplete()
-- function startLevelDialogue(level) -- Call GameData.startLevelDialogue(level)
-- function startEndingDialogue() -- Call GameData.startEndingDialogue()
-- function getCurrentDialogue() -- Call GameData.getCurrentDialogue(resources, currentGameLanguage)
-- function nextDialogue() -- Call GameData.nextDialogue()
-- function skipDialogue() -- Call GameData.skipDialogue()
-- function getEmotionEffect(emotion) -- Call GameData.getEmotionEffect(emotion)
-- function changeRelationship(character, amount) -- Call GameData.changeRelationship(character, amount)
-- function determineEnding() -- Call GameData.determineEnding()

local function loadResource(loadFunc, resourceType, assetPath, ...)
  local success, resource = pcall(loadFunc, assetPath, ...)
  if success then
    print(string.format("[RESOURCE] Loaded %s: %s", resourceType, assetPath))
    return resource
  else
    print(string.format("[ERROR] Failed to load %s: %s - %s", resourceType, assetPath, resource))
    return nil
  end
end
local function loadImage(assetPath)
  return loadResource(love.graphics.newImage, "image", assetPath)
end
local function loadSound(assetPath, type)
  return loadResource(love.audio.newSource, "sound", assetPath, type)
end
local function loadFont(assetPath, size)
  return loadResource(love.graphics.newFont, "font", assetPath, size)
end
local audioState = {
  isMutedBGM = false,
  isMutedSFX = false
}
playerSettings = {
    isCheatMode = false,
    isInfiniteHP = false,
    fontScale = 1.0, -- This is technically derived from GAME_CONSTANTS.currentFontSizeIndex
    isFullScreen = false,
}
screenWidth = 1880
screenHeight = 720
local availableResolutions = {
    {width = 1920, height = 1080, name = "1920x1080 (Full HD)"},
    {width = 1280, height = 720, name = "1280x720 (HD)"},
    {width = 854, height = 480, name = "854x480 (SD)"},
    {width = 640, height = 360, name = "640x360 (Low)"}
}
local currentResolutionIndex = 1
-- local currentGameLanguage = "en" -- Already defined from GameData
storyPageState = {
  storyText = "",
  scrollPosition = 0,
  backButtonArea = {},
  navDelay = 0.3,
}
aboutPageState = {
    scrollPosition = 0,
    backButtonArea = {},
}
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
    currentFontSizeIndex = 2, -- Default to 1.0X
    TIMER = {
        ACTION_DELAY = 2.0,
        EFFECT_DURATION = 0.5,
        MESSAGE_DURATION = 2.0
    }
}
function validateNumber(value, min, max, default)
    if type(value) ~= "number" or value ~= value then -- value ~= value checks for NaN
        return default
    end
    return math.max(min, math.min(max, value))
end
local VALID_GAME_STATES = {
    menu = true,
    battle = true,
    story = true,
    pause = true,
    victory = true,
    defeat = true,
    options = true,
    storyPage = true,
    levelSelect = true,
    aboutPage = true,
}
local VALID_BATTLE_PHASES = {
    select = true,
    action = true,
    result = true
}
local function validateGameState(state)
    if not VALID_GAME_STATES[state] then
        print("[ERROR] Invalid game state: " .. tostring(state))
        return "menu"
    end
    return state
end
local function validateBattlePhase(phase)
    if not VALID_BATTLE_PHASES[phase] then
        print("[ERROR] Invalid battle phase: " .. tostring(phase))
        return "select"
    end
    return phase
end
function transitionGameState(from, to)
    local validatedFrom = validateGameState(from or "menu")
    local validatedTo = validateGameState(to)
    if validatedFrom == validatedTo and from ~= nil then
        if validatedFrom == "options" and to == "options" then
            -- Allow options to options transition for things like language/font changes
            -- Screen mode changes are handled by applyResolutionChange() directly
        else
            return false
        end
    end
    if not audioState.isMutedBGM then
        if resources.sounds.menuBgm and resources.sounds.menuBgm:isPlaying() then
            resources.sounds.menuBgm:stop()
            print("[AUDIO] Stopped Menu BGM.")
        end
        if resources.sounds.battleBgm and resources.sounds.battleBgm:isPlaying() then
            resources.sounds.battleBgm:stop()
            print("[AUDIO] Stopped Battle BGM.")
        end
        if resources.sounds.victory and resources.sounds.victory:isPlaying() then
            resources.sounds.victory:stop()
            print("[AUDIO] Stopped Victory Music.")
        end
        if resources.sounds.defeat and resources.sounds.defeat:isPlaying() then
            resources.sounds.defeat:stop()
            print("[AUDIO] Stopped Defeat Music.")
        end
        if GameData.story.levelIntros[currentState.currentLevel] and GameData.story.levelIntros[currentState.currentLevel].music and resources.sounds[GameData.story.levelIntros[currentState.currentLevel].music] and resources.sounds[GameData.story.levelIntros[currentState.currentLevel].music]:isPlaying() then
            resources.sounds[GameData.story.levelIntros[currentState.currentLevel].music]:stop()
            print("[AUDIO] Stopped Level Specific BGM.")
        end
        -- Special handling for ending music, as determineEnding might be called too early
        -- during a save/load.
        local endingType = GameData.determineEnding() -- This gets the type, not the music directly
        if validatedFrom == "ending" then -- Only stop ending music if *leaving* the ending state
            if GameData.story.ending[endingType] and GameData.story.ending[endingType].music and resources.sounds[GameData.story.ending[endingType].music] and resources.sounds[GameData.story.ending[endingType].music]:isPlaying() then
                resources.sounds[GameData.story.ending[endingType].music]:stop()
                print("[AUDIO] Stopped Ending BGM.")
            end
        end

        if validatedTo == "menu" or validatedTo == "options" or validatedTo == "levelSelect" or validatedTo == "storyPage" or validatedTo == "aboutPage" then
            if resources.sounds.menuBgm then
                resources.sounds.menuBgm:setLooping(true)
                resources.sounds.menuBgm:play()
                print("[AUDIO] Started Menu BGM.")
            end
        elseif validatedTo == "battle" then
            if resources.sounds.battleBgm then
                resources.sounds.battleBgm:setLooping(true)
                resources.sounds.battleBgm:play()
                print("[AUDIO] Started Battle BGM.")
            end
        elseif validatedTo == "victory" then
            if resources.sounds.victory then
                resources.sounds.victory:setLooping(false)
                resources.sounds.victory:play()
                print("[AUDIO] Started Victory Music.")
            end
        elseif validatedTo == "defeat" then
            if resources.sounds.defeat then
                resources.sounds.defeat:setLooping(false)
                resources.sounds.defeat:play()
                print("[AUDIO] Started Defeat Music.")
            end
        elseif validatedTo == "story" then
            local currentLevelIntro = GameData.story.levelIntros[currentState.currentLevel]
            if currentLevelIntro and currentLevelIntro.music and resources.sounds[currentLevelIntro.music] then
                resources.sounds[currentLevelIntro.music]:setLooping(true)
                resources.sounds[currentLevelIntro.music]:play()
                print("[AUDIO] Started Story BGM: " .. currentLevelIntro.music)
            else
                if resources.sounds.battleBgm then
                    resources.sounds.battleBgm:setLooping(true)
                    resources.sounds.battleBgm:play()
                    print("[AUDIO] Started Battle BGM (fallback for story).")
                end
            end
        elseif validatedTo == "ending" then
            local determinedEndingType = GameData.determineEnding() -- Recalculate ending type
            local currentEnding = GameData.story.ending[determinedEndingType]
            if currentEnding and currentEnding.music and resources.sounds[currentEnding.music] then
                resources.sounds[currentEnding.music]:setLooping(false)
                resources.sounds[currentEnding.music]:play()
                print("[AUDIO] Started Ending BGM: " .. currentEnding.music)
            else
                if resources.sounds.menuBgm then
                    resources.sounds.menuBgm:setLooping(true)
                    resources.sounds.menuBgm:play()
                    print("[AUDIO] Started Menu BGM (fallback for ending).")
                end
            end
        elseif validatedTo == "pause" then
        end
    else
        love.audio.stop()
        print("[AUDIO] BGM is muted, all audio stopped.")
    end
    if validatedTo == "battle" then
        battleState.phase = validateBattlePhase("select")
        battleState.turn = "player"
        battleState.message = getText(currentGameLanguage, "battle_start")
        battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
    elseif validatedFrom == "battle" then
    end
    gameState = validatedTo
    print(string.format("[GAME STATE] Transitioned from '%s' to '%s'", validatedFrom, validatedTo))
    return true
end
local function initFonts()
    local scale = GAME_CONSTANTS.FONT_SIZE_OPTIONS[GAME_CONSTANTS.currentFontSizeIndex] or 1.0
    resources.fonts.ui = loadFont("assets/ui-font.ttf", math.floor(GAME_CONSTANTS.FONT_SIZES.UI * scale))
    resources.fonts.battle = loadFont("assets/battle-font.ttf", math.floor(GAME_CONSTANTS.FONT_SIZES.BATTLE * scale))
    resources.fonts.damage = loadFont("assets/damage-font.ttf", math.floor(GAME_CONSTANTS.FONT_SIZES.DAMAGE * scale))
    resources.fonts.chineseUI = loadFont("assets/chinese-font.ttf", math.floor(GAME_CONSTANTS.FONT_SIZES.UI_CHINESE * scale))
    resources.fonts.chineseBattle = loadFont("assets/chinese-font.ttf", math.floor(GAME_CONSTANTS.FONT_SIZES.BATTLE_CHINESE * scale))
    print(string.format("[GAME] Fonts initialized with scale: %.1f", scale))
end
function applyFontSizeChange()
    initFonts()
end
function love.load()
  print("[GAME] love.load() - Game loading started")
  screenWidth = availableResolutions[currentResolutionIndex].width
  screenHeight = availableResolutions[currentResolutionIndex].height
  love.window.setMode(screenWidth, screenHeight, {resizable = false, vsync = true, fullscreen = playerSettings.isFullScreen})
  print("[GAME] Set window mode to " .. screenWidth .. "x" .. screenHeight)

  -- Load loading screen specific assets
  -- Ensure ui-font.ttf exists in assets, otherwise this will error.
  -- If it might not exist, add a pcall or fallback to love.graphics.newFont()
  loadingFont = loadFont("assets/ui-font.ttf", 24) -- Use loadFont helper
  creatorLogo = loadImage("assets/author_portrait.png")
  engineLogo = loadImage("assets/love2d_logo.png") -- Assuming this asset exists
  gameGroupLogo = loadImage("assets/game_group_logo.png") -- Assuming this asset exists

  -- Draw initial loading screen
  drawLoadingScreen()
  love.graphics.present() -- Force draw the loading screen
  love.timer.sleep(0.5) -- Optional: small delay to ensure it's seen

  camera = {
      x = 0,
      y = 0,
      scale = 1
  }
timers = {}
print("[GAME] Timer system initialized")
resources = {
  images = {
    background = loadImage("assets/background.png"),
    dialogBox = loadImage("assets/dialog-box.png"),
    uiFrame = loadImage("assets/battle-ui-frame.png"),
    playerStand = loadImage("assets/player-stand.png"),
    playerAttack = loadImage("assets/player-attack.png"),
    battleBgForest = loadImage("assets/battle-bg-forest.png"),
    battleBgCave = loadImage("assets/battle-bg-cave.png"),
    battleBgDungeon = loadImage("assets/battle-bg-dungeon.png"),
    battleBgCastle = loadImage("assets/battle-bg-castle.png"),
    hitEffect = loadImage("assets/effect-hit.png"),
    defendEffect = loadImage("assets/effect-defend.png"),
    skillDefend = loadImage("assets/skill-defend.png"),
    skillSpecial = loadImage("assets/skill-special.png"),
    skillHeal = loadImage("assets/skill-heal.png"),
    skillAttack = loadImage("assets/skill-attack.png"),
    cooldownOverlay = loadImage("assets/cooldown-overlay.png"),
    portraitHero = loadImage("assets/portrait-hero.png"),
    portraitKing = loadImage("assets/portrait-king.png"),
    portraitPrincess = loadImage("assets/portrait-princess.png"),
    portraitDemonKing = loadImage("assets/portrait-demonking.png"),
    enemyDemonKing = loadImage("assets/enemy-demonking.png"),
    enemy_level1_stand = loadImage("assets/enemy_level1_stand.png"),
    enemy_level1_attack = loadImage("assets/enemy_level1_attack.png"),
    enemy_level2_stand = loadImage("assets/enemy_level2_stand.png"),
    enemy_level2_attack = loadImage("assets/enemy_level2_attack.png"),
    enemy_level3_stand = loadImage("assets/enemy_level3_stand.png"),
    enemy_level3_attack = loadImage("assets/enemy_level3_attack.png"),
    enemy_level4_stand = loadImage("assets/enemy_level4_stand.png"),
    enemy_level4_attack = loadImage("assets/enemy_level4_attack.png"),
    enemy_level5_stand = loadImage("assets/enemy_level5_stand.png"),
    enemy_level5_attack = loadImage("assets/enemy_level5_attack.png"),
    enemy_level6_stand = loadImage("assets/enemy_level6_stand.png"),
    enemy_level6_attack = loadImage("assets/enemy_level6_attack.png"),
    enemy_level7_stand = loadImage("assets/enemy_level7_stand.png"),
    enemy_level7_attack = loadImage("assets/enemy_level7_attack.png"),
    enemy_level8_stand = loadImage("assets/enemy_level8_stand.png"),
    enemy_level8_attack = loadImage("assets/enemy_level8_attack.png"),
    enemy_level9_stand = loadImage("assets/enemy_level9_stand.png"),
    enemy_level9_attack = loadImage("assets/enemy_level9_attack.png"),
    enemy_level10_stand = loadImage("assets/enemy_level10_stand.png"),
    enemy_level10_attack = loadImage("assets/enemy_level10_attack.png"),
    authorPortrait = loadImage("assets/author_portrait.png")
  },
     sounds = {
         crit = loadSound("assets/crit.mp3", "static"),
         attack = loadSound("assets/attack.mp3", "static"),
         heal = loadSound("assets/heal.mp3", "static"),
         special = loadSound("assets/special.mp3", "static"),
         defend = loadSound("assets/defend.mp3", "static"),
         victory = loadSound("assets/victory.mp3", "static"),
         defeat = loadSound("assets/defeat.mp3", "static"),
         menuBgm = loadSound("assets/menu.mp3", "stream"),
         battleBgm = loadSound("assets/battle.mp3", "stream"),
         attackLight = loadSound("assets/attack-light.mp3", "static"),
         attackHeavy = loadSound("assets/attack-heavy.mp3", "static"),
         enemyHit1 = loadSound("assets/enemy-hit1.mp3", "static"),
         enemyHit2 = loadSound("assets/enemy-hit2.mp3", "static"),
         palaceTheme = loadSound("assets/palaceTheme.mp3", "stream"),
         finalBattle = loadSound("assets/finalBattle.mp3", "stream"),
         menuSelect = loadSound("assets/menu_select.wav", "static"),
      },
  fonts = {}
}
print("[GAME] Resources loaded")
initFonts() -- Calls the local initFonts which then calls GameData.initText implicitly via its initial setup
enemyData = {
  [1] = {
    image = "enemy_level1_stand",
    attackImage = "enemy_level1_attack",
    hp = 20, -- Lower for grinding
    maxHp = 20,
    attack = 5,
    defense = 2,
    critRate = 4,
    critDamage = 1.2,
    ai = "basic",
    expReward = 25, -- NEW
    displayNameKey = "enemy_name_goblin" -- FIXED PATH
  },
  [2] = {
    image = "enemy_level2_stand",
    attackImage = "enemy_level2_attack",
    hp = 30,
    maxHp = 30,
    attack = 6,
    defense = 3,
    critRate = 4,
    critDamage = 1.2,
    ai = "basic",
    expReward = 35,
    displayNameKey = "enemy_name_orc"
  },
  [3] = {
    image = "enemy_level3_stand",
    attackImage = "enemy_level3_attack",
    hp = 40,
    maxHp = 40,
    attack = 7,
    defense = 4,
    critRate = 5,
    critDamage = 1.25,
    ai = "basic",
    expReward = 50,
    displayNameKey = "enemy_name_stonegolem"
  },
  [4] = {
    image = "enemy_level4_stand",
    attackImage = "enemy_level4_attack",
    hp = 50,
    maxHp = 50,
    attack = 8,
    defense = 5,
    critRate = 5,
    critDamage = 1.25,
    ai = "basic",
    expReward = 60,
    displayNameKey = "enemy_name_skeletonwarrior"
  },
  [5] = {
    image = "enemy_level5_stand",
    attackImage = "enemy_level5_attack",
    hp = 70,
    maxHp = 70,
    attack = 9,
    defense = 6,
    critRate = 6,
    critDamage = 1.3,
    ai = "basic",
    expReward = 80,
    displayNameKey = "enemy_name_darkknight"
  },
  [6] = {
    image = "enemy_level6_stand",
    attackImage = "enemy_level6_attack",
    hp = 90,
    maxHp = 90,
    attack = 10,
    defense = 7,
    critRate = 6,
    critDamage = 1.3,
    ai = "basic",
    expReward = 100,
    displayNameKey = "enemy_name_banshee"
  },
  [7] = {
    image = "enemy_level7_stand",
    attackImage = "enemy_level7_attack",
    hp = 110,
    maxHp = 110,
    attack = 11,
    defense = 8,
    critRate = 7,
    critDamage = 1.35,
    ai = "basic",
    expReward = 120,
    displayNameKey = "enemy_name_minotaur"
  },
  [8] = {
    image = "enemy_level8_stand",
    attackImage = "enemy_level8_attack",
    hp = 130,
    maxHp = 130,
    attack = 12,
    defense = 9,
    critRate = 7,
    critDamage = 1.35,
    ai = "basic",
    expReward = 140,
    displayNameKey = "enemy_name_greendragon"
  },
  [9] = {
    image = "enemy_level9_stand",
    attackImage = "enemy_level9_attack",
    hp = 150,
    maxHp = 150,
    attack = 13,
    defense = 10,
    critRate = 8,
    critDamage = 1.4,
    ai = "basic",
    expReward = 160,
    displayNameKey = "enemy_name_reddragon"
  },
  [10] = {
    image = "enemy_level10_stand",
    attackImage = "enemy_level10_attack",
    hp = 200, -- Increased for boss
    maxHp = 200,
    attack = 20,
    defense = 12,
    critRate = 15,
    critDamage = 1.75,
    ai = "tactical",
    expReward = 500, -- High reward for boss
    displayNameKey = "enemy_name_demonking"
  }
}
print("[GAME] Enemy data loaded")
battleBackgrounds = {
  [1] = "battleBgForest",
  [2] = "battleBgForest",
  [3] = "battleBgCave",
  [4] = "battleBgCave",
  [5] = "battleBgDungeon",
  [6] = "battleBgDungeon",
  [7] = "battleBgCastle",
  [8] = "battleBgCastle",
  [9] = "battleBgCastle",
  [10] = "battleBgCastle"
}
print("[GAME] Battle backgrounds loaded")
enemyAI = {
  basic = {
    decideAction = function(enemy, player)
      return math.random() < 0.7 and "attack" or "defend"
    end
  },
  aggressive = {
    decideAction = function(enemy, player)
      return math.random() < 0.9 and "attack" or "defend"
    end
  },
  tactical = {
    decideAction = function(enemy, player)
      if enemy.hp < enemy.maxHp * 0.3 then
        return "defend"
      elseif player.hp < player.maxHp * 0.5 then
        return "attack"
      else
        return math.random() < 0.6 and "attack" or "defend"
      end
    end
  }
}
print("[GAME] Enemy AI patterns loaded")
  screenWidth = love.graphics.getWidth()
  screenHeight = love.graphics.getHeight()
positions = {
  player = {
    x = screenWidth * 0.25, -- Adjusted X
    y = screenHeight * 0.5,
    scale = 1.0, -- Start with 1.0, let character drawing handle fitting
    maxWidth = screenWidth * 0.4,
    maxHeight = screenHeight * 0.6, -- Added max height for character image
    minHeight = screenHeight * 0.2, -- Added min height for character image
  },
  enemy = {
    x = screenWidth * 0.75, -- Adjusted X
    y = screenHeight * 0.5,
    scale = 1.0, -- Start with 1.0, let character drawing handle fitting
    maxWidth = screenWidth * 0.4,
    maxHeight = screenHeight * 0.6,
    minHeight = screenHeight * 0.2,
  },
  playerHP = {x = screenWidth * 0.02, y = screenHeight * 0.02}, -- Relative to screen top-left
  enemyHP = {x = screenWidth * 0.78, y = screenHeight * 0.02}, -- Relative to screen top-right (will be adjusted for width)
  playerUI = {x = screenWidth * 0.02, y = screenHeight * 0.75}, -- UI elements on bottom left
  enemyUI = {x = screenWidth * 0.68, y = screenHeight * 0.75}  -- UI elements on bottom right (if any)
}
print("[GAME] Battle positions defined")
animations = {
  player = {
    current = "stand",
    timer = 0,
    x = positions.player.x,
    y = positions.player.y,
    originalX = positions.player.x
  },
  enemy = {
    current = "stand",
    timer = 0,
    x = positions.enemy.x,
    y = positions.enemy.y,
    originalX = positions.enemy.x
  },
  effects = {}
}
print("[GAME] Animation states initialized")
player = {
  x = 100,
  y = 300,
  speed = 200,
  image = resources.images.playerStand,
  hp = 100,
  maxHp = 100,
  mp = 50, -- NEW
  maxMp = 50, -- NEW
  level = 1, -- NEW
  exp = 0, -- NEW
  expToNextLevel = 100, -- NEW
  attack = 10,
    critRate = 10,
    critDamage = 1.5,
  defense = 5,
  isDefending = false,
  status = {},
  combo = 0,
}
print("[GAME] Player settings initialized (with EXP/MP)")
enemy = {
  x = 600,
  y = 300,
  image = nil,
  hp = 80,
  maxHp = 80,
  attack = 8,
   critRate = 5,
    critDamage = 1.2,
  defense = 3,
  isDefending = false,
  status = {},
  combo = 0
}
print("[GAME] Default enemy settings initialized")
battleState = {
  phase = "select",
  turn = "player",
  message = GameData.getText(currentGameLanguage, "battle_start"),
  messageTimer = 2,
  options = {
    {name = "Attack", description = "Deal damage to enemy"},
    {name = "Defend", description = "Reduce incoming damage"},
    {name = "Special", description = "Powerful attack with delay"},
      {name = "Heal", description = "Restore health"},
  },
  currentOption = 1,
  buttonAreas = {},
  effects = {}
}
print("[GAME] Battle state initialized")
  uiState = {
      showSkillInfo = false,
      selectedSkill = 1,
  }
  pauseState = {
      isPaused = false,
      options = {
        {
          textKey = "pause_continue",
          action = function() resumeBattle() end
        },
        {textKey = "pause_restart", action = function() restartGame() end},
        {textKey = "pause_main_menu", action = function() transitionGameState(gameState, "menu") end},
        {textKey = "pause_quit_game", action = function() love.event.quit() end}
    },
    currentOption = 1,
    buttonAreas = {},
    navDelay = 0.3,
  }
  -- Initialize resultState here for Victory/Defeat screens
  resultState = {
    options = {
      {textKey = "result_restart", action = function() restartGame() end},
      {textKey = "result_main_menu", action = function() transitionGameState(gameState, "menu") end}
    },
    currentOption = 1,
    buttonAreas = {}
  }
  print("[GAME] Result state initialized")

   gameState = "menu"
    local hitParticleSystemTemplate = function()
      local ps = love.graphics.newParticleSystem(resources.images.hitEffect, 100)
      ps:setParticleLifetime(0.2, 0.5)
      ps:setSpeed(100, 200)
      ps:setDirection(0, 360)
      ps:setSpread(math.pi / 4)
      ps:setEmissionRate(50)
      ps:setSizes(0.3, 0.1)
      ps:setRotation(0, 360)
      ps:setLinearAcceleration(-50, 50, -50, 50)
      return ps
    end
    local defendParticleSystemTemplate = function()
      local ps = love.graphics.newParticleSystem(resources.images.defendEffect, 100)
      ps:setParticleLifetime(0.2, 0.5)
      ps:setSpeed(50, 100)
      ps:setDirection(0, 360)
      ps:setSpread(math.pi / 4)
      ps:setEmissionRate(50)
      ps:setSizes(0.3, 0.1)
      ps:setRotation(0, 360)
      ps:setLinearAcceleration(-20, 20, -20, 20)
      return ps
    end
    resources.particleSystems = {
      hit = hitParticleSystemTemplate,
      defend = defendParticleSystemTemplate,
      heal = defendParticleSystemTemplate,
    }
 print("[GAME] Particle systems initialized")
  skillInfo = {
      {
          name = "Basic Attack",
          description = "A basic attack skill.",
          details = "Deal small physical damage to enemy.",
          type = "offensive",
          icon = "skillAttack",
          key = "attack",
          mpCost = 0 -- NEW
      },
      {
          name = "Defend",
          description = "Enter defensive stance.",
          details = "Increase defense to reduce incoming damage.",
          type = "defensive",
          icon = "skillDefend",
          key = "defend",
          mpCost = 0 -- NEW
      },
      {
          name = "Special Attack",
          description = "Powerful special attack with high damage.",
          details = "Deal large physical damage but requires preparation.",
          type = "offensive",
          icon = "skillSpecial",
          key = "special",
          mpCost = 20 -- NEW
      },
      {
          name = "Heal",
          description = "Restore HP.",
          details = "Heal yourself based on character attributes.",
          type = "support",
          icon = "skillHeal",
          key = "heal",
          mpCost = 15 -- NEW
      }
  }
  print("[GAME] Skill info loaded")
  menuState = {
    options = {
      {textKey = "menu_select_level", action = function() transitionGameState(gameState, "levelSelect") end, descriptionKey = "menu_select_level_desc"},
      {textKey = "menu_options", action = function() transitionGameState(gameState, "options") end, descriptionKey = "menu_options_desc"},
      {textKey = "menu_story_page", action = function() transitionGameState(gameState, "storyPage") end, descriptionKey = "menu_story_page_desc"},
      {textKey = "menu_about", action = function() transitionGameState(gameState, "aboutPage") end, descriptionKey = "menu_about_desc"},
      {textKey = "menu_save_game", action = function() saveGame() end, descriptionKey = "menu_save_game_desc"}, -- NEW
      {textKey = "menu_load_game", action = function() loadGame() end, descriptionKey = "menu_load_game_desc"}, -- NEW
      {textKey = "menu_exit", action = function() love.event.quit() end, descriptionKey = "menu_exit_desc"}
    },
    currentOption = 1,
    navTimer = 0,
    navDelay = 0.6,
    buttonAreas = {},
    levelSelect = {
        currentLevel = 1,
        maxLevel = 10,
        navTimer = 0,
        navDelay = 0.6,
        buttonAreas = {},
        backButtonArea = {}
    }
  }
  print("[GAME] Menu state initialized")
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
      {textKey = "options_back_to_menu", action = function() transitionGameState(gameState, "menu") end},
    },
    currentOption = 1,
    navTimer = 0,
    navDelay = 0.6,
    buttonAreas = {},
    backButtonArea = {},
    languageButtonAreas = {} ,
    resolutionButtonAreas = {},
    fontSizeButtonAreas = {}
  }
  print("[GAME] Options state initialized")
    storyPageState.storyText = GameData.getText(currentGameLanguage, "game_full_story")
    aboutPageState.storyText = GameData.getText(currentGameLanguage, "about_project")
    aboutPageState.staffText = GameData.getText(currentGameLanguage, "about_staff")
  resources.images.palace = resources.images.background
  resources.images.forest = resources.images.background
  resources.images.demonCastle = resources.images.background
  resources.images.ruins = resources.images.background
  local backgrounds = {'palace', 'forest', 'demonCastle', 'ruins'}
  for _, bg in ipairs(backgrounds) do
      local image = loadImage('assets/' .. bg .. '.png')
      if image then
          resources.images[bg] = image
          print("[RESOURCE] Loaded background image: assets/" .. bg .. '.png')
      end
  end
  print("[GAME] Background images loaded")
  print("[GAME] love.load() - Game loading complete")
  local criticalResources = {
    resources.images.background,
    resources.images.dialogBox,
    resources.images.uiFrame,
    resources.images.playerStand,
    resources.images.playerAttack,
    resources.images.battleBgForest,
    resources.images.battleBgCave,
    resources.images.battleBgDungeon,
    resources.images.battleBgCastle,
    resources.images.hitEffect,
    resources.images.defendEffect,
    resources.images.skillDefend,
    resources.images.skillSpecial,
    resources.images.skillHeal,
    resources.images.skillAttack,
    resources.images.cooldownOverlay,
    resources.images.portraitHero,
    resources.images.portraitKing,
    resources.images.portraitPrincess,
    resources.images.portraitDemonKing,
    resources.images.enemyDemonKing,
    resources.fonts.ui,
    resources.fonts.battle,
    resources.fonts.damage,
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
  loadingState = false -- Set loading state to false after all loading is done
  transitionGameState(nil, "menu")
end
TimerSystem = {
    timers = {},
    nextId = 1
}

local TIMER_STATE = {
    ACTIVE = "active",
    PAUSED = "paused",
    CANCELLED = "cancelled"
}
TIMER_GROUPS = {
    BATTLE = "battle",
    ANIMATION = "animation",
    UI = "ui",
    GLOBAL = "global"
}

function TimerSystem.create(duration, callback, group)
    local id = TimerSystem.nextId
    TimerSystem.nextId = TimerSystem.nextId + 1
    TimerSystem.timers[id] = {
        duration = duration,
        remaining = duration,
        callback = callback,
        state = TIMER_STATE.ACTIVE,
        group = group or TIMER_GROUPS.GLOBAL
    }
    return id
end
function TimerSystem.cancel(id)
    local timer = TimerSystem.timers[id]
    if timer then
        timer.state = TIMER_STATE.CANCELLED
    end
end
function TimerSystem.pause(id)
    local timer = TimerSystem.timers[id]
    if timer and timer.state == TIMER_STATE.ACTIVE then
        timer.state = TIMER_STATE.PAUSED
    end
end
function TimerSystem.resume(id)
    local timer = TimerSystem.timers[id]
    if timer and timer.state == TIMER_STATE.PAUSED then
        timer.state = TIMER_STATE.ACTIVE
    end
end
function TimerSystem.pauseGroup(group)
    for id, timer in pairs(TimerSystem.timers) do
        if timer.group == group and timer.state == TIMER_STATE.ACTIVE then
            timer.state = TIMER_STATE.PAUSED
        end
    end
end
function TimerSystem.resumeGroup(group)
    for id, timer in pairs(TimerSystem.timers) do
        if timer.group == group and timer.state == TIMER_STATE.PAUSED then
            timer.state = TIMER_STATE.ACTIVE
        end
    end
end
function TimerSystem.update(dt)
    for id, timer in pairs(TimerSystem.timers) do
        if timer.state == TIMER_STATE.ACTIVE then
            timer.remaining = timer.remaining - dt
            if timer.remaining <= 0 then
                if timer.callback then
                    timer.callback()
                end
                TimerSystem.timers[id] = nil
            end
        end
    end
end
function addTimer(duration, callback, group)
    return TimerSystem.create(duration, callback, group)
end
function updateTimers(dt)
    TimerSystem.update(dt)
end
function startEnemyTurn()
    local timerId = addTimer(GAME_CONSTANTS.TIMER.ACTION_DELAY, function()
        if gameState == "battle" then
            battleState.phase = "select"
            battleState.turn = "player"
        end
    end, TIMER_GROUPS.BATTLE)
    battleState.currentTimerId = timerId
end
function handleBattlePause()
    if not pauseState.isPaused then
        pauseState.isPaused = true
        transitionGameState(gameState, "pause")
        TimerSystem.pauseGroup(TIMER_GROUPS.BATTLE)
        if not audioState.isMutedBGM then
            love.audio.stop()
            print("[AUDIO] Game paused, all audio stopped.")
        end
    end
end
function resumeBattle()
    if pauseState.isPaused then
        pauseState.isPaused = false
        transitionGameState(gameState, "battle")
        TimerSystem.resumeGroup(TIMER_GROUPS.BATTLE)
    end
end
function love.update(dt)
    updateTimers(dt)
    if gameState == "menu" then
        handleMenuInput(dt)
    elseif gameState == "levelSelect" then
        handleLevelSelectInput(dt)
    elseif gameState == "story" then
        GameData.updateTextEffect(dt)
        handleStoryInput(dt)
    elseif gameState == "battle" then
        updateAnimations(dt)
        updateEffects(dt)
        if battleState.messageTimer > 0 then
            battleState.messageTimer = battleState.messageTimer - dt
        end
        if enemy.hp <= 0 then -- Victory condition check
            local currentEnemyData = enemyData[menuState.levelSelect.currentLevel]
            if currentEnemyData and currentEnemyData.expReward then
                grantExp(currentEnemyData.expReward) -- NEW: Grant EXP on victory
            end
            battleState.phase = "result"
            TimerSystem.create(GAME_CONSTANTS.TIMER.ACTION_DELAY + (battleState.messageTimer > 0 and battleState.messageTimer or 0), function() -- Wait for message to clear
                transitionGameState(gameState, "victory")
            end, TIMER_GROUPS.BATTLE)
        elseif player.hp <= 0 then -- Defeat condition check
            battleState.phase = "result"
            TimerSystem.create(GAME_CONSTANTS.TIMER.ACTION_DELAY + (battleState.messageTimer > 0 and battleState.messageTimer or 0), function() -- Wait for message to clear
                transitionGameState(gameState, "defeat")
            end, TIMER_GROUPS.BATTLE)
        end
    elseif gameState == "pause" then
    elseif gameState == "ending" then
    elseif gameState == "options" then
        handleOptionsInput(dt)
    elseif gameState == "storyPage" then
        handleStoryPageInput(dt)
    elseif gameState == "aboutPage" then
        handleAboutPageInput(dt)
    end
end
function love.draw()
  if loadingState then
    drawLoadingScreen()
    return -- Stop drawing the rest of the game
  end
  love.graphics.push()
  love.graphics.scale(camera.scale, camera.scale)
  love.graphics.translate(-camera.x, -camera.y)
  if gameState == "menu" then
    drawMainMenu()
  elseif gameState == "levelSelect" then
    drawLevelSelect()
  elseif gameState == "story" then
    drawStoryDialogue()
  elseif gameState == "battle" then
    drawBattleScene()
    drawCharacters()
    drawBattleUI()
    drawEffects()
    drawBattleMessage()
    if uiState.showSkillInfo then
      drawSkillInfoUI()
    end
  elseif gameState == "pause" then
    drawBattleScene()
    drawCharacters()
    drawBattleUI()

    drawPauseUI()
  elseif gameState == "victory" then
    drawVictoryUI()
  elseif gameState == "defeat" then
    drawDefeatUI()
  elseif gameState == "options" then
    drawOptionsUI()
  elseif gameState == "storyPage" then
    drawStoryPageUI()
  elseif gameState == "aboutPage" then
    drawAboutPageUI()
  end
  love.graphics.pop()
end
local uiLayoutConfig = {
  mainMenu = {
    titleOffsetY = 0.2,
    buttonWidth = 200,
    buttonHeight = 40,
    buttonSpacing = 50,
    buttonOffsetY = 0.4
  },
}
function drawMainMenu()
  local windowWidth = love.graphics.getWidth()
  local windowHeight = love.graphics.getHeight()
  love.graphics.draw(resources.images.background, 0, 0, 0,
    windowWidth/resources.images.background:getWidth(),
    windowHeight/resources.images.background:getHeight())
  local font = resources.fonts.battle
  if currentGameLanguage == "zh" then
    font = resources.fonts.chineseBattle
  end
  love.graphics.setFont(font)
  love.graphics.setColor(1, 1, 1)
  local title = GameData.getText(currentGameLanguage, "menu_title")
  local titleWidth = font:getWidth(title)
  love.graphics.print(
    title,
    windowWidth / 2 - titleWidth / 2,
    windowHeight * uiLayoutConfig.mainMenu.titleOffsetY
  )
  local fontUI = resources.fonts.ui
  if currentGameLanguage == "zh" then
    fontUI = resources.fonts.chineseUI
  end
  love.graphics.setFont(fontUI)
  menuState.buttonAreas = {}
  for i, option in ipairs(menuState.options) do
    local optionY = (
      windowHeight * uiLayoutConfig.mainMenu.buttonOffsetY
      + (i - 1) * uiLayoutConfig.mainMenu.buttonSpacing
    )
    local buttonRect = {
      x = windowWidth / 2 - uiLayoutConfig.mainMenu.buttonWidth / 2,
      y = optionY,
      width = uiLayoutConfig.mainMenu.buttonWidth,
      height = uiLayoutConfig.mainMenu.buttonHeight
    }
    menuState.buttonAreas[i] = buttonRect
    if i == menuState.currentOption then
      love.graphics.setColor(1, 1, 0)
      love.graphics.rectangle("line", buttonRect.x, buttonRect.y, buttonRect.width, buttonRect.height)
    else
      love.graphics.setColor(1, 1, 1)
    end
    love.graphics.print(GameData.getText(currentGameLanguage, option.textKey), buttonRect.x, buttonRect.y)
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.print(GameData.getText(currentGameLanguage, option.descriptionKey), buttonRect.x + 10, buttonRect.y + 20)
  end
  local fontUI = resources.fonts.ui
  love.graphics.setFont(fontUI)
  love.graphics.setColor(1,1,1)
  local versionInfo = "V0.02\nBy Dundd2\nBuild with love-12.0-win64 Beta"
  local textWidth = fontUI:getWidth(versionInfo)
  local textHeight = fontUI:getHeight()
  love.graphics.print(versionInfo, love.graphics.getWidth() - textWidth - 100, love.graphics.getHeight() - textHeight - 100)
end
function drawLevelSelect()
  local windowWidth = love.graphics.getWidth()
  local windowHeight = love.graphics.getHeight()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(resources.images.background, 0, 0, 0,
    windowWidth/resources.images.background:getWidth(),
    windowHeight/resources.images.background:getHeight())
  local font = resources.fonts.battle
  if currentGameLanguage == "zh" then
    font = resources.fonts.chineseBattle
  end
  love.graphics.setFont(font)
  local title = GameData.getText(currentGameLanguage, "level_select_title")
  local titleWidth = font:getWidth(title)
  love.graphics.print(title, windowWidth / 2 - titleWidth / 2, 50)
  local fontUI = resources.fonts.ui
  if currentGameLanguage == "zh" then
    fontUI = resources.fonts.chineseUI
  end
  love.graphics.setFont(fontUI)
  menuState.levelSelect.buttonAreas = {}
  for i = 1, menuState.levelSelect.maxLevel do
      local levelY = 150 + (i-1) * 40
      local buttonRect = {
        x = windowWidth / 2 - 50,
        y = levelY,
        width = 100,
        height = 30
      }
      menuState.levelSelect.buttonAreas[i] = buttonRect
      if i == menuState.levelSelect.currentLevel then
          love.graphics.setColor(1, 1, 0)
          love.graphics.rectangle("line", buttonRect.x, buttonRect.y, buttonRect.width, buttonRect.height)
      else
          love.graphics.setColor(1, 1, 1)
      end
      local text = GameData.getText(currentGameLanguage, "level_number", {level = i})
      local textWidth = fontUI:getWidth(text)
      love.graphics.print(text, buttonRect.x, buttonRect.y)
  end
  local backButtonRect = {
    x = 10,
    y = 10,
    width = 50,
    height = 50
  }
  menuState.levelSelect.backButtonArea = backButtonRect
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("line", backButtonRect.x, backButtonRect.y, backButtonRect.width, backButtonRect.height)
  love.graphics.print("<", backButtonRect.x + 15, backButtonRect.y + 15)
end
function drawStoryDialogue()
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()
    love.graphics.draw(resources.images.background, 0, 0, 0,
        windowWidth/resources.images.background:getWidth(),
        windowHeight/resources.images.background:getHeight())
    local currentDialogue = GameData.getCurrentDialogue(resources, currentGameLanguage) -- Pass resources and language
    if not currentDialogue then return end
    local currentLevelData = GameData.story.levelIntros[currentState.currentLevel]
    if currentLevelData and currentLevelData.background then
        local bgKey = string.match(currentLevelData.background, "([^/]+)$"):gsub("%.png$", "")
        if resources.images[bgKey] then
            love.graphics.draw(resources.images[bgKey], 0, 0, 0,
                windowWidth/resources.images[bgKey]:getWidth(),
                windowHeight/resources.images[bgKey]:getHeight())
        end
    end
    -- Revised dialog box positioning and sizing
    local bottomMargin = windowHeight * 0.05 -- 5% from bottom
    local dialogBoxHeight = windowHeight * 0.2 -- 20% of screen height
    local dialogBoxWidth = windowWidth * 0.8
    local dialogBoxX = (windowWidth - dialogBoxWidth) / 2
    local dialogBoxY = windowHeight - dialogBoxHeight - bottomMargin -- Position from bottom
    
    local portraitImage = currentDialogue.portraitKey and resources.images[currentDialogue.portraitKey] or nil
    local maxPortraitWidth = dialogBoxHeight -- Portrait can be as wide as dialog box height
    local portraitDrawWidth = 0
    local portraitDrawHeight = 0
    local portraitDrawX = dialogBoxX + 10
    local portraitDrawY = dialogBoxY + 10 -- Relative to dialog box top
    if portraitImage then
        portraitDrawWidth = math.min(portraitImage:getWidth(), maxPortraitWidth)
        portraitDrawHeight = portraitDrawWidth * (portraitImage:getHeight() / portraitImage:getWidth())
        if portraitDrawHeight > dialogBoxHeight - 20 then
            portraitDrawHeight = dialogBoxHeight - 20
            portraitDrawWidth = portraitDrawHeight * (portraitImage:getWidth() / portraitImage:getHeight())
        end
    end
    love.graphics.setColor(0, 0, 0, 0.8)
    love.graphics.rectangle("fill", dialogBoxX, dialogBoxY, dialogBoxWidth, dialogBoxHeight)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", dialogBoxX, dialogBoxY, dialogBoxWidth, dialogBoxHeight)
    if portraitImage then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(portraitImage, portraitDrawX, portraitDrawY, 0, portraitDrawWidth / portraitImage:getWidth(), portraitDrawHeight / portraitImage:getHeight())
    end
    if currentDialogue.enemyDisplayNameKey then
        local enemyImageKey = enemyData[currentState.currentLevel] and enemyData[currentState.currentLevel].image or "enemyDemonKing"
        local enemyImage = resources.images[enemyImageKey]
        if enemyImage then
            local enemyMaxHeight = windowHeight * 0.6
            local enemyScale = enemyMaxHeight / enemyImage:getHeight()
            local enemyDrawWidth = enemyImage:getWidth() * enemyScale
            local enemyDrawHeight = enemyImage:getHeight() * enemyScale
            local enemyDrawX = windowWidth - enemyDrawWidth - (windowWidth * 0.05)
            local enemyDrawY = dialogBoxY - enemyDrawHeight + 20 -- Adjusted to be above the dialog box
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(enemyImage, enemyDrawX, enemyDrawY, 0, enemyScale, enemyScale)
        end
    end
    local fontUIStory = resources.fonts.ui
    if currentGameLanguage == "zh" then
        fontUIStory = resources.fonts.chineseUI
    end
    love.graphics.setFont(fontUIStory)
    love.graphics.setColor(0, 0, 1, 1)
    local textStartX = portraitImage and portraitDrawX + portraitDrawWidth + 20 or dialogBoxX + 20
    local textStartY = dialogBoxY + 30
    local textWidthLimit = dialogBoxWidth - (portraitImage and portraitDrawWidth + 40 or 40)
    love.graphics.printf(GameData.getCurrentText(), textStartX, textStartY, textWidthLimit, "left")
    love.graphics.setColor(1, 1, 1)
    local fontBattleStory = resources.fonts.battle
    if currentGameLanguage == "zh" then
        fontBattleStory = resources.fonts.chineseBattle
    end
    love.graphics.setFont(fontBattleStory)
    love.graphics.setColor(1, 1, 0)
    local speakerNameX = portraitImage and (portraitDrawX + portraitDrawWidth - fontBattleStory:getWidth(currentDialogue.speaker)) or (dialogBoxX + 20)
    local speakerNameY = portraitImage and portraitDrawY or (dialogBoxY + 10) -- Speaker name above portrait or dialog box
    love.graphics.print(currentDialogue.speaker, speakerNameX, speakerNameY)
    if GameData.isTextComplete() then
        love.graphics.setColor(1, 1, 1, 0.5 + math.sin(love.timer.getTime() * 5) * 0.5)
        love.graphics.print(GameData.getText(currentGameLanguage, "story_continue_prompt"), dialogBoxX + dialogBoxWidth - 150, dialogBoxY + dialogBoxHeight - 30)
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", windowWidth - 150, windowHeight - 50, 100, 30)
    love.graphics.print(GameData.getText(currentGameLanguage, "story_skip_button"), windowWidth - 140, windowHeight - 45)
end
function drawStoryPageUI()
  local windowWidth = love.graphics.getWidth()
  local windowHeight = love.graphics.getHeight()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(resources.images.background, 0, 0, 0,
    windowWidth/resources.images.background:getWidth(),
    windowHeight/resources.images.background:getHeight())
  local font = resources.fonts.battle
  if currentGameLanguage == "zh" then
    font = resources.fonts.chineseBattle
  end
  love.graphics.setFont(font)
  love.graphics.setColor(1, 1, 1)
  local title = GameData.getText(currentGameLanguage, "story_page_title")
  local titleWidth = font:getWidth(title)
  love.graphics.print(title, windowWidth / 2 - titleWidth / 2, 50)
  local textStartX = 50
  local textStartY = 100
  local textWidthLimit = windowWidth - 100
  local textHeightLimit = windowHeight - 200
  local fontUI = resources.fonts.ui
  if currentGameLanguage == "zh" then
    fontUI = resources.fonts.chineseUI
  end
  love.graphics.setFont(fontUI)
  love.graphics.setColor(1, 1, 1)
  love.graphics.setScissor(textStartX, textStartY, textWidthLimit, textHeightLimit)
  love.graphics.translate(0, -storyPageState.scrollPosition)
  love.graphics.printf(storyPageState.storyText, textStartX, textStartY, textWidthLimit, "left")
  love.graphics.setScissor()
  love.graphics.translate(0, storyPageState.scrollPosition)
  local backButtonRect = {
    x = windowWidth / 2 - 100,
    y = windowHeight - 80,
    width = 200,
    height = 40
  }
  storyPageState.backButtonArea = backButtonRect
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("line", backButtonRect.x, backButtonRect.y, backButtonRect.width, backButtonRect.height)
  local buttonTextWidth = fontUI:getWidth(GameData.getText(currentGameLanguage, "story_page_back_button"))
  love.graphics.print(GameData.getText(currentGameLanguage, "story_page_back_button"), backButtonRect.x + backButtonRect.width / 2 - buttonTextWidth / 2, backButtonRect.y + backButtonRect.height / 2 - 10)
end
function drawAboutPageUI()
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(resources.images.background, 0, 0, 0,
        windowWidth/resources.images.background:getWidth(),
        windowHeight/resources.images.background:getHeight())
    local fontTitle = resources.fonts.battle
    if currentGameLanguage == "zh" then
        fontTitle = resources.fonts.chineseBattle
    end
    love.graphics.setFont(fontTitle)
    love.graphics.setColor(1, 1, 1)
    local title = GameData.getText(currentGameLanguage, "about_page_title")
    local titleWidth = fontTitle:getWidth(title)
    love.graphics.print(title, windowWidth / 2 - titleWidth / 2, 50)
    if resources.images.authorPortrait then
        local portrait = resources.images.authorPortrait
        local portraitSize = 100
        local portraitX = 50
        local portraitY = 120
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(portrait, portraitX, portraitY, 0, portraitSize / portrait:getWidth(), portraitSize / portrait:getHeight())
    else
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.rectangle("fill", 50, 120, 100, 100)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("NO\nIMG", 70, 150)
    end
    local textStartX = 200
    local textStartY = 120
    local textWidthLimit = windowWidth - textStartX - 50
    local textHeightLimit = windowHeight - textStartY - 200
    local fontUI = resources.fonts.ui
    if currentGameLanguage == "zh" then
        fontUI = resources.fonts.chineseUI
    end
    love.graphics.setFont(fontUI)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setScissor(textStartX, textStartY, textWidthLimit, textHeightLimit)
    love.graphics.translate(0, -aboutPageState.scrollPosition)
    love.graphics.printf(GameData.getText(currentGameLanguage, "about_project"), textStartX, textStartY, textWidthLimit, "left")
    local staffText = GameData.getText(currentGameLanguage, "about_staff")
    local staffTextY = textStartY + fontUI:getHeight(GameData.getText(currentGameLanguage, "about_project"), textWidthLimit) + 20
    love.graphics.printf(staffText, textStartX, staffTextY, textWidthLimit, "left")
    love.graphics.setScissor()
    love.graphics.translate(0, aboutPageState.scrollPosition)
    local backButtonRect = {
        x = windowWidth / 2 - 100,
        y = windowHeight - 80,
        width = 200,
        height = 40
    }
    aboutPageState.backButtonArea = backButtonRect
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", backButtonRect.x, backButtonRect.y, backButtonRect.width, backButtonRect.height)
    local buttonTextWidth = fontUI:getWidth(GameData.getText(currentGameLanguage, "story_page_back_button"))
    love.graphics.print(GameData.getText(currentGameLanguage, "story_page_back_button"), backButtonRect.x + backButtonRect.width / 2 - buttonTextWidth / 2, backButtonRect.y + backButtonRect.height / 2 - 10)
end
function drawDialogueBox(dialogue, windowWidth, windowHeight)
    local dialogBoxWidth = windowWidth * 0.8
    local dialogBoxHeight = 150
    local dialogBoxX = (windowWidth - dialogBoxWidth) / 2
    local dialogBoxY = windowHeight - dialogBoxHeight - 50
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(resources.images.dialogBox,
        dialogBoxX, dialogBoxY,
        0,
        dialogBoxWidth / resources.images.dialogBox:getWidth(),
        dialogBoxHeight / resources.images.dialogBox:getHeight())
    love.graphics.setColor(1, 1, 0)
    love.graphics.setFont(resources.fonts.battle)
    love.graphics.print(dialogue.speaker, dialogBoxX + 20, dialogBoxY + 10)
    local portraitKey = dialogue.portraitKey or ("portrait" .. dialogue.speaker)
    if resources.images[portraitKey] then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(resources.images[portraitKey], dialogBoxX + 20, dialogBoxY - 80)
    end
    love.graphics.setColor(0, 0, 1, 1)
    love.graphics.setFont(resources.fonts.ui)
    love.graphics.printf(GameData.getCurrentText(), dialogBoxX + 40, dialogBoxY + 50, dialogBoxWidth - 80, "left")
    drawDialoguePrompts(dialogBoxX, dialogBoxY, dialogBoxWidth, dialogBoxHeight, windowWidth, windowHeight)
end
function drawDialoguePrompts(dialogBoxX, dialogBoxY, dialogBoxWidth, dialogBoxHeight, windowWidth, windowHeight)
    if GameData.isTextComplete() then
        love.graphics.setColor(1, 1, 1, 0.5 + math.sin(love.timer.getTime() * 5) * 0.5)
        love.graphics.print(GameData.getText(currentGameLanguage, "story_continue_prompt"), dialogBoxX + dialogBoxWidth - 150, dialogBoxY + dialogBoxHeight - 30)
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", windowWidth - 150, windowHeight - 50, 100, 30)
    love.graphics.print(GameData.getText(currentGameLanguage, "story_skip_button"), windowWidth - 140, windowHeight - 45)
end
function drawDialogueChoices(choices, windowWidth, windowHeight)
    if not choices then return end
    local choiceBoxWidth = windowWidth * 0.3
    local choiceBoxHeight = #choices * 40 + 20
    local choiceBoxX = windowWidth - choiceBoxWidth - 20
    local choiceBoxY = windowHeight - choiceBoxHeight - 200
    love.graphics.setColor(0, 0, 0, 0.8)
    love.graphics.rectangle("fill", choiceBoxX, choiceBoxY, choiceBoxWidth, choiceBoxHeight)
    love.graphics.setFont(resources.fonts.ui)
    for i, choice in ipairs(choices) do
        if i == choices.current then
            love.graphics.setColor(1, 1, 0)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.print(choice.text, choiceBoxX + 10, choiceBoxY + 10 + (i-1) * 40)
    end
end
function drawCharacters()
  local windowWidth = love.graphics.getWidth()
  local windowHeight = love.graphics.getHeight()

  -- Player Character
  local playerImage = animations.player.current == "stand" and resources.images.playerStand or resources.images.playerAttack
  local playerScaleX = positions.player.maxWidth / playerImage:getWidth()
  local playerScaleY = positions.player.maxHeight / playerImage:getHeight()
  local playerScale = math.min(playerScaleX, playerScaleY) -- Scale to fit within both max width and max height

  -- Ensure it's not too small
  if playerImage:getHeight() * playerScale < positions.player.minHeight then
      playerScale = positions.player.minHeight / playerImage:getHeight()
  end

  local playerDrawX = positions.player.x - (playerImage:getWidth() * playerScale) / 2
  local playerDrawY = positions.player.y - (playerImage:getHeight() * playerScale) / 2
  love.graphics.draw(playerImage, playerDrawX, playerDrawY, 0, playerScale, playerScale)

  -- Enemy Character
  local currentEnemyData = enemyData[menuState.levelSelect.currentLevel]
  local enemyImageKey = animations.enemy.current == "attack" and (currentEnemyData.attackImage or currentEnemyData.image) or currentEnemyData.image
  local enemyImage = resources.images[enemyImageKey] or resources.images.enemyDemonKing

  local enemyScaleX = positions.enemy.maxWidth / enemyImage:getWidth()
  local enemyScaleY = positions.enemy.maxHeight / enemyImage:getHeight()
  local enemyScale = math.min(enemyScaleX, enemyScaleY) -- Scale to fit within both max width and max height

  -- Ensure it's not too small
  if enemyImage:getHeight() * enemyScale < positions.enemy.minHeight then
      enemyScale = positions.enemy.minHeight / enemyImage:getHeight()
  end

  local enemyDrawX = positions.enemy.x - (enemyImage:getWidth() * enemyScale) / 2
  local enemyDrawY = positions.enemy.y - (enemyImage:getHeight() * enemyScale) / 2
  love.graphics.draw(enemyImage, enemyDrawX, enemyDrawY, 0, enemyScale, enemyScale)
end
function drawBattleUI()
  if gameState == "story" then
    return
  end
  local windowWidth = love.graphics.getWidth()
  local windowHeight = love.graphics.getHeight()

  local fontUI = resources.fonts.ui
  if currentGameLanguage == "zh" then
    fontUI = resources.fonts.chineseUI
  end
  love.graphics.setFont(fontUI)
  love.graphics.setColor(1, 1, 1)

  -- UI Frame for player actions (dynamically scaled)
  local uiFrameWidth = windowWidth * 0.3 -- Make it 30% of screen width
  local uiFrameHeight = windowHeight * 0.25 -- 25% of screen height
  local uiFrameX = windowWidth * 0.02 -- Left side, small margin
  local uiFrameY = windowHeight * 0.73 -- Bottom, leaving space for skill icons below if needed

  local uiFrameImage = resources.images.uiFrame
  local uiFrameScaleX = uiFrameWidth / uiFrameImage:getWidth()
  local uiFrameScaleY = uiFrameHeight / uiFrameImage:getHeight()
  love.graphics.draw(uiFrameImage, uiFrameX, uiFrameY, 0, uiFrameScaleX, uiFrameScaleY)

  -- HP Bar (Player)
  local hpBarWidth = windowWidth * 0.2  -- 20% of screen width
  local hpBarHeight = windowHeight * 0.03 -- 3% of screen height
  local playerHpX = windowWidth * 0.02
  local playerHpY = windowHeight * 0.02

  love.graphics.setColor(1, 0, 0)
  love.graphics.rectangle("fill", playerHpX, playerHpY, hpBarWidth, hpBarHeight)
  love.graphics.setColor(0, 1, 0)
  love.graphics.rectangle("fill", playerHpX, playerHpY, (player.hp / player.maxHp) * hpBarWidth, hpBarHeight)
  love.graphics.setColor(1, 1, 1)
  local playerHpText = string.format("HP: %d / %d", math.floor(player.hp), math.floor(player.maxHp)) -- Changed to show HP
  local playerHpTextWidth = fontUI:getWidth(playerHpText)
  love.graphics.print(playerHpText, playerHpX + hpBarWidth / 2 - playerHpTextWidth / 2, playerHpY + hpBarHeight + 5)

  -- MP Bar (Player) -- NEW
  local mpBarWidth = hpBarWidth * 0.8 -- Slightly smaller than HP
  local mpBarHeight = windowHeight * 0.02
  local playerMpX = playerHpX + hpBarWidth - mpBarWidth - 5 -- Below HP bar, right-aligned with HP
  local playerMpY = playerHpY + hpBarHeight + 5 + fontUI:getHeight() + 5 -- Below HP text
  love.graphics.setColor(0, 0, 1) -- Blue for MP
  love.graphics.rectangle("fill", playerMpX, playerMpY, mpBarWidth, mpBarHeight)
  love.graphics.setColor(0.5, 0.5, 1) -- Lighter blue for filled
  love.graphics.rectangle("fill", playerMpX, playerMpY, (player.mp / player.maxMp) * mpBarWidth, mpBarHeight)
  love.graphics.setColor(1, 1, 1)
  local playerMpText = string.format("MP: %d / %d", math.floor(player.mp), math.floor(player.maxMp))
  local playerMpTextWidth = fontUI:getWidth(playerMpText)
  love.graphics.print(playerMpText, playerMpX + mpBarWidth / 2 - playerMpTextWidth / 2, playerMpY + mpBarHeight + 5)

  -- Player Stats Display -- NEW
  local statsX = playerHpX
  local statsY = playerHpY + hpBarHeight + 5 + fontUI:getHeight() * 2 + 10 -- Below MP bar
  love.graphics.print(string.format("LV: %d", player.level), statsX, statsY)
  love.graphics.print(string.format("EXP: %d/%d", player.exp, player.expToNextLevel), statsX, statsY + fontUI:getHeight())

  love.graphics.print(GameData.getText(currentGameLanguage, "player_stats_attack") .. ": " .. player.attack, statsX + 100, statsY)
  love.graphics.print(GameData.getText(currentGameLanguage, "player_stats_defense") .. ": " .. player.defense, statsX + 100, statsY + fontUI:getHeight())
  love.graphics.print(GameData.getText(currentGameLanguage, "player_stats_crit_rate") .. ": " .. player.critRate .. "%", statsX + 200, statsY)
  love.graphics.print(GameData.getText(currentGameLanguage, "player_stats_crit_damage") .. ": " .. player.critDamage .. "X", statsX + 200, statsY + fontUI:getHeight())


  -- HP Bar (Enemy)
  local enemyHpX = windowWidth * 0.98 - hpBarWidth -- Align to right edge
  local enemyHpY = windowHeight * 0.02

  love.graphics.setColor(1, 0, 0)
  love.graphics.rectangle("fill", enemyHpX, enemyHpY, hpBarWidth, hpBarHeight)
  love.graphics.setColor(0, 1, 0)
  love.graphics.rectangle("fill", enemyHpX, enemyHpY, (enemy.hp / enemy.maxHp) * hpBarWidth, hpBarHeight)
  love.graphics.setColor(1, 1, 1)
  local enemyHpText = string.format("HP: %d / %d", math.floor(enemy.hp), math.floor(enemy.maxHp))
  local enemyHpTextWidth = fontUI:getWidth(enemyHpText)
  love.graphics.print(enemyHpText, enemyHpX + hpBarWidth / 2 - enemyHpTextWidth / 2, enemyHpY + hpBarHeight + 5)
  -- Enemy Name -- NEW
  local currentEnemyData = enemyData[menuState.levelSelect.currentLevel]
  local enemyName = GameData.getText(currentGameLanguage, currentEnemyData.displayNameKey)
  local enemyNameWidth = fontUI:getWidth(enemyName)
  love.graphics.print(enemyName, enemyHpX + hpBarWidth / 2 - enemyNameWidth / 2, enemyHpY - fontUI:getHeight() - 5)


  if battleState.phase == "select" then
    battleState.buttonAreas = {}
    love.graphics.setColor(1, 1, 1)
    local optionStartX = uiFrameX + uiFrameWidth * 0.05 -- Relative to UI frame, small margin
    local optionStartY = uiFrameY + uiFrameHeight * 0.05
    local optionButtonWidth = uiFrameWidth * 0.9 -- 90% of UI frame width
    local optionButtonHeight = uiFrameHeight * 0.2 -- 20% of UI frame height
    local optionSpacing = uiFrameHeight * 0.25 -- Spacing between buttons (height + padding)

    for i, option in ipairs(battleState.options) do
      local optionY = optionStartY + (i-1) * optionSpacing
      local buttonRect = {
        x = optionStartX,
        y = optionY,
        width = optionButtonWidth,
        height = optionButtonHeight
      }
      battleState.buttonAreas[i] = buttonRect
      if i == battleState.currentOption then
        love.graphics.setColor(1, 1, 0)
        love.graphics.rectangle("line", buttonRect.x, buttonRect.y, buttonRect.width, buttonRect.height)
      else
        love.graphics.setColor(1, 1, 1)
      end
      love.graphics.print(GameData.getText(currentGameLanguage, "battle_action_" .. option.name:lower()), buttonRect.x + optionButtonWidth * 0.05, buttonRect.y + optionButtonHeight * 0.05)
      love.graphics.setColor(0.8, 0.8, 0.8)
      love.graphics.print(GameData.getText(currentGameLanguage, "battle_action_desc_" .. option.name:lower()), buttonRect.x + optionButtonWidth * 0.05, buttonRect.y + optionButtonHeight * 0.5)
    end
  end

  -- Skill Icons (bottom of screen)
  local iconSize = windowHeight * 0.08 -- 8% of screen height for icon size
  local iconSpacing = windowWidth * 0.02 -- 2% of screen width for spacing
  local totalIconsWidth = (#skillInfo * iconSize) + ((#skillInfo - 1) * iconSpacing)
  local skillIconsStartX = (windowWidth - totalIconsWidth) / 2 -- Center horizontally
  local skillIconsStartY = windowHeight * 0.9 -- 90% down the screen (bottom margin)

  for i, skill in ipairs(skillInfo) do
    love.graphics.setColor(1, 1, 1)
    if resources.images[skill.icon] then
        love.graphics.draw(resources.images[skill.icon],
          skillIconsStartX + (i-1) * (iconSize + iconSpacing),
          skillIconsStartY,
          0,
          iconSize / resources.images[skill.icon]:getWidth(),
          iconSize / resources.images[skill.icon]:getHeight())
    else
        love.graphics.rectangle("fill", skillIconsStartX + (i-1) * (iconSize + iconSpacing), skillIconsStartY, iconSize, iconSize)
        love.graphics.setColor(1,0,0)
        love.graphics.print("?", skillIconsStartX + (i-1) * (iconSize + iconSpacing) + iconSize/2 - 5, skillIconsStartY + iconSize/2 - 10)
        love.graphics.setColor(1,1,1)
    end
    -- Cooldown and MP Cost Overlay -- UPDATED
    local cooldown = skillSystem[skill.key].cooldown
    local mpCost = skill.mpCost or 0 -- Get MP cost from skillInfo

    if cooldown > 0 or player.mp < mpCost then
      love.graphics.setColor(0, 0, 0, 0.7)
      if resources.images.cooldownOverlay then
          love.graphics.draw(resources.images.cooldownOverlay,
            skillIconsStartX + (i-1) * (iconSize + iconSpacing),
            skillIconsStartY,
            0,
            iconSize / resources.images.cooldownOverlay:getWidth(),
            iconSize / resources.images.cooldownOverlay:getHeight())
      else
          love.graphics.rectangle("fill", skillIconsStartX + (i-1) * (iconSize + iconSpacing), skillIconsStartY, iconSize, iconSize)
      end
      love.graphics.setColor(1, 1, 1)
      love.graphics.setFont(resources.fonts.ui)
      if cooldown > 0 then
        love.graphics.print(cooldown,
          skillIconsStartX + (i-1) * (iconSize + iconSpacing) + iconSize/2 - fontUI:getWidth(tostring(cooldown))/2,
          skillIconsStartY + iconSize/2 - fontUI:getHeight()/2)
      elseif player.mp < mpCost then
        love.graphics.print(mpCost,
          skillIconsStartX + (i-1) * (iconSize + iconSpacing) + iconSize/2 - fontUI:getWidth(tostring(mpCost))/2,
          skillIconsStartY + iconSize/2 - fontUI:getHeight()/2)
        love.graphics.setColor(1, 0.5, 0.5) -- Reddish tint for insufficient MP number
      end
    end
  end
end
function drawEffects()
love.graphics.setColor(1, 1, 1)
for _, effect in ipairs(battleState.effects) do
  if effect.type == "hit" or effect.type == "defend" or effect.type == "heal" then
    if effect.particleSystem then
      love.graphics.draw(effect.particleSystem, effect.x, effect.y)
    end
  elseif effect.type == "damage" then
    love.graphics.setFont(resources.fonts.damage)
    love.graphics.setColor(effect.color[1], effect.color[2], effect.color[3])
    love.graphics.print(effect.amount, effect.x, effect.y)
    love.graphics.setColor(1, 1, 1)
  else
    if resources.images[effect.type] then
      love.graphics.draw(resources.images[effect.type], effect.x, effect.y, effect.rotation, effect.scale, effect.scale)
    end
  end
end
end
function drawBattleMessage()
    if battleState.message ~= "" and battleState.messageTimer > 0 then
        local fontBattleMsg = resources.fonts.battle
        if currentGameLanguage == "zh" then
            fontBattleMsg = resources.fonts.chineseBattle
        end
        love.graphics.setFont(fontBattleMsg)
        -- Check for common strings to color messages
        if string.find(battleState.message, GameData.getText(currentGameLanguage, "battle_msg_enemy_attack", {damage=0})) or
           string.find(battleState.message, GameData.getText(currentGameLanguage, "battle_msg_enemy_crit", {damage=0})) or
           string.find(battleState.message, GameData.getText(currentGameLanguage, "battle_msg_enemy_defend")) then
            love.graphics.setColor(1, 0, 0) -- Red for enemy actions
        elseif string.find(battleState.message, GameData.getText(currentGameLanguage, "battle_msg_player_attack", {damage=0})) or
               string.find(battleState.message, GameData.getText(currentGameLanguage, "battle_msg_player_crit", {damage=0})) or
               string.find(battleState.message, GameData.getText(currentGameLanguage, "battle_msg_player_defend")) or
               string.find(battleState.message, GameData.getText(currentGameLanguage, "battle_msg_player_special", {damage=0})) or
               string.find(battleState.message, GameData.getText(currentGameLanguage, "battle_msg_player_heal", {healAmount=0})) then
            love.graphics.setColor(0, 1, 0) -- Green for player actions
        elseif string.find(battleState.message, GameData.getText(currentGameLanguage, "battle_msg_exp_gain", {exp=0})) or -- NEW EXP MSG
               string.find(battleState.message, GameData.getText(currentGameLanguage, "battle_msg_level_up", {level=0})) then -- NEW LEVEL UP MSG
            love.graphics.setColor(0, 0.8, 0.8) -- Cyan for progression messages
        else
            love.graphics.setColor(1, 1, 0) -- Yellow for generic messages
        end
        local textWidth = fontBattleMsg:getWidth(battleState.message)
        love.graphics.print(battleState.message,
            love.graphics.getWidth() / 2 - textWidth / 2,
            love.graphics.getHeight() - 150)
        love.graphics.setColor(1,1,1)
    end
    if gameState == "victory" or gameState == "defeat" then
        local fontBattleResult = resources.fonts.battle
        if currentGameLanguage == "zh" then
            fontBattleResult = resources.fonts.chineseBattle
        end
        love.graphics.setFont(fontBattleResult)
        if player.hp <= 0 then
          love.graphics.setColor(1, 0, 0)
          local text = GameData.getText(currentGameLanguage, "defeat_title")
          local textWidth = fontBattleResult:getWidth(text)
          love.graphics.print(text, love.graphics.getWidth() / 2 - textWidth / 2, love.graphics.getHeight() / 2 - 30)
        elseif enemy.hp <= 0 then
          love.graphics.setColor(0, 1, 0)
          local text = GameData.getText(currentGameLanguage, "victory_title")
          local textWidth = fontBattleResult:getWidth(text)
          love.graphics.print(text, love.graphics.getWidth() / 2 - textWidth / 2, love.graphics.getHeight() / 2 - 30)
        end
        love.graphics.setColor(1,1,1)
    end
end
function updateAnimations(dt)
  if animations.player.current == "attack" then
    animations.player.timer = animations.player.timer + dt
    if animations.player.timer < 0.2 then
      animations.player.x = animations.player.x + (200 * dt)
    elseif animations.player.timer < 0.4 then
      animations.player.x = animations.player.x - (200 * dt)
    else
      animations.player.timer = 0
      animations.player.current = "stand"
      animations.player.x = animations.player.originalX
    end
  end
  if animations.enemy.current == "attack" then
    animations.enemy.timer = animations.enemy.timer + dt
    if animations.enemy.timer < 0.2 then
      animations.enemy.x = animations.enemy.x - (200 * dt)
    elseif animations.enemy.timer < 0.4 then
      animations.enemy.x = animations.enemy.x + (200 * dt)
    else
      animations.enemy.timer = 0
      animations.enemy.current = "stand"
      animations.enemy.x = animations.enemy.originalX
    end
  end
end
function updateEffects(dt)
  for i = #battleState.effects, 1, -1 do
    local effect = battleState.effects[i]
    if effect.type == "hit" or effect.type == "defend" or effect.type == "heal" then
      if effect.particleSystem then
        effect.particleSystem:update(dt)
        effect.timer = effect.timer - dt
        if effect.timer <= 0 then
          effect.particleSystem:stop()
          table.remove(battleState.effects, i)
        end
      else
        table.remove(battleState.effects, i)
      end
    elseif effect.type == "damage" then
      effect.timer = effect.timer - dt
      effect.y = effect.y - 30 * dt
      if effect.timer <= 0 then
        table.remove(battleState.effects, i)
      end
    else
      effect.timer = effect.timer - dt
      if effect.timer <= 0 then
        table.remove(battleState.effects, i)
      end
    end
  end
end
function handleMenuInput(dt)
  if not dt then return end
  local moved = false
  local prevOption = menuState.currentOption
  local direction = "None"
  menuState.navTimer = menuState.navTimer + dt
  if menuState.navTimer > menuState.navDelay then
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
      menuState.currentOption = menuState.currentOption - 1
      moved = true
      direction = "Up"
      menuState.navTimer = 0
    elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
      menuState.currentOption = menuState.currentOption + 1
      moved = true
      direction = "Down"
      menuState.navTimer = 0
    end
  end
  if moved then
    if menuState.currentOption < 1 then
      menuState.currentOption = #menuState.options
    elseif menuState.currentOption > #menuState.options then
      menuState.currentOption = 1
    end
    if menuState.currentOption ~= prevOption then
      print("[MENU] Navigated menu: " .. direction .. ", selected option index: " .. menuState.currentOption .. ", option name: " .. GameData.getText(currentGameLanguage, menuState.options[menuState.currentOption].textKey))
    end
  end
end
function handleStoryPageInput(dt)
  if not dt then return end
  local scrollSpeed = 200 * dt
  if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
    storyPageState.scrollPosition = storyPageState.scrollPosition + scrollSpeed
  elseif love.keyboard.isDown("up") or love.keyboard.isDown("w") then
    storyPageState.scrollPosition = storyPageState.scrollPosition - scrollSpeed
    if storyPageState.scrollPosition < 0 then
      storyPageState.scrollPosition = 0
    end
  end
end
function handleAboutPageInput(dt)
    if not dt then return end
    local scrollSpeed = 200 * dt
    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        aboutPageState.scrollPosition = aboutPageState.scrollPosition + scrollSpeed
    elseif love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        aboutPageState.scrollPosition = aboutPageState.scrollPosition - scrollSpeed
        if aboutPageState.scrollPosition < 0 then
            aboutPageState.scrollPosition = 0
        end
    end
end
function handleLevelSelectInput(dt)
  local moved = false
  local prevLevel = menuState.levelSelect.currentLevel
  menuState.levelSelect.navTimer = menuState.levelSelect.navTimer + dt
  if  menuState.levelSelect.navTimer >  menuState.levelSelect.navDelay then
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
      menuState.levelSelect.currentLevel = math.max(1, menuState.levelSelect.currentLevel - 1)
      moved = true
      menuState.levelSelect.navTimer = 0
    elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
      menuState.levelSelect.currentLevel = math.min(menuState.levelSelect.maxLevel, menuState.levelSelect.currentLevel + 1)
      moved = true
      menuState.levelSelect.navTimer = 0
    end
  end
  if moved and menuState.levelSelect.currentLevel ~= prevLevel then
    print("[LEVEL SELECT] Level selected: " .. menuState.levelSelect.currentLevel)
  end
end
local storyEnterTimer = 0
local storyEnterDelay = 0.6
function handleStoryInput(dt)
    storyEnterTimer = storyEnterTimer + dt
    if love.keyboard.isDown("return") and storyEnterTimer > storyEnterDelay then
        storyEnterTimer = 0
        print("[STORY] Continue dialogue pressed")
        GameData.nextDialogue()
        if not currentState.isPlaying then
            if currentState.isEnding then
                transitionGameState(gameState, "menu")
            else
                transitionGameState(gameState, "battle")
                restartGame()
            end
        end
    elseif love.keyboard.isDown("escape") then
        print("[STORY] Skip dialogue pressed")
        GameData.skipDialogue()
        transitionGameState(gameState, "battle")
        restartGame()
    end
end
function updateBattleAction(dt)
end
function handleBattleInput()
  local moved = false
  local prevBattleOption = battleState.currentOption
  if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
    battleState.currentOption = battleState.currentOption - 1
    if battleState.currentOption < 1 then
      battleState.currentOption = #battleState.options
    end
    moved = true
  elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
    battleState.currentOption = battleState.currentOption + 1
    if battleState.currentOption > #battleState.options then
      battleState.currentOption = 1
    end
    moved = true
  end
  if moved then
    if battleState.currentOption ~= prevBattleOption then
      print("[BATTLE MENU] Option selected: " .. battleState.currentOption)
    end
  end
end
local optionsNavTimerLR = 0
local optionsNavDelayLR = 0.6
function handleOptionsInput(dt)
  local moved = false
  local prevOption = optionsState.currentOption
  local direction = "None"
  optionsState.navTimer = optionsState.navTimer + dt
  optionsNavTimerLR = optionsNavTimerLR + dt
  if optionsState.navTimer > optionsState.navDelay then
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
      optionsState.currentOption = optionsState.currentOption - 1
      moved = true
      direction = "Up"
      optionsState.navTimer = 0
    elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
      optionsState.currentOption = optionsState.currentOption + 1
      moved = true
      direction = "Down"
      optionsState.navTimer = 0
    end
  end
  if optionsNavTimerLR > optionsNavDelayLR then
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
      optionsNavTimerLR = 0
      local currentOption = optionsState.options[optionsState.currentOption]
      if currentOption.type == "language" then
        currentOption.currentOption = currentOption.currentOption - 1
        if currentOption.currentOption < 1 then
          currentOption.currentOption = #currentOption.languageOptions
        end
        currentGameLanguage = currentOption.languageOptions[currentOption.currentOption]
        setCurrentLanguage(currentGameLanguage) -- Use the new setCurrentLanguage
        storyPageState.storyText = GameData.getText(currentGameLanguage, "game_full_story")
        aboutPageState.storyText = GameData.getText(currentGameLanguage, "about_project")
        aboutPageState.staffText = GameData.getText(currentGameLanguage, "about_staff")
        print("[OPTIONS MENU] Language changed to: " .. currentGameLanguage)
      elseif currentOption.type == "resolution" then
        currentOption.currentOption = currentOption.currentOption - 1
        if currentOption.currentOption < 1 then
          currentOption.currentOption = #currentOption.resolutionOptions
        end
        currentResolutionIndex = currentOption.currentOption
        applyResolutionChange()
      elseif currentOption.type == "font_size" then
        currentOption.currentOption = currentOption.currentOption - 1
        if currentOption.currentOption < 1 then
            currentOption.currentOption = #currentOption.fontSizeOptions
        end
        GAME_CONSTANTS.currentFontSizeIndex = currentOption.currentOption
        applyFontSizeChange()
      end
      moved = true
    elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
      optionsNavTimerLR = 0
      local currentOption = optionsState.options[optionsState.currentOption]
       if currentOption.type == "language" then
        currentOption.currentOption = currentOption.currentOption + 1
        if currentOption.currentOption > #currentOption.languageOptions then
          currentOption.currentOption = 1
        end
        currentGameLanguage = currentOption.languageOptions[currentOption.currentOption]
        setCurrentLanguage(currentGameLanguage) -- Use the new setCurrentLanguage
        storyPageState.storyText = GameData.getText(currentGameLanguage, "game_full_story")
        aboutPageState.storyText = GameData.getText(currentGameLanguage, "about_project")
        aboutPageState.staffText = GameData.getText(currentGameLanguage, "about_staff")
        print("[OPTIONS MENU] Language changed to: " .. currentGameLanguage)
      elseif currentOption.type == "resolution" then
        currentOption.currentOption = currentOption.currentOption + 1
        if currentOption.currentOption > #currentOption.resolutionOptions then
          currentOption.currentOption = 1
        end
         currentResolutionIndex = currentOption.currentOption
         applyResolutionChange()
      elseif currentOption.type == "font_size" then
        currentOption.currentOption = currentOption.currentOption + 1
        if currentOption.currentOption > #currentOption.fontSizeOptions then
            currentOption.currentOption = 1
        end
        GAME_CONSTANTS.currentFontSizeIndex = currentOption.currentOption
        applyFontSizeChange()
      end
      moved = true
    end
  end
  if moved then
    if optionsState.currentOption < 1 then
      optionsState.currentOption = #optionsState.options
    elseif optionsState.currentOption > #optionsState.options then
      optionsState.currentOption = 1
    end
    if optionsState.currentOption ~= prevOption then
      print("[OPTIONS MENU] Navigated menu: " .. direction .. ", selected option index: " .. optionsState.currentOption .. ", option name: " .. GameData.getText(currentGameLanguage, optionsState.options[optionsState.currentOption].textKey))
    end
  end
end
function applyResolutionChange()
  screenWidth = availableResolutions[currentResolutionIndex].width
  screenHeight = availableResolutions[currentResolutionIndex].height
  love.window.setMode(screenWidth, screenHeight, {resizable = false, vsync = true, fullscreen = playerSettings.isFullScreen})
  print("[GAME] Resolution changed to " .. screenWidth .. "x" .. screenHeight)
    positions.player = {
        x = screenWidth * 0.25, -- Adjusted X
        y = screenHeight * 0.5,
        scale = 1.0,
        maxWidth = screenWidth * 0.4,
        maxHeight = screenHeight * 0.6,
        minHeight = screenHeight * 0.2,
    }
    positions.enemy = {
        x = screenWidth * 0.75, -- Adjusted X
        y = screenHeight * 0.5,
        scale = 1.0,
        maxWidth = screenWidth * 0.4,
        maxHeight = screenHeight * 0.6,
        minHeight = screenHeight * 0.2,
    }
    positions.playerHP = {x = screenWidth * 0.02, y = screenHeight * 0.02}
    positions.enemyHP = {x = screenWidth * 0.78, y = screenHeight * 0.02} -- Adjusted X
    positions.playerUI = {x = screenWidth * 0.02, y = screenHeight * 0.75}
    positions.enemyUI = {x = screenWidth * 0.68, y = screenHeight * 0.75}
    animations.player.x = positions.player.x
    animations.player.y = positions.player.y
    animations.player.originalX = positions.player.x
    animations.enemy.x = positions.enemy.x
    animations.enemy.y = positions.enemy.y
    animations.enemy.originalX = positions.enemy.x
end
function love.keypressed(key)
  if gameState == "menu" then
    if key == "return" or key == "space" then
      local option = menuState.options[menuState.currentOption]
      print("[MENU] Option selected: " .. GameData.getText(currentGameLanguage, option.textKey))
      option.action()
    end
  elseif gameState == "levelSelect" then
    if key == "return" then
        print("[LEVEL SELECT] Level " .. menuState.levelSelect.currentLevel .. " selected")
        GameData.startLevelDialogue(menuState.levelSelect.currentLevel)
        transitionGameState(gameState, "story")
    elseif key == "escape" then
      transitionGameState(gameState, "menu")
    elseif key == "up" or key == "w" then
      menuState.levelSelect.currentLevel = math.max(1, menuState.levelSelect.currentLevel - 1)
      print("[LEVEL SELECT] Level selected: " .. menuState.levelSelect.currentLevel)
    elseif key == "down" or key == "s" then
      menuState.levelSelect.currentLevel = math.min(menuState.levelSelect.maxLevel, menuState.levelSelect.currentLevel + 1)
      print("[LEVEL SELECT] Level selected: " .. menuState.levelSelect.currentLevel)
    end
  elseif gameState == "story" then
    if key == "return" then
      print("[STORY] Continue dialogue key pressed")
      GameData.nextDialogue()
      if not currentState.isPlaying then
        if currentState.isEnding then
          transitionGameState(gameState, "menu")
        else
          transitionGameState(gameState, "battle")
          restartGame()
        end
      end
    elseif key == "escape" then
      print("[STORY] Skip dialogue key pressed")
      GameData.skipDialogue()
      transitionGameState(gameState, "battle")
      restartGame()
    end
  elseif gameState == "battle" then
    if key == "up" or key == "down" or key == "w" or key == "s" then
      handleBattleInput()
    elseif key == "return" or key == "space" then
      if battleState.phase == "select" and battleState.turn == "player" then
        local option = battleState.options[battleState.currentOption]
        print("[BATTLE MENU] Option chosen: " .. option.name)
        if option.name == "Attack" then
          performPlayerAttack()
        elseif option.name == "Defend" then
          performPlayerDefend()
        elseif option.name == "Special" then
          performPlayerSpecial()
        elseif option.name == "Heal" then
          performPlayerHeal()
        end
      end
    elseif key == "escape" then
        handleBattlePause() 
    end
  elseif gameState == "pause" then 
      if key == "up" or key == "w" then
        local prevPauseOption = pauseState.currentOption
        pauseState.currentOption = pauseState.currentOption - 1
        if pauseState.currentOption < 1 then
          pauseState.currentOption = #pauseState.options
        end
        if pauseState.currentOption ~= prevPauseOption then
          print("[PAUSE MENU] Navigated menu: Up, selected option index: " .. pauseState.currentOption .. ", option text: " .. GameData.getText(currentGameLanguage, pauseState.options[pauseState.currentOption].textKey))
        end
      elseif key == "down" or key == "s" then
        local prevPauseOption = pauseState.currentOption
        pauseState.currentOption = pauseState.currentOption + 1
        if pauseState.currentOption > #pauseState.options then
          pauseState.currentOption = 1
        end
        if pauseState.currentOption ~= prevPauseOption then
          print("[PAUSE MENU] Navigated menu: Down, selected option index: " .. pauseState.currentOption .. ", option text: " .. GameData.getText(currentGameLanguage, pauseState.options[pauseState.currentOption].textKey))
        end
      elseif key == "return" or key == "space" then
        local selectedPauseOption = pauseState.options[pauseState.currentOption]
        print("[PAUSE MENU] Option selected: " .. GameData.getText(currentGameLanguage, selectedPauseOption.textKey))
        selectedPauseOption.action()
      end
  elseif gameState == "defeat" or gameState == "victory" then
    if key == "up" or key == "w" then
      local prevResultOption = resultState.currentOption
      resultState.currentOption = resultState.currentOption - 1
      if resultState.currentOption < 1 then
        resultState.currentOption = #resultState.options
      end
      if resultState.currentOption ~= prevResultOption then
        print("[" .. gameState:upper() .. " MENU] Navigated menu: Up, selected option index: " .. resultState.currentOption .. ", option text: " .. GameData.getText(currentGameLanguage, resultState.options[resultState.currentOption].textKey))
      end
    elseif key == "down" or key == "s" then
      local prevResultOption = resultState.currentOption
      resultState.currentOption = resultState.currentOption + 1
      if resultState.currentOption > #resultState.options then
        resultState.currentOption = 1
      end
      if resultState.currentOption ~= prevResultOption then
        print("[" .. gameState:upper() .. " MENU] Navigated menu: Down, selected option index: " .. resultState.currentOption .. ", option text: " .. GameData.getText(currentGameLanguage, resultState.options[resultState.currentOption].textKey))
      end
    elseif key == "return" or key == "space" then
      local selectedResultOption = resultState.options[resultState.currentOption]
      print("[" .. gameState:upper() .. " MENU] Option selected: " .. GameData.getText(currentGameLanguage, selectedResultOption.textKey))
      selectedResultOption.action()
    end
    return
  elseif gameState == "options" then
    if key == "escape" then
      transitionGameState(gameState, "menu")
    elseif key == "return" or key == "space" then
      handleOptionsInputReturn()
    end
  elseif gameState == "storyPage" then
    if key == "escape" then
      transitionGameState(gameState, "menu")
      storyPageState.scrollPosition = 0
      print("[GAME STATE] Game state changed to 'menu' from storyPage")
    end
  elseif gameState == "aboutPage" then
    if key == "escape" then
      transitionGameState(gameState, "menu")
      aboutPageState.scrollPosition = 0
      print("[GAME STATE] Game state changed to 'menu' from aboutPage")
    end
  end
end
function handleOptionsInputReturn()
  local option = optionsState.options[optionsState.currentOption]
  if option.type == "toggle" then
    local targetState = option.targetState or audioState
    local oldState = targetState[option.state]
    targetState[option.state] = not oldState
    print("[OPTIONS MENU] Toggled option: " .. GameData.getText(currentGameLanguage, option.textKey) .. ", new state: " .. tostring(targetState[option.state]))
    if option.state == "isMutedBGM" then
      transitionGameState(gameState, gameState) -- For BGM
    elseif option.state == "isFullScreen" then -- ADD THIS CHECK
        applyResolutionChange() -- Call the function that applies screen settings
    end
  elseif option.action then
    option.action()
    print("[OPTIONS MENU] Option selected: " .. GameData.getText(currentGameLanguage, option.textKey))
  end
end
local function isPointInRect(x, y, rect)
    if not rect or not rect.x or not rect.y or not rect.width or not rect.height then
        return false
    end
    return x >= rect.x and x <= rect.x + rect.width and
           y >= rect.y and y <= rect.y + rect.height
end
function love.mousepressed(x, y, button, istouch, presses)
    if button ~= 1 then return end
    local handled = false
    if gameState == "menu" then
        if menuState.buttonAreas then
            for i, area in ipairs(menuState.buttonAreas) do
                if isPointInRect(x, y, area) then
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
        if menuState.levelSelect.buttonAreas then
            for i, buttonRect in ipairs(menuState.levelSelect.buttonAreas) do
                if isPointInRect(x, y, buttonRect) then
                    menuState.levelSelect.currentLevel = i
                    print("[LEVEL SELECT] Level " .. menuState.levelSelect.currentLevel .. " selected by mouse")
                    GameData.startLevelDialogue(menuState.levelSelect.currentLevel)
                    transitionGameState(gameState, "story")
                    handled = true
                    break
                end
            end
        end
        if menuState.levelSelect.backButtonArea then
          local backButtonRect = menuState.levelSelect.backButtonArea
          if isPointInRect(x, y, backButtonRect) then
            transitionGameState(gameState, "menu")
            print("[LEVEL SELECT] Back button clicked, returning to main menu")
            handled = true
          end
        end
    elseif gameState == "battle" and not pauseState.isPaused then
        if battleState.buttonAreas then
            for i, area in ipairs(battleState.buttonAreas) do
                if isPointInRect(x, y, area) and battleState.phase == "select" then
                    battleState.currentOption = i
                    local option = battleState.options[i]
                    print("[BATTLE MENU] Option clicked: " .. option.name)
                    if option.name == "Attack" then
                        performPlayerAttack()
                    elseif option.name == "Defend" then
                        performPlayerDefend()
                    elseif option.name == "Special" then
                        performPlayerSpecial()
                    elseif option.name == "Heal" then
                        performPlayerHeal()
                    end
                    handled = true
                    break
                end
            end
        end
    elseif gameState == "pause" then
        if pauseState.buttonAreas then
            for i, area in ipairs(pauseState.buttonAreas) do
                if isPointInRect(x, y, area) then
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
          if isPointInRect(x, y, buttonRect) then
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
          if isPointInRect(x, y, buttonRect) then
            optionsState.currentOption = i
            local option = optionsState.options[i]
            print("[OPTIONS MENU] Option clicked: " .. GameData.getText(currentGameLanguage, option.textKey))
            if option.type == "toggle" or option.type == "font_size" or option.type == "resolution" then
              handleOptionsInputReturn()
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
          if isPointInRect(x, y, areaRect) then
            if areaType == "left" then
              local currentOption = optionsState.options[optionsState.currentOption]
              currentOption.currentOption = currentOption.currentOption - 1
              if currentOption.currentOption < 1 then
                currentOption.currentOption = #currentOption.languageOptions
              end
              currentGameLanguage = currentOption.languageOptions[currentOption.currentOption]
              setCurrentLanguage(currentGameLanguage)
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
              setCurrentLanguage(currentGameLanguage)
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
                if isPointInRect(x, y, areaRect) then
                    if areaType == "left" then
                        local currentOption = optionsState.options[optionsState.currentOption].currentOption
                        currentOption = currentOption - 1
                        if currentOption < 1 then
                            currentOption = #availableResolutions
                        end
                        optionsState.options[optionsState.currentOption].currentOption = currentOption
                        currentResolutionIndex = currentOption
                        applyResolutionChange()
                        print("[OPTIONS MENU] Resolution changed (Left Arrow Click)")
                    elseif areaType == "right" then
                        local currentOption = optionsState.options[optionsState.currentOption].currentOption
                        currentOption = currentOption + 1
                        if currentOption > #availableResolutions then
                            currentOption = 1
                        end
                        optionsState.options[optionsState.currentOption].currentOption = currentOption
                        currentResolutionIndex = currentOption
                        applyResolutionChange()
                        print("[OPTIONS MENU] Resolution changed (Right Arrow Click)")
                    end
                    handled = true
                    break
                end
            end
        end
        if optionsState.options[optionsState.currentOption].type == "font_size" and optionsState.fontSizeButtonAreas then
            for areaType, areaRect in pairs(optionsState.fontSizeButtonAreas) do
                if isPointInRect(x, y, areaRect) then
                    if areaType == "left" then
                        local currentOption = optionsState.options[optionsState.currentOption]
                        currentOption.currentOption = currentOption.currentOption - 1
                        if currentOption.currentOption < 1 then
                            currentOption.currentOption = #currentOption.fontSizeOptions
                        end
                        GAME_CONSTANTS.currentFontSizeIndex = currentOption.currentOption
                        applyFontSizeChange()
                        print("[OPTIONS MENU] Font size changed (Left Arrow Click)")
                    elseif areaType == "right" then
                        local currentOption = optionsState.options[optionsState.currentOption]
                        currentOption.currentOption = currentOption.currentOption + 1
                        if currentOption.currentOption > #currentOption.fontSizeOptions then
                            currentOption.currentOption = 1
                        end
                        GAME_CONSTANTS.currentFontSizeIndex = currentOption.currentOption
                        applyFontSizeChange()
                        print("[OPTIONS MENU] Font size changed (Right Arrow Click)")
                    end
                    handled = true
                    break
                end
            end
        end
      if optionsState.backButtonArea then
        local backButtonRect = optionsState.backButtonArea
        if isPointInRect(x, y, backButtonRect) then
          transitionGameState(gameState, "menu")
          print("[OPTIONS MENU] Back button clicked")
          handled = true
        end
      end
    elseif gameState == "storyPage" then
        if storyPageState.backButtonArea then
          local backButtonRect = storyPageState.backButtonArea
          if isPointInRect(x, y, backButtonRect) then
            transitionGameState(gameState, "menu")
            storyPageState.scrollPosition = 0
            print("[STORY PAGE] Back button clicked, returning to main menu")
            handled = true
          end
        end
    elseif gameState == "aboutPage" then
        if aboutPageState.backButtonArea then
          local backButtonRect = aboutPageState.backButtonArea
          if isPointInRect(x, y, backButtonRect) then
            transitionGameState(gameState, "menu")
            aboutPageState.scrollPosition = 0
            print("[ABOUT PAGE] Back button clicked, returning to main menu")
            handled = true
          end
        end
    elseif gameState == "story" then
      local windowWidth = love.graphics.getWidth()
      local windowHeight = love.graphics.getHeight()
      -- Use the same calculation for dialog box area as in drawStoryDialogue
      local bottomMargin = windowHeight * 0.05
      local dialogBoxHeight = windowHeight * 0.2
      local dialogBoxWidth = windowWidth * 0.8
      local dialogBoxX = (windowWidth - dialogBoxWidth) / 2
      local dialogBoxY = windowHeight - dialogBoxHeight - bottomMargin
      
      if isPointInRect(x, y, {x = dialogBoxX, y = dialogBoxY, width = dialogBoxWidth, height = dialogBoxHeight}) then
        if GameData.isTextComplete() then
            handleStoryInput(0.61) -- Trigger continue
            print("[STORY] Dialogue box clicked, continuing story")
            handled = true
        end
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
function restartGame()
print("[GAME] Restarting game...")
player.hp = player.maxHp
player.mp = player.maxMp -- NEW: Also restore MP on restart
player.isDefending = false
player.combo = 0
print("[GAME] Player settings reset")
local currentEnemyData = enemyData[menuState.levelSelect.currentLevel]
if not currentEnemyData then
    print("[ERROR] Failed to load enemy data for level: " .. tostring(menuState.levelSelect.currentLevel))
    return
end
enemy = {
  x = positions.enemy.x,
  y = positions.enemy.y,
  image = resources.images[currentEnemyData.image],
  hp = validateNumber(currentEnemyData.hp, GAME_CONSTANTS.HP.MIN, GAME_CONSTANTS.HP.MAX, GAME_CONSTANTS.HP.BASE),
  maxHp = validateNumber(currentEnemyData.maxHp, GAME_CONSTANTS.HP.MIN, GAME_CONSTANTS.HP.MAX, GAME_CONSTANTS.HP.BASE),
  attack = validateNumber(currentEnemyData.attack, 1, math.huge, 10),
  defense = validateNumber(currentEnemyData.defense, 0, math.huge, 5),
  critRate = validateNumber(currentEnemyData.critRate, 0, GAME_CONSTANTS.MAX_CRIT_RATE, GAME_CONSTANTS.BASE_CRIT_RATE),
  critDamage = validateNumber(currentEnemyData.critDamage, 1, GAME_CONSTANTS.MAX_CRIT_DAMAGE, GAME_CONSTANTS.BASE_CRIT_DAMAGE),
  isDefending = false,
  status = {},
  combo = 0
}
print("[GAME] Enemy settings loaded for level " .. menuState.levelSelect.currentLevel)
  battleState = {
      phase = "select",
      turn = "player",
      message = GameData.getText(currentGameLanguage, "battle_start"),
      messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION,
      options = {
          {name = "Attack", description = "Deal damage to enemy"},
          {name = "Defend", description = "Reduce incoming damage"},
          {name = "Special", description = "Powerful attack with delay"},
          {name = "Heal", description = "Restore health"},
      },
      currentOption = 1,
      buttonAreas = {},
      effects = {}
  }
  -- Reset skill cooldowns
  for _, skill in pairs(skillSystem) do
    skill.cooldown = 0
  end
  print("[GAME] Battle state reset")
  animations = {
      player = {
          current = "stand",
          timer = 0,
          x = positions.player.x,
          y = positions.player.y,
          originalX = positions.player.x
      },
      enemy = {
          current = "stand",
          timer = 0,
          x = positions.enemy.x,
          y = positions.enemy.y,
          originalX = positions.enemy.x
      },
      effects = {}
  }
  print("[GAME] Animations reset")
transitionGameState(gameState, "battle")
pauseState.isPaused = false
end
local function calculateHeal(character)
  local healAmount = math.floor(character.maxHp * GAME_CONSTANTS.HP.HEAL_PERCENT)
  return validateNumber(healAmount, 1, character.maxHp, 1)
end
local function calculateDamage(attacker, defender)
    local attack = validateNumber(attacker.attack, 1, 9999, GAME_CONSTANTS.MIN_DAMAGE)
    local defense = validateNumber(defender.defense, 0, 9999, 0)
    local baseDamage = attack * (GAME_CONSTANTS.DEFENSE_SCALING / (GAME_CONSTANTS.DEFENSE_SCALING + defense))
    local randomMod = 1 + math.random(
        GAME_CONSTANTS.DAMAGE_RANDOM_MIN * 100,
        GAME_CONSTANTS.DAMAGE_RANDOM_MAX * 100
    ) / 100
    local damage = baseDamage * randomMod
    local critRate = validateNumber(attacker.critRate, 0, GAME_CONSTANTS.MAX_CRIT_RATE, GAME_CONSTANTS.BASE_CRIT_RATE)
    local isCrit = math.random(1, 100) <= critRate
    if isCrit then
        local critDmg = validateNumber(attacker.critDamage, 1, GAME_CONSTANTS.MAX_CRIT_DAMAGE, GAME_CONSTANTS.BASE_CRIT_DAMAGE)
        damage = damage * critDmg
    end
    damage = validateNumber(
        math.floor(damage),
        GAME_CONSTANTS.MIN_DAMAGE,
        attack * GAME_CONSTANTS.MAX_DAMAGE_MULTIPLIER,
        GAME_CONSTANTS.MIN_DAMAGE
    )
    if attacker == player and playerSettings.isCheatMode then
        damage = defender.hp + 1000 -- One-shot kill
    end
    if defender == player and playerSettings.isInfiniteHP then
        damage = 0
        print("[CHEAT] Player took 0 damage (Infinite HP active).")
    end
    return damage, isCrit
end

-- NEW: Function to grant EXP and check for level up
function grantExp(amount)
    player.exp = player.exp + amount
    battleState.message = GameData.getText(currentGameLanguage, "battle_msg_exp_gain", {exp = amount})
    battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
    print("[GAME] Player gained " .. amount .. " EXP. Current EXP: " .. player.exp)
    checkLevelUp()
end

-- NEW: Function to check for and apply level ups
function checkLevelUp()
    while player.exp >= player.expToNextLevel do
        player.exp = player.exp - player.expToNextLevel
        player.level = player.level + 1
        player.expToNextLevel = math.floor(player.expToNextLevel * 1.5) -- Example: EXP needed increases by 50%
        
        -- Increase player stats on level up
        player.maxHp = player.maxHp + 10
        player.hp = player.hp + 10 -- Recover HP on level up, or set to maxHp
        player.maxMp = player.maxMp + 5
        player.mp = player.mp + 5 -- Recover MP on level up, or set to maxMp
        player.attack = player.attack + 2
        player.defense = player.defense + 1
        player.critRate = math.min(GAME_CONSTANTS.MAX_CRIT_RATE, player.critRate + 0.5) -- Cap crit rate
        player.critDamage = math.min(GAME_CONSTANTS.MAX_CRIT_DAMAGE, player.critDamage + 0.05) -- Cap crit damage

        battleState.message = GameData.getText(currentGameLanguage, "battle_msg_level_up", {level = player.level})
        battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION + 1 -- Longer message for level up
        print(string.format("[GAME] Player leveled up to LV %d! HP: %d/%d, MP: %d/%d, ATK: %d, DEF: %d, CRT: %.1f, CRD: %.2f",
                            player.level, player.hp, player.maxHp, player.mp, player.maxMp, player.attack, player.defense, player.critRate, player.critDamage))
    end
end

function performPlayerAttack()
    if skillSystem.attack.cooldown > 0 then
        battleState.message = GameData.getText(currentGameLanguage, "battle_msg_skill_cooldown")
        battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
        print("[BATTLE] Attack skill on cooldown")
        return
    end
    if not audioState.isMutedSFX then
        resources.sounds.attack:play()
    end
    animations.player.current = "attack"
    local damage, isCrit = calculateDamage(player, enemy)
    enemy.hp = validateNumber(enemy.hp - damage, 0, enemy.maxHp, 0)
    local currentEnemyData = enemyData[menuState.levelSelect.currentLevel]
    local enemyImage = resources.images[currentEnemyData.image] or resources.images.enemyDemonKing
    -- Corrected drawing for enemy image
    local enemyDrawScale = math.min(positions.enemy.maxWidth / enemyImage:getWidth(), positions.enemy.maxHeight / enemyImage:getHeight())
    if enemyImage:getHeight() * enemyDrawScale < positions.enemy.minHeight then
        enemyDrawScale = positions.enemy.minHeight / enemyImage:getHeight()
    end
    local effectX = animations.enemy.x
    local effectY = animations.enemy.y
    -- The particle system should be offset based on the image size to hit the center
    local hitPS = resources.particleSystems.hit()
    hitPS:emit(100)
    table.insert(battleState.effects, {
        type = "hit",
        x = effectX,
        y = effectY,
        particleSystem = hitPS,
        timer = GAME_CONSTANTS.TIMER.EFFECT_DURATION
    })
    local damageText = tostring(damage)
    local damageColor = {1, 1, 1}
    if isCrit then
        damageText = damageText .. "!"
        damageColor = {1, 0.5, 0}
        if not audioState.isMutedSFX then
            resources.sounds.crit:play()
        end
    end
    table.insert(battleState.effects, {
      type = "damage",
      amount = damageText,
      x = effectX,
      y = effectY - 50,
      timer = 1,
      color = damageColor
    })
    battleState.message = isCrit and
        GameData.getText(currentGameLanguage, "battle_msg_player_crit", {damage = damage}) or
        GameData.getText(currentGameLanguage, "battle_msg_player_attack", {damage = damage})
    battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
    battleState.phase = "action"
    if enemy.hp <= 0 then
        -- EXP Granting moved to love.update for consistency, before victory state transition
        battleState.phase = "result"
        -- Timer is handled in love.update
    else
        TimerSystem.create(GAME_CONSTANTS.TIMER.ACTION_DELAY, startEnemyTurn, TIMER_GROUPS.BATTLE)
    end
    skillSystem.attack.cooldown = skillSystem.attack.maxCooldown
end
function performPlayerHeal()
  print("[BATTLE ACTION] Player action: Heal")
  local skill = skillSystem.heal
  local skillData = skillInfo[4] -- Assuming Heal is the 4th skill in skillInfo table
  if skill.cooldown > 0 then
    battleState.message = GameData.getText(currentGameLanguage, "battle_msg_skill_cooldown")
    battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
    print("[BATTLE] Heal skill on cooldown")
    return
  end
  if player.mp < skillData.mpCost then -- NEW MP CHECK
      battleState.message = GameData.getText(currentGameLanguage, "battle_msg_not_enough_mp")
      battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
      print("[BATTLE] Not enough MP for Heal skill")
      return
  end
    if not audioState.isMutedSFX then
        resources.sounds.heal:play()
        print("[AUDIO] Played sound: heal")
    end
    player.mp = math.max(0, player.mp - skillData.mpCost) -- NEW MP DEDUCTION
    local healAmount = calculateHeal(player)
    player.hp = validateNumber(player.hp + healAmount, 0, player.maxHp, player.hp)
    local playerImage = resources.images.playerStand
    -- Corrected drawing for player image
    local playerDrawScale = math.min(positions.player.maxWidth / playerImage:getWidth(), positions.player.maxHeight / playerImage:getHeight())
    if playerImage:getHeight() * playerDrawScale < positions.player.minHeight then
        playerDrawScale = positions.player.minHeight / playerImage:getHeight()
    end
    local effectX = animations.player.x
    local effectY = animations.player.y
    local healPS = resources.particleSystems.heal()
    healPS:emit(100)
    table.insert(battleState.effects, {
        type = "heal",
        x = effectX,
        y = effectY,
        particleSystem = healPS,
        timer = GAME_CONSTANTS.TIMER.EFFECT_DURATION
    })
    table.insert(battleState.effects, {
      type = "damage",
      amount = "+" .. tostring(healAmount),
      x = effectX,
      y = effectY - 50,
      timer = 1,
      color = {0, 1, 0}
    })
    battleState.message = GameData.getText(currentGameLanguage, "battle_msg_player_heal", {healAmount = healAmount})
    battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
    battleState.phase = "action"
    TimerSystem.create(GAME_CONSTANTS.TIMER.ACTION_DELAY, startEnemyTurn, TIMER_GROUPS.BATTLE)
    skillSystem.heal.cooldown = skillSystem.heal.maxCooldown
    print("[SKILL SYSTEM] Heal skill cooldown set to " .. skillSystem.heal.cooldown)
end
function performPlayerDefend()
  performPlayerDefend_original()
end
function performPlayerSpecial()
  performPlayerSpecial_original()
end
function performPlayerDefend_original()
  print("[BATTLE ACTION] Player action: Defend")
  if skillSystem.defend.cooldown > 0 then
    battleState.message = GameData.getText(currentGameLanguage, "battle_msg_skill_cooldown")
    battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
    print("[BATTLE] Defend skill on cooldown")
    return
  end
  if not audioState.isMutedSFX then
    resources.sounds.defend:play()
    print("[AUDIO] Played sound: defend")
  end
  player.isDefending = true
  animations.player.current = "stand"
  local playerImage = resources.images.playerStand
  local playerImgWidth = playerImage:getWidth() * (positions.player.scale or 1)
  local playerImgHeight = playerImage:getHeight() * (positions.player.scale or 1)
  local effectX = animations.player.x
  local effectY = animations.player.y
  local defendPS = resources.particleSystems.defend()
  defendPS:emit(100)
  table.insert(battleState.effects, {
    type = "defend",
    x = effectX,
    y = effectY,
    particleSystem = defendPS,
    timer = 0.5
  })
  battleState.message = GameData.getText(currentGameLanguage, "battle_msg_player_defend")
  battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
  battleState.phase = "action"
  print("[BATTLE STATE] Battle phase changed to 'action'")
  addTimer(GAME_CONSTANTS.TIMER.ACTION_DELAY, function() startEnemyTurn() end, TIMER_GROUPS.BATTLE)
  print("[TIMER] Added timer for enemy turn")
  skillSystem.defend.cooldown = skillSystem.defend.maxCooldown
  print("[SKILL SYSTEM] Defend skill cooldown set to " .. skillSystem.defend.cooldown)
end
function performPlayerSpecial_original()
  print("[BATTLE ACTION] Player action: Special")
  local skill = skillSystem.special
  local skillData = skillInfo[3] -- Assuming Special is the 3rd skill in skillInfo table
  if skill.cooldown > 0 then
    battleState.message = GameData.getText(currentGameLanguage, "battle_msg_skill_cooldown")
    battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
    print("[BATTLE] Special skill on cooldown")
    return
  end
  if player.mp < skillData.mpCost then -- NEW MP CHECK
      battleState.message = GameData.getText(currentGameLanguage, "battle_msg_not_enough_mp")
      battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
      print("[BATTLE] Not enough MP for Special skill")
      return
  end
  if not audioState.isMutedSFX then
    resources.sounds.special:play()
    print("[AUDIO] Played sound: special")
  end
player.mp = math.max(0, player.mp - skillData.mpCost) -- NEW MP DEDUCTION
animations.player.current = "attack"
local damage, isCrit = calculateDamage(player, enemy)
print("[BATTLE] Player stats before special: HP=" .. player.hp .. ", MP=" .. player.mp .. ", Attack=" .. player.attack .. ", Defense=" .. player.defense .. ", CritRate=" .. player.critRate .. ", CritDamage=" .. player.critDamage)
print("[BATTLE] Enemy stats before special: HP=" .. enemy.hp .. ", Attack=" .. enemy.attack .. ", Defense=" .. enemy.defense .. ", CritRate=" .. enemy.critRate .. ", CritDamage=" .. enemy.critDamage)
enemy.hp = validateNumber(enemy.hp - damage, 0, enemy.maxHp, 0)
print("[BATTLE] Player dealt " .. damage .. " damage to enemy with Special attack")
local currentEnemyData = enemyData[menuState.levelSelect.currentLevel]
local enemyImage = resources.images[currentEnemyData.image] or resources.images.enemyDemonKing
-- Corrected drawing for enemy image
local enemyDrawScale = math.min(positions.enemy.maxWidth / enemyImage:getWidth(), positions.enemy.maxHeight / enemyImage:getHeight())
if enemyImage:getHeight() * enemyDrawScale < positions.enemy.minHeight then
    enemyDrawScale = positions.enemy.minHeight / enemyImage:getHeight()
end
local effectX = animations.enemy.x
local effectY = animations.enemy.y
local hitPS = resources.particleSystems.hit()
hitPS:emit(100)
table.insert(battleState.effects, {
    type = "hit",
    x = effectX,
    y = effectY,
    particleSystem = hitPS,
    timer = GAME_CONSTANTS.TIMER.EFFECT_DURATION
})
local damageText = tostring(damage)
local damageColor = {1, 1, 0}
if isCrit then
    damageText = damageText .. "!"
    damageColor = {1, 0.5, 0}
    if not audioState.isMutedSFX then
        resources.sounds.crit:play()
    end
end
table.insert(battleState.effects, {
  type = "damage",
  amount = damageText,
  x = effectX,
  y = effectY - 50,
  timer = 1,
  color = damageColor
})
battleState.message = GameData.getText(currentGameLanguage, "battle_msg_player_special", {damage = damage})
battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
battleState.phase = "action"
print("[BATTLE STATE] Battle phase changed to 'action'")
if enemy.hp <= 0 then
  -- EXP Granting moved to love.update for consistency, before victory state transition
  battleState.phase = "result"
  print("[BATTLE STATE] Battle phase changed to 'result', enemy defeated by special attack")
  -- Timer is handled in love.update
else
  addTimer(GAME_CONSTANTS.TIMER.ACTION_DELAY, function() startEnemyTurn() end, TIMER_GROUPS.BATTLE)
  print("[TIMER] Added timer for enemy turn")
end
skillSystem.special.cooldown = skillSystem.special.maxCooldown
print("[SKILL SYSTEM] Special skill cooldown set to " .. skillSystem.special.cooldown)
end
function startEnemyTurn()
    if battleState.phase ~= "action" then
        print("[ERROR] Invalid battle phase for enemy turn: " .. tostring(battleState.phase))
        return
    end
    battleState.turn = "enemy"
    battleState.phase = validateBattlePhase("action")
    local enemyDataForLevel = enemyData[menuState.levelSelect.currentLevel]
    if not enemyDataForLevel then
        print("[ERROR] Missing enemy data for level: " .. tostring(menuState.levelSelect.currentLevel))
        return
    end
    local aiType = enemyAI[enemyDataForLevel.ai] or enemyAI.basic
    local action = aiType.decideAction(enemy, player)
    print("[ENEMY AI] Enemy AI decision: " .. action)
    if action == "attack" then
      print("[BATTLE ACTION] Enemy action: Attack")
      animations.enemy.current = "attack"
      local damage, isCrit = calculateDamage(enemy, player)
      print("[BATTLE] Enemy stats before attack: HP=" .. enemy.hp .. ", Attack=" .. enemy.attack .. ", Defense=" .. enemy.defense .. ", CritRate=" .. enemy.critRate .. ", CritDamage=" .. enemy.critDamage)
      print("[BATTLE] Player stats before attack: HP=" .. player.hp .. ", Attack=" .. player.attack .. ", Defense=" .. player.defense .. ", CritRate=" .. player.critRate .. ", CritDamage=" .. player.critRate .. ", CritDamage=" .. player.critDamage)
      player.hp = math.max(0, player.hp - damage)
      print("[BATTLE] Enemy dealt " .. damage .. " damage to player. Crit=" .. tostring(isCrit))
      battleState.message = GameData.getText(currentGameLanguage, "battle_msg_enemy_attack", {damage = damage})
      if isCrit then
        battleState.message = GameData.getText(currentGameLanguage, "battle_msg_enemy_crit", {damage = damage})
        if not audioState.isMutedSFX then
          love.audio.play(resources.sounds.crit)
          print("[AUDIO] Played sound: crit")
        end
      end
      local playerImage = resources.images.playerStand
      -- Corrected drawing for player image
      local playerDrawScale = math.min(positions.player.maxWidth / playerImage:getWidth(), positions.player.maxHeight / playerImage:getHeight())
      if playerImage:getHeight() * playerDrawScale < positions.player.minHeight then
          playerDrawScale = positions.player.minHeight / playerImage:getHeight()
      end
      local effectX = animations.player.x
      local effectY = animations.player.y
      local hitPS = resources.particleSystems.hit()
      hitPS:emit(100)
      table.insert(battleState.effects, {
        type = "hit",
        x = effectX,
        y = effectY,
        particleSystem = hitPS,
        timer = GAME_CONSTANTS.TIMER.EFFECT_DURATION
      })
      local damageText = tostring(damage)
      local damageColor = {1, 1, 1}
      if isCrit then
        damageText = damageText .. "!"
        damageColor = {1, 0.5, 0}
      end
      table.insert(battleState.effects, {
        type = "damage",
        amount = damageText,
        x = effectX,
        y = effectY - 50,
        timer = 1,
        color = damageColor
      })
      local attackSound = math.random() < 0.5 and resources.sounds.enemyHit1 or resources.sounds.enemyHit2
      if not audioState.isMutedSFX then
        love.audio.play(attackSound)
        print("[AUDIO] Played sound: " .. (attackSound == resources.sounds.enemyHit1 and "enemyHit1" or "enemyHit2"))
      end
    else
      print("[BATTLE ACTION] Enemy action: Defend")
      enemy.isDefending = true
      battleState.message = GameData.getText(currentGameLanguage, "battle_msg_enemy_defend")
      local enemyImage = resources.images[enemyDataForLevel.image] or resources.images.enemyDemonKing
      -- Corrected drawing for enemy image
      local enemyDrawScale = math.min(positions.enemy.maxWidth / enemyImage:getWidth(), positions.enemy.maxHeight / enemyImage:getHeight())
      if enemyImage:getHeight() * enemyDrawScale < positions.enemy.minHeight then
          enemyDrawScale = positions.enemy.minHeight / enemyImage:getHeight()
      end
      local effectX = animations.enemy.x
      local effectY = animations.enemy.y
      local defendPS = resources.particleSystems.defend()
      defendPS:emit(100)
      table.insert(battleState.effects, {
        type = "defend",
        x = effectX,
        y = effectY,
        particleSystem = defendPS,
        timer = 0.5
      })
    end
    battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
    if player.hp <= 0 then
      -- Defeat is handled in love.update
    else
      addTimer(GAME_CONSTANTS.TIMER.ACTION_DELAY, function()
        if gameState == "battle" then
            battleState.turn = "player"
            battleState.phase = "select"
            player.isDefending = false
            enemy.isDefending = false
            animations.player.current = "stand"
            animations.enemy.current = "stand"
            print("[BATTLE TURN] Player turn started")
            print("[BATTLE STATE] Battle phase changed to 'select'")
        end
      end, TIMER_GROUPS.BATTLE)
      print("[TIMER] Added timer for player turn")
    end
    updateCooldowns()
    print("[SKILL SYSTEM] Cooldowns updated")
end
function drawPauseUI()
  local windowWidth = love.graphics.getWidth()
  local windowHeight = love.graphics.getHeight()
love.graphics.setColor(0, 0, 0, 0.8)
love.graphics.rectangle("fill", 0, 0, windowWidth, windowHeight)
local fontPauseTitle = resources.fonts.battle
    if currentGameLanguage == "zh" then
        fontPauseTitle = resources.fonts.chineseBattle
    end
love.graphics.setFont(fontPauseTitle)
love.graphics.setColor(1, 1, 1)
local title = GameData.getText(currentGameLanguage, "pause_title")
local titleWidth = fontPauseTitle:getWidth(title)
love.graphics.print(title, windowWidth / 2 - titleWidth / 2, windowHeight / 2 - 100)
local fontUIPause = resources.fonts.ui
    if currentGameLanguage == "zh" then
        fontUIPause = resources.fonts.chineseUI
    end
love.graphics.setFont(fontUIPause)
pauseState.buttonAreas = {}
for i, option in ipairs(pauseState.options) do
    local buttonY = windowHeight / 2 - 20 + (i-1) * 60
    local buttonRect = {
        x = windowWidth / 2 - 100,
        y = buttonY,
        width = 200,
        height = 40
    }
    pauseState.buttonAreas[i] = buttonRect
    if i == pauseState.currentOption then
        love.graphics.setColor(1, 1, 0)
        love.graphics.rectangle("line", buttonRect.x, buttonRect.y, buttonRect.width, buttonRect.height)
    else
        love.graphics.setColor(1, 1, 1)
    end
    love.graphics.rectangle("line", buttonRect.x, buttonRect.y, buttonRect.width, buttonRect.height)
    local textWidth = fontUIPause:getWidth(GameData.getText(currentGameLanguage, option.textKey))
    love.graphics.print(GameData.getText(currentGameLanguage, option.textKey),
        buttonRect.x + buttonRect.width / 2 - textWidth / 2,
        buttonRect.y + buttonRect.height / 2 - 10)
end
end
function drawVictoryUI()
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(resources.images.background, 0, 0, 0,
        windowWidth/resources.images.background:getWidth(),
        windowHeight/resources.images.background:getHeight())
    love.graphics.setColor(0, 0, 0, 0.8)
    love.graphics.rectangle("fill", 0, 0, windowWidth, windowHeight)
    local fontVictoryTitle = resources.fonts.battle
    if currentGameLanguage == "zh" then
        fontVictoryTitle = resources.fonts.chineseBattle
    end
    love.graphics.setFont(fontVictoryTitle)
    love.graphics.setColor(0, 1, 0)
    local text = GameData.getText(currentGameLanguage, "victory_title")
    local textWidth = fontVictoryTitle:getWidth(text)
    love.graphics.print(text, windowWidth / 2 - textWidth / 2, windowHeight / 2 - 50)
    resultState.buttonAreas = {}
    local restartButton = {
        x = windowWidth / 2 - 100,
        y = windowHeight / 2 + 20,
        width = 200,
        height = 40,
        textKey = "result_restart"
    }
    resultState.buttonAreas[1] = restartButton
    if resultState.currentOption == 1 then
        love.graphics.setColor(1, 1, 0)
        love.graphics.rectangle("line", restartButton.x, restartButton.y, restartButton.width, restartButton.height)
    else
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", restartButton.x, restartButton.y, restartButton.width, restartButton.height)
    end
    local fontUIVictory = resources.fonts.ui
    if currentGameLanguage == "zh" then
        fontUIVictory = resources.fonts.chineseUI
    end
    love.graphics.setFont(fontUIVictory)
    local buttonTextWidth = fontUIVictory:getWidth(GameData.getText(currentGameLanguage, restartButton.textKey))
    love.graphics.print(GameData.getText(currentGameLanguage, restartButton.textKey), restartButton.x + restartButton.width / 2 - buttonTextWidth / 2 , restartButton.y + restartButton.height / 2 - 10)
    local mainMenuButton = {
        x = windowWidth / 2 - 100,
        y = windowHeight / 2 + 80,
        width = 200,
        height = 40,
        textKey = "result_main_menu"
    }
    resultState.buttonAreas[2] = mainMenuButton
    if resultState.currentOption == 2 then
        love.graphics.setColor(1, 1, 0)
        love.graphics.rectangle("line", mainMenuButton.x, mainMenuButton.y, mainMenuButton.width, mainMenuButton.height)
    else
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", mainMenuButton.x, mainMenuButton.y, mainMenuButton.width, mainMenuButton.height)
    end
    love.graphics.setFont(fontUIVictory)
    local mainMenuTextWidth = fontUIVictory:getWidth(GameData.getText(currentGameLanguage, mainMenuButton.textKey))
    love.graphics.print(GameData.getText(currentGameLanguage, mainMenuButton.textKey), mainMenuButton.x + mainMenuButton.width / 2 - mainMenuTextWidth / 2 , mainMenuButton.y + mainMenuButton.height / 2 - 10)
end
function drawDefeatUI()
   local windowWidth = love.graphics.getWidth()
   local windowHeight = love.graphics.getHeight()
   love.graphics.setColor(1, 1, 1)
   love.graphics.draw(resources.images.background, 0, 0, 0,
       windowWidth/resources.images.background:getWidth(),
       windowHeight/resources.images.background:getHeight())
   love.graphics.setColor(0, 0, 0, 0.8)
   love.graphics.rectangle("fill", 0, 0, windowWidth, windowHeight)
 local fontDefeatTitle = resources.fonts.battle
    if currentGameLanguage == "zh" then
        fontDefeatTitle = resources.fonts.chineseBattle
    end
 love.graphics.setFont(fontDefeatTitle)
 love.graphics.setColor(1, 0, 0)
 local text = GameData.getText(currentGameLanguage, "defeat_title")
 local textWidth = fontDefeatTitle:getWidth(text)
 love.graphics.print(text, windowWidth / 2 - textWidth / 2, windowHeight / 2 - 50)
resultState.buttonAreas = {}
local restartButton = {
   x = windowWidth / 2 - 100,
   y = windowHeight / 2 + 20,
   width = 200,
   height = 40,
   textKey = "result_restart"
 }
 resultState.buttonAreas[1] = restartButton
 if resultState.currentOption == 1 then
    love.graphics.setColor(1, 1, 0)
    love.graphics.rectangle("line", restartButton.x, restartButton.y, restartButton.width, restartButton.height)
 else
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", restartButton.x, restartButton.y, restartButton.width, restartButton.height)
 end
 local fontUIDefeat = resources.fonts.ui
    if currentGameLanguage == "zh" then
        fontUIDefeat = resources.fonts.chineseUI
    end
 love.graphics.setFont(fontUIDefeat)
 local buttonTextWidth = fontUIDefeat:getWidth(GameData.getText(currentGameLanguage, restartButton.textKey))
 love.graphics.print(GameData.getText(currentGameLanguage, restartButton.textKey), restartButton.x + restartButton.width / 2 - buttonTextWidth / 2 , restartButton.y + restartButton.height / 2 - 10)
 local mainMenuButton = {
   x = windowWidth / 2 - 100,
   y = windowHeight / 2 + 80,
   width = 200,
   height = 40,
   textKey = "result_main_menu"
 }
 resultState.buttonAreas[2] = mainMenuButton
 if resultState.currentOption == 2 then
    love.graphics.setColor(1, 1, 0)
    love.graphics.rectangle("line", mainMenuButton.x, mainMenuButton.y, mainMenuButton.width, mainMenuButton.height)
 else
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", mainMenuButton.x, mainMenuButton.y, mainMenuButton.width, mainMenuButton.height)
 end
 local mainMenuTextWidth = fontUIDefeat:getWidth(GameData.getText(currentGameLanguage, mainMenuButton.textKey))
 love.graphics.print(GameData.getText(currentGameLanguage, mainMenuButton.textKey), mainMenuButton.x + mainMenuButton.width / 2 - mainMenuTextWidth / 2 , mainMenuButton.y + mainMenuButton.height / 2 - 10)
end
function drawSkillInfoUI()
local windowWidth = love.graphics.getWidth()
local windowHeight = love.graphics.getHeight()
love.graphics.setColor(0, 0, 0, 0.8)
love.graphics.rectangle("fill", 0, 0, windowWidth, windowHeight)
local fontSkillInfoTitle = resources.fonts.battle
    if currentGameLanguage == "zh" then
        fontSkillInfoTitle = resources.fonts.chineseBattle
    end
love.graphics.setFont(fontSkillInfoTitle)
love.graphics.setColor(1, 1, 1)
local title = GameData.getText(currentGameLanguage, "skill_info_title")
local titleWidth = fontSkillInfoTitle:getWidth(title)
love.graphics.print(title, windowWidth / 2 - titleWidth / 2, 50)
local fontUISkillInfo = resources.fonts.ui
    if currentGameLanguage == "zh" then
        fontUISkillInfo = resources.fonts.chineseUI
    end
love.graphics.setFont(fontUISkillInfo)
local listX = 50
local listY = 100
 for i, skill in ipairs(skillInfo) do
     if i == uiState.selectedSkill then
         love.graphics.setColor(1, 1, 0)
     else
          love.graphics.setColor(1, 1, 1)
     end
     love.graphics.print(GameData.getText(currentGameLanguage, "skill_name_" .. skill.key), listX, listY + (i - 1) * 30)
   love.graphics.setColor(0.8, 0.8, 0.8)
   love.graphics.print(GameData.getText(currentGameLanguage, "skill_desc_" .. skill.key), listX + 20, listY + 20 + (i - 1) * 30)
end
 local detailsX = windowWidth / 2 + 50
 local detailsY = 100
 local selectedSkill = skillInfo[uiState.selectedSkill]
 love.graphics.setColor(1, 1, 1)
 love.graphics.print(GameData.getText(currentGameLanguage, "skill_detail_name") .. ": " .. GameData.getText(currentGameLanguage, "skill_name_" .. selectedSkill.key), detailsX, detailsY)
 love.graphics.print(GameData.getText(currentGameLanguage, "skill_detail_type") .. ": " .. GameData.getText(currentGameLanguage, "skill_type_" .. selectedSkill.type), detailsX, detailsY + 30)
 love.graphics.print(GameData.getText(currentGameLanguage, "skill_detail_desc") .. ": ", detailsX, detailsY + 60)
 love.graphics.setFont(fontUISkillInfo)
 love.graphics.setColor(0.8, 0.8, 0.8)
 love.graphics.printf(GameData.getText(currentGameLanguage, "skill_details_" .. selectedSkill.key), detailsX, detailsY + 80, windowWidth - detailsX - 50, "left")
 love.graphics.setFont(fontSkillInfoTitle)
end
skillSystem = {
  attack = { cooldown = 0, maxCooldown = GAME_CONSTANTS.COOLDOWN.ATTACK },
  defend = { cooldown = 0, maxCooldown = GAME_CONSTANTS.COOLDOWN.DEFEND },
  special = { cooldown = 0, maxCooldown = GAME_CONSTANTS.COOLDOWN.SPECIAL },
  heal = { cooldown = 0, maxCooldown = GAME_CONSTANTS.COOLDOWN.HEAL }
}
function updateCooldowns()
  for _, skill in pairs(skillSystem) do
    if skill.cooldown > 0 then
      skill.cooldown = skill.cooldown - 1
    end
  end
end
function drawBattleScene()
  local bgImage = resources.images[battleBackgrounds[menuState.levelSelect.currentLevel]]
  if bgImage then
      love.graphics.draw(bgImage, 0, 0, 0,
        love.graphics.getWidth()/bgImage:getWidth(),
        love.graphics.getHeight()/bgImage:getHeight())
  else
      love.graphics.setColor(0.5, 0.5, 0.5)
      love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
      love.graphics.setColor(1,1,1)
  end
end
function drawOptionsUI()
  local windowWidth = love.graphics.getWidth()
  local windowHeight = love.graphics.getHeight()
  love.graphics.draw(resources.images.background, 0, 0, 0,
    windowWidth/resources.images.background:getWidth(),
    windowHeight/resources.images.background:getHeight())
  local fontOptionsTitle = resources.fonts.battle
  if currentGameLanguage == "zh" then
    fontOptionsTitle = resources.fonts.chineseBattle
  end
  love.graphics.setFont(fontOptionsTitle)
  love.graphics.setColor(1, 1, 1)
  local title = GameData.getText(currentGameLanguage, "options_title")
  local titleWidth = fontOptionsTitle:getWidth(title)
  love.graphics.print(title, windowWidth / 2 - titleWidth / 2, windowHeight * 0.2)
  local fontUIOptions = resources.fonts.ui
  if currentGameLanguage == "zh" then
    fontUIOptions = resources.fonts.chineseUI
  end
  love.graphics.setFont(fontUIOptions)
  optionsState.buttonAreas = {}
  optionsState.languageButtonAreas = {}
  optionsState.resolutionButtonAreas = {}
  optionsState.fontSizeButtonAreas = {}
  for i, option in ipairs(optionsState.options) do
    local optionY = windowHeight * 0.4 + (i-1) * 50
    local buttonRect = {
      x = windowWidth / 2 - 150,
      y = optionY,
      width = 300,
      height = 40
    }
    optionsState.buttonAreas[i] = buttonRect
    if i == optionsState.currentOption then
      love.graphics.setColor(1, 1, 0)
      love.graphics.rectangle("line", buttonRect.x, buttonRect.y, buttonRect.width, buttonRect.height)
    else
      love.graphics.setColor(1, 1, 1)
    end
    local optionText = GameData.getText(currentGameLanguage, option.textKey)
    if option.type == "language" then
      optionText = optionText .. ": " .. string.upper(currentGameLanguage)
      local arrowButtonWidth = 30
      local leftArrowRect = {
        x = buttonRect.x - arrowButtonWidth - 5,
        y = buttonRect.y,
        width = arrowButtonWidth,
        height = buttonRect.height
      }
      local rightArrowRect = {
        x = buttonRect.x + buttonRect.width + 5,
        y = buttonRect.y,
        width = arrowButtonWidth,
        height = buttonRect.height
      }
      optionsState.languageButtonAreas["left"] = leftArrowRect
      optionsState.languageButtonAreas["right"] = rightArrowRect
      love.graphics.rectangle("line", leftArrowRect.x, leftArrowRect.y, leftArrowRect.width, leftArrowRect.height)
      love.graphics.print("<", leftArrowRect.x + 10, leftArrowRect.y + 10)
      love.graphics.rectangle("line", rightArrowRect.x, rightArrowRect.y, rightArrowRect.width, rightArrowRect.height)
      love.graphics.print(">", rightArrowRect.x + 10, rightArrowRect.y + 10)
    elseif option.type == "resolution" then
        optionText = optionText .. ": " .. option.resolutionOptions[currentResolutionIndex].name
        local arrowButtonWidth = 30
        local leftArrowRect = {
            x = buttonRect.x - arrowButtonWidth - 5,
            y = buttonRect.y,
            width = arrowButtonWidth,
            height = buttonRect.height
        }
        local rightArrowRect = {
            x = buttonRect.x + buttonRect.width + 5,
            y = buttonRect.y,
            width = arrowButtonWidth,
            height = buttonRect.height
        }
        optionsState.resolutionButtonAreas["left"] = leftArrowRect
        optionsState.resolutionButtonAreas["right"] = rightArrowRect
        love.graphics.rectangle("line", leftArrowRect.x, leftArrowRect.y, leftArrowRect.width, leftArrowRect.height)
        love.graphics.print("<", leftArrowRect.x + 10, leftArrowRect.y + 10)
        love.graphics.rectangle("line", rightArrowRect.x, rightArrowRect.y, rightArrowRect.width, rightArrowRect.height)
        love.graphics.print(">", rightArrowRect.x + 10, rightArrowRect.y + 10)
    elseif option.type == "font_size" then
        optionText = optionText .. ": " .. string.format("%.1fX", option.fontSizeOptions[GAME_CONSTANTS.currentFontSizeIndex])
        local arrowButtonWidth = 30
        local leftArrowRect = {
            x = buttonRect.x - arrowButtonWidth - 5,
            y = buttonRect.y,
            width = arrowButtonWidth,
            height = buttonRect.height
        }
        local rightArrowRect = {
            x = buttonRect.x + buttonRect.width + 5,
            y = buttonRect.y,
            width = arrowButtonWidth,
            height = buttonRect.height
        }
        optionsState.fontSizeButtonAreas["left"] = leftArrowRect
        optionsState.fontSizeButtonAreas["right"] = rightArrowRect
        love.graphics.rectangle("line", leftArrowRect.x, leftArrowRect.y, leftArrowRect.width, leftArrowRect.height)
        love.graphics.print("<", leftArrowRect.x + 10, leftArrowRect.y + 10)
        love.graphics.rectangle("line", rightArrowRect.x, rightArrowRect.y, rightArrowRect.width, rightArrowRect.height)
        love.graphics.print(">", rightArrowRect.x + 10, rightArrowRect.y + 10)
    elseif option.type == "toggle" then
      local targetState = option.targetState or audioState
      optionText = optionText .. ": " .. (targetState[option.state] and GameData.getText(currentGameLanguage, "options_on") or GameData.getText(currentGameLanguage, "options_off"))
    end
    love.graphics.print(optionText, buttonRect.x, buttonRect.y)
  end
  local backButtonRect = {
    x = 10,
    y = 10,
    width = 50,
    height = 50
  }
  optionsState.backButtonArea = backButtonRect
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("line", backButtonRect.x, backButtonRect.y, backButtonRect.width, backButtonRect.height)
  love.graphics.print("<", backButtonRect.x + 15, backButtonRect.y + 15)
end

-- NEW: Basic table serializer for saving
function table_to_string(tbl)
    local s = "{\n"
    local first = true
    for k, v in pairs(tbl) do
        -- Skip any function values
        if type(v) == "function" then
            print("Warning: Skipping function value for key: " .. tostring(k))
            goto continue
        end
        -- Skip `_pointer` keys that might be from love objects, or any internal refs
        if type(k) == "string" and k:sub(1,1) == "_" then -- Example: _pointer for love.graphics.Image
            print("Warning: Skipping internal/private key: " .. k)
            goto continue
        end

        if not first then
            s = s .. ",\n"
        end
        first = false

        -- Handle key formatting
        if type(k) == "number" then
            s = s .. "  [" .. k .. "] = "
        elseif type(k) == "string" then
            s = s .. "  " .. string.format("%q", k) .. " = " -- Quote string keys for safety
        else
            -- Skip unsupported key types (e.g., boolean keys, userdata)
            print("Warning: Skipping unsupported key type: " .. type(k))
            first = true -- prevent adding comma if we skip this entry
            goto continue
        end

        -- Handle value formatting
        if type(v) == "number" then
            s = s .. tostring(v)
        elseif type(v) == "string" then
            s = s .. string.format("%q", v)
        elseif type(v) == "boolean" then
            s = s .. tostring(v)
        elseif type(v) == "table" then
            s = s .. table_to_string(v)
        else
            -- Skip unsupported value types
            print("Warning: Skipping unsupported value type " .. type(v) .. " for key " .. tostring(k))
            first = true -- prevent adding comma if we skip this entry
        end
        ::continue::
    end
    s = s .. "\n}"
    return s
end

-- NEW: Save Game Function
function saveGame()
    local saveData = {
        player = {
            hp = player.hp,
            maxHp = player.maxHp,
            mp = player.mp,
            maxMp = player.maxMp,
            level = player.level,
            exp = player.exp,
            expToNextLevel = player.expToNextLevel,
            attack = player.attack,
            defense = player.defense,
            critRate = player.critRate,
            critDamage = player.critDamage,
            -- Do NOT save image, x, y, speed, isDefending, status, combo as they are runtime states or loaded resources
        },
        -- currentState for story progression
        currentState = {
            currentLevel = currentState.currentLevel,
            dialogueIndex = currentState.dialogueIndex,
            -- If character relationships or other GameData internal states need to be saved,
            -- they would need to be extracted here. For now, GameData states are assumed persistent
            -- or reset by game logic as needed.
        },
        playerSettings = {
            isCheatMode = playerSettings.isCheatMode,
            isInfiniteHP = playerSettings.isInfiniteHP,
            isFullScreen = playerSettings.isFullScreen,
        },
        audioState = {
            isMutedBGM = audioState.isMutedBGM,
            isMutedSFX = audioState.isMutedSFX,
        },
        currentResolutionIndex = currentResolutionIndex,
        currentFontSizeIndex = GAME_CONSTANTS.currentFontSizeIndex,
        currentGameLanguage = currentGameLanguage,
        -- skillSystem cooldowns
        skillCooldowns = {
            attack = skillSystem.attack.cooldown,
            defend = skillSystem.defend.cooldown,
            special = skillSystem.special.cooldown,
            heal = skillSystem.heal.cooldown,
        }
    }

    local saveFile = "savegame.sav"
    local success, err = love.filesystem.write(saveFile, table_to_string(saveData))
    if success then
        print("[SAVE GAME] Game saved successfully to " .. saveFile)
        battleState.message = GameData.getText(currentGameLanguage, "game_saved_success")
        battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
    else
        print("[SAVE GAME] Failed to save game: " .. tostring(err))
        battleState.message = GameData.getText(currentGameLanguage, "game_saved_fail")
        battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
    end
end

-- NEW: Load Game Function
function loadGame()
    local saveFile = "savegame.sav"
    if not love.filesystem.isFile(saveFile) then
        print("[LOAD GAME] No save file found.")
        battleState.message = GameData.getText(currentGameLanguage, "game_load_no_file")
        battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
        return false
    end

    local success, content = love.filesystem.read(saveFile)
    if not success then
        print("[LOAD GAME] Failed to read save file: " .. tostring(content))
        battleState.message = GameData.getText(currentGameLanguage, "game_load_fail")
        battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
        return false
    end

    -- Use load to parse the Lua table string
    local loadedChunk, err = load("return " .. content, "savegame.sav")
    if not loadedChunk then
        print("[LOAD GAME] Failed to parse save data: " .. tostring(err))
        battleState.message = GameData.getText(currentGameLanguage, "game_load_corrupt")
        battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
        return false
    end
    local data = loadedChunk() -- Execute the loaded chunk to get the table

    -- Apply loaded data to global variables
    if data.player then
        player.hp = data.player.hp or player.hp
        player.maxHp = data.player.maxHp or player.maxHp
        player.mp = data.player.mp or player.mp
        player.maxMp = data.player.maxMp or player.maxMp
        player.level = data.player.level or player.level
        player.exp = data.player.exp or player.exp
        player.expToNextLevel = data.player.expToNextLevel or player.expToNextLevel
        player.attack = data.player.attack or player.attack
        player.defense = data.player.defense or player.defense
        player.critRate = data.player.critRate or player.critRate
        player.critDamage = data.player.critDamage or player.critDamage
        -- Re-initialize other player properties as they are runtime/resource related
        player.image = resources.images.playerStand
        player.isDefending = false
        player.status = {}
        player.combo = 0
    end

    if data.currentState then
        currentState.currentLevel = data.currentState.currentLevel or 1
        currentState.dialogueIndex = data.currentState.dialogueIndex or 1
        -- Call GameData to load story state, which also loads relationships
        GameData.loadStoryState(currentState.currentLevel, currentState.dialogueIndex)
        print("[LOAD GAME] Story state loaded to level " .. currentState.currentLevel .. ", dialogue index " .. currentState.dialogueIndex)
    end

    if data.playerSettings then
        playerSettings.isCheatMode = data.playerSettings.isCheatMode or false
        playerSettings.isInfiniteHP = data.playerSettings.isInfiniteHP or false
        playerSettings.isFullScreen = data.playerSettings.isFullScreen or false
    end

    if data.audioState then
        audioState.isMutedBGM = data.audioState.isMutedBGM or false
        audioState.isMutedSFX = data.audioState.isMutedSFX or false
    end

    currentResolutionIndex = data.currentResolutionIndex or 1
    GAME_CONSTANTS.currentFontSizeIndex = data.currentFontSizeIndex or 2
    currentGameLanguage = data.currentGameLanguage or "en"

    -- Apply settings changes that require re-initialization
    setCurrentLanguage(currentGameLanguage)
    applyFontSizeChange()
    applyResolutionChange()
    
    -- Apply skill cooldowns
    if data.skillCooldowns then
        skillSystem.attack.cooldown = data.skillCooldowns.attack or 0
        skillSystem.defend.cooldown = data.skillCooldowns.defend or 0
        skillSystem.special.cooldown = data.skillCooldowns.special or 0
        skillSystem.heal.cooldown = data.skillCooldowns.heal or 0
    end

    -- After loading, transition to menu and reset relevant battle state
    transitionGameState(nil, "menu")
    -- Reset battleState messages etc. to avoid lingering messages from before load
    battleState.message = ""
    battleState.messageTimer = 0

    print("[LOAD GAME] Game loaded successfully.")
    battleState.message = GameData.getText(currentGameLanguage, "game_loaded_success")
    battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
    return true
end