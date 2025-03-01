-- Build with love-12.0-win64 Beta
-- A Hero's Redemption 2D Game Script
-- Created by Dundd2, 2025/1

local story = {
  text = {
      en = {
          menu_title = "A Hero's Redemption 2D",
          menu_select_level = "Select Level",
          menu_select_level_desc = "Choose a level to challenge",
          menu_options = "Options",
          menu_options_desc = "Adjust game settings",
          menu_exit = "Exit",
          menu_exit_desc = "Quit the game",
          menu_story_page = "Story Page",
          menu_story_page_desc = "Read the game's story",

          level_select_title = "Select Level",
          level_number = "Level %{level}",

          pause_title = "Game Paused",
          pause_continue = "Continue",
          pause_restart = "Restart",
          pause_main_menu = "Main Menu",
          pause_quit_game = "Quit Game",

          victory_title = "Victory!",
          defeat_title = "Defeat!",
          result_restart = "Restart",
          result_main_menu = "Main Menu",

          options_title = "Options",
          options_language = "Language",
          options_bgm = "Background Music",
          options_sfx = "Sound Effects",
          options_cheat = "Cheat Mode (One-Hit Kill)",
          options_back_to_menu = "Back to Main Menu",
          options_on = "ON",
          options_off = "OFF",
          options_resolution = "Resolution", -- New option
          options_resolution_desc = "Set game screen resolution", -- Description for resolution option

          battle_victory = "Victory!",
          battle_defeat = "Defeat!",
          battle_action_attack = "Attack",
          battle_action_desc_attack = "Deal damage to enemy",
          battle_action_defend = "Defend",
          battle_action_desc_defend = "Reduce incoming damage",
          battle_action_special = "Special",
          battle_action_desc_special = "Powerful attack with delay",
          battle_action_heal = "Heal",
          battle_action_desc_heal = "Restore health",

          skill_info_title = "Skill Information",
          skill_name_attack = "Basic Attack",
          skill_desc_attack = "A basic attack skill.",
          skill_details_attack = "Deal small physical damage to enemy.",
          skill_name_defend = "Defend",
          skill_desc_defend = "Enter defensive stance.",
          skill_details_defend = "Increase defense to reduce incoming damage.",
          skill_name_special = "Special Attack",
          skill_desc_special = "Powerful special attack with high damage.",
          skill_details_special = "Deal large physical damage but requires preparation.",
          skill_name_heal = "Heal",
          skill_desc_heal = "Restore HP.",
          skill_details_heal = "Heal yourself based on character attributes.",
          skill_detail_name = "Skill Name",
          skill_detail_type = "Skill Type",
          skill_detail_desc = "Description",
          skill_type_offensive = "Offensive",
          skill_type_defensive = "Defensive",
          skill_type_support = "Support",

          story_continue_prompt = "Press ENTER to continue",
          story_skip_button = "Skip (ESC)",

          battle_msg_player_attack = "You attack! Dealt %{damage} damage!",
          battle_msg_player_crit = "Critical hit! Dealt %{damage} damage!",
          battle_msg_player_defend = "You enter defensive stance!",
          battle_msg_player_special = "Player unleashes special attack! %{damage} damage!",
          battle_msg_player_heal = "You restored %{healAmount} health points!",
          battle_msg_enemy_attack = "Enemy attacks! Dealt %{damage} damage!",
          battle_msg_enemy_crit = "Enemy critical hit! Dealt %{damage} damage!",
          battle_msg_enemy_defend = "Enemy enters defensive stance!",

          -- Enemy display names
          enemy_name_goblin = "Goblin",
          enemy_name_orc = "Orc",
          enemy_name_stonegolem = "Stone Golem",
          enemy_name_skeletonwarrior = "Skeleton Warrior",
          enemy_name_darkknight = "Dark Knight",
          enemy_name_banshee = "Banshee",
          enemy_name_minotaur = "Minotaur",
          enemy_name_greendragon = "Green Dragon",
          enemy_name_reddragon = "Red Dragon",
          enemy_name_demonking = "Demon King",

          story_page_title = "A Hero’s Redemption Story:", -- 故事頁標題
          story_page_back_button = "Back to Menu", -- 故事頁返回按鈕
          game_full_story = [[

A month ago, the Demon King led his army to 
In the end, the hero successfully defeated the Demon King,
]],
      },
      zh = {
          menu_title = "英雄的救贖 2D",
          menu_select_level = "選擇關卡",
          menu_select_level_desc = "選擇要挑戰的關卡",
          menu_options = "選項",
          menu_options_desc = "調整遊戲設定",
          menu_exit = "退出",
          menu_exit_desc = "離開遊戲",
          menu_story_page = "故事頁", -- 新增主選單選項文本
          menu_story_page_desc = "閱讀遊戲故事", -- 新增主選單選項描述

          level_select_title = "選擇關卡",
          level_number = "關卡 %{level}",

          pause_title = "遊戲暫停",
          pause_continue = "繼續",
          pause_restart = "重新開始",
          pause_main_menu = "主選單",
          pause_quit_game = "退出遊戲",

          victory_title = "勝利！",
          defeat_title = "失敗！",
          result_restart = "重新開始",
          result_main_menu = "主選單",

          options_title = "選項",
          options_language = "語言",
          options_bgm = "背景音樂",
          options_sfx = "音效",
          options_cheat = "作弊模式 (一擊必殺)",
          options_back_to_menu = "返回主選單",
          options_on = "開",
          options_off = "關",
          options_resolution = "解析度", -- New option (Chinese)
          options_resolution_desc = "設定遊戲螢幕解析度", -- Description for resolution option (Chinese)

          battle_victory = "勝利！",
          battle_defeat = "失敗！",
          battle_action_attack = "攻擊",
          battle_action_desc_attack = "對敵人造成傷害",
          battle_action_defend = "防禦",
          battle_action_desc_defend = "減少受到的傷害",
          battle_action_special = "特殊",
          battle_action_desc_special = "強力的延遲攻擊",
          battle_action_heal = "治療",
          battle_action_desc_heal = "恢復生命值",

          skill_info_title = "技能資訊",
          skill_name_attack = "基本攻擊",
          skill_desc_attack = "基礎攻擊技能。",
          skill_details_attack = "對敵人造成少量物理傷害。",
          skill_name_defend = "防禦",
          skill_desc_defend = "進入防禦姿態。",
          skill_details_defend = "增加防禦力以減少受到的傷害。",
          skill_name_special = "特殊攻擊",
          skill_desc_special = "強大的特殊高傷害攻擊。",
          skill_details_special = "造成大量物理傷害，但需要準備時間。",
          skill_name_heal = "治療",
          skill_desc_heal = "恢復生命值。",
          skill_details_heal = "根據角色屬性治療自己。",
          skill_detail_name = "技能名稱",
          skill_detail_type = "技能類型",
          skill_detail_desc = "描述",
          skill_type_offensive = "攻擊型",
          skill_type_defensive = "防禦型",
          skill_type_support = "輔助型",

          story_continue_prompt = "按 ENTER 繼續",
          story_skip_button = "跳過 (ESC)",

          battle_msg_player_attack = "你發動攻擊！造成 %{damage} 點傷害！",
          battle_msg_player_crit = "暴擊！造成 %{damage} 點傷害！",
          battle_msg_player_defend = "你進入防禦姿態！",
          battle_msg_player_special = "玩家釋放特殊攻擊！%{damage} 點傷害！",
          battle_msg_player_heal = "你恢復了 %{healAmount} 點生命值！",
          battle_msg_enemy_attack = "敵人攻擊！造成 %{damage} 點傷害！",
          battle_msg_enemy_crit = "敵人暴擊！造成 %{damage} 點傷害！",
          battle_msg_enemy_defend = "敵人進入防禦姿態！",

          -- Enemy display names (Chinese)
          enemy_name_goblin = "哥布林",
          enemy_name_orc = "兽人",
          enemy_name_stonegolem = "石頭巨人",
          enemy_name_skeletonwarrior = "骷髏戰士",
          enemy_name_darkknight = "黑暗騎士",
          enemy_name_banshee = "女妖",
          enemy_name_minotaur = "牛頭怪",
          enemy_name_greendragon = "綠龍",
          enemy_name_reddragon = "紅龍",
          enemy_name_demonking = "惡魔之王",

          story_page_title = "英雄的救贖 2D 故事", -- 故事頁標題 (中文)
          story_page_back_button = "返回主選單", -- 故事頁返回按鈕 (中文)
          game_full_story = [[
一個月前，魔王率領他的軍隊征服城池、奪取領土，並綁架國王的公主，威脅國王要么割讓土地，要么退位讓賢。  

最終，英雄憑藉自身的智慧與實力擊敗了魔王，打破封印，成功救出了公主。  

]],
      },
  },
  -- Text display effect settings
  textEffect = {
      currentText = "",
      targetText = "",
      displayIndex = 1,
      charDelay = 0.1, -- 調整故事模式文字速度，原本 0.05 改為 0.1 (數值越大越慢)
      timer = 0,
      isComplete = false
  },

  -- Character definitions
  characters = {
      hero = {
          name = "Hero",
          portrait = "portraitHero",
          title = "Fearless Warrior",
          personality = "Brave and Righteous"
      },
      king = {
          name = "King",
          portrait = "portraitKing",
          title = "Ruler of Azure Kingdom",
          personality = "Dignified and Kind"
      },
      princess = {
          name = "Princess",
          portrait = "portraitPrincess",
          title = "Azure Princess",
          personality = "Gentle but Strong"
      },
      demonKing = {
          name = "Demon King",
          portrait = "portraitDemonKing",
          title = "Dark Overlord",
          personality = "Cunning and Evil"
      }
  },

  -- Level intro dialogues
  levelIntros = {
      [1] = {
          background = "assets/palace.png",
          music = "assets/palaceTheme",
          dialogues = {
              {speaker = "King", text = "The kingdom faces an unprecedented crisis...", emotion = "worried"},
              {speaker = "King", text = "The Demon King has not only seized our border towns but also kidnapped my daughter!", emotion = "angry"},
              {speaker = "Hero", text = "Your Majesty, I heard the princess is held in the demon castle.", emotion = "determined"},
              {speaker = "King", text = "Yes, many heroes went to rescue her, but none returned...", emotion = "sad"},
              {speaker = "Hero", text = "Let me go rescue the princess! I swear to bring her back safely.", emotion = "confident"},
              {speaker = "King", text = "You seem different from the others... Very well, I trust you can succeed.", emotion = "hopeful"},
              {speaker = "King", text = "If you save the princess, I'll grant you her hand and half the kingdom.", emotion = "serious"}
          }
      },
      [2] = {
          background = "assets/forest.png",
          dialogues = {
              {speaker = "Narrator", text = "The hero enters the Demon King's territory - the Misty Forest...", emotion = "narrative"},
              {speaker = "enemy_name_goblin", text = "Another foolish human!", emotion = "mocking"}, -- Using displayNameKey
              {speaker = "Hero", text = "You monsters will be cleared today!", emotion = "determined"}
          }
      },
      [3] = {
          dialogues = {
              {speaker = "enemy_name_orc", text = "Want to pass? Get through me first!"}, -- Using displayNameKey
              {speaker = "Hero", text = "Fragile bones, rest in peace!"}
          }
      },
      [4] = {
          dialogues = {
              {speaker = "Narrator", text = "Deeper into the Demon King's domain, the hero feels a strange energy...", emotion = "mysterious"}, -- 新增敘述者對話
              {speaker = "Narrator", text = "Suddenly, hero realizes that equipment and power have been greatly weakened!", emotion = "mysterious"}, -- 新增勇者能力被吸收的敘述
              {speaker = "Hero", text = "What happened? My power...!", emotion = "worried"}, -- 勇者表示能力被削減
              {speaker = "enemy_name_stonegolem", text = "Hehe, look who we have here?"}, -- Using displayNameKey
              {speaker = "Hero", text = "Even without full power, I will not be defeated!", emotion = "determined"} -- 即使能力削減，勇者依然決心
          }
      },
      [5] = {
          dialogues = {
              {speaker = "enemy_name_skeletonwarrior", text = "Human, you are too weak!"}, -- Using displayNameKey
              {speaker = "Hero", text = "Size doesn't determine strength!"}
          }
      },
      [6] = {
          dialogues = {
              {speaker = "enemy_name_darkknight", text = "You will stay here forever..."}, -- Using displayNameKey
              {speaker = "Hero", text = "Sorry, I have a mission to complete."}
          }
      },
      [7] = {
          dialogues = {
              {speaker = "enemy_name_banshee", text = "Serve the Demon King, or die!"}, -- Using displayNameKey
              {speaker = "Hero", text = "I choose to defeat you!"}
          }
      },
      [8] = {
          dialogues = {
              {speaker = "enemy_name_minotaur", text = "Your journey ends here."}, -- Using displayNameKey
              {speaker = "Hero", text = "I will prove you wrong!"}
          }
      },
      [9] = {
          dialogues = {
              {speaker = "enemy_name_greendragon", text = "This is the end for you!"}, -- Using displayNameKey
              {speaker = "Hero", text = "I'll show you who the real weakling is!"}
          }
      },
      [10] = {
          background = "assets/demonCastle.png",
          music = "assets/finalBattle",
          dialogues = {
              {speaker = "Demon King", text = "Hahaha! Finally, the so-called hero arrives!", emotion = "mocking"},
              {speaker = "Hero", text = "Demon King! Release the princess now!", emotion = "angry"},
              {speaker = "Demon King", text = "You? Defeat me first!", emotion = "threatening"},
              {speaker = "Princess", text = "Be careful, Hero! His power has grown stronger!", emotion = "worried"},
              {speaker = "Hero", text = "Don't worry, I will save you!", emotion = "determined"},
              {speaker = "Demon King", text = "Enough talk, come!", emotion = "battle_ready"}
          }
      }
  },

  -- Ending dialogues
  ending = {
      good = {
          background = "palace",
          music = "victory",
          dialogues = {
              {speaker = "King", text = "Hero! You actually did it!", emotion = "overjoyed"},
              {speaker = "Princess", text = "Thank you for saving me and the kingdom...", emotion = "grateful"},
              {speaker = "Hero", text = "It was my duty, to protect peace.", emotion = "humble"},
              {speaker = "King", text = "As promised, the princess's hand and half the kingdom are yours.", emotion = "pleased"},
              {speaker = "Princess", text = "Hero, will you... accept?", emotion = "shy"},
              {speaker = "Hero", text = "It would be my honor to serve the kingdom.", emotion = "honored"},
              {speaker = "Narrator", text = "And so, peace returned to the kingdom, and the hero and princess lived happily ever after.", emotion = "narrative"}
          }
      },
      neutral = {
          background = "palace",
          music = "neutral",
          dialogues = {
              {speaker = "King", text = "You completed the mission, this is your reward.", emotion = "neutral"},
              {speaker = "Hero", text = "Thank you, I must continue my journey.", emotion = "neutral"},
              {speaker = "Narrator", text = "The hero continued his journey, seeking new adventures...", emotion = "narrative"}
          }
      },
      tragic = {
          background = "ruins",
          music = "tragic",
          dialogues = {
              {speaker = "Hero", text = "We won... but the cost was too great...", emotion = "devastated"},
              {speaker = "Narrator", text = "The kingdom was saved, but at a great loss...", emotion = "narrative"}
          }
      }
  },

  -- Current dialogue state
  currentState = {
      isPlaying = false,
      currentLevel = 1,
      dialogueIndex = 1,
      isEnding = false
  },

  -- Emotion system
  emotions = {
      worried = {color = {0.7, 0.7, 1}, scale = 1},
      angry = {color = {1, 0.5, 0.5}, scale = 1.1},
      determined = {color = {1, 1, 1}, scale = 1},
      sad = {color = {0.7, 0.7, 0.8}, scale = 0.9},
      confident = {color = {1, 1, 0.8}, scale = 1.1},
      hopeful = {color = {0.8, 1, 0.8}, scale = 1},
      serious = {color = {0.9, 0.9, 1}, scale = 1},
      mocking = {color = {1, 0.6, 0.6}, scale = 1.2},
      threatening = {color = {1, 0.4, 4}, scale = 1.3},
      overjoyed = {color = {1, 1, 0.6}, scale = 1.2},
      grateful = {color = {0.8, 0.8, 1}, scale = 1},
      humble = {color = {0.7, 1, 0.7}, scale = 0.9},
      pleased = {color = {1, 0.9, 0.7}, scale = 1.1},
      shy = {color = {1, 0.8, 0.8}, scale = 0.9},
      devastated = {color = {0.5, 0.5, 0.5}, scale = 0.8},
      heroic = {color = {1, 0.9, 0.4}, scale = 1.3},
      mysterious = {color = {0.6, 0.4, 0.8}, scale = 1.1},
      furious = {color = {1, 0.2, 0.2}, scale = 1.4}
  },

  -- Relationship system
  relationships = {
      princess = 0,
      king = 0,
      villagers = 0,
      -- -100 to 100 scale
      getAffinityLevel = function(value)
          if value >= 80 then return "Loved"
          elseif value >= 50 then return "Trusted"
          elseif value >= 20 then return "Friendly"
          elseif value >= -20 then return "Neutral"
          elseif value >= -50 then return "Disliked"
          else return "Hostile" end
      end
  },

  -- Quest system
  quests = {
      active = {},
      completed = {},
      addQuest = function(self, id, title, description)
          self.active[id] = {title = title, description = description, objectives = {}}
      end,
      completeQuest = function(self, id)
          if self.active[id] then
              self.completed[id] = self.active[id]
              self.active[id] = nil
          end
      end
  },

  -- Choice system
  choices = {
      current = nil,
      makeChoice = function(self, options, callback)
          self.current = {options = options, callback = callback}
      end
  }
}

-- Add this line after story is declared
local currentState = story.currentState

-- Current language state
local currentLanguage = "en" -- Default language

-- Function to initialize text
local function initText()
  -- Set default language or load from save if needed
  currentLanguage = "en" -- Or load saved language
end

-- Add a simple function to validate language
local function validateLanguage(lang)
  if story.text[lang] then
    return lang
  else
    print("[WARNING] Language '" .. tostring(lang) .. "' not found, fallback to default.")
    return "en"
  end
end

-- Modify getText to use validation and fallback
local function getText(language, key, params, defaultValue)
  language = validateLanguage(language or currentLanguage)
  local langTable = story.text[language]
  if not langTable[key] then
    print("[WARNING] Missing text key '" .. key .. "' for language '" .. language .. "'.")
    return defaultValue or "**MISSING TEXT**"
  end

  local textString = langTable[key]
  if params then
    for k, v in pairs(params) do
      textString = string.gsub(textString, "%%{" .. k .. "}", tostring(v))
    end
  end
  return textString
end

-- Function to set current language
local function setCurrentLanguage(language)
  currentLanguage = language
end

-- Function to get current language
function getCurrentLanguage()
  return currentLanguage
end


-- Update text display animation
function updateTextEffect(dt)
  local effect = story.textEffect -- Access textEffect through story table
  if effect.currentText ~= effect.targetText then
      effect.timer = effect.timer + dt
      if effect.timer >= effect.charDelay then
          effect.timer = 0
          effect.displayIndex = effect.displayIndex + 1
          effect.currentText = string.sub(effect.targetText, 1, effect.displayIndex)
          effect.isComplete = (effect.currentText == effect.targetText)
      end
  end
end

-- Set new target text
function setTargetText(text)
  story.textEffect.targetText = text -- Access textEffect through story table
  story.textEffect.currentText = ""
  story.textEffect.displayIndex = 0
  story.textEffect.timer = 0
  story.textEffect.isComplete = false
end

-- Get current displayed text
function getCurrentText()
  return story.textEffect.currentText -- Access textEffect through story table
end

-- Check if text is fully displayed
function isTextComplete()
  return story.textEffect.isComplete -- Access textEffect through story table
end

-- Start level dialogue
function startLevelDialogue(level)
  currentState.isPlaying = true
  currentState.currentLevel = level
  currentState.dialogueIndex = 1
  currentState.isEnding = false

  -- Initialize the first dialogue immediately
  local currentLevel = story.levelIntros[level]
  if currentLevel and currentLevel.dialogues and currentLevel.dialogues[1] then
      setTargetText(currentLevel.dialogues[1].text)
  end
end

-- Start ending dialogue
function startEndingDialogue()
  currentState.isPlaying = true
  currentState.dialogueIndex = 1
  currentState.isEnding = true
end

-- Get current dialogue content (single combined version)
function getCurrentDialogue()
  if not currentState.isPlaying then
      return {
          speaker = "System",
          text = "No active dialogue",
          emotion = "normal"
      }
  end

  local dialogues
  if currentState.isEnding then
      -- Get the appropriate ending based on relationships
      local endingType = determineEnding()
      dialogues = story.ending[endingType].dialogues
  else
      -- 確保當前關卡的對話內容存在
      local currentLevel = story.levelIntros[currentState.currentLevel]
      if not currentLevel or not currentLevel.dialogues then
          return {
              speaker = "System",
              text = "Level dialogue not found",
              emotion = "normal"
          }
      end
      dialogues = currentLevel.dialogues

      -- 檢查對話索引是否有效
      if currentState.dialogueIndex > #dialogues then
          currentState.isPlaying = false
          return {
              speaker = "System",
              text = "Dialogue ended",
              emotion = "normal"
          }
      end
  end

  local currentDialogue = dialogues[currentState.dialogueIndex]
  if not currentDialogue then
      return {
          speaker = "System",
          text = "Dialogue not found",
          emotion = "normal"
      }
  end

  -- 設置要顯示的文字
  setTargetText(currentDialogue.text)

  -- 返回完整的對話資訊
  return {
      speaker = currentDialogue.speaker,
      text = currentDialogue.text,
      emotion = currentDialogue.emotion or "normal",
      character = story.characters[currentDialogue.speaker:lower()] or nil,
      choices = currentDialogue.choices
  }
end

-- Next dialogue
function nextDialogue()
  local currentDialogues
  if currentState.isEnding then
      currentDialogues = story.ending.good.dialogues
  else
      currentDialogues = story.levelIntros[currentState.currentLevel].dialogues
  end

  if currentState.dialogueIndex < #currentDialogues then
      currentState.dialogueIndex = currentState.dialogueIndex + 1
  else
      currentState.isPlaying = false
  end
end

-- Skip current dialogue
function skipDialogue()
  currentState.isPlaying = false
end

-- Add new functions for emotion system
function getEmotionEffect(emotion)
  return story.emotions[emotion] or {color = {1, 1, 1}, scale = 1}
end

-- Add new function for relationship changes
function changeRelationship(character, amount)
  if story.relationships[character] then
      story.relationships.character = math.max(-100, math.min(100, story.relationships[character] + amount))
  end
end

-- Add function to determine ending based on relationships
function determineEnding()
  local total = story.relationships.princess + story.relationships.king + story.relationships.villagers
  if total >= 150 then return "good"
  elseif total >= 0 then return "neutral"
  else return "tragic" end
end

-- **Merged content from lua ends here.**


-- **Your existing main.lua code (if any) starts here.**
-- You can add your game logic, love.load, love.draw, etc. below.

function love.load()
  initText() -- Initialize the story text system

  -- Example: Accessing story data
  print("Game Title (EN): " .. getText("en", "menu_title"))
  print("Game Title (ZH): " .. getText("zh", "menu_title"))

  -- Example: Starting a dialogue (you'll need to trigger this based on your game flow)
  -- startLevelDialogue(1) -- Start dialogue for level 1
end

function love.update(dt)
  updateTextEffect(dt) -- Update the text effect every frame
  -- Your game update logic here
  if gameState == "menu" then
    if not audioState.isMutedBGM and not resources.sounds.menuBgm:isPlaying() then
      resources.sounds.menuBgm:play()
      print("[AUDIO] Menu BGM resumed")
    end
  end
end

function love.draw()
  -- Your game drawing logic here

  -- Example: Drawing the current dialogue text (if a dialogue is active)
  if currentState.isPlaying then
      local currentDialogue = getCurrentDialogue()
      love.graphics.print(getText(getCurrentLanguage(), currentDialogue.speaker), 100, 100) -- Speaker name
      love.graphics.print(getCurrentText(), 100, 120) -- Dialogue text
  end
end

local audioState = {
  isMutedBGM = false,
  isMutedSFX = false
}

-- local story = require("story") -- REMOVE or COMMENT OUT this line AFTER MERGING

-- Make these global
screenWidth = 1880
screenHeight = 720

-- Available resolutions in 16:9 aspect ratio
local availableResolutions = {
    {width = 1920, height = 1080, name = "1920x1080 (Full HD)"},
    {width = 1280, height = 720, name = "1280x720 (HD)"},
    {width = 854, height = 480, name = "854x480 (SD)"},
    {width = 640, height = 360, name = "640x360 (Low)"}
}
local currentResolutionIndex = 1 -- Default resolution index

-- Add this near the other state declarations (after gameState declaration)
resultState = {
  currentOption = 1,
  options = {
    {textKey = "result_restart", action = function() restartGame() end},
    {textKey = "result_main_menu", action = function() gameState = "menu" end}
  },
  buttonAreas = {}, -- Add buttonAreas for mouse interaction
  navDelay = 0.3, -- 調整結果介面選項卡速度 (原本 0.2 改為 0.3)
}

-- Global game language state
local currentGameLanguage = "en"

storyPageState = {
  storyText = "", -- 遊戲故事文本將在此處載入
  scrollPosition = 0,
  backButtonArea = {},
  navDelay = 0.3, -- 調整故事頁面選項卡速度 (新增 0.3)
  navTimer = 0, -- Initialize navTimer to 0, fix for error
}

function love.load()
  print("[GAME] love.load() - Game loading started")

  -- Load saved resolution settings (if you implement saving)
  -- For now, default resolution is used.

  -- Set initial screen resolution
  screenWidth = availableResolutions[currentResolutionIndex].width
  screenHeight = availableResolutions[currentResolutionIndex].height
  love.window.setMode(screenWidth, screenHeight, {resizable = false, vsync = true})
  print("[GAME] Set window mode to " .. screenWidth .. "x" .. screenHeight)

  -- Add camera
  camera = {
      x = 0,
      y = 0,
      scale = 1
  }

-- Add timer system
timers = {}
print("[GAME] Timer system initialized")

-- Function to safely load resources with error handling
local function loadResource(loadFunc, resourceType, assetPath, ...)
  local success, resource = pcall(loadFunc, assetPath, ...)
  if success then
    print(string.format("[RESOURCE] Loaded %s: %s", resourceType, assetPath))
    return resource
  else
    print(string.format("[ERROR] Failed to load %s: %s - %s", resourceType, assetPath, resource))
    return nil -- Return nil on failure
  end
end

-- Function to safely load images
local function loadImage(assetPath)
  return loadResource(love.graphics.newImage, "image", assetPath)
end

-- Function to safely load sounds
local function loadSound(assetPath, type)
  return loadResource(love.audio.newSource, "sound", assetPath, type)
end

-- Function to safely load fonts
local function loadFont(assetPath, size)
  return loadResource(love.graphics.newFont, "font", assetPath, size)
end

-- Resources
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
    enemy_level10_attack = loadImage("assets/enemy_level10_attack.png")
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
      },
  fonts = {
    ui = loadFont("assets/ui-font.ttf", 16),
    battle = loadFont("assets/battle-font.ttf", 24),
    damage = loadFont("assets/damage-font.ttf", 32),
    chineseUI = loadFont("assets/chinese-font.ttf", 16),
    chineseBattle = loadFont("assets/chinese-font.ttf", 24),
  }
}
print("[GAME] Resources loaded")

-- Define enemy data for each level
enemyData = {
  [1] = {
    image = "enemy_level1_stand", -- Stand image key
    hp = 30,
    maxHp = 60,
    attack = 6,
    defense = 3,
    critRate = 4,
    critDamage = 1.2,
    ai = "basic",
    displayNameKey = "enemy_name_goblin" -- Add a display name key (remember to add to lua)
  },
  [2] = {
    image = "enemy_level2_stand",
    hp = 30,
    maxHp = 60,
    attack = 6,
    defense = 3,
    critRate = 4,
    critDamage = 1.2,
    ai = "basic",
    displayNameKey = "enemy_name_orc" -- Add a display name key (remember to add to lua)
  },
  [3] = {
    image = "enemy_level3_stand",
    hp = 40,
    maxHp = 60,
    attack = 6,
    defense = 3,
    critRate = 4,
    critDamage = 1.2,
    ai = "basic",
    displayNameKey = "enemy_name_stonegolem" -- Add a display name key (remember to add to lua)
  },
  [4] = {
    image = "enemy_level4_stand",
    hp = 60,
    maxHp = 60,
    attack = 6,
    defense = 3,
    critRate = 4,
    critDamage = 1.2,
    ai = "basic",
    displayNameKey = "enemy_name_skeletonwarrior" -- Add a display name key (remember to add to lua)
  },
  [5] = {
    image = "enemy_level5_stand",
    hp = 60,
    maxHp = 60,
    attack = 6,
    defense = 3,
    critRate = 4,
    critDamage = 1.2,
    ai = "basic",
    displayNameKey = "enemy_name_darkknight" -- Add a display name key (remember to add to lua)
  },
  [6] = {
    image = "enemy_level6_stand",
    hp = 60,
    maxHp = 60,
    attack = 6,
    defense = 3,
    critRate = 4,
    critDamage = 1.2,
    ai = "basic",
    displayNameKey = "enemy_name_banshee" -- Add a display name key (remember to add to lua)
  },
  [7] = {
    image = "enemy_level7_stand",
    hp = 60,
    maxHp = 60,
    attack = 6,
    defense = 3,
    critRate = 4,
    critDamage = 1.2,
    ai = "basic",
    displayNameKey = "enemy_name_minotaur" -- Add a display name key (remember to add to lua)
  },
  [8] = {
    image = "enemy_level8_stand",
    hp = 60,
    maxHp = 60,
    attack = 6,
    defense = 3,
    critRate = 4,
    critDamage = 1.2,
    ai = "basic",
    displayNameKey = "enemy_name_greendragon" -- Add a display name key (remember to add to lua)
  },
  [9] = {
    image = "enemy_level9_stand",
    hp = 60,
    maxHp = 60,
    attack = 6,
    defense = 3,
    critRate = 4,
    critDamage = 1.2,
    ai = "basic",
    displayNameKey = "enemy_name_reddragon" -- Add a display name key (remember to add to lua)
  },
  [10] = {
    image = "enemy_level10_stand", -- Demon King stand image
    hp = 150,
    maxHp = 150,
    attack = 15,
    defense = 8,
    critRate = 10,
    critDamage = 1.5,
    ai = "tactical",
    displayNameKey = "enemy_name_demonking" -- Add a display name key (remember to add to lua)
  }
}
print("[GAME] Enemy data loaded")

-- Define battle backgrounds for each level
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

-- Add enemy AI patterns
enemyAI = {
  basic = {
    decideAction = function(enemy, player)
      -- Basic AI just randomly attacks or defends
      return math.random() < 0.7 and "attack" or "defend"
    end
  },
  aggressive = {
    decideAction = function(enemy, player)
      -- Aggressive AI prefers attacking
      return math.random() < 0.9 and "attack" or "defend"
    end
  },
  tactical = {
    decideAction = function(enemy, player)
      -- Tactical AI considers HP levels
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

-- Screen setup
  screenWidth = love.graphics.getWidth()
  screenHeight = love.graphics.getHeight()

-- Battle positions and constraints
positions = {
  player = {
    x = screenWidth * 0.15,
    y = screenHeight * 0.5,
    scale = 0.7,
    maxWidth = screenWidth * 0.4
  },
  enemy = {
    x = screenWidth * 0.55,
    y = screenHeight * 0.5,
    scale = 0.7,
    maxWidth = screenWidth * 0.4
  },
  playerHP = {x = 20, y = 20},
  enemyHP = {x = love.graphics.getWidth() - 220, y = 20},
  playerUI = {x = screenWidth * 0.05 - 50, y = screenHeight * 0.78}, -- Move player UI frame 50 pixels to the left
  enemyUI = {x = screenWidth * 0.65, y = screenHeight * 0.75}
}
print("[GAME] Battle positions defined")

-- Animation states
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

-- Player settings
player = {
  x = 100,
  y = 300,
  speed = 200,
  image = love.graphics.newImage("assets/player.png"), -- Note: player.png might be unused now, verify
  hp = 100,
  maxHp = 100,
  attack = 10,
    critRate = 10,
    critDamage = 1.5,
  defense = 5,
  isDefending = false,
  status = {},
  combo = 0,
  isCheatMode = false
}
print("[GAME] Player settings initialized")

-- Enemy settings
enemy = {
  x = 600,
  y = 300,
  image = love.graphics.newImage("assets/enemy.png"), -- Note: enemy.png might be unused now, verify
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

-- Battle state
battleState = {
  phase = "select",
  turn = "player",
  message = "Battle Start!",
  messageTimer = 2,
  options = {
    {name = "Attack", description = "Deal damage to enemy"},
    {name = "Defend", description = "Reduce incoming damage"},
    {name = "Special", description = "Powerful attack with delay"},
      {name = "Heal", description = "Restore health"},
  },
  currentOption = 1,
  buttonAreas = {}, -- Add buttonAreas for mouse interaction
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
          action = function()
            pauseState.isPaused = false
            audioState.isMutedBGM = false
            audioState.isMutedSFX = false
            -- Restart battle BGM on unpause if not muted
            if not audioState.isMutedBGM and resources.sounds.battleBgm then
              resources.sounds.battleBgm:stop()
              resources.sounds.battleBgm:play()
            end
          end
        },
        {textKey = "pause_restart", action = function() restartGame() end},
        {textKey = "pause_main_menu", action = function() gameState = "menu"; pauseState.isPaused = false end},
        {textKey = "pause_quit_game", action = function() love.event.quit() end}
    },
    currentOption = 1,
    buttonAreas = {}, -- Add buttonAreas for mouse interaction
    navDelay = 0.3, -- 調整暫停介面選項卡速度 (原本 0.2 改為 0.3)
  }
   gameState = "menu"
    local hitParticleSystem = love.graphics.newParticleSystem(resources.images.hitEffect, 100)
      hitParticleSystem:setParticleLifetime(0.2, 0.5)
      hitParticleSystem:setSpeed(100, 200)
      hitParticleSystem:setDirection(0, 360)
      hitParticleSystem:setSpread(5)
      hitParticleSystem:setEmissionRate(50)
      hitParticleSystem:setSizes(0.3, 0.1)
      hitParticleSystem:setRotation(0, 360)

    local defendParticleSystem = love.graphics.newParticleSystem(resources.images.defendEffect, 100)
      defendParticleSystem:setParticleLifetime(0.2, 0.5)
      defendParticleSystem:setSpeed(50, 100)
      defendParticleSystem:setDirection(0, 360)
      defendParticleSystem:setSpread(5)
      defendParticleSystem:setEmissionRate(50)
      defendParticleSystem:setSizes(0.3, 0.1)
      defendParticleSystem:setRotation(0, 360)

    resources.particleSystems = {
      hit = hitParticleSystem,
      defend = defendParticleSystem
    }
 print("[GAME] Particle systems initialized")
   -- Skill information that can be loaded from external file
  skillInfo = {
      {
          name = "Basic Attack",
          description = "A basic attack skill.",
          details = "Deal small physical damage to enemy.",
          type = "offensive",
          icon = "skillAttack",
          key = "attack"
      },
      {
          name = "Defend",
          description = "Enter defensive stance.",
          details = "Increase defense to reduce incoming damage.",
          type = "defensive",
          icon = "skillDefend",
          key = "defend"
      },
      {
          name = "Special Attack",
          description = "Powerful special attack with high damage.",
          details = "Deal large physical damage but requires preparation.",
          type = "offensive",
          icon = "skillSpecial",
          key = "special"
      },
      {
          name = "Heal",
          description = "Restore HP.",
          details = "Heal yourself based on character attributes.",
          type = "support",
          icon = "skillHeal",
          key = "heal"
      }
  }
  print("[GAME] Skill info loaded")

  -- Add menu state
  menuState = {
    options = {
      {textKey = "menu_select_level", action = function() gameState = "levelSelect" end, descriptionKey = "menu_select_level_desc"},
      {textKey = "menu_options", action = function() gameState = "options" end, descriptionKey = "menu_options_desc"},
      {textKey = "menu_story_page", action = function() gameState = "storyPage" end, descriptionKey = "menu_story_page_desc"}, -- 新增選項
      {textKey = "menu_exit", action = function() love.event.quit() end, descriptionKey = "menu_exit_desc"}
    },
    currentOption = 1,
    -- Timer for menu navigation delay
    navTimer = 0,
    navDelay = 0.6, -- 調整主選單選項卡速度 (原本 0.2 改為 0.3)
    buttonAreas = {}, -- Add buttonAreas for mouse interaction

    -- Level selection state
    levelSelect = {
        currentLevel = 1,
        maxLevel = 10,
        navTimer = 0,
        navDelay = 0.6, -- 調整關卡選擇介面選項卡速度 (原本 0.2 改為 0.3)
        buttonAreas = {}, -- Add buttonAreas for mouse interaction
        backButtonArea = {} -- Add backButtonArea for mouse interaction
    }
  }
  print("[GAME] Menu state initialized")

  -- Options State
  optionsState = {
    options = {
      {textKey = "options_language", type = "language", currentOption = 1, languageOptions = {"en", "zh"}},
      {textKey = "options_resolution", type = "resolution", currentOption = currentResolutionIndex, resolutionOptions = availableResolutions}, -- Resolution option
      {textKey = "options_bgm", type = "toggle", state = "isMutedBGM"},
      {textKey = "options_sfx", type = "toggle", state = "isMutedSFX"},
      {textKey = "options_cheat", type = "toggle", state = "isCheatMode", targetState = player},
      {textKey = "options_back_to_menu", action = function() gameState = "menu" end},
    },
    currentOption = 1,
    navTimer = 0,
    navDelay = 0.6, -- 調整選項介面選項卡速度 (原本 0.2 改為 0.3)
    buttonAreas = {}, -- Add buttonAreas for mouse interaction
    backButtonArea = {}, -- Add backButtonArea for mouse interaction
    languageButtonAreas = {} ,-- Add languageButtonAreas for mouse interaction
    resolutionButtonAreas = {} -- Add resolutionButtonAreas for mouse interaction
  }
  print("[GAME] Options state initialized")

    -- 初始化故事頁面的文本內容
    storyPageState.storyText = getText(currentGameLanguage, "game_full_story")

  -- Start playing menu music
  resources.sounds.menuBgm:setLooping(true)
  if not audioState.isMutedBGM then
    resources.sounds.menuBgm:play()
    print("[AUDIO] Menu BGM started playing")
  else
    print("[AUDIO] Menu Bgm not started (muted)")
  end


  -- Add background images to resources
  resources.images.palace = resources.images.background -- Use background as fallback
  resources.images.forest = resources.images.background
  resources.images.demonCastle = resources.images.background
  resources.images.ruins = resources.images.background

  -- Try to load actual background images if they exist
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

  -- Check for critical resources
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

  if not allCriticalResourcesLoaded then
    -- Display an error message on screen
    love.graphics.clear(0, 0, 0)
    love.graphics.setColor(1, 0, 0)
    love.graphics.setFont(resources.fonts.battle)
    love.graphics.print("Critical resources failed to load.\nPlease check the console for details.", 100, 100)
    love.event.quit() -- Terminate the game
  end
end

-- Timer system improvements
local TimerSystem = {
    timers = {},
    nextId = 1
}

-- Timer states
local TIMER_STATE = {
    ACTIVE = "active",
    PAUSED = "paused",
    CANCELLED = "cancelled"
}

-- Timer groups
local TIMER_GROUPS = {
    BATTLE = "battle",
    ANIMATION = "animation",
    UI = "ui"
}

function TimerSystem.create(duration, callback, group)
    local id = TimerSystem.nextId
    TimerSystem.nextId = TimerSystem.nextId + 1
    
    TimerSystem.timers[id] = {
        duration = duration,
        remaining = duration,
        callback = callback,
        state = TIMER_STATE.ACTIVE,
        group = group or "default"
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

-- Replace existing timer related functions
function addTimer(duration, callback, group)
    return TimerSystem.create(duration, callback, group)
end

function updateTimers(dt)
    TimerSystem.update(dt)
end

-- Example usage in startEnemyTurn
function startEnemyTurn()
    -- ...existing code...
    
    -- Use the new timer system with group
    local timerId = addTimer(GAME_CONSTANTS.TIMER.ACTION_DELAY, function()
        battleState.phase = "select"
        battleState.turn = "player"
    end, TIMER_GROUPS.BATTLE)
    
    -- Store timer ID if needed to cancel/pause later
    battleState.currentTimerId = timerId
end

-- Add pause handling
function handleBattlePause()
    if not pauseState.isPaused then
        pauseState.isPaused = true
        gameState = "pause"
        -- Pause all battle timers
        TimerSystem.pauseGroup(TIMER_GROUPS.BATTLE)
    end
end

function resumeBattle()
    if pauseState.isPaused then
        pauseState.isPaused = false
        gameState = "battle"
        -- Resume all battle timers
        TimerSystem.resumeGroup(TIMER_GROUPS.BATTLE)
    end
end

function love.update(dt)
    if gameState == "menu" then
        handleMenuInput(dt)
    elseif gameState == "levelSelect" then
        handleLevelSelectInput(dt)
    elseif gameState == "story" then
        handleStoryInput(dt)
        updateTextEffect(dt)

        -- 改進故事文字更新邏輯
        local currentDialogue = getCurrentDialogue()
        if currentDialogue then
            -- 確保文字被設置
            if getCurrentText() == "" then
                setTargetText(currentDialogue.text)
            end
            -- 持續更新文字效果
            updateTextEffect(dt)
        end
    elseif gameState == "battle" then
        if pauseState.isPaused or gameState ~= "battle" then
            return
        end
        -- Update timers
        updateTimers(dt)

        -- Update animations
        updateAnimations(dt)

        -- Update battle state
        if battleState.phase == "select" then
            handleBattleInput()
        elseif battleState.phase == "action" then
            updateBattleAction(dt)
        end

        -- Update effects
        updateEffects(dt)

        -- Update message timer
        if battleState.messageTimer > 0 then
            battleState.messageTimer = battleState.messageTimer - dt
        end

        -- Check for victory/defeat
        if enemy.hp <= 0 then
            gameState = "victory"
            print("[GAME STATE] Game state changed to 'victory'")
            if not audioState.isMutedBGM then
              resources.sounds.battleBgm:stop()
              resources.sounds.victory:play()
              print("[AUDIO] Battle BGM stopped, Victory music started")
            end
        elseif player.hp <= 0 then
            gameState = "defeat"
            print("[GAME STATE] Game state changed to 'defeat'")
            if not audioState.isMutedBGM then
              resources.sounds.battleBgm:stop()
              resources.sounds.defeat:play()
              print("[AUDIO] Battle BGM stopped, Defeat music started")
            end
        end
    elseif gameState == "ending" then
        handleEndingInput()
    elseif gameState == "options" then
        handleOptionsInput(dt)
    elseif gameState == "storyPage" then -- 新增 storyPage 的處理
        handleStoryPageInput(dt)
    end
end

function love.draw()
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
    -- Draw background first
    drawBattleScene()

    -- Draw characters
    drawCharacters()

    -- Draw UI
    drawBattleUI()

    -- Draw effects
    drawEffects()

    -- Draw messages
    drawBattleMessage()

    -- Draw pause menu if needed
    if pauseState.isPaused then
      drawPauseUI()
    end

    -- Draw skill info if needed
    if uiState.showSkillInfo then
      drawSkillInfoUI()
    end
  elseif gameState == "victory" then
    drawVictoryUI()
  elseif gameState == "defeat" then
    drawDefeatUI()
  elseif gameState == "options" then
    drawOptionsUI()
  elseif gameState == "storyPage" then -- 新增 storyPage 的繪製
    drawStoryPageUI(dt) -- Pass dt here
  end

  love.graphics.pop()
end

-- Add new main menu drawing function
local uiLayoutConfig = {
  mainMenu = {
    titleOffsetY = 0.2,
    buttonWidth = 200,
    buttonHeight = 40,
    buttonSpacing = 50,
    buttonOffsetY = 0.4
  },
  -- ...existing UI config for other screens...
}

function drawMainMenu()
  local windowWidth = love.graphics.getWidth()
  local windowHeight = love.graphics.getHeight()

  -- Draw background
  love.graphics.draw(resources.images.background, 0, 0, 0,
    windowWidth/resources.images.background:getWidth(),
    windowHeight/resources.images.background:getHeight())

  -- Draw title
  local font = resources.fonts.battle
  if currentGameLanguage == "zh" then
    font = resources.fonts.chineseBattle
  end
  love.graphics.setFont(font)
  love.graphics.setColor(1, 1, 1)
  local title = getText(currentGameLanguage, "menu_title")
  local titleWidth = font:getWidth(title)
  love.graphics.print(
    title,
    windowWidth / 2 - titleWidth / 2,
    windowHeight * uiLayoutConfig.mainMenu.titleOffsetY
  )

  -- Draw menu options
  local fontUI = resources.fonts.ui
  if currentGameLanguage == "zh" then
    fontUI = resources.fonts.chineseUI
  end
  love.graphics.setFont(fontUI)
  menuState.buttonAreas = {} -- Store button areas for mouse interaction
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
      love.graphics.rectangle("line", buttonRect.x, buttonRect.y, buttonRect.width, buttonRect.height) -- Yellow outline
    else
      love.graphics.setColor(1, 1, 1)
    end
    love.graphics.print(getText(currentGameLanguage, option.textKey), buttonRect.x, buttonRect.y)
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.print(getText(currentGameLanguage, option.descriptionKey), buttonRect.x + 10, buttonRect.y + 20)
  end

  -- Draw version/author info at bottom-right
  local fontUI = resources.fonts.ui
  love.graphics.setFont(fontUI)
  local versionInfo = "V0.02\nBy Dundd2\nBuild with love-12.0-win64 Beta"
  local textWidth = fontUI:getWidth(versionInfo)
  local textHeight = fontUI:getHeight()
  love.graphics.print(versionInfo, love.graphics.getWidth() - textWidth - 100, love.graphics.getHeight() - textHeight - 100)
end

-- Add level selection screen
function drawLevelSelect()
  local windowWidth = love.graphics.getWidth()
  local windowHeight = love.graphics.getHeight()

  -- Draw background (與主頁相同的背景)
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(resources.images.background, 0, 0, 0,
    windowWidth/resources.images.background:getWidth(),
    windowHeight/resources.images.background:getHeight())

  -- Draw title
  local font = resources.fonts.battle
  if currentGameLanguage == "zh" then
    font = resources.fonts.chineseBattle
  end
  love.graphics.setFont(font)
  local title = getText(currentGameLanguage, "level_select_title")
  local titleWidth = font:getWidth(title)
  love.graphics.print(title, windowWidth / 2 - titleWidth / 2, 50)

  -- Draw level options
  local fontUI = resources.fonts.ui
  if currentGameLanguage == "zh" then
    fontUI = resources.fonts.chineseUI
  end
  love.graphics.setFont(fontUI)
  menuState.levelSelect.buttonAreas = {} -- Store button areas
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
          love.graphics.rectangle("line", buttonRect.x, buttonRect.y, buttonRect.width, buttonRect.height) -- Yellow outline
      else
          love.graphics.setColor(1, 1, 1)
      end
      local text = getText(currentGameLanguage, "level_number", {level = i})
      local textWidth = fontUI:getWidth(text)
      love.graphics.print(text, buttonRect.x, buttonRect.y)
  end

  -- Draw back button box
  local backButtonRect = {
    x = 10,
    y = 10,
    width = 50,
    height = 50
  }
  menuState.levelSelect.backButtonArea = backButtonRect
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("line", backButtonRect.x, backButtonRect.y, backButtonRect.width, backButtonRect.height)
  love.graphics.print("<", backButtonRect.x + 15, backButtonRect.y + 15) -- Simple "<" as back arrow
end

-- Modify drawStoryDialogue function to handle image and text layout requests
function drawStoryDialogue()
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()

    -- Draw default background first
    love.graphics.draw(resources.images.background, 0, 0, 0,
        windowWidth/resources.images.background:getWidth(),
        windowHeight/resources.images.background:getHeight())

    -- Get current dialogue safely
    local currentDialogue = getCurrentDialogue()
    if not currentDialogue then return end

    -- Draw background if available
    local currentLevel = story.levelIntros[menuState.levelSelect.currentLevel]    if currentLevel and currentLevel.background then
        -- Use the already loaded background from resources
        local bgKey = string.match(currentLevel.background, "([^/]+)$"):gsub("%.png$", "")
        if resources.images[bgKey] then
            love.graphics.draw(resources.images[bgKey], 0, 0, 0,
                windowWidth/resources.images[bgKey]:getWidth(),
                windowHeight/resources.images[bgKey]:getHeight())
        end
    end

    -- Dialogue box dimensions and position
    local dialogBoxWidth = windowWidth * 0.8
    local dialogBoxHeight = 150
    local dialogBoxX = (windowWidth - dialogBoxWidth) / 2
    local dialogBoxY = windowHeight - dialogBoxHeight - 50

    -- Portrait settings
    local portraitKey = "portrait" .. currentDialogue.speaker
    local portraitImage = resources.images[portraitKey]
    local maxPortraitWidth = dialogBoxHeight -- Set max width to dialog box height, adjust as needed
    local portraitDrawWidth = 0
    local portraitDrawHeight = 0
    local portraitDrawX = dialogBoxX + 10 -- Portrait left padding
    local portraitDrawY = dialogBoxY + 10 -- Portrait top padding

    if portraitImage then
        portraitDrawWidth = math.min(portraitImage:getWidth(), maxPortraitWidth)
        portraitDrawHeight = portraitDrawWidth * (portraitImage:getHeight() / portraitImage:getWidth())
        if portraitDrawHeight > dialogBoxHeight - 20 then -- Ensure portrait doesn't exceed dialog box height with padding
            portraitDrawHeight = dialogBoxHeight - 20
            portraitDrawWidth = portraitDrawHeight * (portraitImage:getWidth() / portraitImage:getHeight())
        end
    end

    -- 繪製半透明黑色背景
    love.graphics.setColor(0, 0, 0, 0.8)
    love.graphics.rectangle("fill", dialogBoxX, dialogBoxY, dialogBoxWidth, dialogBoxHeight)

    -- 對話框邊框
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", dialogBoxX, dialogBoxY, dialogBoxWidth, dialogBoxHeight)

    -- Draw speaker portrait if available
    if portraitImage then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(portraitImage, portraitDrawX, portraitDrawY, 0, portraitDrawWidth / portraitImage:getWidth(), portraitDrawHeight / portraitImage:getHeight())
    end

    -- 統一文字顏色和大小
    local fontUIStory = resources.fonts.ui
    if currentGameLanguage == "zh" then
        fontUIStory = resources.fonts.chineseUI
    end
    love.graphics.setFont(fontUIStory)
    love.graphics.setColor(1, 1, 1) -- Set text color to white (changed from black to white for better visibility on dark box)

    local textStartX = portraitImage and portraitDrawX + portraitDrawWidth + 20 or dialogBoxX + 20 -- Adjust text start X if portrait exists
    local textStartY = dialogBoxY + 30
    local textWidthLimit = dialogBoxWidth - (portraitImage and portraitDrawWidth + 40 or 40) -- Adjust text width limit based on portrait presence

    -- **DEBUG: Print the text being drawn**
    -- print("Drawing story text: " .. getCurrentText()) -- Uncomment for debugging

    love.graphics.printf(getCurrentText(), textStartX, textStartY, textWidthLimit, "left")

    if menuState.levelSelect.currentLevel > 1 and menuState.levelSelect.currentLevel < 10 then
        local eData = enemyData[menuState.levelSelect.currentLevel]
        if eData and eData.image then
            love.graphics.draw(resources.images[eData.image], 200, 200)
        end
    end

    love.graphics.setColor(0, 0, 1, 1)  -- Draw text in blue
    love.graphics.print(getCurrentText(), 400, 400)
    love.graphics.setColor(1, 1, 1, 1)  -- Reset color to white

    -- 統一說話者名稱樣式
    local fontBattleStory = resources.fonts.battle
    if currentGameLanguage == "zh" then
        fontBattleStory = resources.fonts.chineseBattle
    end
    love.graphics.setFont(fontBattleStory)
    love.graphics.setColor(1, 1, 0) -- 說話者名稱使用黃色

    local speakerNameX = portraitImage and portraitDrawX + portraitDrawWidth - fontBattleStory:getWidth(currentDialogue.speaker) or dialogBoxX + 20 -- Position name relative to portrait or dialogue box
    if portraitImage then
        speakerNameX = portraitDrawX + portraitDrawWidth - fontBattleStory:getWidth(currentDialogue.speaker)
        speakerNameY = portraitDrawY -- Align name to the top of portrait
    else
        speakerNameX = dialogBoxX + 20
        speakerNameY = dialogBoxY + 10
    end

    love.graphics.print(currentDialogue.speaker, speakerNameX, speakerNameY)


    -- Draw continue prompt if text is complete
    if isTextComplete() then
        love.graphics.setColor(1, 1, 1, 0.5 + math.sin(love.timer.getTime() * 5) * 0.5)
        love.graphics.print(getText(currentGameLanguage, "story_continue_prompt"), dialogBoxX + dialogBoxWidth - 150, dialogBoxY + dialogBoxHeight - 30)
    end

    -- Draw skip button
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", windowWidth - 150, windowHeight - 50, 100, 30)
    love.graphics.print(getText(currentGameLanguage, "story_skip_button"), windowWidth - 140, windowHeight - 45)
end

-- 新增 drawStoryPageUI 函數
function drawStoryPageUI() -- Remove dt parameter
  storyPageState.navTimer = storyPageState.navTimer + 0.0167 -- Update navTimer without dt

  local windowWidth = love.graphics.getWidth()
  local windowHeight = love.graphics.getHeight()

  -- Draw background (與主選單相同的背景)
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(resources.images.background, 0, 0, 0,
    windowWidth/resources.images.background:getWidth(),
    windowHeight/resources.images.background:getHeight())

  -- 標題
  local font = resources.fonts.battle
  if currentGameLanguage == "zh" then
    font = resources.fonts.chineseBattle
  end
  love.graphics.setFont(font)
  love.graphics.setColor(1, 1, 1)
  local title = getText(currentGameLanguage, "story_page_title")
  local titleWidth = font:getWidth(title)
  love.graphics.print(title, windowWidth / 2 - titleWidth / 2, 50)

  -- 故事文本區域
  local textStartX = 50
  local textStartY = 100
  local textWidthLimit = windowWidth - 100
  local textHeightLimit = windowHeight - 200 -- 預留底部按鈕空間

  love.graphics.setFont(resources.fonts.ui)
  love.graphics.setColor(1, 1, 1)

  -- 使用剪裁區域來實現滾動
  love.graphics.setScissor(textStartX, textStartY, textWidthLimit, textHeightLimit)
  love.graphics.translate(0, -storyPageState.scrollPosition) -- 根據滾動位置平移繪製

  love.graphics.printf(storyPageState.storyText, textStartX, textStartY, textWidthLimit, "left")

  love.graphics.setScissor() -- 移除剪裁區域
  love.graphics.translate(0, storyPageState.scrollPosition) -- 恢復平移

  -- 返回主選單按鈕
  local backButtonRect = {
    x = windowWidth / 2 - 100,
    y = windowHeight - 80,
    width = 200,
    height = 40
  }
  storyPageState.backButtonArea = backButtonRect
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("line", backButtonRect.x, backButtonRect.y, backButtonRect.width, backButtonRect.height)
  local fontUI = resources.fonts.ui
  if currentGameLanguage == "zh" then
    fontUI = resources.fonts.chineseUI
  end
  love.graphics.setFont(fontUI)
  local buttonTextWidth = fontUI:getWidth(getText(currentGameLanguage, "story_page_back_button"))
  love.graphics.print(getText(currentGameLanguage, "story_page_back_button"), backButtonRect.x + backButtonRect.width / 2 - buttonTextWidth / 2, backButtonRect.y + backButtonRect.height / 2 - 10)
end

function drawDialogueBox(dialogue, windowWidth, windowHeight)
    -- Draw dialogue box background
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

    -- Draw speaker name
    love.graphics.setColor(1, 1, 0)
    love.graphics.setFont(resources.fonts.battle)
    love.graphics.print(dialogue.speaker, dialogBoxX + 20, dialogBoxY + 10)

    -- Draw speaker portrait if available
    local portraitKey = "portrait" .. dialogue.speaker
    if resources.images[portraitKey] then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(resources.images[portraitKey], dialogBoxX + 20, dialogBoxY - 80)
    end

    -- Draw dialogue text
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(resources.fonts.ui)
    love.graphics.printf(getCurrentText(), dialogBoxX + 40, dialogBoxY + 50, dialogBoxWidth - 80, "left")

    -- Draw continue/skip prompts
    drawDialoguePrompts(dialogBoxX, dialogBoxY, dialogBoxWidth, dialogBoxHeight, windowWidth, windowHeight)
end

function drawDialoguePrompts(dialogBoxX, dialogBoxY, dialogBoxWidth, dialogBoxHeight, windowWidth, windowHeight)
    -- Draw continue prompt if text is complete
    if isTextComplete() then
        love.graphics.setColor(1, 1, 1, 0.5 + math.sin(love.timer.getTime() * 5) * 0.5)
        love.graphics.print("Press ENTER to continue", dialogBoxX + dialogBoxWidth - 150, dialogBoxY + dialogBoxHeight - 30)
    end

    -- Draw skip button
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", windowWidth - 150, windowHeight - 50, 100, 30)
    love.graphics.print("Skip (ESC)", windowWidth - 140, windowHeight - 45)
end

function drawDialogueChoices(choices, windowWidth, windowHeight)
    if not choices then return end

    -- Draw choice box background
    local choiceBoxWidth = windowWidth * 0.3
    local choiceBoxHeight = #choices * 40 + 20
    local choiceBoxX = windowWidth - choiceBoxWidth - 20
    local choiceBoxY = windowHeight - choiceBoxHeight - 200

    love.graphics.setColor(0, 0, 0, 0.8)
    love.graphics.rectangle("fill", choiceBoxX, choiceBoxY, choiceBoxWidth, choiceBoxHeight)

    -- Draw choices
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
  -- Draw the player with current animation and scaling constraints
  local playerImage = animations.player.current == "stand" and resources.images.playerStand or resources.images.playerAttack

  -- Calculate scale to ensure character doesn't exceed max width
  local playerScale = positions.player.scale
  if playerImage:getWidth() * playerScale > positions.player.maxWidth then
    playerScale = positions.player.maxWidth / playerImage:getWidth()
  end

  -- Ensure player stays on left side
  local playerX = math.min(animations.player.x, screenWidth * 0.5 - (playerImage:getWidth() * playerScale) / 2)
  love.graphics.draw(playerImage, playerX, positions.player.y, 0, playerScale, playerScale)

  -- Draw the enemy with current animation and scaling constraints
  local currentLevelData = enemyData[menuState.levelSelect.currentLevel] -- Get current level's enemy data
  local enemyStandImageKey = currentLevelData.image -- Get the stand image key

  local enemyImage = resources.images[enemyStandImageKey]

  -- Calculate scale to ensure character doesn't exceed max width
  local enemyScale = positions.enemy.scale
  if enemyImage:getWidth() * enemyScale > positions.enemy.maxWidth then
    enemyScale = positions.enemy.maxWidth / enemyImage:getWidth()
  end

  -- **Enemy Image Max Size Frame:**
  local maxEnemyImageHeight = screenHeight * 0.6 -- Set max height to 60% of screen height
  if enemyImage:getHeight() * enemyScale > maxEnemyImageHeight then
      enemyScale = maxEnemyImageHeight / enemyImage:getHeight()
  end


  -- Ensure enemy stays on right side
  local enemyX = math.max(animations.enemy.x, screenWidth * 0.5 + (enemyImage:getWidth() * enemyScale) / 2)
  love.graphics.draw(enemyImage, enemyX, positions.enemy.y, 0, enemyScale, enemyScale)
end

function drawBattleUI()
  if gameState == "story" then
    return  -- Do not display battle UI in story mode
  end

  local fontUI = resources.fonts.ui
  if currentGameLanguage == "zh" then
    fontUI = resources.fonts.chineseUI
  end
  love.graphics.setFont(fontUI)
  love.graphics.setColor(1, 1, 1)

  -- Draw UI frame
  love.graphics.draw(resources.images.uiFrame, positions.playerUI.x, positions.playerUI.y, 0, 0.2, 0.2) -- 縮放 battle-ui-frame.png 到 20%
  -- **Removed the extra UI frame drawing for the enemy side. Only player UI frame needed.**

  -- Player HP Bar (now above player with bigger dimensions)
  local hpBarWidth = 200
  local hpBarHeight = 20

  love.graphics.setColor(1, 0, 0)
  love.graphics.rectangle("fill", positions.playerHP.x, positions.playerHP.y, hpBarWidth, hpBarHeight)
  love.graphics.setColor(0, 1, 0)
  love.graphics.rectangle("fill", positions.playerHP.x, positions.playerHP.y, (player.hp / player.maxHp) * hpBarWidth, hpBarHeight)

  -- Enemy HP Bar (now above enemy with bigger dimensions)
  local hpBarWidth = 200
  local hpBarHeight = 20

  love.graphics.setColor(1, 0, 0)
  love.graphics.rectangle("fill", positions.enemyHP.x, positions.enemyHP.y, hpBarWidth, hpBarHeight)
  love.graphics.setColor(0, 1, 0)
  love.graphics.rectangle("fill", positions.enemyHP.x, positions.enemyHP.y, (enemy.hp / enemy.maxHp) * hpBarWidth, hpBarHeight)

  -- Battle menu
  if battleState.phase == "select" then
    battleState.buttonAreas = {} -- Store button areas for mouse interaction
    love.graphics.setColor(1, 1, 1)
    for i, option in ipairs(battleState.options) do
      local optionY = positions.playerUI.y -200 + (i-1) * 30 -- Raise the battle options text by 20 pixels
      local buttonRect = {
        x = positions.playerUI.x + 10,
        y = optionY,
        width = 180,
        height = 25
      }
      battleState.buttonAreas[i] = buttonRect

      if i == battleState.currentOption then
        love.graphics.setColor(1, 1, 0)
        love.graphics.rectangle("line", buttonRect.x, buttonRect.y, buttonRect.width, buttonRect.height) -- Yellow outline
      else
        love.graphics.setColor(1, 1, 1)
      end
      love.graphics.print(getText(currentGameLanguage, "battle_action_" .. option.name:lower()), buttonRect.x, buttonRect.y)
      love.graphics.setColor(0.8, 0.8, 0.8)
      love.graphics.print(getText(currentGameLanguage, "battle_action_desc_" .. option.name:lower()), buttonRect.x + 10, buttonRect.y + 20)
    end
  end

  -- Draw skill icons and cooldowns
  local iconSize = 50
  local iconSpacing = 20
  local startX = 50
  local startY = love.graphics.getHeight() - 100

  for i, skill in ipairs(skillInfo) do
    -- Draw skill icon
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(resources.images[skill.icon],
      startX + (i-1) * (iconSize + iconSpacing),
      startY,
      0,
      iconSize / resources.images[skill.icon]:getWidth(),
      iconSize / resources.images[skill.icon]:getHeight())

    -- Draw cooldown overlay
    local cooldown = skillSystem[skill.key].cooldown
    if cooldown > 0 then
      love.graphics.setColor(0, 0, 0, 0.7)
      love.graphics.draw(resources.images.cooldownOverlay,
        startX + (i-1) * (iconSize + iconSpacing),
        startY,
        0,
        iconSize / resources.images.cooldownOverlay:getWidth(),
        iconSize / resources.images.cooldownOverlay:getHeight())

      -- Draw cooldown number
      love.graphics.setColor(1, 1, 1)
      love.graphics.setFont(resources.fonts.ui)
      love.graphics.print(cooldown,
        startX + (i-1) * (iconSize + iconSpacing) + iconSize/2 - 5,
        startY + iconSize/2 - 10)
    end
  end
end

function drawEffects()
love.graphics.setColor(1, 1, 1)
for _, effect in ipairs(battleState.effects) do
  if effect.type == "hit" or effect.type == "defend" then
    love.graphics.draw(effect.particleSystem, effect.x, effect.y)
  elseif effect.type == "damage" then
    love.graphics.setFont(resources.fonts.damage)
    love.graphics.print(effect.amount, effect.x, effect.y)
  else
    love.graphics.draw(resources.images[effect.type], effect.x, effect.y, effect.rotation, effect.scale, effect.scale)
  end
end
end

-- 修改 drawBattleMessage 函數
function drawBattleMessage()
    if battleState.message ~= "" and battleState.messageTimer > 0 then
        local fontBattleMsg = resources.fonts.battle
        if currentGameLanguage == "zh" then
            fontBattleMsg = resources.fonts.chineseBattle
        end
        love.graphics.setFont(fontBattleMsg)

        -- 根據不同情況設置不同顏色
        if battleState.turn == "enemy" then
            -- 敵人的消息顯示為紅色
            love.graphics.setColor(1, 0, 0)
        else
            -- 玩家的消息顯示為綠色
            love.graphics.setColor(0, 1, 0)
        end

        local textWidth = fontBattleMsg:getWidth(battleState.message)
        love.graphics.print(battleState.message,
            love.graphics.getWidth() / 2 - textWidth / 2,
            love.graphics.getHeight() - 150)
    end
    
    if battleState.phase == "result" then
        local fontBattleResult = resources.fonts.battle
        if currentGameLanguage == "zh" then
            fontBattleResult = resources.fonts.chineseBattle
        end
        love.graphics.setFont(fontBattleResult)
        if player.hp <= 0 then
          love.graphics.setColor(1, 0, 0)
          local text = getText(currentGameLanguage, "battle_defeat")
          local textWidth = fontBattleResult:getWidth(text)
          love.graphics.print(text, love.graphics.getWidth() / 2 - textWidth / 2, love.graphics.getHeight() / 2 - 30)
        elseif enemy.hp <= 0 then
          love.graphics.setColor(0, 1, 0)
          local text = getText(currentGameLanguage, "battle_victory")
          local textWidth = fontBattleResult:getWidth(text)
          love.graphics.print(text, love.graphics.getWidth() / 2 - textWidth / 2, love.graphics.getHeight() / 2 - 30)
        end
      end
end


function drawBattleMessage()
if battleState.message ~= "" and battleState.messageTimer > 0 then
  local fontBattleMsgDraw = resources.fonts.battle
    if currentGameLanguage == "zh" then
        fontBattleMsgDraw = resources.fonts.chineseBattle
    end
  love.graphics.setFont(fontBattleMsgDraw)
  love.graphics.setColor(1, 1, 0)
  local textWidth = fontBattleMsgDraw:getWidth(battleState.message)
  love.graphics.print(battleState.message, love.graphics.getWidth() / 2 - textWidth / 2, love.graphics.getHeight() - 150)
end

if battleState.phase == "result" then
  local fontBattleResultDraw = resources.fonts.battle
    if currentGameLanguage == "zh" then
        fontBattleResultDraw = resources.fonts.chineseBattle
    end
  love.graphics.setFont(fontBattleResultDraw)
  if player.hp <= 0 then
    love.graphics.setColor(1, 0, 0)
    local text = "Defeat!"
    local textWidth = fontBattleResultDraw:getWidth(text)
    love.graphics.print(text, love.graphics.getWidth() / 2 - textWidth / 2, love.graphics.getHeight() / 2 - 30)
  elseif enemy.hp <= 0 then
    love.graphics.setColor(0, 1, 0)
    local text = "Victory!"
    local textWidth = fontBattleResultDraw:getWidth(text)
    love.graphics.print(text, love.graphics.getWidth() / 2 - textWidth / 2, love.graphics.getHeight() / 2 - 30)
  end
end
end

-- Add these new helper functions
function updateAnimations(dt)
  for _, anim in pairs(animations) do
    if anim.current == "attack" then
      -- Move forward during attack
      anim.timer = anim.timer + dt
      if anim.timer < 0.2 then
        anim.x = anim.x + (200 * dt) -- Move forward
      elseif anim.timer < 0.4 then
        anim.x = anim.x - (200 * dt) -- Move back
      else
        anim.timer = 0
        anim.current = "stand"
        anim.x = anim.originalX
      end
    end
  end
end

function updateEffects(dt)
  for i = #battleState.effects, 1, -1 do
    local effect = battleState.effects[i]

    if effect.type == "hit" or effect.type == "defend" then
      if effect.particleSystem then  -- Add this check
        effect.particleSystem:update(dt)
        effect.timer = effect.timer - dt
        if effect.timer <= 0 then
          table.remove(battleState.effects, i)
        end
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
  -- Check if dt is nil to prevent error
  if not dt then return end

  local moved = false
  local prevOption = menuState.currentOption
  local direction = "None" -- Default direction

  menuState.navTimer = menuState.navTimer + dt

  if menuState.navTimer > menuState.navDelay then
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
      menuState.currentOption = menuState.currentOption - 1
      moved = true
      direction = "Up" -- Set direction string
      menuState.navTimer = 0
    elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
      menuState.currentOption = menuState.currentOption + 1
      moved = true
      direction = "Down" -- Set direction string
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
      print("[MENU] Navigated menu: " .. direction .. ", selected option index: " .. menuState.currentOption .. ", option name: " .. getText(currentGameLanguage, menuState.options[menuState.currentOption].textKey)) -- Use direction variable
    end
  end
end


function handleStoryPageInput(dt)
  if dt == nil then
    print("[ERROR] dt IS NIL in handleStoryPageInput!") -- ERROR CHECK
    return -- Exit function early to avoid further errors
  end
  print("[DEBUG] handleStoryPageInput dt value: ", dt) -- DEBUG PRINT
  local scrollSpeed = 200 * dt
  if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
    storyPageState.scrollPosition = storyPageState.scrollPosition + scrollSpeed
  elseif love.keyboard.isDown("up") or love.keyboard.isDown("w") then
    storyPageState.scrollPosition = storyPageState.scrollPosition - scrollSpeed
    if storyPageState.scrollPosition < 0 then
      storyPageState.scrollPosition = 0
    end
  end
  handleMenuInput(dt) -- 故事頁面也套用主選單的速度調整
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
  handleMenuInput(dt) -- 關卡選擇頁面也套用主選單的速度調整
end

local storyEnterTimer = 0
local storyEnterDelay = 0.6

function handleStoryInput(dt)
    storyEnterTimer = storyEnterTimer + dt
    if love.keyboard.isDown("return") and storyEnterTimer > storyEnterDelay then
        storyEnterTimer = 0
        print("[STORY] Continue dialogue pressed")
        nextDialogue()
        local nextDialogue = getCurrentDialogue()
        if nextDialogue then
            setTargetText(nextDialogue.text)
        end

        if not currentState.isPlaying then
            if currentState.isEnding then
                gameState = "menu"
                print("[GAME STATE] Game state changed to 'menu' after ending")
            else
                gameState = "battle"
                print("[GAME STATE] Game state changed to 'battle' after story")
                restartGame()
            end
        end
    elseif love.keyboard.isDown("escape") then
        print("[STORY] Skip dialogue pressed")
        skipDialogue()
        gameState = "battle"
        print("[GAME STATE] Game state changed to 'battle' after skip")
        restartGame()
    end
end

function handleEndingInput()
  if love.keyboard.isDown("return") then
    print("[ENDING] Return pressed, going to menu")
    gameState = "menu"
    print("[GAME STATE] Game state changed to 'menu' from ending")
  end
  handleMenuInput(dt) -- 結局介面也套用主選單的速度調整
end

function updateBattleAction(dt)
end

function handleBattleInput()
  local moved = false
  local prevBattleOption = battleState.currentOption
  if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
    battleState.currentOption = battleState.currentOption - 1
    moved = true
  elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
    battleState.currentOption = battleState.currentOption + 1
    moved = true
  end

  if moved then
    if battleState.currentOption < 1 then
      battleState.currentOption = #battleState.options
    elseif battleState.currentOption > #battleState.options then
      battleState.currentOption = 1
    end
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
  local direction = "None" -- Default direction

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
        setCurrentLanguage(currentGameLanguage)
        print("[OPTIONS MENU] Language changed to: " .. currentGameLanguage)
      elseif currentOption.type == "resolution" then -- Resolution change
        currentOption.currentOption = currentOption.currentOption - 1
        if currentOption.currentOption < 1 then
          currentOption.currentOption = #currentOption.resolutionOptions
        end
        currentResolutionIndex = currentOption.currentOption
        applyResolutionChange() -- Apply resolution change
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
        setCurrentLanguage(currentGameLanguage)
        print("[OPTIONS MENU] Language changed to: " .. currentGameLanguage)
      elseif currentOption.type == "resolution" then -- Resolution change
        currentOption.currentOption = currentOption.currentOption + 1
        if currentOption.currentOption > #currentOption.resolutionOptions then
          currentOption.currentOption = 1
        end
         currentResolutionIndex = currentOption.currentOption
         applyResolutionChange() -- Apply resolution change
      end
      moved = true
    end
  end


  if moved then
    if optionsState.currentOption < 1 then
      optionsState.currentOption = #optionsState.options
    elseif optionsState.currentOption > #optionsState.options then
      optionsState.options = 1
    end
    if optionsState.currentOption ~= prevOption then
      print("[OPTIONS MENU] Navigated menu: " .. direction .. ", selected option index: " .. optionsState.currentOption .. ", option name: " .. getText(currentGameLanguage, optionsState.options[optionsState.currentOption].textKey))
    end
  end

  if love.keyboard.isDown("return") or love.keyboard.isDown("space") then
    local option = optionsState.options[optionsState.currentOption]
    if option.type == "toggle" then
      local targetState = option.targetState or audioState
      local stateKey = option.state -- Get the state key

      if targetState and stateKey then -- Check if targetState and stateKey are valid
        targetState[stateKey] = not targetState[stateKey] -- Toggle the boolean state
        print("[OPTIONS MENU] Toggled option: " .. getText(currentGameLanguage, option.textKey) .. ", new state: " .. tostring(targetState[stateKey]))
         if option.state == "isMutedBGM" then -- Handle BGM mute
          if targetState.isMutedBGM then
            love.audio.stop()
            print("[AUDIO] BGM stopped due to mute option")
          elseif gameState == "menu" then
            resources.sounds.menuBgm:play()
            print("[AUDIO] Menu BGM started due to unmute option")
          elseif gameState == "battle" then
            resources.sounds.battleBgm:play()
            print("[AUDIO] Battle BGM started due to unmute option")
          elseif gameState == "victory" then
            resources.sounds.victory:play()
            print("[AUDIO] Victory BGM started due to unmute option")
          elseif gameState == "defeat" then
            resources.sounds.defeat:play()
            print("[AUDIO] Defeat BGM started due to unmute option")
          end
        end
      else
        print("[OPTIONS MENU] ERROR: targetState or stateKey is invalid. Toggle action skipped.")
      end
    elseif option.action then
      option.action() -- Execute action if any
      print("[OPTIONS MENU] Option selected: " .. getText(currentGameLanguage, option.textKey))
    end
  end
  handleMenuInput(dt)  -- 選項介面也套用主選單的速度調整
end

-- Function to apply resolution change
function applyResolutionChange()
  screenWidth = availableResolutions[currentResolutionIndex].width
  screenHeight = availableResolutions[currentResolutionIndex].height
  love.window.setMode(screenWidth, screenHeight, {resizable = false, vsync = true})
  print("[GAME] Resolution changed to " .. screenWidth .. "x" .. screenHeight)

    -- Update positions based on new resolution
    positions.player = {
        x = screenWidth * 0.15,
        y = screenHeight * 0.5,
        scale = 0.7,
        maxWidth = screenWidth * 0.4
    }
    positions.enemy = {
        x = screenWidth * 0.55,
        y = screenHeight * 0.5,
        scale = 0.7,
        maxWidth = screenWidth * 0.4
    }
    positions.enemyHP = {x = screenWidth - 220, y = 20}
    positions.playerUI = {x = screenWidth * 0.05 - 50, y = screenHeight * 0.78}
    positions.enemyUI = {x = screenWidth * 0.65, y = screenHeight * 0.75}

    animations.player.x = positions.player.x
    animations.player.y = positions.player.y
    animations.player.originalX = positions.player.x
    animations.enemy.x = positions.enemy.x
    animations.enemy.y = positions.enemy.y
    animations.enemy.originalX = positions.enemy.x
end


local inputMapping = {
  ["return"] = "select_option",
  ["escape"] = "back",
  ["up"] = "move_up",
  ["down"] = "move_down",
  ["w"] = "move_up",
  ["s"] = "move_down"
}

local inputMappingByState = {
    menu = {
        ["return"] = function() handleMenuSelect() end,
        ["escape"] = function() handleMenuBack() end,
        ["up"] = function() handleMenuNavigation("up") end,
        ["down"] = function() handleMenuNavigation("down") end,
        ["w"] = function() handleMenuNavigation("up") end,
        ["s"] = function() handleMenuNavigation("down") end
    },
    battle = {
        ["return"] = function() handleBattleAction() end,
        ["escape"] = function() handleBattlePause() end,
        ["up"] = function() handleBattleNavigation("up") end,
        ["down"] = function() handleBattleNavigation("down") end
    },
    storyPage = {
        ["escape"] = function() handleStoryPageBack() end,
        ["up"] = function() handleStoryPageScroll("up") end,
        ["down"] = function() handleStoryPageScroll("down") end
    }
}

-- Modify love.keypressed to use the new mapping system
function love.keypressed(key)
    local currentStateMappings = inputMappingByState[gameState]
    if currentStateMappings then
        local action = currentStateMappings[key]
        if action then
            action()
        end
    end
end

-- Add input handling functions
function handleMenuSelect()
    -- ...existing code from love.keypressed menu select handling...
end

function handleMenuBack()
    -- ...existing code from love.keypressed menu back handling...
end

function handleMenuNavigation(direction)
    local moved = false
    local prevOption = menuState.currentOption
    
    if direction == "up" then
        if menuState.currentOption > 1 then
            menuState.currentOption = menuState.currentOption - 1
            moved = true
        end
    elseif direction == "down" then
        if menuState.currentOption < #menuState.options then
            menuState.currentOption = menuState.currentOption + 1
            moved = true
        end
    end
    
    if moved then
        if not audioState.isMutedSFX then
            resources.sounds.menuSelect:play()
        end
    end
end

function handleBattleAction()
    if battleState.phase == "select" then
        local selectedOption = battleState.options[battleState.currentOption]
        if selectedOption.name == "Attack" then
            performPlayerAttack()
        elseif selectedOption.name == "Defend" then
            performPlayerDefend()
        elseif selectedOption.name == "Special" then
            performPlayerSpecial()
        elseif selectedOption.name == "Heal" then
            performPlayerHeal()
        end
    end
end

function handleBattlePause()
    if not pauseState.isPaused then
        pauseState.isPaused = true
        gameState = "pause"
        -- Pause all battle timers
        TimerSystem.pauseGroup(TIMER_GROUPS.BATTLE)
    end
end

function resumeBattle()
    if pauseState.isPaused then
        pauseState.isPaused = false
        gameState = "battle"
        -- Resume all battle timers
        TimerSystem.resumeGroup(TIMER_GROUPS.BATTLE)
    end
end

function handleBattleNavigation(direction)
    local moved = false
    local prevOption = battleState.currentOption
    
    if direction == "up" then
        if battleState.currentOption > 1 then
            battleState.currentOption = battleState.currentOption - 1
            moved = true
        end
    elseif direction == "down" then
        if battleState.currentOption < #battleState.options then
            battleState.currentOption = battleState.currentOption + 1
            moved = true
        end
    end
    
    if moved then
        if not audioState.isMutedSFX then
            resources.sounds.menuSelect:play()
        end
    end
end

local function handleInputAction(action)
  -- 根據 action 進行對應邏輯，例如:
  if action == "select_option" then
    -- ...existing code...
  elseif action == "back" then
    -- ...existing code...
  elseif action == "move_up" then
    -- ...existing code...
  elseif action == "move_down" then
    -- ...existing code...
  end
end

function love.keypressed(key)
  local mappedAction = inputMapping[key]
  if mappedAction then
    handleInputAction(mappedAction)
  else
    -- ...existing code for other keys...
  end
end

function love.keypressed(key)
  if gameState == "menu" then
    if key == "return" or key == "space" then
      local option = menuState.options[menuState.currentOption]
      print("[MENU] Option selected: " .. getText(currentGameLanguage, option.textKey))
      if option.textKey == "menu_select_level" then
        gameState = "levelSelect"
        print("[GAME STATE] Game state changed to 'levelSelect'")
      elseif option.textKey == "menu_options" then
        gameState = "options"
        print("[GAME STATE] Game state changed to 'options'")
      elseif option.textKey == "menu_exit" then
        print("[MENU] Exit selected, quitting game")
        love.event.quit()
      elseif option.textKey == "menu_story_page" then -- 新增 story_page 的處理
        gameState = "storyPage"
        print("[GAME STATE] Game state changed to 'storyPage'")
      end
    end
  elseif gameState == "levelSelect" then
    if key == "return" then
        -- Properly start the story when selecting a level
        print("[LEVEL SELECT] Level " .. menuState.levelSelect.currentLevel .. " selected")
        startLevelDialogue(menuState.levelSelect.currentLevel)
        gameState = "story"
        print("[GAME STATE] Game state changed to 'story'")
        -- Set initial text
        local currentDialogue = getCurrentDialogue()
        setTargetText(currentDialogue.text)
    elseif key == "escape" then
      gameState = "menu"
      print("[GAME STATE] Game state changed to 'menu'")
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
      nextDialogue()
      if not currentState.isPlaying then
        if currentState.isEnding then
          gameState = "menu"
          print("[GAME STATE] Game state changed to 'menu' from story ending")
        else
          gameState = "battle"
          print("[GAME STATE] Game state changed to 'battle' from story")
          restartGame()
        end
      end
    elseif key == "escape" then
      print("[STORY] Skip dialogue key pressed")
      skipDialogue()
      gameState = "battle"
      print("[GAME STATE] Game state changed to 'battle' from story skip")
      restartGame()
    end
  elseif gameState == "battle" then
    if pauseState.isPaused then
      if key == "up" or key == "w" then
        local prevPauseOption = pauseState.currentOption
        pauseState.currentOption = pauseState.currentOption - 1
        if pauseState.currentOption < 1 then
          pauseState.currentOption = #pauseState.options
        end
        if pauseState.currentOption ~= prevPauseOption then
          print("[PAUSE MENU] Navigated menu: Up, selected option index: " .. pauseState.currentOption .. ", option text: " .. getText(currentGameLanguage, pauseState.options[pauseState.currentOption].textKey))
        end
      elseif key == "down" or key == "s" then
        local prevPauseOption = pauseState.currentOption
        pauseState.currentOption = pauseState.currentOption + 1
        if pauseState.currentOption > #pauseState.options then
          pauseState.currentOption = 1
        end
        if pauseState.currentOption ~= prevPauseOption then
          print("[PAUSE MENU] Navigated menu: Down, selected option index: " .. pauseState.currentOption .. ", option text: " .. getText(currentGameLanguage, pauseState.options[pauseState.currentOption].textKey))
        end
      elseif key == "return" or key == "space" then
        -- Execute the selected option's action
        local selectedPauseOption = pauseState.options[pauseState.currentOption]
        print("[PAUSE MENU] Option selected: " .. getText(currentGameLanguage, selectedPauseOption.textKey))
        selectedPauseOption.action()
        if selectedPauseOption.textKey == "pause_continue" then
          print("[GAME STATE] Game unpaused")
        elseif selectedPauseOption.textKey == "pause_restart" then
          print("[GAME STATE] Game restarted from pause menu")
        elseif selectedPauseOption.textKey == "pause_main_menu" then
          print("[GAME STATE] Game state changed to 'menu' from pause menu")
        elseif selectedPauseOption.textKey == "pause_quit_game" then
          print("[GAME] Quit game from pause menu")
        end
      end
      return  -- Stop processing other inputs while paused
    else
      -- 戰鬥選擇階段的按鍵處理
      if battleState.phase == "select" and battleState.turn == "player" then
        if key == "up" or key == "down" or key == "w" or key == "s" then -- Navigation handled in handleBattleInput
        elseif key == "return" or key == "space" then
          -- 執行選擇的動作
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
      end

      -- 暫停遊戲的按鍵處理
      if key == "escape" then
        pauseState.isPaused = not pauseState.isPaused
        print("[GAME STATE] Pause state toggled: " .. tostring(pauseState.isPaused))
        if pauseState.isPaused then
          audioState.isMutedBGM = true
          audioState.isMutedSFX = true
          love.audio.stop()
          print("[AUDIO] Game paused, audio stopped")
        else
          audioState.isMutedBGM = false
          audioState.isMutedSFX = false
          print("[AUDIO] Game unpaused, audio muted state: BGM=" .. tostring(audioState.isMutedBGM) .. ", SFX=" .. tostring(audioState.isMutedSFX))
        end
      end
    end
  elseif gameState == "defeat" or gameState == "victory" then
    if key == "up" or key == "w" then
      local prevResultOption = resultState.currentOption
      resultState.currentOption = resultState.currentOption - 1
      if resultState.currentOption < 1 then
        resultState.currentOption = #resultState.options
      end
      if resultState.currentOption ~= prevResultOption then
        print("[" .. gameState:upper() .. " MENU] Navigated menu: Up, selected option index: " .. resultState.currentOption .. ", option text: " .. getText(currentGameLanguage, resultState.options[resultState.currentOption].textKey))
      end
    elseif key == "down" or key == "s" then
      local prevResultOption = resultState.currentOption
      resultState.currentOption = resultState.currentOption + 1
      if resultState.currentOption > #resultState.options then
        resultState.currentOption = 1
      end
      if resultState.currentOption ~= prevResultOption then
        print("[" .. gameState:upper() .. " MENU] Navigated menu: Down, selected option index: " .. resultState.currentOption .. ", option text: " .. getText(currentGameLanguage, resultState.options[resultState.currentOption].textKey))
      end
    elseif key == "return" or key == "space" then
      local selectedResultOption = resultState.options[resultState.currentOption]
      print("[" .. gameState:upper() .. " MENU] Option selected: " .. getText(currentGameLanguage, selectedResultOption.textKey))
      selectedResultOption.action()
      if selectedResultOption.textKey == "result_restart" then
        print("[GAME STATE] Game restarted from " .. gameState .. " menu")
      elseif selectedResultOption.textKey == "result_main_menu" then
        print("[GAME STATE] Game state changed to 'menu' from " .. gameState .. " menu")
      end
    end
    return
  elseif gameState == "options" then
    if key == "escape" then
      gameState = "menu"
      print("[GAME STATE] Game state changed to 'menu' from options")
    elseif key == "return" or key == "space" then
      handleOptionsInputReturn() -- Handle return key press in options menu
    end
    handleMenuInput(dt) -- 選項介面也套用主選單的速度調整
  elseif gameState == "storyPage" then -- 新增 storyPage 的按鍵處理
    if key == "escape" then
      gameState = "menu"
      storyPageState.scrollPosition = 0 -- 返回主選單時重置滾動位置
      print("[GAME STATE] Game state changed to 'menu' from storyPage")
    end
    handleStoryPageInput(dt) -- 故事頁面也套用主選單的速度調整
  end
end

function handleOptionsInputReturn()
  local option = optionsState.options[optionsState.currentOption]
  if option.type == "toggle" then
    local targetState = option.targetState or audioState
    targetState[option.state] = not targetState[option.state]
    print("[OPTIONS MENU] Toggled option: " .. getText(currentGameLanguage, option.textKey) .. ", new state: " .. tostring(targetState[option.state]))
    if option.state == "isMutedBGM" then
      if targetState.isMutedBGM then
        love.audio.stop()
        print("[AUDIO] BGM stopped due to mute option")
      elseif gameState == "menu" then
        resources.sounds.menuBgm:play()
        print("[AUDIO] Menu BGM started due to unmute option")
      elseif gameState == "battle" then
        resources.sounds.battleBgm:play()
        print("[AUDIO] Battle BGM started due to unmute option")
      elseif gameState == "victory" then
        resources.sounds.victory:play()
        print("[AUDIO] Victory BGM started due to unmute option")
      elseif gameState == "defeat" then
        resources.sounds.defeat:play()
        print("[AUDIO] Defeat BGM started due to unmute option")
      end
    end
  elseif option.action then
    option.action()
    print("[OPTIONS MENU] Option selected: " .. getText(currentGameLanguage, option.textKey))
  end
end


-- Add this utility function for mouse collision detection
local function isPointInRect(x, y, rect)
    if not rect or not rect.x or not rect.y or not rect.width or not rect.height then
        return false
    end
    return x >= rect.x and x <= rect.x + rect.width and
           y >= rect.y and y <= rect.y + rect.height
end

-- Replace the existing love.mousepressed function
function love.mousepressed(x, y, button, istouch, presses)
    if button ~= 1 then return end -- Only handle left clicks
    
    local handled = false
    
    if gameState == "menu" then
        if menuState.buttonAreas then
            for i, area in ipairs(menuState.buttonAreas) do
                if isPointInRect(x, y, area) then
                    menuState.currentOption = i
                    handleMenuSelect()
                    handled = true
                    break
                end
            end
        end
    elseif gameState == "battle" and not pauseState.isPaused then
        if battleState.buttonAreas then
            for i, area in ipairs(battleState.buttonAreas) do
                if isPointInRect(x, y, area) and battleState.phase == "select" then
                    battleState.currentOption = i
                    handleBattleAction()
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
                    if i == 1 then
                        resumeBattle()
                    elseif i == 2 then
                        gameState = "menu"
                        TimerSystem.pauseGroup(TIMER_GROUPS.BATTLE)
                    end
                    handled = true
                    break
                end
            end
        end
    elseif gameState == "storyPage" then
        if storyPageState.backButtonArea and isPointInRect(x, y, storyPageState.backButtonArea) then
            gameState = "menu"
            handled = true
        end
    end

    if handled and not audioState.isMutedSFX then
        resources.sounds.menuSelect:play()
    end
end

-- Add touch input support
function love.touchpressed(id, x, y)
    love.mousepressed(x, y, 1, true, 1)
end

function love.mousepressed(x, y, button, istouch, presses)
 if gameState == "menu" then
    if menuState.buttonAreas then
      for i, buttonRect in ipairs(menuState.buttonAreas) do
        if x > buttonRect.x and x < buttonRect.x + buttonRect.width and y > buttonRect.y and y < buttonRect.y + buttonRect.height then
          menuState.currentOption = i
          local option = menuState.options[i]
          print("[MENU] Option clicked: " .. getText(currentGameLanguage, option.textKey))
          if option.textKey == "menu_select_level" then
            gameState = "levelSelect"
            print("[GAME STATE] Game state changed to 'levelSelect'")
          elseif option.textKey == "menu_options" then
            gameState = "options"
            print("[GAME STATE] Game state changed to 'options'")
          elseif option.textKey == "menu_exit" then
            print("[MENU] Exit selected, quitting game")
            love.event.quit()
          elseif option.textKey == "menu_story_page" then -- 新增 story_page 的處理
            gameState = "storyPage"
            print("[GAME STATE] Game state changed to 'storyPage'")
          end
          break -- Exit loop after click is handled
        end
      end
    end
  elseif gameState == "levelSelect" then
    if menuState.levelSelect.buttonAreas then
      for i, buttonRect in ipairs(menuState.levelSelect.buttonAreas) do
        if x > buttonRect.x and x < buttonRect.x + buttonRect.width and y > buttonRect.y and y < buttonRect.y + buttonRect.height then
          menuState.levelSelect.currentLevel = i
          print("[LEVEL SELECT] Level " .. menuState.levelSelect.currentLevel .. " selected by mouse")
          startLevelDialogue(menuState.levelSelect.currentLevel)
          gameState = "story"
          print("[GAME STATE] Game state changed to 'story'")
          local currentDialogue = getCurrentDialogue()
          setTargetText(currentDialogue.text)
          break
        end
      end
    end
    -- Back button click detection in Level Select
    if menuState.levelSelect.backButtonArea then
      local backButtonRect = menuState.levelSelect.backButtonArea
      if x > backButtonRect.x and x < backButtonRect.x + backButtonRect.width and y > buttonRect.y and y < backButtonRect.y + backButtonRect.height then
        gameState = "menu"
        print("[LEVEL SELECT] Back button clicked, returning to main menu")
      end
    end
  elseif gameState == "battle" then
    if battleState.phase == "select" and battleState.turn == "player" and battleState.buttonAreas then
      for i, buttonRect in ipairs(battleState.buttonAreas) do
        if x > buttonRect.x and x < buttonRect.x + buttonRect.width and y > buttonRect.y and y < buttonRect.y + buttonRect.height then
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
          break
        end
      end
    end
  elseif pauseState.isPaused then
  local windowWidth = love.graphics.getWidth()
  local windowHeight = love.graphics.getHeight()

  if pauseState.buttonAreas then
    for i, buttonRect in ipairs(pauseState.buttonAreas) do
      if x > buttonRect.x and x < buttonRect.x + buttonRect.width and y > buttonRect.y and y < buttonRect.y + buttonRect.height then
        pauseState.currentOption = i
        local option = pauseState.options[i]
        print("[PAUSE MENU] Option clicked: " .. getText(currentGameLanguage, option.textKey))
        option.action()
        break
      end
    end
  end
elseif gameState == "victory" or gameState == "defeat" then
  if resultState.buttonAreas then
    for i, buttonRect in ipairs(resultState.buttonAreas) do
      if x > buttonRect.x and x < buttonRect.x + buttonRect.width and y > buttonRect.y and y < buttonRect.y + buttonRect.height then
        resultState.currentOption = i
        local option = resultState.options[i]
        print("[" .. gameState:upper() .. " MENU] Option clicked: " .. getText(currentGameLanguage, option.textKey))
        option.action()
        break
      end
    end
  end
elseif gameState == "options" then
  if optionsState.buttonAreas then
    for i, buttonRect in ipairs(optionsState.buttonAreas) do
      if x > buttonRect.x and x < buttonRect.x + buttonRect.width and y > buttonRect.y and y < buttonRect.y + buttonRect.height then
        optionsState.currentOption = i
        local option = optionsState.options[i]
        print("[OPTIONS MENU] Option clicked: " .. getText(currentGameLanguage, option.textKey))
        if option.type == "toggle" then
          handleOptionsInputReturn()
        elseif option.action then
          option.action()
        end
        break
      end
    end
  end
  -- Language option click handling
  if optionsState.options[optionsState.currentOption].type == "language" and optionsState.languageButtonAreas then
    for areaType, areaRect in pairs(optionsState.languageButtonAreas) do
      if x > areaRect.x and x < areaRect.x + areaRect.width and y > areaRect.y and y < areaRect.y + areaRect.height then
        if areaType == "left" then
          local currentOption = optionsState.options[optionsState.currentOption]
          currentOption.currentOption = currentOption.currentOption - 1
          if currentOption.currentOption < 1 then
            currentOption.currentOption = #currentOption.languageOptions
          end
          currentGameLanguage = currentOption.languageOptions[currentOption.currentOption]
          setCurrentLanguage(currentGameLanguage)
          print("[OPTIONS MENU] Language changed to: " .. currentGameLanguage .. " (Left Arrow Click)")
        elseif areaType == "right" then
          local currentOption = optionsState.options[optionsState.currentOption]
          currentOption.currentOption = currentOption.currentOption + 1
          if currentOption.currentOption > #currentOption.languageOptions then
            currentOption.currentOption = 1
          end
          currentGameLanguage = currentOption.languageOptions[currentOption.currentOption]
          setCurrentLanguage(currentGameLanguage)
          print("[OPTIONS MENU] Language changed to: " .. currentGameLanguage .. " (Right Arrow Click)")
        end
        break -- Exit loop after click is handled
      end
    end
  end
    -- Resolution option click handling
    if optionsState.options[optionsState.currentOption].type == "resolution" and optionsState.resolutionButtonAreas then
        for areaType, areaRect in pairs(optionsState.resolutionButtonAreas) do
            if x > areaRect.x and x < areaRect.x + areaRect.width and y > areaRect.y and y < areaRect.y + areaRect.height then
                if areaType == "left" then
                    local currentOption = optionsState.options[optionsState.currentOption]
                    currentOption.currentOption = currentOption.currentOption - 1
                    if currentOption.currentOption < 1 then
                        currentOption.currentOption = #currentOption.resolutionOptions
                    end
                    currentResolutionIndex = currentOption.currentOption
                    applyResolutionChange()
                    print("[OPTIONS MENU] Resolution changed (Left Arrow Click)")
                elseif areaType == "right" then
                    local currentOption = optionsState.options[optionsState.currentOption]
                    currentOption.currentOption = currentOption.currentOption + 1
                    if currentOption.currentOption > #currentOption.resolutionOptions then
                        currentOption.currentOption = #currentOption.resolutionOptions
                    end
                     currentResolutionIndex = currentOption.currentOption
                     applyResolutionChange()
                     print("[OPTIONS MENU] Resolution changed (Right Arrow Click)")
                end
                break -- Exit loop after click is handled
            end
        end
    end
  -- Back button click detection in Options
  if optionsState.backButtonArea then
    local backButtonRect = optionsState.backButtonArea
    if x > backButtonRect.x and x < backButtonRect.x + backButtonRect.width and y > buttonRect.y and y < backButtonRect.y + backButtonRect.height then
      gameState = "menu"
      print("[OPTIONS MENU] Back button clicked")
    end
  end
elseif gameState == "storyPage" then -- 新增 storyPage 的滑鼠處理
    if storyPageState.backButtonArea then
      local backButtonRect = storyPageState.backButtonArea
      if x > backButtonRect.x and x < backButtonRect.x + backButtonRect.width and y > backButtonRect.y and y < backButtonRect.y + backButtonRect.height then
        gameState = "menu"
        storyPageState.scrollPosition = 0 -- 返回主選單時重置滾動位置
        print("[STORY PAGE] Back button clicked, returning to main menu")
      end
    end
  elseif gameState == "story" then
  local windowWidth = love.graphics.getWidth()
  local windowHeight = love.graphics.getHeight()
  local dialogBoxWidth = windowWidth * 0.8
  local dialogBoxHeight = windowHeight - 200
  local dialogBoxX = (windowWidth - dialogBoxWidth) / 2
  local dialogBoxY = windowHeight - dialogBoxHeight - 50

  if x > dialogBoxX and x < dialogBoxX + dialogBoxWidth and y > dialogBoxY and y < dialogBoxY + dialogBoxHeight then
    handleStoryInput() -- Simulate story input on dialogue box click
    print("[STORY] Dialogue box clicked, continuing story")
  end
end
end
function restartGame()
print("[GAME] Restarting game...")
-- Reset player settings
player.hp = player.maxHp
player.isDefending = false
player.combo = 0
player.isCheatMode = player.isCheatMode -- Keep cheat mode setting across restarts
print("[GAME] Player settings reset")

-- Load enemy data for current level
local currentEnemyData = enemyData[menuState.levelSelect.currentLevel]
enemy = {
  x = 600,
  y = 300,
  image = resources.images[currentEnemyData.image], -- Use stand image from enemyData
  hp = currentEnemyData.hp,
  maxHp = currentEnemyData.maxHp,
  attack = currentEnemyData.attack,
  defense = currentEnemyData.defense,
  critRate = currentEnemyData.critRate,
  critDamage = currentEnemyData.critDamage,
  isDefending = false,
  status = {},
  combo = 0
}
print("[GAME] Enemy settings loaded for level " .. menuState.levelSelect.currentLevel)

  battleState = {
      phase = "select",
      turn = "player",
      message = "Battle Start!",
      messageTimer = 2,
      options = {
          {name = "Attack", description = "Deal damage to enemy"},
          {name = "Defend", description = "Reduce incoming damage"},
          {name = "Special", description = "Powerful attack with delay"},
          {name = "Heal", description = "Restore health"},
      },
      currentOption = 1,
      buttonAreas = {}, -- Add buttonAreas for mouse interaction
      effects = {}
  }
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
gameState = "battle"
pauseState.isPaused = false
print("[GAME STATE] Game state changed to 'battle'")

if not audioState.isMutedBGM then
  resources.sounds.menuBgm:stop()
  resources.sounds.battleBgm:setLooping(true)
  resources.sounds.battleBgm:play()
  print("[AUDIO] Menu BGM stopped, Battle BGM started")
end
end
local function calculateDamage(attacker, defender)
  local damage = attacker.attack * (1 - defender.defense / (attacker.attack + defender.defense))
  damage = damage * (1 + math.random(-0.1, 0.1)) -- Add randomness

  local isCrit = math.random(1, 100) <= attacker.critRate
  if isCrit then
      damage = damage * attacker.critDamage
  end

  damage = math.max(0, math.floor(damage)) -- ensure damage is not a negative value or a decimal and round it down

  -- Cheat mode: one-hit kill
  if player.isCheatMode then
    damage = defender.hp -- Set damage to enemy's current HP, effectively OHKO
  end

  -- Assertion to ensure damage is non-negative
  assert(damage >= 0, "Damage should not be negative")

 return damage, isCrit
end

-- Modify performPlayerAttack function
function performPlayerAttack()
    -- Guard clause for cooldown
    if skillSystem.attack.cooldown > 0 then
        battleState.message = getText(currentGameLanguage, "battle_msg_skill_cooldown")
        battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
        return
    end

    if not audioState.isMutedSFX then
        resources.sounds.attack:play()
    end

    animations.player.current = "attack"
    local damage, isCrit = calculateDamage(player, enemy)
    enemy.hp = validateNumber(enemy.hp - damage, 0, enemy.maxHp, 0)

    -- Create battle effect with new timer system
    local effectId = TimerSystem.create(GAME_CONSTANTS.TIMER.EFFECT_DURATION, function()
        table.remove(battleState.effects, 1)
    end, TIMER_GROUPS.ANIMATION)

    -- Add hit effect
    table.insert(battleState.effects, {
        type = "hit",
        x = positions.enemy.x + 50,
        y = positions.enemy.y + 50,
        timer = effectId
    })

    -- Set battle message
    battleState.message = isCrit and 
        getText(currentGameLanguage, "battle_msg_player_attack_crit", {damage = damage}) or
        getText(currentGameLanguage, "battle_msg_player_attack", {damage = damage})
    battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
    battleState.phase = "action"

    -- Check victory condition
    if enemy.hp <= 0 then
        battleState.phase = "result"
        TimerSystem.create(GAME_CONSTANTS.TIMER.ACTION_DELAY, function()
            gameState = "victory"
        end, TIMER_GROUPS.BATTLE)
    else
        TimerSystem.create(GAME_CONSTANTS.TIMER.ACTION_DELAY, startEnemyTurn, TIMER_GROUPS.BATTLE)
    end

    -- Apply cooldown
    skillSystem.attack.cooldown = skillSystem.attack.maxCooldown
end

-- Modified performPlayerHeal to use improved systems
function performPlayerHeal()
    -- Guard clause for cooldown
    if skillSystem.heal.cooldown > 0 then
        battleState.message = getText(currentGameLanguage, "battle_msg_skill_cooldown")
        battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
        return
    end

    if not audioState.isMutedSFX then
        resources.sounds.heal:play()
    end

    local healAmount = calculateHeal(player)
    player.hp = validateNumber(player.hp + healAmount, 0, player.maxHp, player.hp)
    
    -- Create heal effect with new timer system
    local effectId = TimerSystem.create(GAME_CONSTANTS.TIMER.EFFECT_DURATION, function()
        table.remove(battleState.effects, 1)
    end, TIMER_GROUPS.ANIMATION)

    -- Add heal effect
    table.insert(battleState.effects, {
        type = "heal",
        x = positions.player.x + 50,
        y = positions.player.y + 50,
        timer = effectId
    })

    battleState.message = getText(currentGameLanguage, "battle_msg_player_heal", {healAmount = healAmount})
    battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
    battleState.phase = "action"

    TimerSystem.create(GAME_CONSTANTS.TIMER.ACTION_DELAY, startEnemyTurn, TIMER_GROUPS.BATTLE)
    skillSystem.heal.cooldown = skillSystem.heal.maxCooldown
end

function performPlayerDefend()
  -- No changes needed for defend skill
  performPlayerDefend_original() -- call original defend function if you have any
end

function performPlayerSpecial()
  -- No changes needed for special skill
  performPlayerSpecial_original() -- call original special function if you have any
end


-- Original functions (if you have any logic in them that you don't want to remove)
function performPlayerDefend_original()
  print("[BATTLE ACTION] Player action: Defend")
  if skillSystem.defend.cooldown > 0 then
    battleState.message = "Skill on cooldown!"
    print("[BATTLE] Defend skill on cooldown")
    return
  end

  if not audioState.isMutedSFX then
    resources.sounds.defend:play()
    print("[AUDIO] Played sound: defend")
  end

  player.isDefending = true
  animations.player.current = "stand"

  -- Create new particle system instance for defend effect
  local defendParticleSystem = love.graphics.newParticleSystem(resources.images.defendEffect, 100)
  defendParticleSystem:setParticleLifetime(0.2, 0.5)
  defendParticleSystem:setSpeed(50, 100)
  defendParticleSystem:setDirection(0, 360)
  defendParticleSystem:setSpread(5)
  defendParticleSystem:setSizes(0.3, 0.1)
  defendParticleSystem:setRotation(0, 360)
  defendParticleSystem:emit(100)

  table.insert(battleState.effects, {
    type = "defend",
    x = positions.player.x + 50,
    y = positions.player.y + 50,
    particleSystem = defendParticleSystem,
    timer = 0.5
  })

  battleState.message = getText(currentGameLanguage, "battle_msg_player_defend")
  battleState.messageTimer = 2
  battleState.phase = "action"
  print("[BATTLE STATE] Battle phase changed to 'action'")

  addTimer(2, function() startEnemyTurn() end)
  print("[TIMER] Added timer for enemy turn")

  skillSystem.defend.cooldown = skillSystem.defend.maxCooldown
  print("[SKILL SYSTEM] Defend skill cooldown set to " .. skillSystem.defend.cooldown)
end

function performPlayerSpecial_original()
  print("[BATTLE ACTION] Player action: Special")
  if skillSystem.special.cooldown > 0 then
    battleState.message = "Skill on cooldown!"
    print("[BATTLE] Special skill on cooldown")
    return
  end

  if not audioState.isMutedSFX then
    resources.sounds.special:play()
    print("[AUDIO] Played sound: special")
  end

animations.player.current = "attack"
local damage = player.attack * 2
print("[BATTLE] Player stats before special: HP=" .. player.hp .. ", Attack=" .. player.attack .. ", Defense=" .. player.defense .. ", CritRate=" .. player.critRate .. ", CritDamage=" .. player.critRate .. ", CritDamage=" .. player.critDamage)
print("[BATTLE] Enemy stats before special: HP=" .. enemy.hp .. ", Attack=" .. enemy.attack .. ", Defense=" .. enemy.defense .. ", CritRate=" .. enemy.critRate .. ", CritDamage=" .. enemy.critDamage)
enemy.hp = math.max(0, enemy.hp - damage)
print("[BATTLE] Player dealt " .. damage .. " damage to enemy with Special attack")

-- Add special effect
battleState.message = getText(currentGameLanguage, "battle_msg_player_special", {damage = damage})
battleState.messageTimer = 2
battleState.phase = "action"
print("[BATTLE STATE] Battle phase changed to 'action'")

if enemy.hp <= 0 then
  battleState.phase = "result"
  print("[BATTLE STATE] Battle phase changed to 'result', enemy defeated by special attack")
else
  addTimer(2, function() startEnemyTurn() end)
  print("[TIMER] Added timer for enemy turn")
end

skillSystem.special.cooldown = skillSystem.special.maxCooldown
print("[SKILL SYSTEM] Special skill cooldown set to " .. skillSystem.special.cooldown)
end

function performPlayerHeal_original()
  print("[BATTLE ACTION] Player action: Heal")
  if skillSystem.heal.cooldown > 0 then
    battleState.message = "Skill on cooldown!"
    print("[BATTLE] Heal skill on cooldown")
    return
  end

  if not audioState.isMutedSFX then
    resources.sounds.heal:play()
    print("[AUDIO] Played sound: heal")
  end

local healAmount = player.maxHp * 0.2 -- Heal for 20% of max HP
print("[BATTLE] Player stats before heal: HP=" .. player.hp .. ", MaxHP=" .. player.maxHp)
player.hp = math.min(player.maxHp, player.hp + healAmount)
print("[BATTLE] Player healed for " .. healAmount .. " HP, current HP=" .. player.hp)
  animations.player.current = "stand"
battleState.message = getText(currentGameLanguage, "battle_msg_player_heal", {healAmount = healAmount})
battleState.messageTimer = 2
battleState.phase = "action"
print("[BATTLE STATE] Battle phase changed to 'action'")

  -- Add heal effect
local particleSystem = resources.particleSystems.defend
particleSystem:emit(100) -- Emit some particles
table.insert(battleState.effects, {
  type = "defend",
  x = positions.player.x + 50,
  y = positions.player.y + 50,
  particleSystem = particleSystem,
  timer = 0.5
})
  addTimer(2, function() startEnemyTurn() end)
  print("[TIMER] Added timer for enemy turn")

skillSystem.heal.cooldown = skillSystem.heal.maxCooldown
print("[SKILL SYSTEM] Heal skill cooldown set to " .. skillSystem.heal.cooldown)
end


-- Modify startEnemyTurn function
function startEnemyTurn()
battleState.turn = "enemy"
print("[BATTLE TURN] Enemy turn started")

local enemyData = enemyData[menuState.levelSelect.currentLevel]
local aiType = enemyAI[enemyData.ai]
local action = aiType.decideAction(enemy, player)
print("[ENEMY AI] Enemy AI decision: " .. action)

if action == "attack" then
  print("[BATTLE ACTION] Enemy action: Attack")
  animations.enemy.current = "attack"
  -- --- No need to set enemy image here as drawCharacters handles it based on animation state ---
  -- animations.enemy.image = resources.images[enemyData[menuState.levelSelect.currentLevel].attackImage]
  local damage, isCrit = calculateDamage(enemy, player)
  print("[BATTLE] Enemy stats before attack: HP=" .. enemy.hp .. ", Attack=" .. enemy.attack .. ", Defense=" .. enemy.defense .. ", CritRate=" .. enemy.critRate .. ", CritDamage=" .. enemy.critDamage)
  print("[BATTLE] Player stats before attack: HP=" .. player.hp .. ", Attack=" .. player.attack .. ", Defense=" .. player.defense .. ", CritRate=" .. player.critRate .. ", CritDamage=" .. player.critRate .. ", CritDamage=" .. player.critDamage)
  player.hp = math.max(0, player.hp - damage)
  print("[BATTLE] Enemy dealt " .. damage .. " damage to player. Crit=" .. tostring(isCrit))
  battleState.message = getText(currentGameLanguage, "battle_msg_enemy_attack", {damage = damage})
  if isCrit then
    battleState.message = getText(currentGameLanguage, "battle_msg_enemy_crit", {damage = damage})
    if not audioState.isMutedSFX then
      love.audio.play(resources.sounds.crit)
      print("[AUDIO] Played sound: crit")
    end
  end
  -- Add hit effect
  local particleSystem = resources.particleSystems.hit
  particleSystem:emit(100) -- Emit some particles
  table.insert(battleState.effects, {
    type = "hit",
    x = positions.player.x + 50,
    y = positions.player.y + 50,
    particleSystem = particleSystem,
    timer = 0.5
  })
  -- Add damage number effect
  local damageText = tostring(damage)
  if isCrit then
    damageText = damageText .. "!"
    if not audioState.isMutedSFX then
      love.audio.play(resources.sounds.crit)
      print("[AUDIO] Played sound: crit")
    end
  end
  table.insert(battleState.effects, {
    type = "damage",
    amount = damageText,
    x = positions.player.x + 50,
    y = positions.player.y,
    timer = 1
  })
  -- Add varied attack sounds
  local attackSound = math.random() < 0.5 and resources.sounds.enemyHit1 or resources.sounds.enemyHit2
  if not audioState.isMutedSFX then
    love.audio.play(attackSound)
    print("[AUDIO] Played sound: " .. (attackSound == resources.sounds.enemyHit1 and "enemyHit1" or "enemyHit2"))
  end
else
  print("[BATTLE ACTION] Enemy action: Defend")
  enemy.isDefending = true
  battleState.message = getText(currentGameLanguage, "battle_msg_enemy_defend")
  -- Add defend effect
  local particleSystem = resources.particleSystems.defend
  particleSystem:emit(100) -- Emit some particles
  table.insert(battleState.effects, {
    type = "defend",
    x = positions.enemy.x + 50,
    y = positions.enemy.y + 50,
    particleSystem = particleSystem,
    timer = 0.5
  })
end

battleState.messageTimer = 2

-- Check for defeat
if player.hp <= 0 then
  battleState.phase = "result"
  print("[BATTLE STATE] Battle phase changed to 'result', player defeated")
else
  addTimer(2, function()
    battleState.turn = "player"
    battleState.phase = "select"
    player.isDefending = false
    enemy.isDefending = false
    animations.player.current = "stand"
    animations.enemy.current = "stand"
    print("[BATTLE TURN] Player turn started")
    print("[BATTLE STATE] Battle phase changed to 'select'")
  end)
  print("[TIMER] Added timer for player turn")
end

updateCooldowns()
print("[SKILL SYSTEM] Cooldowns updated")
end
-- Add function to draw pause UI
function drawPauseUI()
  local windowWidth = love.graphics.getWidth()
  local windowHeight = love.graphics.getHeight()

-- Background semi-transparent
love.graphics.setColor(0, 0, 0, 0.8)
love.graphics.rectangle("fill", 0, 0, windowWidth, windowHeight)

-- Title
local fontPauseTitle = resources.fonts.battle
    if currentGameLanguage == "zh" then
        fontPauseTitle = resources.fonts.chineseBattle
    end
love.graphics.setFont(fontPauseTitle)
love.graphics.setColor(1, 1, 1)
local title = getText(currentGameLanguage, "pause_title")
local titleWidth = fontPauseTitle:getWidth(title)
love.graphics.print(title, windowWidth / 2 - titleWidth / 2, windowHeight / 2 - 100)

-- Draw menu options
local fontUIPause = resources.fonts.ui
    if currentGameLanguage == "zh" then
        fontUIPause = resources.fonts.chineseUI
    end
love.graphics.setFont(fontUIPause)
pauseState.buttonAreas = {} -- Store button areas for mouse interaction
for i, option in ipairs(pauseState.options) do
    local buttonY = windowHeight / 2 - 20 + (i-1) * 60
    local buttonRect = {
        x = windowWidth / 2 - 100,
        y = buttonY,
        width = 200,
        height = 40
    }
    pauseState.buttonAreas[i] = buttonRect

    -- Highlight selected option
    if i == pauseState.currentOption then
        love.graphics.setColor(1, 1, 0)
        love.graphics.rectangle("line", buttonRect.x, buttonRect.y, buttonRect.width, buttonRect.height) -- Yellow outline
    else
        love.graphics.setColor(1, 1, 1)
    end

    love.graphics.rectangle("line", buttonRect.x, buttonRect.y, buttonRect.width, buttonRect.height)
    local textWidth = fontUIPause:getWidth(getText(currentGameLanguage, option.textKey))
    love.graphics.print(getText(currentGameLanguage, option.textKey),
        buttonRect.x + buttonRect.width / 2 - textWidth / 2,
        buttonRect.y + buttonRect.height / 2 - 10)
end
end

-- Add function to draw victory UI
function drawVictoryUI()
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()

    -- Draw background first
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(resources.images.background, 0, 0, 0,
        windowWidth/resources.images.background:getWidth(),
        windowHeight/resources.images.background:getHeight())

    -- Background semi-transparent overlay
    love.graphics.setColor(0, 0, 0, 0.8)
    love.graphics.rectangle("fill", 0, 0, windowWidth, windowHeight)

    local fontVictoryTitle = resources.fonts.battle
    if currentGameLanguage == "zh" then
        fontVictoryTitle = resources.fonts.chineseBattle
    end
    love.graphics.setFont(fontVictoryTitle)
    love.graphics.setColor(0, 1, 0)
    local text = getText(currentGameLanguage, "victory_title")
    local textWidth = fontVictoryTitle:getWidth(text)
    love.graphics.print(text, windowWidth / 2 - textWidth / 2, windowHeight / 2 - 50)

    resultState.buttonAreas = {} -- Store button areas
    -- Restart button
    local restartButton = {
        x = windowWidth / 2 - 100,
        y = windowHeight / 2 + 20,
        width = 200,
        height = 40,
        textKey = "result_restart"
    }
    resultState.buttonAreas[1] = restartButton
    if resultState.currentOption == 1 then
        love.graphics.setColor(1, 1, 0) -- Yellow outline if selected
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
    local buttonTextWidth = fontUIVictory:getWidth(getText(currentGameLanguage, restartButton.textKey))
    love.graphics.print(getText(currentGameLanguage, restartButton.textKey), restartButton.x + restartButton.width / 2 - buttonTextWidth / 2 , restartButton.y + restartButton.height / 2 - 10)

    -- Main menu button
    local mainMenuButton = {
        x = windowWidth / 2 - 100,
        y = windowHeight / 2 + 80,
        width = 200,
        height = 40,
        textKey = "result_main_menu"
    }
    resultState.buttonAreas[2] = mainMenuButton
    if resultState.currentOption == 2 then
        love.graphics.setColor(1, 1, 0) -- Yellow outline if selected
        love.graphics.rectangle("line", mainMenuButton.x, mainMenuButton.y, mainMenuButton.width, mainMenuButton.height)
    else
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", mainMenuButton.x, mainMenuButton.y, mainMenuButton.width, mainMenuButton.height)
    end
    love.graphics.setFont(fontUIVictory)
    local mainMenuTextWidth = fontUIVictory:getWidth(getText(currentGameLanguage, mainMenuButton.textKey))
    love.graphics.print(getText(currentGameLanguage, mainMenuButton.textKey), mainMenuButton.x + mainMenuButton.width / 2 - mainMenuTextWidth / 2 , mainMenuButton.y + mainMenuButton.height / 2 - 10)
end

-- Add function to draw defeat UI
function drawDefeatUI()
   local windowWidth = love.graphics.getWidth()
   local windowHeight = love.graphics.getHeight()

   -- 繪製背景
   love.graphics.setColor(1, 1, 1)
   love.graphics.draw(resources.images.background, 0, 0, 0,
       windowWidth/resources.images.background:getWidth(),
       windowHeight/resources.images.background:getHeight())

   -- 半透明黑色遮罩
   love.graphics.setColor(0, 0, 0, 0.8)
   love.graphics.rectangle("fill", 0, 0, windowWidth, windowHeight)

 local fontDefeatTitle = resources.fonts.battle
    if currentGameLanguage == "zh" then
        fontDefeatTitle = resources.fonts.chineseBattle
    end
 love.graphics.setFont(fontDefeatTitle)
 love.graphics.setColor(1, 0, 0)
 local text = getText(currentGameLanguage, "defeat_title")
 local textWidth = fontDefeatTitle:getWidth(text)
 love.graphics.print(text, windowWidth / 2 - textWidth / 2, windowHeight / 2 - 50)

resultState.buttonAreas = {} -- Store button areas
-- Restart button
local restartButton = {
   x = windowWidth / 2 - 100,
   y = windowHeight / 2 + 20,
   width = 200,
   height = 40,
   textKey = "result_restart"
 }
 resultState.buttonAreas[1] = restartButton
 if resultState.currentOption == 1 then
    love.graphics.setColor(1, 1, 0) -- Yellow outline if selected
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
 local buttonTextWidth = fontUIDefeat:getWidth(getText(currentGameLanguage, restartButton.textKey))
 love.graphics.print(getText(currentGameLanguage, restartButton.textKey), restartButton.x + restartButton.width / 2 - buttonTextWidth / 2 , restartButton.y + restartButton.height / 2 - 10)
-- Main menu button
 local mainMenuButton = {
   x = windowWidth / 2 - 100,
   y = windowHeight / 2 + 80,
   width = 200,
   height = 40,
   textKey = "result_main_menu"
 }
 resultState.buttonAreas[2] = mainMenuButton
 if resultState.currentOption == 2 then
    love.graphics.setColor(1, 1, 0) -- Yellow outline if selected
    love.graphics.rectangle("line", mainMenuButton.x, mainMenuButton.y, mainMenuButton.width, mainMenuButton.height)
 else
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", mainMenuButton.x, mainMenuButton.y, mainMenuButton.width, mainMenuButton.height)
 end
 local mainMenuTextWidth = fontUIDefeat:getWidth(getText(currentGameLanguage, mainMenuButton.textKey))
 love.graphics.print(getText(currentGameLanguage, mainMenuButton.textKey), mainMenuButton.x + mainMenuButton.width / 2 - mainMenuTextWidth / 2 , mainMenuButton.y + mainMenuButton.height / 2 - 10)
end
-- Add function to draw skill information UI
function drawSkillInfoUI()
local windowWidth = love.graphics.getWidth()
local windowHeight = love.graphics.getHeight()

-- Background semi-transparent
love.graphics.setColor(0, 0, 0, 0.8)
love.graphics.rectangle("fill", 0, 0, windowWidth, windowHeight)

-- Title
local fontSkillInfoTitle = resources.fonts.battle
    if currentGameLanguage == "zh" then
        fontSkillInfoTitle = resources.fonts.chineseBattle
    end
love.graphics.setFont(fontSkillInfoTitle)
love.graphics.setColor(1, 1, 1)
local title = getText(currentGameLanguage, "skill_info_title")
local titleWidth = fontSkillInfoTitle:getWidth(title)
love.graphics.print(title, windowWidth / 2 - titleWidth / 2, 50)

-- Skill list
local fontUISkillInfo = resources.fonts.ui
    if currentGameLanguage == "zh" then
        fontUISkillInfo = resources.fonts.chineseUI
    end
love.graphics.setFont(fontUISkillInfo)
local listX = 50
local listY = 100
 for i, skill in ipairs(skillInfo) do
     if i == uiState.selectedSkill then
         love.graphics.setColor(1, 1, 0) -- Highlight selected skill
     else
          love.graphics.setColor(1, 1, 1)
     end
     love.graphics.print(getText(currentGameLanguage, "skill_name_" .. skill.key), listX, listY + (i - 1) * 30)
   love.graphics.setColor(0.8, 0.8, 0.8)
   love.graphics.print(getText(currentGameLanguage, "skill_desc_" .. skill.key), listX + 20, listY + 20 + (i - 1) * 30)
end


 -- Detailed information
 local detailsX = windowWidth / 2 + 50
 local detailsY = 100
 local selectedSkill = skillInfo[uiState.selectedSkill]
 love.graphics.setColor(1, 1, 1)
 love.graphics.print(getText(currentGameLanguage, "skill_detail_name") .. ": " .. getText(currentGameLanguage, "skill_name_" .. selectedSkill.key), detailsX, detailsY)
 love.graphics.print(getText(currentGameLanguage, "skill_detail_type") .. ": " .. getText(currentGameLanguage, "skill_type_" .. selectedSkill.type), detailsX, detailsY + 30)
 love.graphics.print(getText(currentGameLanguage, "skill_detail_desc") .. ": ", detailsX, detailsY + 60)

 -- Wrap the details text
 love.graphics.setFont(fontUISkillInfo)
 love.graphics.setColor(0.8, 0.8, 0.8)
 love.graphics.printf(getText(currentGameLanguage, "skill_details_" .. selectedSkill.key), detailsX, detailsY + 80, windowWidth - detailsX - 50, "left")
 love.graphics.setFont(fontSkillInfoTitle)
end

-- Add skill system
skillSystem = {
  attack = { cooldown = 0, maxCooldown = 0 },
  defend = { cooldown = 0, maxCooldown = 2 },
  special = { cooldown = 0, maxCooldown = 3 },
  heal = { cooldown = 0, maxCooldown = 4 }
}

-- Update cooldowns at the end of each turn
function updateCooldowns()
  for _, skill in pairs(skillSystem) do
    if skill.cooldown > 0 then
      skill.cooldown = skill.cooldown - 1
    end
  end
end

-- Add battle scene drawing function
function drawBattleScene()
  -- Draw level-specific background
  local bgImage = resources.images[battleBackgrounds[menuState.levelSelect.currentLevel]]
  love.graphics.draw(bgImage, 0, 0, 0,
    love.graphics.getWidth()/bgImage:getWidth(),
    love.graphics.getHeight()/bgImage:getHeight())
end

-- New function to draw Options UI
function drawOptionsUI()
  local windowWidth = love.graphics.getWidth()
  local windowHeight = love.graphics.getHeight()

  -- Draw background
  love.graphics.draw(resources.images.background, 0, 0, 0,
    windowWidth/resources.images.background:getWidth(),
    windowHeight/resources.images.background:getHeight())

  -- Draw title
  local fontOptionsTitle = resources.fonts.battle
  if currentGameLanguage == "zh" then
    fontOptionsTitle = resources.fonts.chineseBattle
  end
  love.graphics.setFont(fontOptionsTitle)
  love.graphics.setColor(1, 1, 1)
  local title = getText(currentGameLanguage, "options_title")
  local titleWidth = fontOptionsTitle:getWidth(title)
  love.graphics.print(title, windowWidth / 2 - titleWidth / 2, windowHeight * 0.2)

  -- Draw options
  local fontUIOptions = resources.fonts.ui
  if currentGameLanguage == "zh" then
    fontUIOptions = resources.fonts.chineseUI
  end
  love.graphics.setFont(fontUIOptions)
  optionsState.buttonAreas = {} -- Store button areas
  optionsState.languageButtonAreas = {} -- Clear previous language button areas
  optionsState.resolutionButtonAreas = {} -- Clear previous resolution button areas

  for i, option in ipairs(optionsState.options) do -- Use ipairs for correct sequential indexing
    local optionY = windowHeight * 0.4 + (i-1) * 50
    local buttonRect = {
      x = windowWidth / 2 - 150, -- Adjusted X to make space for arrows
      y = optionY,
      width = 300, -- Adjusted width
      height = 40
    }
    optionsState.buttonAreas[i] = buttonRect -- Corrected index here, using 'i'

    if i == optionsState.currentOption then
      love.graphics.setColor(1, 1, 0)
      love.graphics.rectangle("line", buttonRect.x, buttonRect.y, buttonRect.width, buttonRect.height) -- Yellow outline
    else
      love.graphics.setColor(1, 1, 1)
    end
    local optionText = getText(currentGameLanguage, option.textKey)

    if option.type == "language" then
      optionText = optionText .. ": " .. string.upper(currentGameLanguage)
      -- Create left and right arrow buttons for language option
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
        -- Create left and right arrow buttons for resolution option
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

    elseif option.type == "toggle" then
      local targetState = option.targetState or audioState
      optionText = optionText .. ": " .. (targetState[option.state] and getText(currentGameLanguage, "options_on") or getText(currentGameLanguage, "options_off"))
    end

    love.graphics.print(optionText, buttonRect.x, buttonRect.y)
  end

  -- Draw back button box
  local backButtonRect = {
    x = 10,
    y = 10,
    width = 50,
    height = 50
  }
  optionsState.backButtonArea = backButtonRect
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("line", backButtonRect.x, backButtonRect.y, backButtonRect.width, backButtonRect.height)
  love.graphics.print("<", backButtonRect.x + 15, backButtonRect.y + 15) -- Simple "<" as back arrow
end

-- 遊戲常量定義
GAME_CONSTANTS = {
    -- 傷害計算相關
    MIN_DAMAGE = 1,
    MAX_DAMAGE_MULTIPLIER = 3.0,
    DAMAGE_RANDOM_MIN = -0.1,
    DAMAGE_RANDOM_MAX = 0.1,
    DEFENSE_SCALING = 100, -- 防禦力縮放係數
    
    -- 暴擊相關
    BASE_CRIT_RATE = 5,
    MAX_CRIT_RATE = 100,
    BASE_CRIT_DAMAGE = 1.5,
    MAX_CRIT_DAMAGE = 3.0,
    
    -- 技能冷卻時間
    COOLDOWN = {
        ATTACK = 0,
        DEFEND = 2,
        SPECIAL = 3,
        HEAL = 4
    },
    
    -- HP related constants
    HP = {
        BASE = 100,
        MIN = 1,
        MAX = 9999,
        HEAL_PERCENT = 0.2
    },

    -- Timer constants
    TIMER = {
        ACTION_DELAY = 2.0,
        EFFECT_DURATION = 0.5,
        MESSAGE_DURATION = 2.0
    }
}

-- 數值驗證工具函數
function validateNumber(value, min, max, default)
    if type(value) ~= "number" or value ~= value then -- Check for NaN
        return default
    end
    return math.max(min, math.min(max, value))
end

-- 修改傷害計算函數
function calculateDamage(attacker, defender)
    -- 驗證攻擊者和防禦者的屬性
    local attack = validateNumber(attacker.attack, 1, 9999, GAME_CONSTANTS.MIN_DAMAGE)
    local defense = validateNumber(defender.defense, 0, 9999, 0)
    
    -- 基礎傷害計算
    local baseDamage = attack * (GAME_CONSTANTS.DEFENSE_SCALING / (GAME_CONSTANTS.DEFENSE_SCALING + defense))
    
    -- 隨機波動
    local randomMod = 1 + math.random(
        GAME_CONSTANTS.DAMAGE_RANDOM_MIN * 100,
        GAME_CONSTANTS.DAMAGE_RANDOM_MAX * 100
    ) / 100
    
    local damage = baseDamage * randomMod
    
    -- 暴擊判定
    local critRate = validateNumber(attacker.critRate, 0, GAME_CONSTANTS.MAX_CRIT_RATE, GAME_CONSTANTS.BASE_CRIT_RATE)
    local isCrit = math.random(1, 100) <= critRate
    
    if isCrit then
        local critDmg = validateNumber(attacker.critDamage, 1, GAME_CONSTANTS.MAX_CRIT_DAMAGE, GAME_CONSTANTS.BASE_CRIT_DAMAGE)
        damage = damage * critDmg
    end
    
    -- 最終傷害範圍驗證
    damage = validateNumber(
        math.floor(damage),
        GAME_CONSTANTS.MIN_DAMAGE,
        attack * GAME_CONSTANTS.MAX_DAMAGE_MULTIPLIER,
        GAME_CONSTANTS.MIN_DAMAGE
    )
    
    return damage, isCrit
end

-- 修改技能系統
skillSystem = {
    attack = { cooldown = 0, maxCooldown = GAME_CONSTANTS.COOLDOWN.ATTACK },
    defend = { cooldown = 0, maxCooldown = GAME_CONSTANTS.COOLDOWN.DEFEND },
    special = { cooldown = 0, maxCooldown = GAME_CONSTANTS.COOLDOWN.SPECIAL },
    heal = { cooldown = 0, maxCooldown = GAME_CONSTANTS.COOLDOWN.HEAL }
}

-- 修改治療計算函數
function calculateHeal(unit)
    local baseHeal = unit.maxHp * GAME_CONSTANTS.HEAL_PERCENT
    local healAmount = validateNumber(
        math.floor(baseHeal),
        1,
        unit.maxHp - unit.hp,
        1
    )
    return healAmount
end

-- Add state validation functions
local VALID_GAME_STATES = {
    menu = true,
    battle = true,
    story = true,
    pause = true,
    victory = true,
    defeat = true,
    options = true,
    storyPage = true,
    levelSelect = true
}

local VALID_BATTLE_PHASES = {
    select = true,
    action = true,
    result = true
}

local function validateGameState(state)
    if not VALID_GAME_STATES[state] then
        print("[ERROR] Invalid game state: " .. tostring(state))
        return "menu" -- Default fallback
    end
    return state
end

local function validateBattlePhase(phase)
    if not VALID_BATTLE_PHASES[phase] then
        print("[ERROR] Invalid battle phase: " .. tostring(phase))
        return "select" -- Default fallback
    end
    return phase
end

-- Add safe state transition function
local function transitionGameState(from, to)
    if not VALID_GAME_STATES[from] or not VALID_GAME_STATES[to] then
        print("[ERROR] Invalid state transition: " .. tostring(from) .. " -> " .. tostring(to))
        return false
    end

    -- Special handling for battle state transitions
    if to == "battle" then
        -- Reset battle state
        battleState.phase = validateBattlePhase("select")
        battleState.turn = "player"
        battleState.message = getText(currentGameLanguage, "battle_start")
        battleState.messageTimer = GAME_CONSTANTS.TIMER.MESSAGE_DURATION
    elseif from == "battle" then
        -- Clean up battle timers
        TimerSystem.pauseGroup(TIMER_GROUPS.BATTLE)
    end

    gameState = to
    return true
end

-- Modify startEnemyTurn to use state validation
function startEnemyTurn()
    if battleState.phase ~= "action" then
        print("[ERROR] Invalid battle phase for enemy turn: " .. tostring(battleState.phase))
        return
    end

    battleState.turn = "enemy"
    battleState.phase = validateBattlePhase("action")

    local enemyData = enemyData[menuState.levelSelect.currentLevel]
    if not enemyData then
        print("[ERROR] Missing enemy data for level: " .. tostring(menuState.levelSelect.currentLevel))
        return
    end

    -- Continue with enemy turn logic using defensive programming
    local aiType = enemyAI[enemyData.ai] or enemyAI.basic -- Fallback to basic AI if missing
    local action = aiType.decideAction(enemy, player)

    -- Safe timer creation with proper group
    TimerSystem.create(GAME_CONSTANTS.TIMER.ACTION_DELAY, function()
        if gameState == "battle" then -- Check if still in battle
            battleState.phase = validateBattlePhase("select")
            battleState.turn = "player"
        end
    end, TIMER_GROUPS.BATTLE)
end

-- Modify restartGame to use safe state transitions
function restartGame()
    -- Reset player with validated values
    player.hp = validateNumber(player.maxHp, GAME_CONSTANTS.HP.MIN, GAME_CONSTANTS.HP.MAX, GAME_CONSTANTS.HP.BASE)
    player.isDefending = false
    player.combo = 0

    -- Load enemy data safely
    local currentEnemyData = enemyData[menuState.levelSelect.currentLevel]
    if not currentEnemyData then
        print("[ERROR] Failed to load enemy data for level: " .. tostring(menuState.levelSelect.currentLevel))
        return
    end

    -- Initialize enemy with validated values
    enemy = {
        x = positions.enemy.x,
        y = positions.enemy.y,
        hp = validateNumber(currentEnemyData.hp, GAME_CONSTANTS.HP.MIN, GAME_CONSTANTS.HP.MAX, GAME_CONSTANTS.HP.BASE),
        maxHp = validateNumber(currentEnemyData.maxHp, GAME_CONSTANTS.HP.MIN, GAME_CONSTANTS.HP.MAX, GAME_CONSTANTS.HP.BASE),
        attack = validateNumber(currentEnemyData.attack, 1, math.huge, 10),
        defense = validateNumber(currentEnemyData.defense, 0, math.huge, 5),
        isDefending = false,
        status = {},
        combo = 0
    }

    -- Safely transition to battle state
    transitionGameState(gameState, "battle")
    pauseState.isPaused = false

    -- Handle audio transition safely
    if not audioState.isMutedBGM then
        if resources.sounds.menuBgm then resources.sounds.menuBgm:stop() end
        if resources.sounds.battleBgm then
            resources.sounds.battleBgm:setLooping(true)
            resources.sounds.battleBgm:play()
        end
    end
end
end
