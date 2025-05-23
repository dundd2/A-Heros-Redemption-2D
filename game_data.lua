-- game_data.lua
-- This file contains the game's story, character definitions, level dialogues,
-- and all Chinese/English UI text, along with functions to manage them.

local M = {} -- Module table to export data and functions

M.story = {
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
          menu_about = "About",
          menu_about_desc = "Project introduction and credits",
          menu_save_game = "Save Game", -- NEW
          menu_save_game_desc = "Save current game progress", -- NEW
          menu_load_game = "Load Game", -- NEW
          menu_load_game_desc = "Load previous game progress", -- NEW
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
          options_resolution = "Resolution",
          options_fullscreen = "Fullscreen",
          options_font_size = "Font Size",
          options_bgm = "Background Music",
          options_sfx = "Sound Effects",
          options_cheat = "One-Hit Kill",
          options_infinite_hp = "Infinite HP",
          options_back_to_menu = "Back to Main Menu",
          options_on = "ON",
          options_off = "OFF",
          options_resolution_desc = "Set game screen resolution",
          battle_action_attack = "Attack",
          battle_action_desc_attack = "Deal damage to enemy",
          battle_action_defend = "Defend",
          battle_action_desc_defend = "Reduce incoming damage",
          battle_action_special = "Special",
          battle_action_desc_special = "Powerful attack with delay",
          battle_action_heal = "Heal",
          battle_action_desc_heal = "Restore health",
          battle_msg_skill_cooldown = "Skill on cooldown!",
          battle_msg_not_enough_mp = "Not enough MP!", -- NEW
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
          battle_start = "Battle Start!",
          battle_msg_player_attack = "You attack! Dealt %{damage} damage!",
          battle_msg_player_crit = "Critical hit! Dealt %{damage} damage!",
          battle_msg_player_defend = "You enter defensive stance!",
          battle_msg_player_special = "Player unleashes special attack! %{damage} damage!",
          battle_msg_player_heal = "You restored %{healAmount} health points!",
          battle_msg_enemy_attack = "Enemy attacks! Dealt %{damage} damage!",
          battle_msg_enemy_crit = "Enemy critical hit! Dealt %{damage} damage!",
          battle_msg_enemy_defend = "Enemy enters defensive stance!",
          battle_msg_exp_gain = "Gained %{exp} EXP!", -- NEW
          battle_msg_level_up = "Level Up! LV %{level}!", -- NEW
          player_stats_attack = "ATK", -- NEW
          player_stats_defense = "DEF", -- NEW
          player_stats_crit_rate = "CRT", -- NEW
          player_stats_crit_damage = "CRD", -- NEW
          game_saved_success = "Game saved successfully!", -- NEW
          game_saved_fail = "Failed to save game!", -- NEW
          game_load_no_file = "No save file found.", -- NEW
          game_load_fail = "Failed to load game!", -- NEW
          game_load_corrupt = "Save data corrupted!", -- NEW
          game_loaded_success = "Game loaded successfully!", -- NEW
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
          story_page_title = "A Hero’s Redemption Story:",
          story_page_back_button = "Back to Menu",
          about_page_title = "About This Project:",
          about_project = [[
"A Hero's Redemption 2D" is a classic 2D RPG inspired by old-school turn-based combat games. It tells the story of a hero embarking on a perilous journey to rescue a kidnapped princess and restore peace to the kingdom.

This project was developed as a learning exercise in Lua and the LÖVE 2D framework, focusing on game state management, UI design, combat mechanics, and basic animation.

Thank you for playing!
]],
          about_staff = [[
Credits:
Developer: Dundd2
Game Design: Dundd2
Programming: Dundd2
Art: Public Domain / Open Source Assets (e.g., Pixel Art assets from various sources)
Music & Sound Effects: Public Domain / Open Source Assets

Special Thanks:
- LÖVE 2D Community for the amazing framework and support.
- OpenGameArt.org for various game assets.
- My imaginary friends for playtesting.
]],
          game_full_story = [[
A month ago, the Demon King led his army to invade the human kingdom.
Cities fell, territories were seized, and even the King's beloved daughter, the Princess, was kidnapped.
The Demon King issued a dire ultimatum: either surrender the land or the throne.

Many brave heroes attempted to rescue the Princess, but none returned.
The kingdom fell into despair, its people losing hope.

But then, a lone hero emerged,
driven by a steadfast heart and an unyielding spirit.
He vowed to save the Princess and reclaim the kingdom's peace.

Through perilous forests, treacherous caves, and dark dungeons,
the hero battled countless monsters, growing stronger with each victory.
He faced powerful generals and ancient beasts,
each encounter forging his resolve.

Finally, after a long and arduous journey,
the hero reached the Demon King's castle, a fortress shrouded in dark magic.
He confronted the Demon King himself,
a formidable foe whose power seemed limitless.

In a climactic battle that shook the very foundations of the castle,
the hero fought with all his might.
With a final, decisive blow, he defeated the Demon King,
breaking the dark seal that held the Princess captive.

The Princess was saved, and the Demon King's reign of terror came to an end.
Peace returned to the kingdom,
and the hero was hailed as a true savior.
His name echoed through the lands, forever etched in history
as the one who brought about "A Hero's Redemption."
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
          menu_story_page = "故事頁",
          menu_story_page_desc = "閱讀遊戲故事",
          menu_about = "關於",
          menu_about_desc = "項目介紹與製作人員",
          menu_save_game = "儲存遊戲", -- NEW
          menu_save_game_desc = "儲存目前的遊戲進度", -- NEW
          menu_load_game = "載入遊戲", -- NEW
          menu_load_game_desc = "載入上次的遊戲進度", -- NEW
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
          options_resolution = "解析度",
          options_fullscreen = "全螢幕",
          options_font_size = "字體大小",
          options_bgm = "背景音樂",
          options_sfx = "音效",
          options_cheat = "一擊必殺",
          options_infinite_hp = "無限生命",
          options_back_to_menu = "返回主選單",
          options_on = "開",
          options_off = "關",
          options_resolution_desc = "設定遊戲螢幕解析度",
          battle_action_attack = "攻擊",
          battle_action_desc_attack = "對敵人造成傷害",
          battle_action_defend = "防禦",
          battle_action_desc_defend = "減少受到的傷害",
          battle_action_special = "特殊",
          battle_action_desc_special = "強力的延遲攻擊",
          battle_action_heal = "治療",
          battle_action_desc_heal = "恢復生命值",
          battle_msg_skill_cooldown = "技能冷卻中！",
          battle_msg_not_enough_mp = "魔力不足！", -- NEW
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
          battle_start = "戰鬥開始！",
          battle_msg_player_attack = "你發動攻擊！造成 %{damage} 點傷害！",
          battle_msg_player_crit = "暴擊！造成 %{damage} 點傷害！",
          battle_msg_player_defend = "你進入防禦姿態！",
          battle_msg_player_special = "玩家釋放特殊攻擊！%{damage} 點傷害！",
          battle_msg_player_heal = "你恢復了 %{healAmount} 點生命值！",
          battle_msg_enemy_attack = "敵人攻擊！造成 %{damage} 點傷害！",
          battle_msg_enemy_crit = "敵人暴擊！造成 %{damage} 點傷害！",
          battle_msg_enemy_defend = "敵人進入防禦姿態！",
          battle_msg_exp_gain = "獲得 %{exp} 經驗值！", -- NEW
          battle_msg_level_up = "升級！等級 %{level}！", -- NEW
          player_stats_attack = "攻擊", -- NEW
          player_stats_defense = "防禦", -- NEW
          player_stats_crit_rate = "暴擊率", -- NEW
          player_stats_crit_damage = "暴擊傷害", -- NEW
          game_saved_success = "遊戲儲存成功！", -- NEW
          game_saved_fail = "儲存遊戲失敗！", -- NEW
          game_load_no_file = "找不到存檔檔案。", -- NEW
          game_load_fail = "載入遊戲失敗！", -- NEW
          game_load_corrupt = "存檔資料損壞！", -- NEW
          game_loaded_success = "遊戲載入成功！", -- NEW
          enemy_name_goblin = "哥布林",
          enemy_name_orc = "獸人",
          enemy_name_stonegolem = "石頭巨人",
          enemy_name_skeletonwarrior = "骷髏戰士",
          enemy_name_darkknight = "黑暗騎士",
          enemy_name_banshee = "女妖",
          enemy_name_minotaur = "牛頭怪",
          enemy_name_greendragon = "綠龍",
          enemy_name_reddragon = "紅龍",
          enemy_name_demonking = "惡魔之王",
          story_page_title = "英雄的救贖 2D 故事：",
          story_page_back_button = "返回主選單",
          about_page_title = "關於此專案：",
          about_project = [[
《英雄的救贖 2D》是一款經典的 2D 角色扮演遊戲，靈感來自於老派回合制戰鬥遊戲。它講述了一位英雄踏上危險旅程，營救被綁架的公主並恢復王國和平的故事。

這個專案是作為使用 Lua 和 LÖVE 2D 框架的學習練習而開發的，重點在於遊戲狀態管理、UI 設計、戰鬥機制和基本動畫。

感謝您的遊玩！
]],
          about_staff = [[
製作人員：
開發者：Dundd2
遊戲設計：Dundd2
程式：Dundd2
美術：公共領域 / 開源資源（例如，來自不同來源的像素藝術資源）
音樂與音效：公共領域 / 開源資源

特別鳴謝：
- LÖVE 2D 社群提供出色的框架和支援。
- OpenGameArt.org 提供各種遊戲資源。
- 我的想像朋友提供遊戲測試。
]],
          game_full_story = [[
一個月前，魔王率領他的軍隊入侵了人類王國。
城市淪陷，領土被佔，甚至國王心愛的女兒——公主，也被綁架了。
魔王發出嚴峻的最後通牒：要么割讓土地，要么退位讓賢。

許多勇敢的英雄曾試圖營救公主，但都一去不復返。
王國陷入絕望，人民失去希望。

然而，一位孤獨的英雄出現了，
他懷著堅定的心和不屈的精神。
他誓言要拯救公主，並恢復王國的和平。

穿越危機四伏的森林、險惡的洞穴和黑暗的地牢，
英雄與無數怪物戰鬥，每次勝利都讓他變得更強大。
他面對強大的將軍和古老的野獸，
每一次遭遇都堅定了他的決心。

最終，經過漫長而艱辛的旅程，
英雄抵達了被黑暗魔法籠罩的魔王城堡。
他親自面對魔王，
一個力量似乎無限的強大敵人。

在一場震撼城堡根基的高潮戰鬥中，
英雄全力以赴。
隨著最後一擊，他擊敗了魔王，
打破了囚禁公主的黑暗封印。

公主獲救了，魔王的恐怖統治也畫上了句號。
和平重新降臨王國，
英雄被譽為真正的救世主。
他的名字響徹大地，永遠銘刻在歷史中，
作為帶來「英雄的救贖」的那個人。
]],
      },
  },
  textEffect = {
      currentText = "",
      targetText = "",
      displayIndex = 1,
      charDelay = 0.1,
      timer = 0,
      isComplete = false
  },
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
      },
      narrator = {
          name = "Narrator",
          portrait = nil,
          title = "Storyteller",
          personality = "Objective"
      }
  },
  levelIntros = {
      [1] = {
          background = "assets/palace.png",
          music = "palaceTheme",
          dialogues = {
              {speaker = "King", text_en = "The kingdom faces an unprecedented crisis...", text_zh = "王國正經歷前所未有的危機...", emotion = "worried"},
              {speaker = "King", text_en = "The Demon King has not only seized our border towns but also kidnapped my daughter!", text_zh = "魔王不僅佔領了我們的邊境城鎮，還綁架了我的女兒！", emotion = "angry"},
              {speaker = "Hero", text_en = "Your Majesty, I heard the princess is held in the demon castle.", text_zh = "陛下，我聽說公主被關在魔王城堡裡。", emotion = "determined"},
              {speaker = "King", text_en = "Yes, many heroes went to rescue her, but none returned...", text_zh = "是的，許多英雄都去營救她了，但無人歸來...", emotion = "sad"},
              {speaker = "Hero", text_en = "Let me go rescue the princess! I swear to bring her back safely.", text_zh = "讓我去營救公主吧！我發誓會安全帶她回來。", emotion = "confident"},
              {speaker = "King", text_en = "You seem different from the others... Very well, I trust you can succeed.", text_zh = "你似乎與眾不同... 很好，我相信你能成功。", emotion = "hopeful"},
              {speaker = "King", text_en = "If you save the princess, I'll grant you her hand and half the kingdom.", text_zh = "如果你救回公主，我就將她許配給你，並賜予你半個王國。", emotion = "serious"}
          }
      },
      [2] = {
          background = "assets/forest.png",
          music = "battleBgm",
          dialogues = {
              {speaker = "Narrator", text_en = "The hero enters the Demon King's territory - the Misty Forest...", text_zh = "英雄進入了魔王的地盤——迷霧森林...", emotion = "narrative"},
              {speaker = "enemy_name_goblin", text_en = "Another foolish human!", text_zh = "又一個愚蠢的人類！", emotion = "mocking"},
              {speaker = "Hero", text_en = "You monsters will be cleared today!", text_zh = "你們這些怪物，今天就該被清除！", emotion = "determined"}
          }
      },
      [3] = {
          music = "battleBgm",
          dialogues = {
              {speaker = "enemy_name_orc", text_en = "Want to pass? Get through me first!", text_zh = "想過去？先過我這關！"},
              {speaker = "Hero", text_en = "Fragile bones, rest in peace!", text_zh = "脆弱的骨頭，安息吧！"}
          }
      },
      [4] = {
          music = "battleBgm",
          dialogues = {
              {speaker = "Narrator", text_en = "Deeper into the Demon King's domain, the hero feels a strange energy...", text_zh = "深入魔王領地，英雄感到一股奇異的能量...", emotion = "mysterious"},
              {speaker = "Narrator", text_en = "Suddenly, hero realizes that equipment and power have been greatly weakened!", text_zh = "突然，英雄發現裝備和力量被大大削弱了！", emotion = "mysterious"},
              {speaker = "Hero", text_en = "What happened? My power...!", text_zh = "發生了什麼？我的力量...！", emotion = "worried"},
              {speaker = "enemy_name_stonegolem", text_en = "Hehe, look who we have here?", text_zh = "嘿嘿，看看這是誰來了？"},
              {speaker = "Hero", text_en = "Even without full power, I will not be defeated!", text_zh = "即使沒有全力，我也不會被打敗！", emotion = "determined"}
          }
      },
      [5] = {
          music = "battleBgm",
          dialogues = {
              {speaker = "enemy_name_skeletonwarrior", text_en = "Human, you are too weak!", text_zh = "人類，你太弱了！"},
              {speaker = "Hero", text_en = "Size doesn't determine strength!", text_zh = "大小不代表力量！"}
          }
      },
      [6] = {
          music = "battleBgm",
          dialogues = {
              {speaker = "enemy_name_darkknight", text_en = "You will stay here forever...", text_zh = "你會永遠留在這裡..."},
              {speaker = "Hero", text_en = "Sorry, I have a mission to complete.", text_zh = "抱歉，我還有任務要完成。"}
          }
      },
      [7] = {
          music = "battleBgm",
          dialogues = {
              {speaker = "enemy_name_banshee", text_en = "Serve the Demon King, or die!", text_zh = "為魔王效力，否則就死！"},
              {speaker = "Hero", text_en = "I choose to defeat you!", text_zh = "我選擇擊敗你！"}
          }
      },
      [8] = {
          music = "battleBgm",
          dialogues = {
              {speaker = "enemy_name_minotaur", text_en = "Your journey ends here.", text_zh = "你的旅程到此為止。"},
              {speaker = "Hero", text_en = "I will prove you wrong!", text_zh = "我會證明你錯了！"}
          }
      },
      [9] = {
          music = "battleBgm",
          dialogues = {
              {speaker = "enemy_name_greendragon", text_en = "This is the end for you!", text_zh = "這就是你的結局！"},
              {speaker = "Hero", text_en = "I'll show you who the real weakling is!", text_zh = "我會讓你看看誰才是真正的弱者！"}
          }
      },
      [10] = {
          background = "assets/demonCastle.png",
          music = "finalBattle",
          dialogues = {
              {speaker = "Demon King", text_en = "Hahaha! Finally, the so-called hero arrives!", text_zh = "哈哈哈！所謂的英雄終於來了！", emotion = "mocking"},
              {speaker = "Hero", text_en = "Demon King! Release the princess now!", text_zh = "魔王！立刻釋放公主！", emotion = "angry"},
              {speaker = "Demon King", text_en = "You? Defeat me first!", text_zh = "你？先打敗我再說！", emotion = "threatening"},
              {speaker = "Princess", text_en = "Be careful, Hero! His power has grown stronger!", text_zh = "英雄，小心！他的力量變得更強了！", emotion = "worried"},
              {speaker = "Hero", text_en = "Don't worry, I will save you!", text_zh = "別擔心，我會救你的！", emotion = "determined"},
              {speaker = "Demon King", text_en = "Enough talk, come!", text_zh = "廢話少說，來吧！", emotion = "battle_ready"}
          }
      }
  },
  ending = {
      good = {
          background = "palace",
          music = "victory",
          dialogues = {
              {speaker = "King", text_en = "Hero! You actually did it!", text_zh = "英雄！你真的辦到了！", emotion = "overjoyed"},
              {speaker = "Princess", text_en = "Thank you for saving me and the kingdom...", text_zh = "謝謝你拯救了我，也拯救了王國...", emotion = "grateful"},
              {speaker = "Hero", text_en = "It was my duty, to protect peace.", text_zh = "這是我的職責，為了守護和平。", emotion = "humble"},
              {speaker = "King", text_en = "As promised, the princess's hand and half the kingdom are yours.", text_zh = "如我所承諾，公主的手和半個王國都是你的了。", emotion = "pleased"},
              {speaker = "Princess", text_en = "Hero, will you... accept?", text_zh = "英雄，你願意... 接受嗎？", emotion = "shy"},
              {speaker = "Hero", text_en = "It would be my honor to serve the kingdom.", text_zh = "我很榮幸能為王國服務。", emotion = "honored"},
              {speaker = "Narrator", text_en = "And so, peace returned to the kingdom, and the hero and princess lived happily ever after.", text_zh = "於是，和平重回王國，英雄與公主從此過著幸福快樂的日子。", emotion = "narrative"}
          }
      },
      neutral = {
          background = "palace",
          music = "menuBgm",
          dialogues = {
              {speaker = "King", text_en = "You completed the mission, this is your reward.", text_zh = "你完成了任務，這是你的獎勵。", emotion = "neutral"},
              {speaker = "Hero", text_en = "Thank you, I must continue my journey.", text_zh = "謝謝，我必須繼續我的旅程。", emotion = "neutral"},
              {speaker = "Narrator", text_en = "The hero continued his journey, seeking new adventures...", text_zh = "英雄繼續他的旅程，尋求新的冒險...", emotion = "narrative"}
          }
      },
      tragic = {
          background = "ruins",
          music = "defeat",
          dialogues = {
              {speaker = "Hero", text_en = "We won... but the cost was too great...", text_zh = "我們贏了... 但代價太大了...", emotion = "devastated"},
              {speaker = "Narrator", text_en = "The kingdom was saved, but at a great loss...", text_zh = "王國獲救了，但卻付出了巨大的代價...", emotion = "narrative"}
          }
      }
  },
  currentState = {
      isPlaying = false,
      currentLevel = 1,
      dialogueIndex = 1,
      isEnding = false
  },
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
      furious = {color = {1, 0.2, 0.2}, scale = 1.4},
      narrative = {color = {0.9, 0.9, 0.9}, scale = 1},
      normal = {color = {1, 1, 1}, scale = 1},
  },
  relationships = {
      princess = 0,
      king = 0,
      villagers = 0,
      getAffinityLevel = function(value)
          if value >= 80 then return "Loved"
          elseif value >= 50 then return "Trusted"
          elseif value >= 20 then return "Friendly"
          elseif value >= -20 then return "Neutral"
          elseif value >= -50 then return "Disliked"
          else return "Hostile" end
      end
  },
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
  choices = {
      current = nil,
      makeChoice = function(self, options, callback)
          self.current = {options = options, callback = callback}
      end
  }
}

-- Internal language state for the module
local currentLanguage = "en"

function M.initText()
  currentLanguage = "en"
end

local function validateLanguage(lang)
  if M.story.text[lang] then
    return lang
  else
    print("[WARNING] Language '" .. tostring(lang) .. "' not found, fallback to default.")
    return "en"
  end
end

function M.getText(language, key, params, defaultValue)
  language = validateLanguage(language or currentLanguage)
  local langTable = M.story.text[language]
  if not langTable then
      print("[WARNING] Language table '" .. language .. "' not found.")
      return defaultValue or "**MISSING LANGUAGE**"
  end
  local textString = langTable[key]
  if not textString then
    print("[WARNING] Missing text key '" .. key .. "' for language '" .. language .. "'.")
    return defaultValue or "**MISSING TEXT**"
  end
  if params then
    for k, v in pairs(params) do
      textString = string.gsub(textString, "%%{" .. k .. "}", tostring(v))
    end
  end
  return textString
end

function M.setCurrentLanguage(language)
  currentLanguage = language
end

function M.getCurrentLanguage()
  return currentLanguage
end

function M.updateTextEffect(dt)
  local effect = M.story.textEffect
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

function M.setTargetText(text)
  M.story.textEffect.targetText = text
  M.story.textEffect.currentText = ""
  M.story.textEffect.displayIndex = 0
  M.story.textEffect.timer = 0
  M.story.textEffect.isComplete = false
end

function M.getCurrentText()
  return M.story.textEffect.currentText
end

function M.isTextComplete()
  return M.story.textEffect.isComplete
end

function M.startLevelDialogue(level)
  M.story.currentState.isPlaying = true
  M.story.currentState.currentLevel = level
  M.story.currentState.dialogueIndex = 1
  M.story.currentState.isEnding = false
  local currentLevel = M.story.levelIntros[level]
  if currentLevel and currentLevel.dialogues and currentLevel.dialogues[1] then
      local firstDialogue = currentLevel.dialogues[1]
      -- Get localized text based on current language, fallback to English
      local dialogueText = firstDialogue["text_" .. M.getCurrentLanguage()] or firstDialogue.text_en
      M.setTargetText(dialogueText)
  end
end

function M.startEndingDialogue()
  M.story.currentState.isPlaying = true
  M.story.currentState.dialogueIndex = 1
  M.story.currentState.isEnding = true
end

-- Pass resources and current game language as parameters to handle external dependencies
function M.getCurrentDialogue(resourcesRef, currentGameLanguageRef)
  if not M.story.currentState.isPlaying then
      return {
          speaker = "System",
          text = "No active dialogue", -- This is a fallback, should not be displayed in-game
          emotion = "normal"
      }
  end
  local dialogues
  if M.story.currentState.isEnding then
      local endingType = M.determineEnding()
      dialogues = M.story.ending[endingType].dialogues
  else
      local currentLevel = M.story.levelIntros[M.story.currentState.currentLevel]
      if not currentLevel or not currentLevel.dialogues then
          return {
              speaker = "System",
              text = "Level dialogue not found", -- Fallback
              emotion = "normal"
          }
      end
      dialogues = currentLevel.dialogues
      -- The dialogue index is already checked in nextDialogue, but good to have a final check here too
      if M.story.currentState.dialogueIndex > #dialogues then
          M.story.currentState.isPlaying = false
          return {
              speaker = "System",
              text = "Dialogue ended", -- Fallback
              emotion = "normal"
          }
      end
  end
  local currentDialogue = dialogues[M.story.currentState.dialogueIndex]
  if not currentDialogue then
      return {
          speaker = "System",
          text = "Dialogue not found", -- Fallback
          emotion = "normal"
      }
  end
  local speakerName = currentDialogue.speaker
  local enemyDisplayNameKey = nil
  if string.sub(speakerName, 1, 11) == "enemy_name_" then
      enemyDisplayNameKey = speakerName
      speakerName = M.getText(currentGameLanguageRef, speakerName)
  end
  if speakerName == "Narrator" then
      speakerName = M.getText(currentGameLanguageRef, "Narrator", nil, "Narrator")
  end
  local portraitKey = M.story.characters[currentDialogue.speaker:lower()] and M.story.characters[currentDialogue.speaker:lower()].portrait or nil
  if portraitKey then
      -- Check if resourcesRef is provided and has the image
      if resourcesRef and resourcesRef.images and not resourcesRef.images[portraitKey] then
          print("[WARNING] Missing portrait image for speaker: " .. currentDialogue.speaker .. " (key: " .. portraitKey .. ")")
          portraitKey = nil
      end
  end
  -- This function is meant to return the current dialogue data.
  -- The actual text to be *displayed_ (for the typing effect) is set by setTargetText
  -- which is called in startLevelDialogue and nextDialogue.
  -- So, currentDialogue.text is just for internal reference here.
  -- It effectively now contains the text that was just set to `M.story.textEffect.targetText`.
  return {
      speaker = speakerName,
      text = M.story.textEffect.targetText, -- This now refers to the currently set text
      emotion = currentDialogue.emotion or "normal",
      character = M.story.characters[currentDialogue.speaker:lower()] or nil,
      portraitKey = portraitKey,
      enemyDisplayNameKey = enemyDisplayNameKey,
      choices = currentDialogue.choices
  }
end

function M.nextDialogue()
  local currentDialogues
  if M.story.currentState.isEnding then
      local endingType = M.determineEnding()
      currentDialogues = M.story.ending[endingType].dialogues
  else
      currentDialogues = M.story.levelIntros[M.story.currentState.currentLevel].dialogues
  end
  if M.story.currentState.dialogueIndex < #currentDialogues then
      M.story.currentState.dialogueIndex = M.story.currentState.dialogueIndex + 1
      local nextDialogueData = currentDialogues[M.story.currentState.dialogueIndex]
      if nextDialogueData then
          -- Get localized text for the next dialogue
          local dialogueText = nextDialogueData["text_" .. M.getCurrentLanguage()] or nextDialogueData.text_en
          M.setTargetText(dialogueText)
      end
  else
      M.story.currentState.isPlaying = false
  end
end

function M.skipDialogue()
  M.story.currentState.isPlaying = false
end

function M.getEmotionEffect(emotion)
  return M.story.emotions[emotion] or {color = {1, 1, 1}, scale = 1}
end

function M.changeRelationship(character, amount)
  if M.story.relationships[character] then
      M.story.relationships.character = math.max(-100, math.min(100, M.story.relationships[character] + amount))
  end
end

function M.determineEnding()
  local total = M.story.relationships.princess + M.story.relationships.king + M.story.relationships.villagers
  if total >= 150 then return "good"
  elseif total >= 0 then return "neutral"
  else return "tragic" end
end

return M