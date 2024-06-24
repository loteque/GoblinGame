extends Node

class_name GameManager

enum GameResult {
    WIN,
    LOSE
}

signal game_over(result: GameResult)

func _ready():
    game_over.connect(_on_game_over)

func _on_game_over(result: GameResult):
    var players = get_tree().get_nodes_in_group("Player")
    var player = players[0]
    #player.process_mode = PROCESS_MODE_DISABLED
