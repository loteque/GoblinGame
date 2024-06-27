extends StaticUnit

class_name Base

var Team = TeamManager.Team

@export var team: TeamManager.Team
@export var base_sprite = Sprite2D
@onready var spawner = %Spawner
@onready var health_component = $HealthComponent
@export var game_manager: GameManager
@export var sfx_manager: SfxManager
@onready var preview = $preview

signal hurt
signal died

func _on_died():
    if team == TeamManager.Team.PLAYER:
        game_manager.game_over.emit(GameManager.GameResult.LOSE)
    else:
        game_manager.game_over.emit(GameManager.GameResult.WIN)
    queue_free()

func receive_attack(attack_obj: Attack):
    health_component.receive_attack(attack_obj)
    hurt.emit()

func _ready():
    sfx_manager.play_rand("build")
    died.connect(_on_died)
    if spawner:
        spawner.team = team
