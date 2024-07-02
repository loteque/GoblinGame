extends StaticBody2D
class_name Scrap

@export var max_amount: int = 50
@export var current_amount: int = 50
@onready var collection_timer: Timer = $CollectionTimer
var on_cooldown = false

func _ready():
    collection_timer.timeout.connect(_on_collection_timer_timeout)

func _on_collectable_collected(collector: Node2D):
    if collector.has_method("collect"):
        collector.collect(self)

func _on_collection_timer_timeout():
    on_cooldown = false

func collect():
    queue_free()

func despawn():
    queue_free()

func get_collected():
    collection_timer.start()
    on_cooldown = true
    if current_amount > 0:
        current_amount -= 1
    if current_amount <= 0:
        despawn()

func is_on_cooldown():
    return on_cooldown
