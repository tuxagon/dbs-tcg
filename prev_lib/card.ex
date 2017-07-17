defmodule Card do
  @derive [Poison.Encoder]
  defstruct [
    :name, 
    :type,
    :combo_power,
    :skills
  ]
end

# "front": true,
#     "power": 10000,
#     "character": "Champa",
#     "special_trait": "God",
#     "era": "Champa Saga",
#     "type": "leader",
#     "number": "BT1-001",
#     "name": "Champa",
#     "image_url": "http:\/\/www.dbs-cardgame.com\/images\/cardlist\/cardimg\/BT1-001.png",
#     "rarity": "R",
#     "series": "Series 1 Booster: ~GALACTIC BATTLE~",
#     "color": "red",
#     "skills": [
#       {
#         "keywords": [
#           "auto",
#           "once-per-turn"
#         ],
#         "text": "[AUTO][ONCE-PER-TURN] When your Battle Card attacks a Leader Card, if the attacking card has 15000 or more power, draw 1 card."
#       },
#       {
#         "keywords": [
#           "awaken"
#         ],
#         "text": "[AWAKEN] When your life is at 4 or less You may draw 2 cards and flip this card over."
#       }
#     ]