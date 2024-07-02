extends State

## Createure is "in_combat"
class_name HurtState

@onready var actor_core = %ActorCore
var animated_sprite: AnimatedSprite2D:
    get: return actor_core.animated_sprite

@onready var hurt_timer = $HurtTimer

func _on_hurt_timeout():
    actor_core.is_hurt = false

func _ready():
    hurt_timer.timeout.connect(_on_hurt_timeout)

func enter_state(_data: Dictionary = {}):
    super.enter_state()
    actor_core.actor.sfx_manager.play_rand("hit")
    animated_sprite.play("hurt")
    hurt_timer.start()

func exit_state():
    super.exit_state()
