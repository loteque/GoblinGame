extends State

@onready var actor_core = %ActorCore
var animated_sprite: AnimatedSprite2D:
    get: return actor_core.animated_sprite

func enter_state(_data: Dictionary = {}):
    super.enter_state()
    animated_sprite.play("idle_front")

func exit_state():
    super.exit_state()
    animated_sprite.stop()
