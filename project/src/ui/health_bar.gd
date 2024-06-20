extends Control

@export var health_component : HealthComponent

@onready var progress_bar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
    progress_bar.value = health_component.current_health
    progress_bar.max_value = health_component.max_health
    health_component.health_changed.connect(_on_health_changed)
    if health_component.current_health == health_component.max_health:
        progress_bar.visible = false

func _on_health_changed(new_health: int):
    progress_bar.value = new_health
    if not health_component.current_health == health_component.max_health:
        progress_bar.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
