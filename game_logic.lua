-- game_logic.lua
-- This file contains core game mechanics, calculations, and helper functions.

local GameData = require("game_data") -- GameData is needed here for item/quest definitions

local M = {} -- Module table to export functions and variables

-- Global references (will be set by main.lua's setGlobals function)
local player, enemy, resources, animations, battleState, uiState, pauseState,
      resultState, menuState, optionsState, storyPageState, aboutPageState, howToPlayState,
      inventoryState, questLogState, statsScreenState,
      GAME_CONSTANTS, playerSettings, audioState,
      screenWidth, screenHeight, availableResolutions, currentResolutionIndex,
      uiMessage, uiMessageTimer

M.skillInfo = {}
M.skillSystem = {} -- Will be populated in setGlobals
M.enemyData = {} -- Will be populated in setGlobals
M.battleBackgrounds = {} -- Will be populated in setGlobals
M.enemyAI = {} -- Will be populated in setGlobals
M.positions = {} -- Will be populated in setGlobals
M.EQUIPPABLE_STATS = {"attack", "defense", "maxHp", "maxMp", "critRate", "critDamage"}


function M.setGlobals(
    p, e, r, a, bs, us, ps, rs, ms, os, sps, aps, htps, is, qls, sss,
    gc, ps_settings, as, sw, sh, ar, cri, uim, uimt
)
    player = p
    enemy = e
    resources = r
    animations = a
    battleState = bs
    uiState = us
    us.showSkillInfo = false -- Ensure this is reset on load/init
    us.selectedSkill = 1

    pauseState = ps
    resultState = rs
    menuState = ms
    optionsState = os
    storyPageState = sps
    aboutPageState = aps
    howToPlayState = htps
    inventoryState = is
    questLogState = qls
    statsScreenState = sss
    GAME_CONSTANTS = gc 
    playerSettings = ps_settings
    audioState = as
    screenWidth = sw
    screenHeight = sh
    availableResolutions = ar
    currentResolutionIndex = cri
    uiMessage = uim
    uiMessageTimer = uimt

    M.skillInfo = {
        { key = "attack",  name = "Basic Attack",   description = "A basic attack skill.",   details = "Deal small physical damage to enemy.",        type = "offensive", icon = "skillAttack",  mpCost = 0 },
        { key = "defend",  name = "Defend",         description = "Enter defensive stance.", details = "Increase defense to reduce incoming damage.", type = "defensive", icon = "skillDefend",  mpCost = 0 },
        { key = "special", name = "Special Attack", description = "Powerful special attack.", details = "Deal large physical damage but requires preparation.", type = "offensive", icon = "skillSpecial", mpCost = 20 },
        { key = "heal",    name = "Heal",           description = "Restore HP.",             details = "Heal yourself based on character attributes.",    type = "support",   icon = "skillHeal",    mpCost = 15 }
    }

    M.skillSystem = {
      attack = { cooldown = 0, maxCooldown = GAME_CONSTANTS.COOLDOWN.ATTACK },
      defend = { cooldown = 0, maxCooldown = GAME_CONSTANTS.COOLDOWN.DEFEND },
      special = { cooldown = 0, maxCooldown = GAME_CONSTANTS.COOLDOWN.SPECIAL },
      heal = { cooldown = 0, maxCooldown = GAME_CONSTANTS.COOLDOWN.HEAL }
    }

    M.enemyData = {
      [1] = { image = "enemy_level1_stand", attackImage = "enemy_level1_attack", hp = 20, maxHp = 20, attack = 5, defense = 2, critRate = 4, critDamage = 1.2, ai = "basic", expReward = 25, displayNameKey = "enemy_name_goblin" },
      [2] = { image = "enemy_level2_stand", attackImage = "enemy_level2_attack", hp = 30, maxHp = 30, attack = 6, defense = 3, critRate = 4, critDamage = 1.2, ai = "basic", expReward = 35, displayNameKey = "enemy_name_orc" },
      [3] = { image = "enemy_level3_stand", attackImage = "enemy_level3_attack", hp = 40, maxHp = 40, attack = 7, defense = 4, critRate = 5, critDamage = 1.25, ai = "basic", expReward = 50, displayNameKey = "enemy_name_stonegolem" },
      [4] = { image = "enemy_level4_stand", attackImage = "enemy_level4_attack", hp = 50, maxHp = 50, attack = 8, defense = 5, critRate = 5, critDamage = 1.25, ai = "basic", expReward = 60, displayNameKey = "enemy_name_skeletonwarrior" },
      [5] = { image = "enemy_level5_stand", attackImage = "enemy_level5_attack", hp = 70, maxHp = 70, attack = 9, defense = 6, critRate = 6, critDamage = 1.3, ai = "basic", expReward = 80, displayNameKey = "enemy_name_darkknight" },
      [6] = { image = "enemy_level6_stand", attackImage = "enemy_level6_attack", hp = 90, maxHp = 90, attack = 10, defense = 7, critRate = 6, critDamage = 1.3, ai = "basic", expReward = 100, displayNameKey = "enemy_name_banshee" },
      [7] = { image = "enemy_level7_stand", attackImage = "enemy_level7_attack", hp = 110, maxHp = 110, attack = 11, defense = 8, critRate = 7, critDamage = 1.35, ai = "basic", expReward = 120, displayNameKey = "enemy_name_minotaur" },
      [8] = { image = "enemy_level8_stand", attackImage = "enemy_level8_attack", hp = 130, maxHp = 130, attack = 12, defense = 9, critRate = 7, critDamage = 1.35, ai = "basic", expReward = 140, displayNameKey = "enemy_name_greendragon" },
      [9] = { image = "enemy_level9_stand", attackImage = "enemy_level9_attack", hp = 150, maxHp = 150, attack = 13, defense = 10, critRate = 8, critDamage = 1.4, ai = "basic", expReward = 160, displayNameKey = "enemy_name_reddragon" },
      [10] = { image = "enemy_level10_stand", attackImage = "enemy_level10_attack", hp = 200, maxHp = 200, attack = 20, defense = 12, critRate = 15, critDamage = 1.75, ai = "tactical", expReward = 500, displayNameKey = "enemy_name_demonking" }
    }

    M.battleBackgrounds = {
      [1] = "battleBgForest", [2] = "battleBgForest", [3] = "battleBgCave", [4] = "battleBgCave",
      [5] = "battleBgDungeon", [6] = "battleBgDungeon", [7] = "battleBgCastle", [8] = "battleBgCastle",
      [9] = "battleBgCastle", [10] = "battleBgCastle"
    }

    M.enemyAI = {
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

    -- Initialize positions here, but don't set animation x/y yet,
    -- as that depends on the images being loaded.
    -- The actual animation x/y will be set in main.lua's applyResolutionChange
    -- after resources are loaded.
    M.positions.player = {
        x = screenWidth * 0.25,
        y = screenHeight * 0.5,
        scale = 1.0,
        maxWidth = screenWidth * 0.4,
        maxHeight = screenHeight * 0.6,
        minHeight = screenHeight * 0.2,
    }
    M.positions.enemy = {
        x = screenWidth * 0.75,
        y = screenHeight * 0.5,
        scale = 1.0,
        maxWidth = screenWidth * 0.4,
        maxHeight = screenHeight * 0.6,
        minHeight = screenHeight * 0.2,
    }
    M.positions.playerHP = {x = screenWidth * 0.02, y = screenHeight * 0.02}
    M.positions.enemyHP = {x = screenWidth * 0.78, y = screenHeight * 0.02}
    M.positions.playerUI = {x = screenWidth * 0.02, y = screenHeight * 0.75}
    M.positions.enemyUI = {x = screenWidth * 0.68, y = screenHeight * 0.75}

end

-- Timer System (moved from main.lua)
M.TimerSystem = {
    timers = {},
    nextId = 1
}

local TIMER_STATE = {
    ACTIVE = "active",
    PAUSED = "paused",
    CANCELLED = "cancelled"
}
M.TIMER_GROUPS = {
    BATTLE = "battle",
    ANIMATION = "animation",
    UI = "ui",
    GLOBAL = "global"
}

function M.TimerSystem.create(duration, callback, group)
    local id = M.TimerSystem.nextId
    M.TimerSystem.nextId = M.TimerSystem.nextId + 1
    M.TimerSystem.timers[id] = {
        duration = duration,
        remaining = duration,
        callback = callback,
        state = TIMER_STATE.ACTIVE,
        group = group or M.TIMER_GROUPS.GLOBAL
    }
    return id
end

function M.TimerSystem.cancel(id)
    local timer = M.TimerSystem.timers[id]
    if timer then
        timer.state = TIMER_STATE.CANCELLED
    end
end

function M.TimerSystem.pause(id)
    local timer = M.TimerSystem.timers[id]
    if timer and timer.state == TIMER_STATE.ACTIVE then
        timer.state = TIMER_STATE.PAUSED
    end
end

function M.TimerSystem.resume(id)
    local timer = M.TimerSystem.timers[id]
    if timer and timer.state == TIMER_STATE.PAUSED then
        timer.state = TIMER_STATE.ACTIVE
    end
end

function M.TimerSystem.pauseGroup(group)
    for id, timer in pairs(M.TimerSystem.timers) do
        if timer.group == group and timer.state == TIMER_STATE.ACTIVE then
            timer.state = TIMER_STATE.PAUSED
        end
    end
end

function M.TimerSystem.resumeGroup(group)
    for id, timer in pairs(M.TimerSystem.timers) do
        if timer.group == group and timer.state == TIMER_STATE.PAUSED then
            timer.state = TIMER_STATE.ACTIVE
        end
    end
end

function M.TimerSystem.update(dt)
    for id, timer in pairs(M.TimerSystem.timers) do
        if timer.state == TIMER_STATE.ACTIVE then
            timer.remaining = timer.remaining - dt
            if timer.remaining <= 0 then
                if timer.callback then
                    timer.callback()
                end
                M.TimerSystem.timers[id] = nil
            end
        end
    end
end

-- Game Constants and Data (some moved from main.lua)
M.VALID_GAME_STATES = {
    menu = true, battle = true, story = true, pause = true, victory = true, defeat = true,
    options = true, storyPage = true, levelSelect = true, aboutPage = true,
    inventoryScreen = true, questLogScreen = true, statsScreen = true, ending = true,
    howToPlay = true
}

M.VALID_BATTLE_PHASES = {
    select = true, action = true, result = true
}

-- Helper Functions
function M.validateNumber(value, min, max, default)
    if type(value) ~= "number" or value ~= value then
        return default
    end
    return math.max(min, math.min(max, value))
end

function M.validateGameState(state)
    if not M.VALID_GAME_STATES[state] then
        print("[ERROR] Invalid game state: " .. tostring(state))
        return "menu"
    end
    return state
end

function M.validateBattlePhase(phase)
    if not M.VALID_BATTLE_PHASES[phase] then
        print("[ERROR] Invalid battle phase: " .. tostring(phase))
        return "select"
    end
    return phase
end

function M.loadResource(loadFunc, resourceType, assetPath, ...)
  local success, resource = pcall(loadFunc, assetPath, ...)
  if success then
    print(string.format("[RESOURCE] Loaded %s: %s", resourceType, assetPath))
    return resource
  else
    print(string.format("[ERROR] Failed to load %s: %s - %s", resourceType, assetPath, resource))
    return nil
  end
end

function M.loadImage(assetPath)
  return M.loadResource(love.graphics.newImage, "image", assetPath)
end

function M.loadSound(assetPath, type)
  return M.loadResource(love.audio.newSource, "sound", assetPath, type)
end

function M.loadFont(assetPath, size)
  return M.loadResource(love.graphics.newFont, "font", assetPath, size)
end

function M.loadAllResources(res, pos)
    print("[GAME] Loading all resources...")
    res.images.background = M.loadImage("assets/background.png")
    res.images.dialogBox = M.loadImage("assets/dialog-box.png")
    res.images.uiFrame = M.loadImage("assets/battle-ui-frame.png")
    res.images.playerStand = M.loadImage("assets/player-stand.png")
    res.images.playerAttack = M.loadImage("assets/player-attack.png")
    res.images.battleBgForest = M.loadImage("assets/battle-bg-forest.png")
    res.images.battleBgCave = M.loadImage("assets/battle-bg-cave.png")
    res.images.battleBgDungeon = M.loadImage("assets/battle-bg-dungeon.png")
    res.images.battleBgCastle = M.loadImage("assets/battle-bg-castle.png")
    res.images.hitEffect = M.loadImage("assets/effect-hit.png")
    res.images.defendEffect = M.loadImage("assets/effect-defend.png")
    res.images.skillDefend = M.loadImage("assets/skill-defend.png")
    res.images.skillSpecial = M.loadImage("assets/skill-special.png")
    res.images.skillHeal = M.loadImage("assets/skill-heal.png")
    res.images.skillAttack = M.loadImage("assets/skill-attack.png")
    res.images.cooldownOverlay = M.loadImage("assets/cooldown-overlay.png")
    res.images.portraitHero = M.loadImage("assets/portrait-hero.png")
    res.images.portraitKing = M.loadImage("assets/portrait-king.png")
    res.images.portraitPrincess = M.loadImage("assets/portrait-princess.png")
    res.images.portraitDemonKing = M.loadImage("assets/portrait-demonking.png")
    res.images.enemyDemonKing = M.loadImage("assets/enemy-demonking.png")
    res.images.enemy_level1_stand = M.loadImage("assets/enemy_level1_stand.png")
    res.images.enemy_level1_attack = M.loadImage("assets/enemy_level1_attack.png")
    res.images.enemy_level2_stand = M.loadImage("assets/enemy_level2_stand.png")
    res.images.enemy_level2_attack = M.loadImage("assets/enemy_level2_attack.png")
    res.images.enemy_level3_stand = M.loadImage("assets/enemy_level3_stand.png")
    res.images.enemy_level3_attack = M.loadImage("assets/enemy_level3_attack.png")
    res.images.enemy_level4_stand = M.loadImage("assets/enemy_level4_stand.png")
    res.images.enemy_level4_attack = M.loadImage("assets/enemy_level4_attack.png")
    res.images.enemy_level5_stand = M.loadImage("assets/enemy_level5_stand.png")
    res.images.enemy_level5_attack = M.loadImage("assets/enemy_level5_attack.png")
    res.images.enemy_level6_stand = M.loadImage("assets/enemy_level6_stand.png")
    res.images.enemy_level6_attack = M.loadImage("assets/enemy_level6_attack.png")
    res.images.enemy_level7_stand = M.loadImage("assets/enemy_level7_stand.png")
    res.images.enemy_level7_attack = M.loadImage("assets/enemy_level7_attack.png")
    res.images.enemy_level8_stand = M.loadImage("assets/enemy_level8_stand.png")
    res.images.enemy_level8_attack = M.loadImage("assets/enemy_level8_attack.png")
    res.images.enemy_level9_stand = M.loadImage("assets/enemy_level9_stand.png")
    res.images.enemy_level9_attack = M.loadImage("assets/enemy_level9_attack.png")
    res.images.enemy_level10_stand = M.loadImage("assets/enemy_level10_stand.png")
    res.images.enemy_level10_attack = M.loadImage("assets/enemy_level10_attack.png")
    res.images.authorPortrait = M.loadImage("assets/author_portrait.png")

    res.sounds.crit = M.loadSound("assets/crit.mp3", "static")
    res.sounds.attack = M.loadSound("assets/attack.mp3", "static")
    res.sounds.heal = M.loadSound("assets/heal.mp3", "static")
    res.sounds.special = M.loadSound("assets/special.mp3", "static")
    res.sounds.defend = M.loadSound("assets/defend.mp3", "static")
    res.sounds.victory = M.loadSound("assets/victory.mp3", "static")
    res.sounds.defeat = M.loadSound("assets/defeat.mp3", "static")
    res.sounds.menuBgm = M.loadSound("assets/menu.mp3", "stream")
    res.sounds.battleBgm = M.loadSound("assets/battle.mp3", "stream")
    res.sounds.attackLight = M.loadSound("assets/attack-light.mp3", "static")
    res.sounds.attackHeavy = M.loadSound("assets/attack-heavy.mp3", "static")
    res.sounds.enemyHit1 = M.loadSound("assets/enemy-hit1.mp3", "static")
    res.sounds.enemyHit2 = M.loadSound("assets/enemy-hit2.mp3", "static")
    res.sounds.palaceTheme = M.loadSound("assets/palaceTheme.mp3", "stream")
    res.sounds.finalBattle = M.loadSound("assets/finalBattle.mp3", "stream")
    res.sounds.menuSelect = M.loadSound("assets/menu_select.wav", "static")

    res.particleSystems.hit = function()
      local ps = love.graphics.newParticleSystem(res.images.hitEffect, 100)
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
    res.particleSystems.defend = function()
      local ps = love.graphics.newParticleSystem(res.images.defendEffect, 100)
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
    res.particleSystems.heal = res.particleSystems.defend -- Use same particle system for heal

    -- DO NOT set animations.player.x/y or positions here.
    -- These are global variables in main.lua and should be initialized there
    -- or updated by main.lua's applyResolutionChange after setGlobals.

    print("[GAME] Resources loaded")
end

function M.isPointInRect(x, y, rect)
    if not rect or not rect.x or not rect.y or not rect.width or not rect.height then
        return false
    end
    return x >= rect.x and x <= rect.x + rect.width and
           y >= rect.y and y <= rect.y + rect.height
end

function M.isInArray(array, value)
    for _, v in ipairs(array) do
        if v == value then return true end
    end
    return false
end

function M.recalculatePlayerStats()
    print("[STATS] Recalculating player stats (HP/MP adjustment)...")

    if player.maxHp <= 0 then player.maxHp = 1 end
    player.hp = math.min(player.hp, player.maxHp)
    player.hp = math.max(0, player.hp)

    if player.maxMp <= 0 then player.maxMp = 1 end
    player.mp = math.min(player.mp, player.maxMp)
    player.mp = math.max(0, player.mp)

    print(string.format("[STATS] Player stats after HP/MP adjustment: HP %d/%d, MP %d/%d", player.hp, player.maxHp, player.mp, player.maxMp))
end

function M.restartGame(currentState, currentLevel, selectedGrindingLevelKey)
    print("[GAME] Restarting game...")
    player.hp = player.maxHp
    player.mp = player.maxMp
    player.isDefending = false
    player.combo = 0
    print("[GAME] Player settings reset")

    local currentEnemyDefinition
    local enemyDisplayNameKey
    local enemyImageKey
    local enemyAttackImageKey

    if currentState.isGrinding and selectedGrindingLevelKey then
        print("[GAME] Setting up grinding level: " .. selectedGrindingLevelKey)
        local grindingLevelData = GameData.grindingLevels[selectedGrindingLevelKey]
        if not grindingLevelData then
            print("[ERROR] Failed to load grinding level data for ID: " .. selectedGrindingLevelKey)
            return
        end
        if not grindingLevelData.enemyPool or #grindingLevelData.enemyPool == 0 then
            print("[ERROR] Grinding level " .. selectedGrindingLevelKey .. " has an empty or undefined enemyPool.")
            return
        end
        local randomEnemyKey = grindingLevelData.enemyPool[math.random(#grindingLevelData.enemyPool)]
        currentEnemyDefinition = M.enemyData[randomEnemyKey]
        if not currentEnemyDefinition then
            print("[ERROR] Failed to load enemy data for key: " .. randomEnemyKey .. " from grinding pool.")
            return
        end
        enemyImageKey = currentEnemyDefinition.image
        enemyAttackImageKey = currentEnemyDefinition.attackImage or currentEnemyDefinition.image
        enemyDisplayNameKey = currentEnemyDefinition.displayNameKey
        print("[GAME] Selected enemy for grinding: " .. randomEnemyKey .. " (Image: " .. enemyImageKey .. ", AttackImage: " .. (enemyAttackImageKey or "N/A") .. ")")
    else
        print("[GAME] Setting up regular level: " .. currentLevel)
        currentEnemyDefinition = M.enemyData[currentLevel]
        if not currentEnemyDefinition then
            print("[ERROR] Failed to load enemy data for regular level: " .. tostring(currentLevel))
            return
        end
        enemyImageKey = currentEnemyDefinition.image
        enemyAttackImageKey = currentEnemyDefinition.attackImage or currentEnemyDefinition.image
        enemyDisplayNameKey = currentEnemyDefinition.displayNameKey
        print("[GAME] Enemy for regular level " .. currentLevel .. ": Image: " .. enemyImageKey .. ", AttackImage: " .. (enemyAttackImageKey or "N/A"))
    end

    enemy.x = M.positions.enemy.x
    enemy.y = M.positions.enemy.y
    enemy.image = resources.images[enemyImageKey]
    enemy.hp = M.validateNumber(currentEnemyDefinition.hp, GAME_CONSTANTS.HP.MIN, GAME_CONSTANTS.HP.MAX, GAME_CONSTANTS.HP.BASE)
    enemy.maxHp = M.validateNumber(currentEnemyDefinition.maxHp, GAME_CONSTANTS.HP.MIN, GAME_CONSTANTS.HP.MAX, GAME_CONSTANTS.HP.BASE)
    enemy.attack = M.validateNumber(currentEnemyDefinition.attack, 1, math.huge, 10)
    enemy.defense = M.validateNumber(currentEnemyDefinition.defense, 0, math.huge, 5)
    enemy.critRate = M.validateNumber(currentEnemyDefinition.critRate, 0, GAME_CONSTANTS.MAX_CRIT_RATE, GAME_CONSTANTS.BASE_CRIT_RATE)
    enemy.critDamage = M.validateNumber(currentEnemyDefinition.critDamage, 1, GAME_CONSTANTS.MAX_CRIT_DAMAGE, GAME_CONSTANTS.BASE_CRIT_DAMAGE)
    enemy.isDefending = false
    enemy.status = {}
    enemy.combo = 0
    enemy.displayNameKey = enemyDisplayNameKey
    enemy.attackImageKey = enemyAttackImageKey

    if currentState.isGrinding then
        print("[GAME] Enemy settings loaded for grinding level " .. selectedGrindingLevelKey)
    else
        print("[GAME] Enemy settings loaded for regular level " .. currentLevel)
    end

    battleState.phase = "select"
    battleState.turn = "player"
    battleState.message = GameData.getText(GameData.getCurrentLanguage(), "battle_start") -- Use GameData.getCurrentLanguage()
    battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
    battleState.options = {
        {name = "Attack", description = "Deal damage to enemy"},
        {name = "Defend", description = "Reduce incoming damage"},
        {name = "Special", description = "Powerful attack with delay"},
        {name = "Heal", description = "Restore health"},
    }
    battleState.currentOption = 1
    battleState.buttonAreas = {}
    battleState.effects = {}
    battleState.victoryTriggered = false
    battleState.defeatTriggered = false
    battleState.leaveGrindingButtonArea = nil

    for _, skill in pairs(M.skillSystem) do
        skill.cooldown = 0
    end
    print("[GAME] Battle state reset")

    animations.player.current = "stand"
    animations.player.timer = 0
    animations.player.x = M.positions.player.x
    animations.player.y = M.positions.player.y
    animations.player.originalX = M.positions.player.x
    animations.enemy.current = "stand"
    animations.enemy.timer = 0
    animations.enemy.x = M.positions.enemy.x
    animations.enemy.y = M.positions.enemy.y
    animations.enemy.originalX = M.positions.enemy.x
    animations.effects = {}
    print("[GAME] Animations reset")
end

function M.calculateHeal(character)
  local healAmount = math.floor(character.maxHp * GAME_CONSTANTS.HP.HEAL_PERCENT)
  return M.validateNumber(healAmount, 1, character.maxHp, 1)
end

function M.calculateDamage(attacker, defender)
    local attack = M.validateNumber(attacker.attack, 1, 9999, GAME_CONSTANTS.MIN_DAMAGE)
    local defense = M.validateNumber(defender.defense, 0, 9999, 0)
    local baseDamage = attack * (GAME_CONSTANTS.DEFENSE_SCALING / (GAME_CONSTANTS.DEFENSE_SCALING + defense))
    local randomMod = 1 + math.random(
        GAME_CONSTANTS.DAMAGE_RANDOM_MIN * 100,
        GAME_CONSTANTS.DAMAGE_RANDOM_MAX * 100
    ) / 100
    local damage = baseDamage * randomMod
    local critRate = M.validateNumber(attacker.critRate, 0, GAME_CONSTANTS.MAX_CRIT_RATE, GAME_CONSTANTS.BASE_CRIT_RATE)
    local isCrit = math.random(1, 100) <= critRate
    if isCrit then
        local critDmg = M.validateNumber(attacker.critDamage, 1, GAME_CONSTANTS.MAX_CRIT_DAMAGE, GAME_CONSTANTS.BASE_CRIT_DAMAGE)
        damage = damage * critDmg
    end
    damage = M.validateNumber(
        math.floor(damage),
        GAME_CONSTANTS.MIN_DAMAGE,
        attack * GAME_CONSTANTS.MAX_DAMAGE_MULTIPLIER,
        GAME_CONSTANTS.MIN_DAMAGE
    )
    if attacker == player and playerSettings.isCheatMode then
        damage = defender.hp + 1000 -- Instant kill for cheat mode
    end
    if defender == player and playerSettings.isInfiniteHP then
        damage = 0
        print("[CHEAT] Player took 0 damage (Infinite HP active).")
    end
    return damage, isCrit
end

function M.grantExp(amount)
    player.exp = player.exp + amount
    battleState.message = GameData.getText(GameData.getCurrentLanguage(), "battle_msg_exp_gain", {exp = amount})
    battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
    print("[GAME] Player gained " .. amount .. " EXP. Current EXP: " .. player.exp)
    M.checkLevelUp()
end

function M.checkLevelUp()
    while player.exp >= player.expToNextLevel do
        player.exp = player.exp - player.expToNextLevel
        player.level = player.level + 1
        player.expToNextLevel = math.floor(player.expToNextLevel * 1.5)

        player.maxHp = player.maxHp + 10
        player.hp = player.hp + 10
        player.maxMp = player.maxMp + 5
        player.mp = player.mp + 5
        player.attack = player.attack + 2
        player.defense = player.defense + 1
        player.critRate = math.min(GAME_CONSTANTS.MAX_CRIT_RATE, player.critRate + 0.5)
        player.critDamage = math.min(GAME_CONSTANTS.MAX_CRIT_DAMAGE, player.critDamage + 0.05)

        battleState.message = GameData.getText(GameData.getCurrentLanguage(), "battle_msg_level_up", {level = player.level})
        battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION + 1
        print(string.format("[GAME] Player leveled up to LV %d! HP: %d/%d, MP: %d/%d, ATK: %d, DEF: %d, CRT: %.1f, CRD: %.2f",
                            player.level, player.hp, player.maxHp, player.mp, player.maxMp, player.attack, player.defense, player.critRate, player.critDamage))
    end
end

-- Inventory Management Functions
function M.addItemToInventory(itemId, quantity)
    if not itemId or not quantity or quantity <= 0 then
        print("[INVENTORY ERROR] Invalid itemId or quantity for addItemToInventory.")
        return false
    end

    local itemData = GameData.items[itemId]
    if not itemData then
        print("[INVENTORY ERROR] Item data not found for itemId: " .. itemId)
        return false
    end

    local remainingQuantity = quantity

    if itemData.stackable then
        for i = 1, player.inventoryCapacity do
            local slot = player.inventory[i]
            if slot and slot.itemId == itemId and slot.quantity < itemData.maxStack then
                local canAdd = itemData.maxStack - slot.quantity
                if remainingQuantity <= canAdd then
                    slot.quantity = slot.quantity + remainingQuantity
                    remainingQuantity = 0
                    print("[INVENTORY] Added " .. quantity .. " of " .. itemId .. " to existing stack in slot " .. i)
                    return true
                else
                    slot.quantity = itemData.maxStack
                    remainingQuantity = remainingQuantity - canAdd
                    print("[INVENTORY] Filled stack in slot " .. i .. " with " .. itemId .. ". Remaining: " .. remainingQuantity)
                end
            end
            if remainingQuantity == 0 then return true end
        end
    end

    if remainingQuantity > 0 then
        for i = 1, player.inventoryCapacity do
            if player.inventory[i] == nil then
                if itemData.stackable then
                    local amountToAdd = math.min(remainingQuantity, itemData.maxStack)
                    player.inventory[i] = {itemId = itemId, quantity = amountToAdd}
                    remainingQuantity = remainingQuantity - amountToAdd
                    print("[INVENTORY] Added " .. amountToAdd .. " of " .. itemId .. " to new slot " .. i)
                else
                    player.inventory[i] = {itemId = itemId, quantity = 1}
                    remainingQuantity = remainingQuantity - 1
                    print("[INVENTORY] Added 1 of non-stackable " .. itemId .. " to new slot " .. i)
                end
                if remainingQuantity == 0 then
                    return true
                end
            end
        end
    end

    if remainingQuantity > 0 then
        print("[INVENTORY] Inventory full. Could not add " .. remainingQuantity .. " of " .. itemId)
        uiMessage = GameData.getText(GameData.getCurrentLanguage(), "inventory_full")
        uiMessageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
        return false
    end
    return true
end

function M.removeItemFromInventory(slotIndex, quantityToRemove)
    if not slotIndex or slotIndex < 1 or slotIndex > player.inventoryCapacity then
        print("[INVENTORY ERROR] Invalid slotIndex for removeItemFromInventory: " .. tostring(slotIndex))
        return false
    end

    local slot = player.inventory[slotIndex]
    if not slot then
        print("[INVENTORY ERROR] No item found in slot " .. slotIndex .. " to remove.")
        return false
    end

    local itemData = GameData.items[slot.itemId]
    if not itemData then
        print("[INVENTORY ERROR] Item data not found for item in slot " .. slotIndex .. " (itemId: " .. slot.itemId .. ")")
        player.inventory[slotIndex] = nil
        return false
    end

    if not itemData.stackable or quantityToRemove >= slot.quantity then
        print("[INVENTORY] Removing item " .. slot.itemId .. " from slot " .. slotIndex)
        player.inventory[slotIndex] = nil
    else
        slot.quantity = slot.quantity - quantityToRemove
        print("[INVENTORY] Removed " .. quantityToRemove .. " of " .. slot.itemId .. " from slot " .. slotIndex .. ". Remaining: " .. slot.quantity)
    end
    return true
end

function M.useItem(slotIndex)
    if not slotIndex or slotIndex < 1 or slotIndex > player.inventoryCapacity then
        print("[INVENTORY ERROR] Invalid slotIndex for useItem: " .. tostring(slotIndex))
        return
    end

    local itemInSlot = player.inventory[slotIndex]
    if not itemInSlot then
        print("[INVENTORY ERROR] No item in slot " .. slotIndex .. " to use.")
        uiMessage = GameData.getText(GameData.getCurrentLanguage(), "inventory_empty_slot")
        uiMessageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
        return
    end

    local itemData = GameData.items[itemInSlot.itemId]
    if not itemData then
        print("[INVENTORY ERROR] Item data not found for " .. itemInSlot.itemId .. " in slot " .. slotIndex)
        uiMessage = GameData.getText(GameData.getCurrentLanguage(), "error_unknown_item_data")
        uiMessageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
        return
    end

    print("[INVENTORY] Attempting to use item " .. itemInSlot.itemId .. " from slot " .. slotIndex)

    if itemData.type == "consumable" then
        local itemUsedSuccessfully = false
        if itemData.effects then
            for _, effect in ipairs(itemData.effects) do
                if effect.type == "heal" then
                    if player.hp < player.maxHp then
                        local healAmount = effect.amount or 0
                        player.hp = math.min(player.maxHp, player.hp + healAmount)
                        local itemNameText = GameData.getText(GameData.getCurrentLanguage(), itemData.name_key)

                        uiMessage = string.format(GameData.getText(GameData.getCurrentLanguage(), "item_used_heal"), itemNameText, healAmount)
                        uiMessageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION

                        print(string.format("[INVENTORY] Player used %s. Healed %d HP. Current HP: %d/%d", itemInSlot.itemId, healAmount, player.hp, player.maxHp))

                        if resources.sounds.heal and not audioState.isMutedSFX then
                            resources.sounds.heal:play()
                        end
                        local healPS = resources.particleSystems.heal()
                        if healPS then
                            healPS:emit(100)
                            table.insert(battleState.effects, {
                                type = "heal",
                                x = animations.player.x,
                                y = animations.player.y,
                                particleSystem = healPS,
                                timer = GAME_CONSTANTS.TIMER.EFFECT_DURATION
                            })
                        end
                        table.insert(battleState.effects, {
                            type = "damage",
                            amount = "+" .. tostring(healAmount),
                            x = animations.player.x,
                            y = animations.player.y - 50,
                            timer = 1,
                            color = {0, 1, 0}
                        })
                        itemUsedSuccessfully = true
                    else
                        uiMessage = GameData.getText(GameData.getCurrentLanguage(), "item_heal_hp_full")
                        uiMessageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
                        print("[INVENTORY] Player HP is full. Cannot use " .. itemInSlot.itemId)
                        return
                    end
                end
            end
        else
            print("[INVENTORY] Consumable item " .. itemInSlot.itemId .. " has no defined effects.")
            uiMessage = GameData.getText(GameData.getCurrentLanguage(), "item_no_effect", {item = GameData.getText(GameData.getCurrentLanguage(), itemData.name_key)})
            uiMessageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
        end

        if itemUsedSuccessfully then
            M.removeItemFromInventory(slotIndex, 1)
        end
    else
        print("[INVENTORY] Item " .. itemInSlot.itemId .. " is not a consumable.")
        uiMessage = GameData.getText(GameData.getCurrentLanguage(), "item_not_consumable", {item = GameData.getText(GameData.getCurrentLanguage(), itemData.name_key)})
        uiMessageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
    end
end

function M.equipItem(inventorySlotIndex)
    if not inventorySlotIndex or not player.inventory[inventorySlotIndex] then
        print("[EQUIP] Invalid inventory slot index or empty slot: " .. tostring(inventorySlotIndex))
        return false
    end

    local itemToEquip = player.inventory[inventorySlotIndex]
    local itemId = itemToEquip.itemId
    local itemData = GameData.items[itemId]

    if not itemData then
        print("[EQUIP] No item data found for: " .. itemId)
        return false
    end

    if itemData.type ~= "equipment" or not itemData.slot then
        print("[EQUIP] Item is not equippable: " .. itemId)
        uiMessage = GameData.getText(GameData.getCurrentLanguage(), "error_not_equippable", {item = GameData.getText(GameData.getCurrentLanguage(), itemData.name_key)})
        uiMessageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
        return false
    end

    local targetSlot = itemData.slot
    print("[EQUIP] Attempting to equip " .. itemId .. " to slot " .. targetSlot)

    if player.equipment[targetSlot] then
        print("[EQUIP] Slot " .. targetSlot .. " is occupied by " .. player.equipment[targetSlot] .. ". Attempting to unequip it.")
        local unequippedSuccessfully = M.unequipItem(targetSlot)
        if not unequippedSuccessfully then
            print("[EQUIP] Failed to unequip item from slot " .. targetSlot .. ". Cannot equip new item.")
            return false
        end
    end

    if itemData.stats then
        for statName, value in pairs(itemData.stats) do
            if M.isInArray(M.EQUIPPABLE_STATS, statName) then
                player[statName] = (player[statName] or 0) + value
                print(string.format("[EQUIP] Applied stat %s: %s%s to player. New value: %s", statName, (value > 0 and "+" or ""), value, player[statName]))
            end
        end
    end

    player.equipment[targetSlot] = itemId
    player.inventory[inventorySlotIndex] = nil

    M.recalculatePlayerStats()

    local itemName = GameData.getText(GameData.getCurrentLanguage(), itemData.name_key)
    uiMessage = GameData.getText(GameData.getCurrentLanguage(), "item_equipped", {item = itemName, slot = targetSlot})
    uiMessageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
    print("[EQUIP] Successfully equipped " .. itemId .. " to " .. targetSlot)
    return true
end

function M.unequipItem(equipmentSlotKey)
    if not equipmentSlotKey or not player.equipment[equipmentSlotKey] then
        print("[UNEQUIP] Invalid equipment slot key or no item in slot: " .. tostring(equipmentSlotKey))
        return false
    end

    local itemIdToUnequip = player.equipment[equipmentSlotKey]
    local itemData = GameData.items[itemIdToUnequip]

    if not itemData then
        print("[UNEQUIP] No item data for item to unequip: " .. itemIdToUnequip)
        player.equipment[equipmentSlotKey] = nil
        return true
    end
    print("[UNEQUIP] Attempting to unequip " .. itemIdToUnequip .. " from slot " .. equipmentSlotKey)

    if not M.addItemToInventory(itemIdToUnequip, 1) then
        print("[UNEQUIP] Inventory full. Cannot unequip " .. itemIdToUnequip)
        uiMessage = GameData.getText(GameData.getCurrentLanguage(), "error_inventory_full_unequip", {item = GameData.getText(GameData.getCurrentLanguage(), itemData.name_key)})
        uiMessageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
        return false
    end

    if itemData.stats then
        for statName, value in pairs(itemData.stats) do
            if M.isInArray(M.EQUIPPABLE_STATS, statName) then
                player[statName] = (player[statName] or 0) - value
                print(string.format("[UNEQUIP] Reverted stat %s: %s%s from player. New value: %s", statName, (value > 0 and "-" or "+"), value, player[statName]))
            end
        end
    end

    player.equipment[equipmentSlotKey] = nil

    M.recalculatePlayerStats()

    local itemName = GameData.getText(GameData.getCurrentLanguage(), itemData.name_key)
    uiMessage = GameData.getText(GameData.getCurrentLanguage(), "item_unequipped", {item = itemName, slot = equipmentSlotKey})
    uiMessageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
    print("[UNEQUIP] Successfully unequipped " .. itemIdToUnequip .. " from " .. equipmentSlotKey)
    return true
end

-- Battle Actions
function M.performPlayerAttack()
    if M.skillSystem.attack.cooldown > 0 then
        battleState.message = GameData.getText(GameData.getCurrentLanguage(), "battle_msg_skill_cooldown")
        battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
        print("[BATTLE] Attack skill on cooldown")
        return
    end
    if not audioState.isMutedSFX then
        resources.sounds.attack:play()
    end
    animations.player.current = "attack"
    local damage, isCrit = M.calculateDamage(player, enemy)
    enemy.hp = M.validateNumber(enemy.hp - damage, 0, enemy.maxHp, 0)
    local currentEnemyData = M.enemyData[GameData.story.currentState.currentLevel]
    local enemyImage = resources.images[currentEnemyData.image] or resources.images.enemyDemonKing
    local enemyDrawScale = math.min(M.positions.enemy.maxWidth / enemyImage:getWidth(), M.positions.enemy.maxHeight / enemyImage:getHeight())
    if enemyImage:getHeight() * enemyDrawScale < M.positions.enemy.minHeight then
        enemyDrawScale = M.positions.enemy.minHeight / enemyImage:getHeight()
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
        GameData.getText(GameData.getCurrentLanguage(), "battle_msg_player_crit", {damage = damage}) or
        GameData.getText(GameData.getCurrentLanguage(), "battle_msg_player_attack", {damage = damage})
    battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
    battleState.phase = "action"
    if enemy.hp <= 0 then
        battleState.phase = "result"
    else
        M.TimerSystem.create(GAME_CONSTANTS.TIMER.ACTION_DELAY, M.startEnemyTurn, M.TIMER_GROUPS.BATTLE)
    end
    M.skillSystem.attack.cooldown = M.skillSystem.attack.maxCooldown
end

function M.performPlayerHeal()
  print("[BATTLE ACTION] Player action: Heal")
  local skill = M.skillSystem.heal
  local skillData = M.skillInfo[4]
  if skill.cooldown > 0 then
    battleState.message = GameData.getText(GameData.getCurrentLanguage(), "battle_msg_skill_cooldown")
    battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
    print("[BATTLE] Heal skill on cooldown")
    return
  end
  if player.mp < skillData.mpCost then
      battleState.message = GameData.getText(GameData.getCurrentLanguage(), "battle_msg_not_enough_mp")
      battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
      print("[BATTLE] Not enough MP for Heal skill")
      return
  end
    if not audioState.isMutedSFX then
        resources.sounds.heal:play()
        print("[AUDIO] Played sound: heal")
    end
    player.mp = math.max(0, player.mp - skillData.mpCost)
    local healAmount = M.calculateHeal(player)
    player.hp = M.validateNumber(player.hp + healAmount, 0, player.maxHp, player.hp)
    local playerImage = resources.images.playerStand
    local playerDrawScale = math.min(M.positions.player.maxWidth / playerImage:getWidth(), M.positions.player.maxHeight / playerImage:getHeight())
    if playerImage:getHeight() * playerDrawScale < M.positions.player.minHeight then
        playerDrawScale = M.positions.player.minHeight / playerImage:getHeight()
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
    battleState.message = GameData.getText(GameData.getCurrentLanguage(), "battle_msg_player_heal", {healAmount = healAmount})
    battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
    battleState.phase = "action"
    M.TimerSystem.create(GAME_CONSTANTS.TIMER.ACTION_DELAY, M.startEnemyTurn, M.TIMER_GROUPS.BATTLE)
    M.skillSystem.heal.cooldown = M.skillSystem.heal.maxCooldown
    print("[SKILL SYSTEM] Heal skill cooldown set to " .. M.skillSystem.heal.cooldown)
end

function M.performPlayerDefend()
  print("[BATTLE ACTION] Player action: Defend")
  if M.skillSystem.defend.cooldown > 0 then
    battleState.message = GameData.getText(GameData.getCurrentLanguage(), "battle_msg_skill_cooldown")
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
  local playerImgWidth = playerImage:getWidth() * (M.positions.player.scale or 1)
  local playerImgHeight = playerImage:getHeight() * (M.positions.player.scale or 1)
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
  battleState.message = GameData.getText(GameData.getCurrentLanguage(), "battle_msg_player_defend")
  battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
  battleState.phase = "action"
  print("[BATTLE STATE] Battle phase changed to 'action'")
  M.TimerSystem.create(GAME_CONSTANTS.TIMER.ACTION_DELAY, M.startEnemyTurn, M.TIMER_GROUPS.BATTLE)
  print("[TIMER] Added timer for enemy turn")
  M.skillSystem.defend.cooldown = M.skillSystem.defend.maxCooldown
  print("[SKILL SYSTEM] Defend skill cooldown set to " .. M.skillSystem.defend.cooldown)
end

function M.performPlayerSpecial()
  print("[BATTLE ACTION] Player action: Special")
  local skill = M.skillSystem.special
  local skillData = M.skillInfo[3]
  if skill.cooldown > 0 then
    battleState.message = GameData.getText(GameData.getCurrentLanguage(), "battle_msg_skill_cooldown")
    battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
    print("[BATTLE] Special skill on cooldown")
    return
  end
  if player.mp < skillData.mpCost then
      battleState.message = GameData.getText(GameData.getCurrentLanguage(), "battle_msg_not_enough_mp")
      battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
      print("[BATTLE] Not enough MP for Special skill")
      return
  end
  if not audioState.isMutedSFX then
    resources.sounds.special:play()
    print("[AUDIO] Played sound: special")
  end
player.mp = math.max(0, player.mp - skillData.mpCost)
animations.player.current = "attack"
local damage, isCrit = M.calculateDamage(player, enemy)
print("[BATTLE] Player stats before special: HP=" .. player.hp .. ", MP=" .. player.mp .. ", Attack=" .. player.attack .. ", Defense=" .. player.defense .. ", CritRate=" .. player.critRate .. ", CritDamage=" .. player.critDamage)
print("[BATTLE] Enemy stats before special: HP=" .. enemy.hp .. ", Attack=" .. enemy.attack .. ", Defense=" .. enemy.defense .. ", CritRate=" .. enemy.critRate .. ", CritDamage=" .. enemy.critDamage)
enemy.hp = M.validateNumber(enemy.hp - damage, 0, enemy.maxHp, 0)
print("[BATTLE] Player dealt " .. damage .. " damage to enemy with Special attack")
local currentEnemyData = M.enemyData[GameData.story.currentState.currentLevel]
local enemyImage = resources.images[currentEnemyData.image] or resources.images.enemyDemonKing
local enemyDrawScale = math.min(M.positions.enemy.maxWidth / enemyImage:getWidth(), M.positions.enemy.maxHeight / enemyImage:getHeight())
if enemyImage:getHeight() * enemyDrawScale < M.positions.enemy.minHeight then
    enemyDrawScale = M.positions.enemy.minHeight / enemyImage:getHeight()
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
battleState.message = GameData.getText(GameData.getCurrentLanguage(), "battle_msg_player_special", {damage = damage})
battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
battleState.phase = "action"
print("[BATTLE STATE] Battle phase changed to 'action'")
if enemy.hp <= 0 then
  battleState.phase = "result"
  print("[BATTLE STATE] Battle phase changed to 'result', enemy defeated by special attack")
else
  M.TimerSystem.create(GAME_CONSTANTS.TIMER.ACTION_DELAY, M.startEnemyTurn, M.TIMER_GROUPS.BATTLE)
  print("[TIMER] Added timer for enemy turn")
end
M.skillSystem.special.cooldown = M.skillSystem.special.maxCooldown
print("[SKILL SYSTEM] Special skill cooldown set to " .. M.skillSystem.special.cooldown)
end

function M.startEnemyTurn()
    if battleState.phase ~= "action" then
        print("[ERROR] Invalid battle phase for enemy turn: " .. tostring(battleState.phase))
        return
    end
    battleState.turn = "enemy"
    battleState.phase = M.validateBattlePhase("action")
    local enemyDataForLevel = M.enemyData[GameData.story.currentState.currentLevel]
    if not enemyDataForLevel then
        print("[ERROR] Missing enemy data for level: " .. tostring(GameData.story.currentState.currentLevel))
        return
    end
    local aiType = M.enemyAI[enemyDataForLevel.ai] or M.enemyAI.basic
    local action = aiType.decideAction(enemy, player)
    print("[ENEMY AI] Enemy AI decision: " .. action)
    if action == "attack" then
      print("[BATTLE ACTION] Enemy action: Attack")
      animations.enemy.current = "attack"
      local damage, isCrit = M.calculateDamage(enemy, player)
      print("[BATTLE] Enemy stats before attack: HP=" .. enemy.hp .. ", Attack=" .. enemy.attack .. ", Defense=" .. enemy.defense .. ", CritRate=" .. enemy.critRate .. ", CritDamage=" .. enemy.critDamage)
      print("[BATTLE] Player stats before attack: HP=" .. player.hp .. ", Attack=" .. player.attack .. ", Defense=" .. player.defense .. ", CritRate=" .. player.critRate .. ", CritDamage=" .. player.critRate .. ", CritDamage=" .. player.critDamage)
      player.hp = math.max(0, player.hp - damage)
      print("[BATTLE] Enemy dealt " .. damage .. " damage to player. Crit=" .. tostring(isCrit))
      battleState.message = GameData.getText(GameData.getCurrentLanguage(), "battle_msg_enemy_attack", {damage = damage})
      if isCrit then
        battleState.message = GameData.getText(GameData.getCurrentLanguage(), "battle_msg_enemy_crit", {damage = damage})
        if not audioState.isMutedSFX then
          love.audio.play(resources.sounds.crit)
          print("[AUDIO] Played sound: crit")
        end
      end
      local playerImage = resources.images.playerStand
      local playerDrawScale = math.min(M.positions.player.maxWidth / playerImage:getWidth(), M.positions.player.maxHeight / playerImage:getHeight())
      if playerImage:getHeight() * playerDrawScale < M.positions.player.minHeight then
          playerDrawScale = M.positions.player.minHeight / playerImage:getHeight()
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
      battleState.message = GameData.getText(GameData.getCurrentLanguage(), "battle_msg_enemy_defend")
      local enemyImage = resources.images[enemyDataForLevel.image] or resources.images.enemyDemonKing
      local enemyDrawScale = math.min(M.positions.enemy.maxWidth / enemyImage:getWidth(), M.positions.enemy.maxHeight / enemyImage:getHeight())
      if enemyImage:getHeight() * enemyDrawScale < M.positions.enemy.minHeight then
          enemyDrawScale = M.positions.enemy.minHeight / enemyImage:getHeight()
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
    else
      M.TimerSystem.create(GAME_CONSTANTS.TIMER.ACTION_DELAY, function()
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
      end, M.TIMER_GROUPS.BATTLE)
      print("[TIMER] Added timer for player turn")
    end
    M.updateCooldowns()
    print("[SKILL SYSTEM] Cooldowns updated")
end

function M.updateCooldowns()
  for _, skill in pairs(M.skillSystem) do
    if skill.cooldown > 0 then
      skill.cooldown = skill.cooldown - 1
    end
  end
end

function M.checkBattleEnd(player, enemy, battleState, currentState, GAME_CONSTANTS, TimerSystem, transitionGameState, restartGame, GameData, currentGameLanguage)
    if enemy.hp <= 0 then
        if not battleState.victoryTriggered then
            M.grantExp(enemy.expReward or 0)
            battleState.victoryTriggered = true

            if currentState.isGrinding then
                battleState.message = GameData.getText(GameData.getCurrentLanguage(), "grinding_next_opponent")
                battleState.messageTimer = GAME_CONSTANTS.TIMER.ACTION_DELAY

                TimerSystem.create(GAME_CONSTANTS.TIMER.ACTION_DELAY + 0.5, function()
                    if gameState == "battle" and currentState.isGrinding then
                        battleState.victoryTriggered = false
                        restartGame()
                        print("[GRINDING] Spawning next enemy.")
                    end
                end, M.TIMER_GROUPS.BATTLE)
            else
                battleState.phase = "result"
                TimerSystem.create(GAME_CONSTANTS.TIMER.ACTION_DELAY + (battleState.messageTimer > 0 and battleState.messageTimer or 0), function()
                    if gameState == "battle" then
                         transitionGameState(gameState, "victory")
                    end
                end, M.TIMER_GROUPS.BATTLE)
            end
        end
    elseif player.hp <= 0 then
        if not battleState.defeatTriggered then
            battleState.defeatTriggered = true
            battleState.phase = "result"
            TimerSystem.create(GAME_CONSTANTS.TIMER.ACTION_DELAY + (battleState.messageTimer > 0 and battleState.messageTimer or 0), function()
                if gameState == "battle" then
                    transitionGameState(gameState, "defeat")
                end
            end, M.TIMER_GROUPS.BATTLE)
        end
    end
end

-- Input Handlers (moved from main.lua)
local menuNavTimer = 0
local menuNavDelay = 0.6
function M.handleMenuInput(dt, menuState, GameData, currentGameLanguage)
  local moved = false
  local prevOption = menuState.currentOption
  local direction = "None"
  menuNavTimer = menuNavTimer + dt
  if menuNavTimer > menuNavDelay then
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
      menuState.currentOption = menuState.currentOption - 1
      moved = true
      direction = "Up"
      menuNavTimer = 0
    elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
      menuState.currentOption = menuState.currentOption + 1
      moved = true
      direction = "Down"
      menuNavTimer = 0
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

local levelSelectNavTimer = 0
local levelSelectNavDelay = 0.6
function M.handleLevelSelectInput(dt, menuState)
  local moved = false
  local prevLevel = menuState.levelSelect.currentLevel
  levelSelectNavTimer = levelSelectNavTimer + dt
  local totalOptions = menuState.levelSelect.maxLevel + #menuState.levelSelect.grindingLevelIds

  if  levelSelectNavTimer >  levelSelectNavDelay then
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
      menuState.levelSelect.currentLevel = math.max(1, menuState.levelSelect.currentLevel - 1)
      moved = true
      levelSelectNavTimer = 0
    elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
      menuState.levelSelect.currentLevel = math.min(totalOptions, menuState.levelSelect.currentLevel + 1)
      moved = true
      levelSelectNavTimer = 0
    end
  end
  if moved and menuState.levelSelect.currentLevel ~= prevLevel then
    if menuState.levelSelect.currentLevel > menuState.levelSelect.maxLevel then
        local grindingIndex = menuState.levelSelect.currentLevel - menuState.levelSelect.maxLevel
        menuState.levelSelect.selectedGrindingLevelKey = menuState.levelSelect.grindingLevelIds[grindingIndex]
    else
        menuState.levelSelect.selectedGrindingLevelKey = nil
    end
    print("[LEVEL SELECT] Level selected: " .. menuState.levelSelect.currentLevel .. " Grinding Key: " .. tostring(menuState.levelSelect.selectedGrindingLevelKey))
  end
end

local storyEnterTimer = 0
local storyEnterDelay = 0.6
function M.handleStoryInput(dt, currentState, transitionGameState, restartGame)
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

function M.handleBattleInput(battleState)
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
function M.handleOptionsInput(dt, optionsState, GameData, currentGameLanguage, applyResolutionChange, applyFontSizeChange, availableResolutions, GAME_CONSTANTS, playerSettings, audioState, currentResolutionIndex)
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
        GameData.setCurrentLanguage(currentGameLanguage)
        storyPageState.storyText = GameData.getText(currentGameLanguage, "game_full_story")
        aboutPageState.storyText = GameData.getText(currentGameLanguage, "about_project")
        aboutPageState.staffText = GameData.getText(currentGameLanguage, "about_staff")
        print("[OPTIONS MENU] Language changed to: " .. currentGameLanguage)
      elseif currentOption.type == "resolution" then
        currentOption.currentOption = currentOption.currentOption - 1
        if currentOption.currentOption < 1 then
          currentOption.currentOption = #availableResolutions
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
        GameData.setCurrentLanguage(currentGameLanguage)
        storyPageState.storyText = GameData.getText(currentGameLanguage, "game_full_story")
        aboutPageState.storyText = GameData.getText(currentGameLanguage, "about_project")
        aboutPageState.staffText = GameData.getText(currentGameLanguage, "about_staff")
        print("[OPTIONS MENU] Language changed to: " .. currentGameLanguage)
      elseif currentOption.type == "resolution" then
        currentOption.currentOption = currentOption.currentOption + 1
        if currentOption.currentOption > #availableResolutions then
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

function M.handleOptionsInputReturn(optionsState, GameData, currentGameLanguage, transitionGameState, applyResolutionChange)
  local option = optionsState.options[optionsState.currentOption]
  if option.type == "toggle" then
    local targetState = option.targetState or audioState
    local oldState = targetState[option.state]
    targetState[option.state] = not oldState
    print("[OPTIONS MENU] Toggled option: " .. GameData.getText(currentGameLanguage, option.textKey) .. ", new state: " .. tostring(targetState[option.state]))
    if option.state == "isMutedBGM" then
      -- This is a bit of a hack, but it forces main.lua's transitionGameState to re-evaluate BGM
      -- A cleaner way would be to expose a function in main.lua to update BGM state.
      -- For now, we'll rely on the fact that transitionGameState stops and restarts BGM.
      -- We need to pass the current game state to avoid unintended transitions.
      transitionGameState(love.graphics.getMode().fullscreen and "options" or "menu", "options")
    elseif option.state == "isFullScreen" then
        applyResolutionChange()
    end
  elseif option.action then
    option.action()
    print("[OPTIONS MENU] Option selected: " .. GameData.getText(currentGameLanguage, option.textKey))
  end
end

function M.handleStoryPageInput(dt, storyPageState)
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

function M.handleAboutPageInput(dt, aboutPageState)
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

function M.handlePauseInput(pauseState, direction, GameData, currentGameLanguage)
    local moved = false
    local prevPauseOption = pauseState.currentOption
    if direction == "up" then
        pauseState.currentOption = pauseState.currentOption - 1
        if pauseState.currentOption < 1 then
            pauseState.currentOption = #pauseState.options
        end
        moved = true
    elseif direction == "down" then
        pauseState.currentOption = pauseState.currentOption + 1
        if pauseState.currentOption > #pauseState.options then
            pauseState.currentOption = 1
        end
        moved = true
    end
    if moved and pauseState.currentOption ~= prevPauseOption then
        print("[PAUSE MENU] Navigated menu: " .. direction .. ", selected option index: " .. pauseState.currentOption .. ", option text: " .. GameData.getText(currentGameLanguage, pauseState.options[pauseState.currentOption].textKey))
    end
end

function M.handleResultInput(resultState, direction, GameData, currentGameLanguage)
    local moved = false
    local prevResultOption = resultState.currentOption
    if direction == "up" then
        resultState.currentOption = resultState.currentOption - 1
        if resultState.currentOption < 1 then
            resultState.currentOption = #resultState.options
        end
        moved = true
    elseif direction == "down" then
        resultState.currentOption = resultState.currentOption + 1
        if resultState.currentOption > #resultState.options then
            resultState.currentOption = 1
        end
        moved = true
    end
    if moved and resultState.currentOption ~= prevResultOption then
        print("[" .. gameState:upper() .. " MENU] Navigated menu: " .. direction .. ", selected option index: " .. resultState.currentOption .. ", option text: " .. GameData.getText(currentGameLanguage, resultState.options[resultState.currentOption].textKey))
    end
end

function M.handleQuestLogInput(dt, questLogState, player, GameData, currentGameLanguage)
    questLogState.navDelayTimer = questLogState.navDelayTimer + dt
    if questLogState.navDelayTimer < questLogState.navDelay then
        return
    end

    local inputProcessed = false
    local currentQuestsArray = {}
    local currentScrollOffset = 0
    local isCompletedTab = questLogState.currentTab == "completed"

    if questLogState.currentTab == "active" then
        if player.activeQuests then
            for id, data in pairs(player.activeQuests) do
                table.insert(currentQuestsArray, {id = id, data = data})
            end
        end
        currentScrollOffset = questLogState.activeQuestScrollOffset
    else
        if player.completedQuests then
            for id, _ in pairs(player.completedQuests) do
                 table.insert(currentQuestsArray, {id = id, data = GameData.quests[id]})
            end
        end
        currentScrollOffset = questLogState.completedQuestScrollOffset
    end
    table.sort(currentQuestsArray, function(a,b) return a.id < b.id end)

    local totalQuestsInCurrentTab = #currentQuestsArray

    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        if totalQuestsInCurrentTab > 0 then
            questLogState.selectedQuestIndex = questLogState.selectedQuestIndex - 1
            if questLogState.selectedQuestIndex < 1 then
                questLogState.selectedQuestIndex = totalQuestsInCurrentTab
                if isCompletedTab then
                    questLogState.completedQuestScrollOffset = math.max(0, totalQuestsInCurrentTab - questLogState.questsPerPage)
                else
                    questLogState.activeQuestScrollOffset = math.max(0, totalQuestsInCurrentTab - questLogState.questsPerPage)
                end
            end
            if questLogState.selectedQuestIndex <= currentScrollOffset then
                if isCompletedTab then
                    questLogState.completedQuestScrollOffset = math.max(0, questLogState.selectedQuestIndex - 1)
                else
                    questLogState.activeQuestScrollOffset = math.max(0, questLogState.selectedQuestIndex - 1)
                end
            end
            inputProcessed = true
        end
    elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        if totalQuestsInCurrentTab > 0 then
            questLogState.selectedQuestIndex = questLogState.selectedQuestIndex + 1
            if questLogState.selectedQuestIndex > totalQuestsInCurrentTab then
                questLogState.selectedQuestIndex = 1
                if isCompletedTab then
                    questLogState.completedQuestScrollOffset = 0
                else
                    questLogState.activeQuestScrollOffset = 0
                end
            end
            if questLogState.selectedQuestIndex > currentScrollOffset + questLogState.questsPerPage then
                 if isCompletedTab then
                    questLogState.completedQuestScrollOffset = questLogState.selectedQuestIndex - questLogState.questsPerPage
                else
                    questLogState.activeQuestScrollOffset = questLogState.selectedQuestIndex - questLogState.questsPerPage
                end
            end
            inputProcessed = true
        end
    elseif love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        if questLogState.currentTab == "completed" then
            questLogState.currentTab = "active"
            questLogState.selectedQuestIndex = 1
            questLogState.activeQuestScrollOffset = 0
            inputProcessed = true
        end
    elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        if questLogState.currentTab == "active" then
            questLogState.currentTab = "completed"
            questLogState.selectedQuestIndex = 1
            questLogState.completedQuestScrollOffset = 0
            inputProcessed = true
        end
    end

    if inputProcessed then
        questLogState.navDelayTimer = 0
        if totalQuestsInCurrentTab > 0 and questLogState.selectedQuestIndex >= 1 and questLogState.selectedQuestIndex <= totalQuestsInCurrentTab then
             questLogState.selectedQuestId = currentQuestsArray[questLogState.selectedQuestIndex].id
        elseif totalQuestsInCurrentTab == 0 then
             questLogState.selectedQuestId = nil
             questLogState.selectedQuestIndex = 1
        else
             questLogState.selectedQuestId = nil
             questLogState.selectedQuestIndex = 1
             if isCompletedTab then questLogState.completedQuestScrollOffset = 0 else questLogState.activeQuestScrollOffset = 0 end
        end
    end
end

-- Drawing Functions (moved from main.lua, but still called by main.lua's love.draw)
function M.drawBattleScene(resources, currentState, battleBackgrounds)
  local bgKey
  if currentState.isGrinding and currentState.currentGrindingLevelId then
    local grindingLevelData = GameData.grindingLevels[currentState.currentGrindingLevelId]
    if grindingLevelData and grindingLevelData.battleBg then
      bgKey = grindingLevelData.battleBg
    else
      print("[ERROR] Grinding level data or battleBg missing for: " .. currentState.currentGrindingLevelId)
      bgKey = "battleBgForest"
    end
  else
    bgKey = battleBackgrounds[currentState.currentLevel]
  end

  local bgImage = resources.images[bgKey]
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

function M.drawEffects(battleState)
    love.graphics.setColor(1, 1, 1)
    for _, effect in ipairs(battleState.effects) do
        -- Draw particle systems for "hit", "defend", and "heal" effects
        if (effect.type == "hit" or effect.type == "defend" or effect.type == "heal") then
            if effect.particleSystem then
                love.graphics.draw(effect.particleSystem, effect.x, effect.y)
            end
        -- Draw damage/heal numbers as text
        elseif effect.type == "damage" then
            if resources.fonts.damage then
                love.graphics.setFont(resources.fonts.damage)
            end
            if effect.color then
                love.graphics.setColor(effect.color[1], effect.color[2], effect.color[3])
            end
            if effect.amount then
                love.graphics.print(effect.amount, effect.x, effect.y)
            end
            love.graphics.setColor(1, 1, 1) -- Reset color
        end
        -- The `else` block for simple image effects is removed as it's an unused feature
        -- and a potential source of errors.
    end
end


function M.updateAnimations(dt, animations, positions)
  if animations.player.current == "attack" then
    animations.player.timer = animations.player.timer + dt
    if animations.player.timer < 0.2 then
      animations.player.x = animations.player.x + (200 * dt)
    elseif animations.player.timer < 0.4 then
      animations.player.x = animations.player.x - (200 * dt)
    else
      animations.player.timer = 0
      animations.player.current = "stand"
      animations.player.x = animations.player.originalX -- BUG FIX: Was positions.player.originalX
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
      animations.enemy.x = animations.enemy.originalX -- BUG FIX: Was positions.enemy.originalX
    end
  end
end

function M.updateEffects(dt, battleState)
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

function M.table_to_string(tbl)
    local s = "{\n"
    local first = true
    for k, v in pairs(tbl) do
        if type(v) == "function" then
            print("Warning: Skipping function value for key: " .. tostring(k))
            goto continue
        end
        if type(k) == "string" and k:sub(1,1) == "_" then
            print("Warning: Skipping internal/private key: " .. k)
            goto continue
        end

        if not first then
            s = s .. ",\n"
        end
        first = false

        if type(k) == "number" then
            s = s .. "  [" .. k .. "] = "
        elseif type(k) == "string" then
            s = s .. "  " .. string.format("%q", k) .. " = "
        else
            print("Warning: Skipping unsupported key type: " .. type(k))
            first = true
            goto continue
        end

        if type(v) == "number" then
            s = s .. tostring(v)
        elseif type(v) == "string" then
            s = s .. string.format("%q", v)
        elseif type(v) == "boolean" then
            s = s .. tostring(v)
        elseif type(v) == "table" then
            s = s .. M.table_to_string(v)
        else
            print("Warning: Skipping unsupported value type " .. type(v) .. " for key " .. tostring(k))
            first = true
        end
        ::continue::
    end
    s = s .. "\n}"
    return s
end

function M.saveGame(player, currentState, playerSettings, audioState, currentResolutionIndex, currentFontSizeIndex, currentGameLanguage, skillCooldowns)
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
            inventory = player.inventory,
            inventoryCapacity = player.inventoryCapacity,
            equipment = player.equipment, -- Save equipment
            activeQuests = player.activeQuests,
            completedQuests = player.completedQuests,
        },
        currentState = {
            currentLevel = currentState.currentLevel,
            dialogueIndex = currentState.dialogueIndex,
            isGrinding = currentState.isGrinding,
            currentGrindingLevelId = currentState.currentGrindingLevelId,
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
        currentFontSizeIndex = currentFontSizeIndex,
        currentGameLanguage = currentGameLanguage,
        skillCooldowns = {
            attack = skillCooldowns.attack.cooldown,
            defend = skillCooldowns.defend.cooldown,
            special = skillCooldowns.special.cooldown,
            heal = skillCooldowns.heal.cooldown,
        }
    }

    local saveFile = "savegame.sav"
    local success, err = love.filesystem.write(saveFile, M.table_to_string(saveData))
    if success then
        print("[SAVE GAME] Game saved successfully to " .. saveFile)
    else
        print("[SAVE GAME] Failed to save game: " .. tostring(err))
    end
end

function M.loadGame(player, currentState, playerSettings, audioState, currentResolutionIndexRef, GAME_CONSTANTS_REF, currentGameLanguageRef, skillCooldowns, availableResolutions)
    local saveFile = "savegame.sav"
    if not love.filesystem.isFile(saveFile) then
        print("[LOAD GAME] No save file found.")
        return false
    end

    local success, content = love.filesystem.read(saveFile)
    if not success then
        print("[LOAD GAME] Failed to read save file: " .. tostring(content))
        return false
    end

    local loadedChunk, err = load("return " .. content, "savegame.sav")
    if not loadedChunk then
        print("[LOAD GAME] Failed to parse save data: " .. tostring(err))
        return false
    end
    local data = loadedChunk()

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

        player.activeQuests = data.player.activeQuests or {}
        player.completedQuests = data.player.completedQuests or {}

        player.inventoryCapacity = data.player.inventoryCapacity or 20
        local loadedInventory = data.player.inventory or {}
        player.inventory = {}
        for i = 1, player.inventoryCapacity do
            if loadedInventory[i] then
                player.inventory[i] = loadedInventory[i]
            else
                player.inventory[i] = nil
            end
        end
        player.equipment = data.player.equipment or {
            head = nil, chest = nil, legs = nil,
            weapon = nil, accessory1 = nil, accessory2 = nil
        }

        player.image = resources.images.playerStand
        player.isDefending = false
        player.status = {}
        player.combo = 0
    end

    if data.currentState then
        currentState.currentLevel = data.currentState.currentLevel or 1
        currentState.dialogueIndex = data.currentState.dialogueIndex or 1
        currentState.isGrinding = data.currentState.isGrinding or false
        currentState.currentGrindingLevelId = data.currentState.currentGrindingLevelId or nil
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

    currentResolutionIndexRef = data.currentResolutionIndex or 1
    GAME_CONSTANTS_REF.currentFontSizeIndex = data.currentFontSizeIndex or 2
    currentGameLanguageRef = data.currentGameLanguage or "en"

    if data.skillCooldowns then
        skillCooldowns.attack.cooldown = data.skillCooldowns.attack or 0
        skillCooldowns.defend.cooldown = data.skillCooldowns.defend or 0
        skillCooldowns.special.cooldown = data.skillCooldowns.special or 0
        skillCooldowns.heal.cooldown = data.skillCooldowns.heal or 0
    end

    print("[LOAD GAME] Game loaded successfully.")
    return true
end

return M