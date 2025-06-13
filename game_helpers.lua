-- game_helpers.lua
-- This module contains helper functions that manage game state transitions,
-- resource initialization, and UI drawing, separated from the main game loop.

local GameLogic
local GameData 

local player, enemy, resources, animations, battleState, uiState, pauseState,
      resultState, menuState, optionsState, storyPageState, aboutPageState, howToPlayState,
      inventoryState, questLogState, statsScreenState,
      GAME_CONSTANTS, playerSettings, audioState,
      screenWidth, screenHeight, availableResolutions, currentResolutionIndex,
      uiMessage, uiMessageTimer,
      currentGameLanguage, previousGameState

local M = {}

function M.setGlobals(
    p, e, r, a, bs, us, ps,
    rs, ms, os, sps, aps, htps,
    is, qls, sss,
    gc, ps_settings, as_audio,
    sw, sh, ar, cri,
    uim, uimt,
    cgl, pgs
)
    player = p
    enemy = e
    resources = r
    animations = a
    battleState = bs
    uiState = us
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
    audioState = as_audio
    screenWidth = sw
    screenHeight = sh
    availableResolutions = ar
    currentResolutionIndex = cri
    uiMessage = uim
    uiMessageTimer = uimt
    currentGameLanguage = cgl
    previousGameState = pgs

    GameLogic = require("game_logic")
    GameData = require("game_data")
end

function M.transitionGameState(from, to)
    local validatedFrom = GameLogic.validateGameState(from or "menu")
    local validatedTo = GameLogic.validateGameState(to)
    if validatedFrom == validatedTo and from ~= nil then
        if validatedFrom == "options" and to == "options" then
        else
            return false
        end
    end

    if resources.sounds.menuBgm and resources.sounds.menuBgm:isPlaying() then resources.sounds.menuBgm:stop() end
    if resources.sounds.battleBgm and resources.sounds.battleBgm:isPlaying() then resources.sounds.battleBgm:stop() end
    if resources.sounds.victory and resources.sounds.victory:isPlaying() then resources.sounds.victory:stop() end
    if resources.sounds.defeat and resources.sounds.defeat:isPlaying() then resources.sounds.defeat:stop() end
    local currentLevelIntro = GameData.story.levelIntros[GameData.story.currentState.currentLevel]
    if currentLevelIntro and currentLevelIntro.music and resources.sounds[currentLevelIntro.music] and resources.sounds[currentLevelIntro.music]:isPlaying() then
        resources.sounds[currentLevelIntro.music]:stop()
    end
    local endingType = GameData.determineEnding()
    if validatedFrom == "ending" then
        if GameData.story.ending[endingType] and GameData.story.ending[endingType].music and resources.sounds[GameData.story.ending[endingType].music] and resources.sounds[GameData.story.ending[endingType].music]:isPlaying() then
            resources.sounds[GameData.story.ending[endingType].music]:stop()
        end
    end

    if not audioState.isMutedBGM then
        if validatedTo == "menu" or validatedTo == "options" or validatedTo == "levelSelect" or validatedTo == "storyPage" or validatedTo == "aboutPage" or validatedTo == "inventoryScreen" or validatedTo == "questLogScreen" or validatedTo == "statsScreen" then
            if resources.sounds.menuBgm then
                resources.sounds.menuBgm:setLooping(true)
                resources.sounds.menuBgm:play()
                print("[AUDIO] Started Menu BGM.")
            end
            if validatedTo == "questLogScreen" then
                questLogState.currentTab = "active"
                questLogState.selectedQuestIndex = 1
                questLogState.activeQuestScrollOffset = 0
                questLogState.completedQuestScrollOffset = 0
                local firstActiveQuestId = nil
                if player.activeQuests then
                    local tempActiveQuests = {}
                    for id, _ in pairs(player.activeQuests) do table.insert(tempActiveQuests, {id=id}) end
                    if #tempActiveQuests > 0 then
                        table.sort(tempActiveQuests, function(a,b) return a.id < b.id end)
                        firstActiveQuestId = tempActiveQuests[1].id
                    end
                end
                questLogState.selectedQuestId = firstActiveQuestId
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
            local currentLevelIntro = GameData.story.levelIntros[GameData.story.currentState.currentLevel]
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
            local determinedEndingType = GameData.determineEnding()
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
        battleState.phase = GameLogic.validateBattlePhase("select")
        battleState.turn = "player"
        battleState.message = GameData.getText(currentGameLanguage, "battle_start")
        battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
    elseif validatedFrom == "battle" then
    end
    gameState = validatedTo
    print(string.format("[GAME STATE] Transitioned from '%s' to '%s'", validatedFrom, validatedTo))
    return true
end

function M.initFonts()
    local scale = GAME_CONSTANTS.FONT_SIZE_OPTIONS[GAME_CONSTANTS.currentFontSizeIndex] or 1.0
    resources.fonts.ui = GameLogic.loadFont("assets/ui-font.ttf", math.floor(GAME_CONSTANTS.FONT_SIZES.UI * scale))
    resources.fonts.battle = GameLogic.loadFont("assets/battle-font.ttf", math.floor(GAME_CONSTANTS.FONT_SIZES.BATTLE * scale))
    resources.fonts.damage = GameLogic.loadFont("assets/damage-font.ttf", math.floor(GAME_CONSTANTS.FONT_SIZES.DAMAGE * scale))
    resources.fonts.chineseUI = GameLogic.loadFont("assets/chinese-font.ttf", math.floor(GAME_CONSTANTS.FONT_SIZES.UI_CHINESE * scale))
    resources.fonts.chineseBattle = GameLogic.loadFont("assets/chinese-font.ttf", math.floor(GAME_CONSTANTS.FONT_SIZES.BATTLE_CHINESE * scale))
    print(string.format("[GAME] Fonts initialized with scale: %.1f", scale))
end

function M.applyFontSizeChange()
    M.initFonts()
end

function M.applyResolutionChange()
  screenWidth = availableResolutions[currentResolutionIndex].width
  screenHeight = availableResolutions[currentResolutionIndex].height
  love.window.setMode(screenWidth, screenHeight, {resizable = false, vsync = true, fullscreen = playerSettings.isFullScreen})
  print("[GAME] Resolution changed to " .. screenWidth .. "x" .. screenHeight)

    GameLogic.positions.player = {
        x = screenWidth * 0.25,
        y = screenHeight * 0.5,
        scale = 1.0,
        maxWidth = screenWidth * 0.4,
        maxHeight = screenHeight * 0.6,
        minHeight = screenHeight * 0.2,
    }
    GameLogic.positions.enemy = {
        x = screenWidth * 0.75,
        y = screenHeight * 0.5,
        scale = 1.0,
        maxWidth = screenWidth * 0.4,
        maxHeight = screenHeight * 0.6,
        minHeight = screenHeight * 0.2,
    }
    GameLogic.positions.playerHP = {x = screenWidth * 0.02, y = screenHeight * 0.02}
    GameLogic.positions.enemyHP = {x = screenWidth * 0.78, y = screenHeight * 0.02}
    GameLogic.positions.playerUI = {x = screenWidth * 0.02, y = screenHeight * 0.75}
    GameLogic.positions.enemyUI = {x = screenWidth * 0.68, y = screenHeight * 0.75}

    animations.player.x = GameLogic.positions.player.x
    animations.player.y = GameLogic.positions.player.y
    animations.player.originalX = GameLogic.positions.player.x
    animations.enemy.x = GameLogic.positions.enemy.x
    animations.enemy.y = GameLogic.positions.enemy.y
    animations.enemy.originalX = GameLogic.positions.enemy.x
end

function M.restartGame()
    GameLogic.restartGame(GameData.story.currentState, menuState.levelSelect.currentLevel, menuState.levelSelect.selectedGrindingLevelKey)
    M.transitionGameState(gameState, "battle")
    pauseState.isPaused = false
end

function M.resumeBattle()
    if pauseState.isPaused then
        pauseState.isPaused = false
        M.transitionGameState(gameState, "battle")
        GameLogic.TimerSystem.resumeGroup(GameLogic.TIMER_GROUPS.BATTLE)
    end
end

function M.handleBattlePause()
    if not pauseState.isPaused then
        pauseState.isPaused = true
        M.transitionGameState(gameState, "pause")
        GameLogic.TimerSystem.pauseGroup(GameLogic.TIMER_GROUPS.BATTLE)
        if not audioState.isMutedBGM then
            love.audio.stop()
            print("[AUDIO] Game paused, all audio stopped.")
        end
    end
end

function M.exitGrindingMode()
    if GameData.story.currentState.isGrinding then
        print("[GRINDING] Exiting grinding mode.")
        GameData.story.currentState.isGrinding = false
        GameData.story.currentState.currentGrindingLevelId = nil

        GameLogic.saveGame()

        if resources.sounds.battleBgm and resources.sounds.battleBgm:isPlaying() then
            resources.sounds.battleBgm:stop()
        end
        if not audioState.isMutedBGM and resources.sounds.menuBgm then
             resources.sounds.menuBgm:setLooping(true)
             resources.sounds.menuBgm:play()
        end

        M.transitionGameState(gameState, "levelSelect")
    end
end

function M.saveGame()
    GameLogic.saveGame(
        player, GameData.story.currentState, playerSettings, audioState,
        currentResolutionIndex, GAME_CONSTANTS.currentFontSizeIndex, currentGameLanguage,
        GameLogic.skillSystem
    )
    uiMessage = GameData.getText(currentGameLanguage, "game_saved_success")
    uiMessageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
end

function M.loadGame()
    local success = GameLogic.loadGame(
        player, GameData.story.currentState, playerSettings, audioState,
        currentResolutionIndex, GAME_CONSTANTS, currentGameLanguage,
        GameLogic.skillSystem, availableResolutions
    )
    if success then
        -- Re-initialize fonts and resolution after loading
        M.initFonts()
        M.applyResolutionChange()
        GameData.setCurrentLanguage(currentGameLanguage) -- Ensure GameData's language is synced
        storyPageState.storyText = GameData.getText(currentGameLanguage, "game_full_story")
        aboutPageState.storyText = GameData.getText(currentGameLanguage, "about_project")
        aboutPageState.staffText = GameData.getText(currentGameLanguage, "about_staff")

        M.transitionGameState(nil, "menu")
        uiMessage = GameData.getText(currentGameLanguage, "game_loaded_success")
        uiMessageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
    else
        uiMessage = GameData.getText(currentGameLanguage, "game_load_fail")
        uiMessageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
    end
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

function M.drawLoadingScreen(loadingFont, creatorLogo, engineLogo, gameGroupLogo)
    love.graphics.clear(0, 0, 0) -- Black background
    love.graphics.setColor(1, 1, 1) -- White text/images

    if not loadingFont then
        loadingFont = love.graphics.newFont(24)
    end
    love.graphics.setFont(loadingFont)

    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()
    local centerX = windowWidth / 2

    local yOffset = windowHeight * 0.15

    local function drawLogoAndText(logo, text, currentYOffset)
        love.graphics.printf(text, 0, currentYOffset, windowWidth, "center")
        currentYOffset = currentYOffset + loadingFont:getHeight() + 10
        if logo then
            local logoWidth = logo:getWidth()
            local logoHeight = logo:getHeight()
            local targetHeight = 100
            local scale = targetHeight / logoHeight
            love.graphics.draw(logo, centerX - (logoWidth * scale) / 2, currentYOffset, 0, scale, scale)
            currentYOffset = currentYOffset + targetHeight + 30
        else
            love.graphics.setColor(0.5, 0.5, 0.5)
            love.graphics.rectangle("fill", centerX - 50, currentYOffset, 100, 100)
            love.graphics.setColor(1,1,1)
            love.graphics.printf("Logo\nMissing", centerX - 50, currentYOffset + 30, 100, "center")
            currentYOffset = currentYOffset + 100 + 30
        end
        return currentYOffset
    end

    yOffset = drawLogoAndText(creatorLogo, "Created by Dundd2", yOffset)
    yOffset = drawLogoAndText(engineLogo, "Built with LÖVE2D", yOffset)
    yOffset = drawLogoAndText(gameGroupLogo, "A Hero's Redemption", yOffset)

    love.graphics.printf("Loading...", 0, windowHeight - 50, windowWidth, "center")
end

function M.drawMainMenu(resources, menuState, GameData, currentGameLanguage, GAME_CONSTANTS)
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
  local versionInfo = "V0.02\nBy Dundd2\nBuild with love-12.0-win64 Beta (Bestest Friend)"
  local textWidth = fontUI:getWidth(versionInfo)
  local textHeight = fontUI:getHeight()
  love.graphics.print(versionInfo, love.graphics.getWidth() - textWidth - 100, love.graphics.getHeight() - textHeight - 100)
end

function M.drawLevelSelect(resources, menuState, GameData, currentGameLanguage)
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
      love.graphics.print(text, buttonRect.x + 10, buttonRect.y + 5)
  end

  local totalRegularLevels = menuState.levelSelect.maxLevel
  local grindingLevelBaseIndex = totalRegularLevels + 1

  for i, grindingId in ipairs(menuState.levelSelect.grindingLevelIds) do
      local levelY = 150 + (totalRegularLevels + i - 1) * 40
      local grindingLevelData = GameData.grindingLevels[grindingId]
      local text = GameData.getText(currentGameLanguage, grindingLevelData.name_key, nil, grindingId)

      local buttonRect = {
          x = windowWidth / 2 - (fontUI:getWidth(text) / 2) - 10,
          y = levelY,
          width = fontUI:getWidth(text) + 20,
          height = 30
      }
      menuState.levelSelect.buttonAreas[grindingLevelBaseIndex + i - 1] = buttonRect

      if menuState.levelSelect.currentLevel == (grindingLevelBaseIndex + i - 1) then
          love.graphics.setColor(1, 1, 0)
          love.graphics.rectangle("line", buttonRect.x, buttonRect.y, buttonRect.width, buttonRect.height)
      else
          love.graphics.setColor(1, 1, 1)
      end
      love.graphics.print(text, buttonRect.x + 10, buttonRect.y + 5)
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

function M.drawStoryDialogue(resources, GameData, currentGameLanguage, enemyData, storyState)
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()
    love.graphics.draw(resources.images.background, 0, 0, 0,
        windowWidth/resources.images.background:getWidth(),
        windowHeight/resources.images.background:getHeight())
    local currentDialogue = GameData.getCurrentDialogue(resources, currentGameLanguage)
    if not currentDialogue then return end
    local currentLevelData = GameData.story.levelIntros[storyState.currentLevel]
    if currentLevelData and currentLevelData.background then
        local bgKey = string.match(currentLevelData.background, "([^/]+)$"):gsub("%.png$", "")
        if resources.images[bgKey] then
            love.graphics.draw(resources.images[bgKey], 0, 0, 0,
                windowWidth/resources.images[bgKey]:getWidth(),
                windowHeight/resources.images[bgKey]:getHeight())
        end
    end
    local bottomMargin = windowHeight * 0.05
    local dialogBoxHeight = windowHeight * 0.2
    local dialogBoxWidth = windowWidth * 0.8
    local dialogBoxX = (windowWidth - dialogBoxWidth) / 2
    local dialogBoxY = windowHeight - dialogBoxHeight - bottomMargin

    local portraitImage = currentDialogue.portraitKey and resources.images[currentDialogue.portraitKey] or nil
    local maxPortraitWidth = dialogBoxHeight
    local portraitDrawWidth = 0
    local portraitDrawHeight = 0
    local portraitDrawX = dialogBoxX + 10
    local portraitDrawY = dialogBoxY + 10
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
        local enemyImageKey = enemyData[storyState.currentLevel] and enemyData[storyState.currentLevel].image or "enemyDemonKing"
        local enemyImage = resources.images[enemyImageKey]
        if enemyImage then
            local enemyMaxHeight = windowHeight * 0.6
            local enemyScale = enemyMaxHeight / enemyImage:getHeight()
            local enemyDrawWidth = enemyImage:getWidth() * enemyScale
            local enemyDrawHeight = enemyImage:getHeight() * enemyScale
            local enemyDrawX = windowWidth - enemyDrawWidth - (windowWidth * 0.05)
            local enemyDrawY = dialogBoxY - enemyDrawHeight + 20
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
    local speakerNameY = portraitImage and portraitDrawY or (dialogBoxY + 10)
    love.graphics.print(currentDialogue.speaker, speakerNameX, speakerNameY)
    if GameData.isTextComplete() then
        love.graphics.setColor(1, 1, 1, 0.5 + math.sin(love.timer.getTime() * 5) * 0.5)
        love.graphics.print(GameData.getText(currentGameLanguage, "story_continue_prompt"), dialogBoxX + dialogBoxWidth - 150, dialogBoxY + dialogBoxHeight - 30)
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", windowWidth - 150, windowHeight - 50, 100, 30)
    love.graphics.print(GameData.getText(currentGameLanguage, "story_skip_button"), windowWidth - 140, windowHeight - 45)
end

function M.drawStoryPageUI(storyPageState, GameData, currentGameLanguage, resources)
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

function M.drawAboutPageUI(aboutPageState, GameData, currentGameLanguage, resources)
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

function M.drawBattleUI(resources, player, enemy, battleState, uiState, GameData, currentGameLanguage, GAME_CONSTANTS, skillInfo, skillSystem)
  local windowWidth = love.graphics.getWidth()
  local windowHeight = love.graphics.getHeight()

  local fontUI = resources.fonts.ui
  if currentGameLanguage == "zh" then
    fontUI = resources.fonts.chineseUI
  end
  love.graphics.setFont(fontUI)
  love.graphics.setColor(1, 1, 1)

  local uiFrameWidth = windowWidth * 0.3
  local uiFrameHeight = windowHeight * 0.25
  local uiFrameX = windowWidth * 0.02
  local uiFrameY = windowHeight * 0.73

  local uiFrameImage = resources.images.uiFrame
  local uiFrameScaleX = uiFrameWidth / uiFrameImage:getWidth()
  local uiFrameScaleY = uiFrameHeight / uiFrameImage:getHeight()
  love.graphics.draw(uiFrameImage, uiFrameX, uiFrameY, 0, uiFrameScaleX, uiFrameScaleY)

  local hpBarWidth = windowWidth * 0.2
  local hpBarHeight = windowHeight * 0.03
  local playerHpX = windowWidth * 0.02
  local playerHpY = windowHeight * 0.02

  love.graphics.setColor(1, 0, 0)
  love.graphics.rectangle("fill", playerHpX, playerHpY, hpBarWidth, hpBarHeight)
  love.graphics.setColor(0, 1, 0)
  love.graphics.rectangle("fill", playerHpX, playerHpY, (player.hp / player.maxHp) * hpBarWidth, hpBarHeight)
  love.graphics.setColor(1, 1, 1)
  local playerHpText = string.format("HP: %d / %d", math.floor(player.hp), math.floor(player.maxHp))
  local playerHpTextWidth = fontUI:getWidth(playerHpText)
  love.graphics.print(playerHpText, playerHpX + hpBarWidth / 2 - playerHpTextWidth / 2, playerHpY + hpBarHeight + 5)

  local mpBarWidth = hpBarWidth * 0.8
  local mpBarHeight = windowHeight * 0.02
  local playerMpX = playerHpX + hpBarWidth - mpBarWidth - 5
  local playerMpY = playerHpY + hpBarHeight + 5 + fontUI:getHeight() + 5
  love.graphics.setColor(0, 0, 1)
  love.graphics.rectangle("fill", playerMpX, playerMpY, mpBarWidth, mpBarHeight)
  love.graphics.setColor(0.5, 0.5, 1)
  love.graphics.rectangle("fill", playerMpX, playerMpY, (player.mp / player.maxMp) * mpBarWidth, mpBarHeight)
  love.graphics.setColor(1, 1, 1)
  local playerMpText = string.format("MP: %d / %d", math.floor(player.mp), math.floor(player.maxMp))
  local playerMpTextWidth = fontUI:getWidth(playerMpText)
  love.graphics.print(playerMpText, playerMpX + mpBarWidth / 2 - playerMpTextWidth / 2, playerMpY + mpBarHeight + 5)

  local statsX = playerHpX
  local statsY = playerHpY + hpBarHeight + 5 + fontUI:getHeight() * 2 + 10
  love.graphics.print(string.format("LV: %d", player.level), statsX, statsY)
  love.graphics.print(string.format("EXP: %d/%d", player.exp, player.expToNextLevel), statsX, statsY + fontUI:getHeight())

  love.graphics.print(GameData.getText(currentGameLanguage, "player_stats_attack") .. ": " .. player.attack, statsX + 100, statsY)
  love.graphics.print(GameData.getText(currentGameLanguage, "player_stats_defense") .. ": " .. player.defense, statsX + 100, statsY + fontUI:getHeight())
  love.graphics.print(GameData.getText(currentGameLanguage, "player_stats_crit_rate") .. ": " .. player.critRate .. "%", statsX + 200, statsY)
  love.graphics.print(GameData.getText(currentGameLanguage, "player_stats_crit_damage") .. ": " .. player.critDamage .. "X", statsX + 200, statsY + fontUI:getHeight())

  local enemyHpX = windowWidth * 0.98 - hpBarWidth
  local enemyHpY = windowHeight * 0.02

  love.graphics.setColor(1, 0, 0)
  love.graphics.rectangle("fill", enemyHpX, enemyHpY, hpBarWidth, hpBarHeight)
  love.graphics.setColor(0, 1, 0)
  love.graphics.rectangle("fill", enemyHpX, enemyHpY, (enemy.hp / enemy.maxHp) * hpBarWidth, hpBarHeight)
  love.graphics.setColor(1, 1, 1)
  local enemyHpText = string.format("HP: %d / %d", math.floor(enemy.hp), math.floor(enemy.maxHp))
  local enemyHpTextWidth = fontUI:getWidth(enemyHpText)
  love.graphics.print(enemyHpText, enemyHpX + hpBarWidth / 2 - enemyHpTextWidth / 2, enemyHpY + hpBarHeight + 5)
  local enemyName = GameData.getText(currentGameLanguage, enemy.displayNameKey, nil, "Unknown Enemy")
  local enemyNameWidth = fontUI:getWidth(enemyName)
  love.graphics.print(enemyName, enemyHpX + hpBarWidth / 2 - enemyNameWidth / 2, enemyHpY - fontUI:getHeight() - 5)


  if battleState.phase == "select" then
    battleState.buttonAreas = {}
    love.graphics.setColor(1, 1, 1)
    local optionStartX = uiFrameX + uiFrameWidth * 0.05
    local optionStartY = uiFrameY + uiFrameHeight * 0.05
    local optionButtonWidth = uiFrameWidth * 0.9
    local optionButtonHeight = uiFrameHeight * 0.2
    local optionSpacing = uiFrameHeight * 0.25

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

  local iconSize = windowHeight * 0.08
  local iconSpacing = windowWidth * 0.02
  local totalIconsWidth = (#skillInfo * iconSize) + ((#skillInfo - 1) * iconSpacing)
  local skillIconsStartX = (windowWidth - totalIconsWidth) / 2
  local skillIconsStartY = windowHeight * 0.9

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
    local cooldown = skillSystem[skill.key].cooldown
    local mpCost = skill.mpCost or 0

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
        love.graphics.setColor(1, 0.5, 0.5)
      end
    end
  end

  if GameData.story.currentState.isGrinding then
      local buttonWidth = 150
      local buttonHeight = 40
      local buttonX = windowWidth - buttonWidth - 20
      local buttonY = windowHeight * 0.1

      battleState.leaveGrindingButtonArea = {x = buttonX, y = buttonY, width = buttonWidth, height = buttonHeight}

      love.graphics.setFont(fontUI)
      local text = GameData.getText(currentGameLanguage, "battle_action_leave_grinding", nil, "Leave Training")
      local textWidth = fontUI:getWidth(text)

      love.graphics.setColor(0.7, 0.2, 0.2, 0.8)
      love.graphics.rectangle("fill", buttonX, buttonY, buttonWidth, buttonHeight)
      love.graphics.setColor(1,1,1)
      love.graphics.rectangle("line", buttonX, buttonY, buttonWidth, buttonHeight)
      love.graphics.printf(text, buttonX + (buttonWidth - textWidth)/2, buttonY + (buttonHeight - fontUI:getHeight())/2, buttonWidth, "center")
  else
      battleState.leaveGrindingButtonArea = nil
  end
end

function M.drawBattleMessage(battleState, player, enemy, GameData, currentGameLanguage)
    if battleState.message ~= "" and battleState.messageTimer > 0 then
        local fontBattleMsg = resources.fonts.battle
        if currentGameLanguage == "zh" then
            fontBattleMsg = resources.fonts.chineseBattle
        end
        love.graphics.setFont(fontBattleMsg)
        if string.find(battleState.message, GameData.getText(currentGameLanguage, "battle_msg_enemy_attack", {damage=0})) or
           string.find(battleState.message, GameData.getText(currentGameLanguage, "battle_msg_enemy_crit", {damage=0})) or
           string.find(battleState.message, GameData.getText(currentGameLanguage, "battle_msg_enemy_defend")) then
            love.graphics.setColor(1, 0, 0)
        elseif string.find(battleState.message, GameData.getText(currentGameLanguage, "battle_msg_player_attack", {damage=0})) or
               string.find(battleState.message, GameData.getText(currentGameLanguage, "battle_msg_player_crit", {damage=0})) or
               string.find(battleState.message, GameData.getText(currentGameLanguage, "battle_msg_player_defend")) or
               string.find(battleState.message, GameData.getText(currentGameLanguage, "battle_msg_player_special", {damage=0})) or
               string.find(battleState.message, GameData.getText(currentGameLanguage, "battle_msg_player_heal", {healAmount=0})) then
            love.graphics.setColor(0, 1, 0)
        elseif string.find(battleState.message, GameData.getText(currentGameLanguage, "battle_msg_exp_gain", {exp=0})) or
               string.find(battleState.message, GameData.getText(currentGameLanguage, "battle_msg_level_up", {level=0})) then
            love.graphics.setColor(0, 0.8, 0.8)
        else
            love.graphics.setColor(1, 1, 0)
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

function M.drawPauseUI(pauseState, GameData, currentGameLanguage, resources)
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
        love.graphics.rectangle("line", buttonRect.x, buttonRect.y, buttonRect.width, buttonRect.height)
    end
    local textWidth = fontUIPause:getWidth(GameData.getText(currentGameLanguage, option.textKey))
    love.graphics.print(GameData.getText(currentGameLanguage, option.textKey),
        buttonRect.x + buttonRect.width / 2 - textWidth / 2,
        buttonRect.y + buttonRect.height / 2 - 10)
end
end

function M.drawVictoryUI(resultState, GameData, currentGameLanguage, resources)
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

function M.drawDefeatUI(resultState, GameData, currentGameLanguage, resources)
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

function M.drawSkillInfoUI(uiState, skillInfo, GameData, currentGameLanguage, resources)
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

function M.drawOptionsUI(optionsState, GameData, currentGameLanguage, resources, availableResolutions, GAME_CONSTANTS, playerSettings, audioState)
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

function M.drawInventoryScreen(inventoryState, player, GameData, currentGameLanguage, resources, uiMessage, uiMessageTimer)
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()
    love.graphics.clear(0.1, 0.1, 0.1, 1)

    local titleFont = resources.fonts.battle or resources.fonts.ui
    local itemFont = resources.fonts.ui
    local descFont = resources.fonts.ui

    love.graphics.setFont(titleFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(GameData.getText(currentGameLanguage, "inventory_screen_title"), 0, 20, windowWidth, "center")

    love.graphics.setFont(itemFont)
    for i = 1, player.inventoryCapacity do
        local row = math.floor((i - 1) / inventoryState.slotCols)
        local col = (i - 1) % inventoryState.slotCols
        local x = inventoryState.gridStartX + col * (inventoryState.slotWidth + inventoryState.slotPadding)
        local y = inventoryState.gridStartY + row * (inventoryState.slotHeight + inventoryState.slotPadding)

        if i == inventoryState.selectedSlot and inventoryState.currentFocus == "inventory" then
            love.graphics.setColor(1, 1, 0, 0.5)
            love.graphics.rectangle("fill", x, y, inventoryState.slotWidth, inventoryState.slotHeight)
            love.graphics.setColor(1, 1, 0)
        else
            love.graphics.setColor(0.3, 0.3, 0.3)
        end
        love.graphics.rectangle("line", x, y, inventoryState.slotWidth, inventoryState.slotHeight)

        love.graphics.setColor(1,1,1)
        local item = player.inventory[i]
        if item then
            local itemData = GameData.items[item.itemId]
            if itemData then
                local itemName = GameData.getText(currentGameLanguage, itemData.name_key, nil, item.itemId)
                love.graphics.printf(itemName, x + 5, y + 5, inventoryState.slotWidth - 10, "left")
                if itemData.stackable then
                    love.graphics.printf("x" .. item.quantity, x + 5, y + inventoryState.slotHeight - 25, inventoryState.slotWidth - 10, "right")
                end
            else
                 love.graphics.printf("Unknown", x + 5, y + 5, inventoryState.slotWidth - 10, "left")
            end
        end
    end

    local selectedItem = player.inventory[inventoryState.selectedSlot]
    if selectedItem then
        local itemData = GameData.items[selectedItem.itemId]
        if itemData then
            love.graphics.setFont(itemFont)
            love.graphics.setColor(1,1,1)
            love.graphics.printf(GameData.getText(currentGameLanguage, itemData.name_key), inventoryState.detailsX, inventoryState.detailsY, windowWidth - inventoryState.detailsX - 20, "left")

            love.graphics.setFont(descFont)
            love.graphics.setColor(0.8, 0.8, 0.8)
            love.graphics.printf(GameData.getText(currentGameLanguage, itemData.description_key), inventoryState.detailsX, inventoryState.detailsY + 30, windowWidth - inventoryState.detailsX - 20, "left")

            if itemData.type == "consumable" then
                love.graphics.setFont(itemFont)
                love.graphics.setColor(0.7, 1, 0.7)
                love.graphics.printf(GameData.getText(currentGameLanguage, "inventory_prompt_details_use"), inventoryState.detailsX, inventoryState.detailsY + 80, windowWidth - inventoryState.detailsX - 20, "left")
            elseif itemData.type == "equipment" then
                love.graphics.setFont(itemFont)
                love.graphics.setColor(0.7, 0.9, 1) -- Light blue for equip/unequip
                -- Check if the item is currently equipped to decide which prompt to show.
                -- This logic might need adjustment based on how equipped status is tracked.
                -- For now, assuming a simple check. If player.equipment[slotKey] == selectedItem.itemId (this check is complex here)
                -- A simpler way is to check if this item is in an equipment slot.
                local isEquipped = false
                for _, equipSlotKey in ipairs(inventoryState.equipmentSlotOrder) do
                    if player.equipment[equipSlotKey] == selectedItem.itemId then
                        isEquipped = true
                        break
                    end
                end
                if isEquipped then
                    love.graphics.printf(GameData.getText(currentGameLanguage, "inventory_prompt_details_unequip"), inventoryState.detailsX, inventoryState.detailsY + 80, windowWidth - inventoryState.detailsX - 20, "left")
                else
                    love.graphics.printf(GameData.getText(currentGameLanguage, "inventory_prompt_details_equip"), inventoryState.detailsX, inventoryState.detailsY + 80, windowWidth - inventoryState.detailsX - 20, "left")
                end
            end
        end
    end

    if uiMessage and uiMessageTimer > 0 then
        love.graphics.setFont(itemFont)
        love.graphics.setColor(1,1,0)
        local msgWidth = itemFont:getWidth(uiMessage)
        love.graphics.printf(uiMessage, windowWidth / 2 - msgWidth / 2, windowHeight - 70, windowWidth, "center")
    end

    -- Equipment Panel Drawing
    local eqPanelX = inventoryState.detailsX;
    local eqPanelY = inventoryState.detailsY + 120;
    local eqPanelWidth = windowWidth - eqPanelX - inventoryState.padding - 20;
    local eqSlotHeight = (itemFont:getHeight() + 4) * 2;
    local eqPanelHeight = (#inventoryState.equipmentSlotOrder * eqSlotHeight) + inventoryState.padding * 3 + itemFont:getHeight();

    inventoryState.equipmentPanel = {x = eqPanelX, y = eqPanelY, width = eqPanelWidth, height = eqPanelHeight};

    love.graphics.setColor(0.12, 0.12, 0.18)
    love.graphics.rectangle("fill", eqPanelX, eqPanelY, eqPanelWidth, eqPanelHeight)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line", eqPanelX, eqPanelY, eqPanelWidth, eqPanelHeight)
    love.graphics.setFont(titleFont)
    love.graphics.printf(GameData.getText(currentGameLanguage, "inventory_equipped_title", nil, "Equipped"), eqPanelX, eqPanelY + inventoryState.padding / 2, eqPanelWidth, "center")
    love.graphics.setFont(itemFont)

    local currentEqY = eqPanelY + titleFont:getHeight() + inventoryState.padding;
    inventoryState.equipmentSlotDisplayAreas = {}

    for i, slotKey in ipairs(inventoryState.equipmentSlotOrder) do
        local slotDisplayName = GameData.getText(currentGameLanguage, "equip_slot_" .. slotKey, nil, slotKey:gsub("^%l", string.upper))
        local itemInSlotId = player.equipment[slotKey]
        local itemDisplayName = GameData.getText(currentGameLanguage, "equip_slot_empty", nil, "Empty")
        if itemInSlotId then
            local itemData = GameData.items[itemInSlotId]
            if itemData then
                itemDisplayName = GameData.getText(currentGameLanguage, itemData.name_key, nil, itemInSlotId)
            else
                itemDisplayName = "Unknown Item"
            end
        end

        local displayArea = {x = eqPanelX + inventoryState.padding, y = currentEqY, width = eqPanelWidth - inventoryState.padding*2, height = eqSlotHeight - 4}
        inventoryState.equipmentSlotDisplayAreas[slotKey] = displayArea

        if inventoryState.currentFocus == "equipment" and inventoryState.selectedEquipmentSlotKey == slotKey then
            love.graphics.setColor(1,1,0,0.3)
            love.graphics.rectangle("fill", displayArea.x, displayArea.y, displayArea.width, displayArea.height)
        end

        love.graphics.setColor(0.8,0.8,1)
        love.graphics.print(slotDisplayName .. ":", displayArea.x + 5, displayArea.y + 2)
        love.graphics.setColor(1,1,1)
        love.graphics.printf(itemDisplayName, displayArea.x + 5, displayArea.y + itemFont:getHeight() + 4, displayArea.width - 10, "left")

        currentEqY = currentEqY + eqSlotHeight
    end

    love.graphics.setColor(1,1,1)

    local promptText = ""
    local currentSelectedItem = player.inventory[inventoryState.selectedSlot]
    if inventoryState.currentFocus == "inventory" and currentSelectedItem then
        local itemData = GameData.items[currentSelectedItem.itemId]
        if itemData and itemData.type == "equipment" then
            promptText = GameData.getText(currentGameLanguage, "prompt_equip", nil, "Enter to Equip (Tab to switch focus)")
        elseif itemData and itemData.type == "consumable" then
            promptText = GameData.getText(currentGameLanguage, "prompt_use", nil, "Enter to Use (Tab to switch focus)")
        else
             promptText = GameData.getText(currentGameLanguage, "prompt_inventory_actions", nil, "I to Close (Tab to switch focus)")
        end
    elseif inventoryState.currentFocus == "equipment" then
        if inventoryState.selectedEquipmentSlotKey and player.equipment[inventoryState.selectedEquipmentSlotKey] then
            promptText = GameData.getText(currentGameLanguage, "prompt_unequip", nil, "Enter to Unequip (Tab to switch focus)")
        else
            promptText = GameData.getText(currentGameLanguage, "prompt_equipment_actions", nil, "I to Close (Tab to switch focus)")
        end
    else
        promptText = GameData.getText(currentGameLanguage, "prompt_general_inventory", nil, "I to Close (Tab to switch focus)")
    end

    love.graphics.setFont(itemFont)
    love.graphics.setColor(0.8,0.8,0.8)
    love.graphics.printf(promptText, inventoryState.gridStartX, windowHeight - 40, windowWidth - inventoryState.gridStartX*2, "center")
end

function M.drawQuestLogScreen(questLogState, player, GameData, currentGameLanguage, resources)
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()
    love.graphics.clear(0.1, 0.1, 0.15, 1)

    local uiFont = resources.fonts.ui or love.graphics.newFont(16)
    local titleFont = resources.fonts.battle or love.graphics.newFont(24)
    questLogState.lineHeight = uiFont:getHeight() + 4

    love.graphics.setFont(titleFont)
    love.graphics.setColor(1, 1, 1)
    local titleText = GameData.getText(currentGameLanguage, "menu_quest_log")
    love.graphics.printf(titleText, 0, questLogState.padding, windowWidth, "center")

    love.graphics.setFont(uiFont)
    local tabY = questLogState.padding * 2 + titleFont:getHeight()
    local tabHeight = questLogState.lineHeight + questLogState.padding
    local activeTabText = GameData.getText(currentGameLanguage, "quest_log_active", nil, "Active")
    local completedTabText = GameData.getText(currentGameLanguage, "quest_log_completed", nil, "Completed")

    local activeTabWidth = uiFont:getWidth(activeTabText) + questLogState.padding * 2
    local completedTabWidth = uiFont:getWidth(completedTabText) + questLogState.padding * 2

    questLogState.tabAreas.active = { x = questLogState.padding, y = tabY, width = activeTabWidth, height = tabHeight }
    questLogState.tabAreas.completed = { x = questLogState.padding + activeTabWidth + questLogState.padding, y = tabY, width = completedTabWidth, height = tabHeight }

    if questLogState.currentTab == "active" then
        love.graphics.setColor(0.4, 0.4, 0.5)
    else
        love.graphics.setColor(0.2, 0.2, 0.3)
    end
    love.graphics.rectangle("fill", questLogState.tabAreas.active.x, questLogState.tabAreas.active.y, questLogState.tabAreas.active.width, questLogState.tabAreas.active.height)
    love.graphics.setColor(1,1,1)
    love.graphics.printf(activeTabText, questLogState.tabAreas.active.x + questLogState.padding, tabY + questLogState.padding / 2, activeTabWidth - questLogState.padding * 2, "center")

    if questLogState.currentTab == "completed" then
        love.graphics.setColor(0.4, 0.4, 0.5)
    else
        love.graphics.setColor(0.2, 0.2, 0.3)
    end
    love.graphics.rectangle("fill", questLogState.tabAreas.completed.x, questLogState.tabAreas.completed.y, questLogState.tabAreas.completed.width, questLogState.tabAreas.completed.height)
    love.graphics.setColor(1,1,1)
    love.graphics.printf(completedTabText, questLogState.tabAreas.completed.x + questLogState.padding, tabY + questLogState.padding/2, completedTabWidth - questLogState.padding*2, "center")

    local listX = questLogState.padding
    local listY = tabY + tabHeight + questLogState.padding
    local listWidth = windowWidth * 0.4 - questLogState.padding * 1.5
    local listHeight = windowHeight - listY - questLogState.padding
    questLogState.questListArea = {x = listX, y = listY, width = listWidth, height = listHeight}
    love.graphics.setColor(0.2, 0.2, 0.25)
    love.graphics.rectangle("fill", listX, listY, listWidth, listHeight)
    love.graphics.setColor(1,1,1)

    local questsToDisplay = {}
    local currentScrollOffset = 0
    if questLogState.currentTab == "active" then
        if player.activeQuests then
            for id, data in pairs(player.activeQuests) do
                table.insert(questsToDisplay, {id = id, data = data})
            end
        end
        currentScrollOffset = questLogState.activeQuestScrollOffset
    else
        if player.completedQuests then
            for id, _ in pairs(player.completedQuests) do
                 table.insert(questsToDisplay, {id = id, data = GameData.quests[id]})
            end
        end
        currentScrollOffset = questLogState.completedQuestScrollOffset
    end

    table.sort(questsToDisplay, function(a,b) return a.id < b.id end)

    love.graphics.setScissor(listX, listY, listWidth, listHeight)
    for i, questEntry in ipairs(questsToDisplay) do
        if i > currentScrollOffset and i <= currentScrollOffset + questLogState.questsPerPage then
            local questDef = GameData.quests[questEntry.id]
            if questDef then
                local questName = GameData.getText(currentGameLanguage, questDef.title_key, nil, questEntry.id)
                local itemY = listY + (i - 1 - currentScrollOffset) * questLogState.lineHeight + questLogState.padding

                if questEntry.id == questLogState.selectedQuestId then
                    love.graphics.setColor(0.5, 0.5, 0.3)
                    love.graphics.rectangle("fill", listX, itemY - questLogState.padding/2, listWidth, questLogState.lineHeight)
                    love.graphics.setColor(1,1,0)
                else
                    love.graphics.setColor(1,1,1)
                end
                love.graphics.print(questName, listX + questLogState.padding, itemY)
            end
        end
    end
    love.graphics.setScissor()
    love.graphics.setColor(1,1,1)

    local detailsX = listX + listWidth + questLogState.padding
    local detailsY = listY
    local detailsWidth = windowWidth - detailsX - questLogState.padding
    local detailsHeight = listHeight
    questLogState.detailsArea = {x = detailsX, y = detailsY, width = detailsWidth, height = detailsHeight}
    love.graphics.setColor(0.25, 0.25, 0.2)
    love.graphics.rectangle("fill", detailsX, detailsY, detailsWidth, detailsHeight)
    love.graphics.setColor(1,1,1)

    love.graphics.setScissor(detailsX, detailsY, detailsWidth, detailsHeight)
    if questLogState.selectedQuestId and GameData.quests[questLogState.selectedQuestId] then
        local questDef = GameData.quests[questLogState.selectedQuestId]
        local currentY = detailsY + questLogState.padding;

        love.graphics.setFont(titleFont)
        local selectedTitle = GameData.getText(currentGameLanguage, questDef.title_key, nil, questLogState.selectedQuestId)
        love.graphics.printf(selectedTitle, detailsX + questLogState.padding, currentY, detailsWidth - questLogState.padding*2, "left")
        currentY = currentY + titleFont:getHeight() + questLogState.padding * 2
        love.graphics.setFont(uiFont)

        local description = GameData.getText(currentGameLanguage, questDef.description_key, nil, "No description.")
        love.graphics.printf(description, detailsX + questLogState.padding, currentY, detailsWidth - questLogState.padding*2, "left")
        currentY = currentY + uiFont:getHeight(description, detailsWidth - questLogState.padding*2) + questLogState.lineHeight

        love.graphics.setColor(0.8, 0.9, 1)
        love.graphics.print(GameData.getText(currentGameLanguage, "quest_log_objectives", nil, "Objectives:"), detailsX + questLogState.padding, currentY)
        currentY = currentY + questLogState.lineHeight
        love.graphics.setColor(1,1,1)

        if questDef.objectives then
            for i, obj in ipairs(questDef.objectives) do
                local progressText = ""
                if questLogState.currentTab == "active" and player.activeQuests[questLogState.selectedQuestId] and player.activeQuests[questLogState.selectedQuestId].objectives[i] then
                    local currentProgress = player.activeQuests[questLogState.selectedQuestId].objectives[i].currentProgress or 0
                    progressText = string.format(" (%d/%d)", currentProgress, obj.requiredCount)
                elseif questLogState.currentTab == "completed" then
                    progressText = string.format(" (%d/%d)", obj.requiredCount, obj.requiredCount)
                end

                local objectiveText = ""
                if obj.type == "kill" then
                    local enemyName = GameData.getText(currentGameLanguage, obj.target_key, nil, obj.target_key)
                    objectiveText = GameData.getText(currentGameLanguage, "quest_log_obj_kill", {target=enemyName, count=obj.requiredCount}, "- Kill %{count} %{target}") .. progressText
                elseif obj.type == "collect" then
                    local itemName = GameData.getText(currentGameLanguage, GameData.items[obj.item_id].name_key, nil, obj.item_id)
                    objectiveText = GameData.getText(currentGameLanguage, "quest_log_obj_collect", {item=itemName, count=obj.requiredCount}, "- Collect %{count} %{item}") .. progressText
                else
                    objectiveText = "- Unknown objective type" .. progressText
                end
                love.graphics.printf(objectiveText, detailsX + questLogState.padding * 2, currentY, detailsWidth - questLogState.padding*3, "left")
                currentY = currentY + uiFont:getHeight(objectiveText, detailsWidth - questLogState.padding*3) + questLogState.padding / 2
            end
        end
        currentY = currentY + questLogState.lineHeight

        love.graphics.setColor(1, 0.9, 0.8)
        love.graphics.print(GameData.getText(currentGameLanguage, "quest_log_rewards", nil, "Rewards:"), detailsX + questLogState.padding, currentY)
        currentY = currentY + questLogState.lineHeight
        love.graphics.setColor(1,1,1)

        if questDef.rewards then
            if questDef.rewards.exp then
                love.graphics.print(GameData.getText(currentGameLanguage, "quest_log_reward_exp", {exp = questDef.rewards.exp}, "- %{exp} EXP"), detailsX + questLogState.padding * 2, currentY)
                currentY = currentY + questLogState.lineHeight
            end
            if questDef.rewards.gold then
                 love.graphics.print(GameData.getText(currentGameLanguage, "quest_log_reward_gold", {gold = questDef.rewards.gold}, "- %{gold} Gold"), detailsX + questLogState.padding * 2, currentY)
                currentY = currentY + questLogState.lineHeight
            end
            if questDef.rewards.items then
                for _, itemReward in ipairs(questDef.rewards.items) do
                    local itemName = GameData.getText(currentGameLanguage, GameData.items[itemReward.itemId].name_key, nil, itemReward.itemId)
                    local itemText = GameData.getText(currentGameLanguage, "quest_log_reward_item", {item=itemName, quantity=itemReward.quantity}, "- %{quantity}x %{item}")
                    love.graphics.print(itemText, detailsX + questLogState.padding * 2, currentY)
                    currentY = currentY + questLogState.lineHeight
                end
            end
        end

    else
        love.graphics.printf(GameData.getText(currentGameLanguage, "quest_log_no_quest_selected", nil, "Select a quest to see details."), detailsX + questLogState.padding, detailsY + questLogState.padding, detailsWidth - questLogState.padding*2, "center")
    end
    love.graphics.setScissor()

    love.graphics.setFont(uiFont)
    love.graphics.setColor(0.8, 0.8, 0.8)
    local instructions = GameData.getText(currentGameLanguage, "quest_log_instructions", nil, "Up/Down: Select Quest | Left/Right: Change Tab | ESC: Back")
    love.graphics.printf(instructions, 0, windowHeight - questLogState.lineHeight, windowWidth, "center")
end

function M.drawStatsScreen(statsScreenState, player, GameData, currentGameLanguage, resources)
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()
    love.graphics.clear(0.15, 0.15, 0.1, 1)

    local uiFont = resources.fonts.ui or love.graphics.newFont(18)
    local titleFont = resources.fonts.battle or love.graphics.newFont(28)

    statsScreenState.lineHeight = uiFont:getHeight() + 8
    local currentY = statsScreenState.padding

    love.graphics.setFont(titleFont)
    love.graphics.setColor(1, 1, 1)
    local titleText = GameData.getText(currentGameLanguage, "stats_screen_title", nil, "Player Statistics")
    love.graphics.printf(titleText, 0, currentY, windowWidth, "center")
    currentY = currentY + titleFont:getHeight() + statsScreenState.padding * 2

    love.graphics.setFont(uiFont)

    local statsToDisplay = {
        {label_key = "stat_label_level", value = player.level},
        {label_key = "stat_label_exp", value_format = "%s / %s", value = player.exp, value2 = player.expToNextLevel},
        {label_key = "stat_label_hp", value_format = "%s / %s", value = player.hp, value2 = player.maxHp},
        {label_key = "stat_label_mp", value_format = "%s / %s", value = player.mp, value2 = player.maxMp},
        {label_key = "stat_label_attack", value = player.attack},
        {label_key = "stat_label_defense", value = player.defense},
        {label_key = "stat_label_crit_rate", value_format = "%s%%", value = player.critRate},
        {label_key = "stat_label_crit_damage", value_format = "%sx", value = player.critDamage}
    }

    local maxLabelWidth = 0
    for _, statItem in ipairs(statsToDisplay) do
        local labelText = GameData.getText(currentGameLanguage, statItem.label_key, nil, statItem.label_key) .. ":"
        if uiFont:getWidth(labelText) > maxLabelWidth then
            maxLabelWidth = uiFont:getWidth(labelText)
        end
    end
    statsScreenState.labelColumnWidth = maxLabelWidth + statsScreenState.padding
    statsScreenState.valueColumnX = statsScreenState.padding + statsScreenState.labelColumnWidth

    for _, statItem in ipairs(statsToDisplay) do
        love.graphics.setColor(0.8, 0.8, 1)
        local labelText = GameData.getText(currentGameLanguage, statItem.label_key, nil, statItem.label_key) .. ":"
        love.graphics.print(labelText, statsScreenState.padding + (statsScreenState.labelColumnWidth - uiFont:getWidth(labelText) - statsScreenState.padding), currentY)

        love.graphics.setColor(1, 1, 1)
        local valueString
        if statItem.value_format then
            if statItem.value2 then
                valueString = string.format(statItem.value_format, tostring(statItem.value), tostring(statItem.value2))
            else
                valueString = string.format(statItem.value_format, tostring(statItem.value))
            end
        else
            valueString = tostring(statItem.value)
        end
        love.graphics.print(valueString, statsScreenState.valueColumnX, currentY)

        currentY = currentY + statsScreenState.lineHeight
    end

    love.graphics.setColor(0.8, 0.8, 0.8)
    local instructions = GameData.getText(currentGameLanguage, "stats_screen_instructions", nil, "Press ESC to go back")
    love.graphics.printf(instructions, 0, windowHeight - statsScreenState.lineHeight - statsScreenState.padding, windowWidth, "center")
end

function M.drawCharacters(animations, resources, positions, enemy)
  local windowWidth = love.graphics.getWidth()
  local windowHeight = love.graphics.getHeight()

  local playerImageKey = nil
  if player.equipment.weapon then
    local itemId = player.equipment.weapon
    local itemData = GameData.items[itemId]
    if itemData and itemData.model_key_player then
      playerImageKey = itemData.model_key_player
    end
  end

  local playerImage
  if playerImageKey and resources.images[playerImageKey] then
    playerImage = resources.images[playerImageKey]
    -- If we want weapon sprites to also have attack animations,
    -- we might need a naming convention like model_key_player .. "_attack"
    -- For now, the weapon model overrides both stand and attack.
  else
    if animations.player.current == "stand" then
        playerImage = resources.images.playerStand
    else -- Assuming "attack" is the other main animation state
        playerImage = resources.images.playerAttack
    end
  end

  if not playerImage then
    print("[ERROR] playerImage is nil in M.drawCharacters. Defaulting to playerStand.")
    playerImage = resources.images.playerStand
    if not playerImage then
        print("[ERROR] Default playerStand image is also nil. Cannot draw player.")
        return 
    end
  end

  local playerScaleX = positions.player.maxWidth / playerImage:getWidth()
  local playerScaleY = positions.player.maxHeight / playerImage:getHeight()
  local playerScale = math.min(playerScaleX, playerScaleY)

  if playerImage:getHeight() * playerScale < positions.player.minHeight then
      playerScale = positions.player.minHeight / playerImage:getHeight()
  end

  local playerDrawX = positions.player.x - (playerImage:getWidth() * playerScale) / 2
  local playerDrawY = positions.player.y - (playerImage:getHeight() * playerScale) / 2
  love.graphics.draw(playerImage, playerDrawX, playerDrawY, 0, playerScale, playerScale)

  local enemyStandImage = enemy.image
  local enemyAttackImageActualKey = enemy.attackImageKey

  local currentEnemySprite
  if animations.enemy.current == "attack" then
    if enemyAttackImageActualKey and resources.images[enemyAttackImageActualKey] then
      currentEnemySprite = resources.images[enemyAttackImageActualKey]
    else
      currentEnemySprite = enemyStandImage
    end
  else
    currentEnemySprite = enemyStandImage
  end

  if not currentEnemySprite then
      print("[ERROR] Enemy sprite is nil in drawCharacters. Fallback.")
      currentEnemySprite = resources.images.enemyDemonKing 
      if not currentEnemySprite then
          print("[ERROR] Default enemyDemonKing image is also nil. Cannot draw enemy.")
          return 
      end
  end

  local enemyImage = currentEnemySprite
  local enemyScaleX = positions.enemy.maxWidth / enemyImage:getWidth()
  local enemyScaleY = positions.enemy.maxHeight / enemyImage:getHeight()
  local enemyScale = math.min(enemyScaleX, enemyScaleY)

  if enemyImage:getHeight() * enemyScale < positions.enemy.minHeight then
      enemyScale = positions.enemy.minHeight / enemyImage:getHeight()
  end

  local enemyDrawX = positions.enemy.x - (enemyImage:getWidth() * enemyScale) / 2
  -- FIX: Changed positions.y to positions.enemy.y
  local enemyDrawY = positions.enemy.y - (enemyImage:getHeight() * enemyScale) / 2
  love.graphics.draw(enemyImage, enemyDrawX, enemyDrawY, 0, enemyScale, enemyScale)
end

function M.drawHowToPlayPageUI(resources, howToPlayState, gameData, currentLanguage)
    love.graphics.setColor(0.1, 0.1, 0.2, 1) -- Dark blue background
    love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
    love.graphics.setColor(1, 1, 1, 1) -- Reset color to white for text

    local uiFont = resources.fonts.ui
    local lineSpacing = uiFont:getHeight() * 1.5
    if currentLanguage == "zh" then
        uiFont = resources.fonts.chineseUI or resources.fonts.ui -- Fallback if chineseUI is not defined
        lineSpacing = (resources.fonts.chineseUI and resources.fonts.chineseUI:getHeight() or uiFont:getHeight()) * 1.5
    end
    love.graphics.setFont(uiFont)

    -- Title
    local titleText = gameData.getText(currentLanguage, "how_to_play_title")
    love.graphics.printf(titleText, 0, 50, screenWidth, "center")

    -- Instructional Text
    local yPos = 120
    local xPos = 50
    local indentX = xPos + 150 -- Indent for keys/actions
    local sectionSpacing = lineSpacing * 1.2 -- Spacing between sections
    local valueIndentX = xPos + 250 -- Indent for the actual keys

    -- Controls Section Title
    love.graphics.setColor(0.8, 1, 0.8) -- Light green for section titles
    love.graphics.print(gameData.getText(currentLanguage, "htp_title_controls"), xPos, yPos)
    love.graphics.setColor(1, 1, 1)
    yPos = yPos + sectionSpacing

    -- Movement
    love.graphics.print(gameData.getText(currentLanguage, "htp_movement"), xPos, yPos)
    love.graphics.print(gameData.getText(currentLanguage, "htp_movement_keys"), valueIndentX, yPos)
    yPos = yPos + lineSpacing

    -- Interact/Confirm
    love.graphics.print(gameData.getText(currentLanguage, "htp_interact"), xPos, yPos)
    love.graphics.print(gameData.getText(currentLanguage, "htp_interact_keys"), valueIndentX, yPos)
    yPos = yPos + lineSpacing

    -- Cancel/Back
    love.graphics.print(gameData.getText(currentLanguage, "htp_cancel_back"), xPos, yPos)
    love.graphics.print(gameData.getText(currentLanguage, "htp_cancel_back_keys"), valueIndentX, yPos)
    yPos = yPos + sectionSpacing -- Add more space after general controls

    -- Inventory Hotkey
    love.graphics.print(gameData.getText(currentLanguage, "htp_menu_inventory"), xPos, yPos)
    love.graphics.print(gameData.getText(currentLanguage, "htp_menu_inventory_key"), valueIndentX, yPos)
    yPos = yPos + lineSpacing

    -- Quest Log Hotkey
    love.graphics.print(gameData.getText(currentLanguage, "htp_menu_quests"), xPos, yPos)
    love.graphics.print(gameData.getText(currentLanguage, "htp_menu_quests_key"), valueIndentX, yPos)
    yPos = yPos + lineSpacing

    -- Stats Screen Hotkey
    love.graphics.print(gameData.getText(currentLanguage, "htp_menu_stats"), xPos, yPos)
    love.graphics.print(gameData.getText(currentLanguage, "htp_menu_stats_key"), valueIndentX, yPos)
    yPos = yPos + sectionSpacing -- Add more space after menu hotkeys

    -- Battle Actions
    love.graphics.print(gameData.getText(currentLanguage, "htp_battle_actions"), xPos, yPos)
    love.graphics.printf(gameData.getText(currentLanguage, "htp_battle_actions_keys"), valueIndentX, yPos, screenWidth - valueIndentX - xPos, "left")
    yPos = yPos + uiFont:getHeight(gameData.getText(currentLanguage, "htp_battle_actions_keys"), screenWidth - valueIndentX - xPos) + lineSpacing


    -- Skip Dialogue
    love.graphics.print(gameData.getText(currentLanguage, "htp_skip_dialogue"), xPos, yPos)
    love.graphics.print(gameData.getText(currentLanguage, "htp_skip_dialogue_key"), valueIndentX, yPos)
    yPos = yPos + sectionSpacing

    -- Back Button
    local backButtonText = gameData.getText(currentLanguage, "how_to_play_back_button")
    local buttonWidth = uiFont:getWidth(backButtonText) + 40 -- Padding
    local buttonHeight = uiFont:getHeight() + 20 -- Padding
    local buttonX = (screenWidth - buttonWidth) / 2
    local buttonY = screenHeight - buttonHeight - 30

    -- Define button area for mouse clicks
    howToPlayState.backButtonArea = {x = buttonX, y = buttonY, width = buttonWidth, height = buttonHeight}

    -- Draw button (simple rectangle and text)
    love.graphics.setColor(0.3, 0.3, 0.3, 1)
    love.graphics.rectangle("fill", buttonX, buttonY, buttonWidth, buttonHeight)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(backButtonText, buttonX, buttonY + (buttonHeight - uiFont:getHeight()) / 2, buttonWidth, "center")
    love.graphics.setColor(1,1,1) -- Reset color just in case
end
return M