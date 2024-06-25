extends AnimatedSprite2D

@export var float_speed: float = 100 
@onready var animation_player = $AnimationPlayer

func _ready():
    get_parent().died.connect(_on_died)
    visible = false
    modulate.a = 0
    process_mode = Node.PROCESS_MODE_DISABLED

func _on_died():
    float_away()

func float_away():
    animation_player.play("fade in")
    visible = true
    process_mode = Node.PROCESS_MODE_ALWAYS
    await animation_player.animation_finished
    animation_player.play("fade_out")
    await animation_player.animation_finished
    queue_free()

func _process(delta):
    global_position = global_position + delta * Vector2(0, -1) * float_speed
