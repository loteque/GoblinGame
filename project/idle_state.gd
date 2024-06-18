extends State

@onready var actor_core = %ActorCore
var animated_sprite: AnimatedSprite2D:
    get: return actor_core.animated_sprite
# Called when the node enters the scene tree for the first time.

func _ready():
    pass # Replace with function body.


func enter_state(data: Dictionary = {}):
    super.enter_state()
    animated_sprite.play("idle_front")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta):
    pass

func exit_state():
    super.exit_state()
    animated_sprite.stop()
    pass
