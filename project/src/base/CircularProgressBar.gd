extends Control

@export var spawner: Marker2D
@onready var circular_progress = $CircularProgress
@export var progress: float:
    set = set_progress

func _process(delta):
    set_progress(spawner.current_progress)

func set_progress(value: float):
    progress = clamp(value, 0.0, 1.0)
    circular_progress.material.set("shader_parameter/value", progress)

func _ready():
    set_progress(1)  # Example to set initial progress to 50%
