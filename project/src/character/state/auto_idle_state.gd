extends State

class_name AutoIdleState

@export var idle_time_min: float = 0.5
@export var idle_time_max: float = 3.0

@onready var actor_core = %ActorCore
var animated_sprite: AnimatedSprite2D:
    get: return actor_core.animated_sprite

@onready var end_signal: Signal = get_parent().state_complete 
@onready var timer = Timer.new()

func _ready():
    timer.one_shot = true
    end_signal.emit()
    timer.timeout.connect(_on_idle_timeout)
    add_child(timer)

func _on_idle_timeout():
    end_signal.emit()

func get_random_delay():
    return randf_range(idle_time_min, idle_time_max)

func enter_state(_data: Dictionary = {}):
    super.enter_state()
    animated_sprite.play("idle_front")
    var delay = get_random_delay()
    timer.start(delay)

func exit_state():
    super.exit_state()
    animated_sprite.stop()
