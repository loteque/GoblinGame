extends Area2D
class_name Scrap

var max_amount: int = 10
var current_amount: int = 10
@onready var collection_timer: Timer = $CollectionTimer

enum CollectableType {
    SCRAP
}

func _ready():
    area_entered.connect(_on_collectable_collected)
    pass
    

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
