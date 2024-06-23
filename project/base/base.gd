extends StaticUnit

class_name Base

const ENEMY_BASE_TEXTURE = preload ("res://base/enemy-base-temp.png")
const PLAYER_BASE_TEXTURE = preload ("res://base/base-temp.png")

var Team = TeamManager.Team

@export var team: TeamManager.Team
@export var base_sprite = Sprite2D
@onready var spawner = %Spawner
@onready var health_component = $HealthComponent
@export var game_manager: GameManager
@export var sfx_manager: SfxManager

signal hurt
signal died

func _on_died():
    if team == TeamManager.Team.PLAYER:
        game_manager.game_over.emit(GameManager.GameResult.LOSE)
    else:
        game_manager.game_over.emit(GameManager.GameResult.WIN)
    visible = false

func receive_attack(attack_obj: Attack):
    health_component.receive_attack(attack_obj)
    hurt.emit()

func display_base_sprite():
    if base_sprite:
        if team == Team.PLAYER:
            base_sprite.texture = PLAYER_BASE_TEXTURE
        else:
            base_sprite.texture = ENEMY_BASE_TEXTURE

func _ready():
    sfx_manager.play_rand("build")
    died.connect(_on_died)
    display_base_sprite()
    if spawner:
        spawner.team = team
