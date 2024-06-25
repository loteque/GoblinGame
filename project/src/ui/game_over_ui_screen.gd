extends Control

@export var game_manager: GameManager
@export var restart_button: Button
@onready var result_label = %ResultLabel

var win_text = "[center][color=red][b][shake]Victory![/shake][/b][/color][/center]"
var lose_text = "[center][color=red][b][shake]Defeat![/shake][/b][/color][/center]"

# Called when the node enters the scene tree for the first time.
func _ready():
    process_mode = Node.PROCESS_MODE_WHEN_PAUSED
    if game_manager:
        game_manager.game_over.connect(_on_game_over)

func _on_game_over(result: GameManager.GameResult):
    get_tree().paused = true
    show_game_over(result)

func show_game_over(result: GameManager.GameResult):
    visible = true
    restart_button.grab_focus()
    if result == game_manager.GameResult.WIN:
        result_label.text = win_text
    else:
        result_label.text = lose_text
