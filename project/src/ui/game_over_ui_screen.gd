extends Control

@export var game_manager: GameManager
@onready var result_label = %ResultLabel

var win_text = "[center][color=red][b][shake]Victory![/shake][/b][/color][/center]"
var lose_text = "[center][color=red][b][shake]Defeat![/shake][/b][/color][/center]"

# Called when the node enters the scene tree for the first time.
func _ready():
    if game_manager:
        game_manager.game_over.connect(_on_game_over)

func _on_game_over(result: GameManager.GameResult):
    show_game_over(result)

func show_game_over(result: GameManager.GameResult):
    visible = true
    if result == game_manager.GameResult.WIN:
        result_label.text = win_text
    else:
        result_label.text = lose_text
