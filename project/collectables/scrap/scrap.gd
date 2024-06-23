extends StaticBody2D
class_name Scrap

@export var max_amount: int = 50
@export var current_amount: int = 50
@onready var collection_timer: Timer = $CollectionTimer

func _on_collectable_collected(collector: Node2D):
    if collector.has_method("collect"):
        collector.collect(self)

func collect():
    queue_free()
    pass

func despawn():
    queue_free()

func get_collected():
    collection_timer.start()
    if current_amount > 0:
        current_amount -= 1
    if current_amount <= 0:
        despawn()

func is_on_cooldown():
    return collection_timer.time_left != 0
