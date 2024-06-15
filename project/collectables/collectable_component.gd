extends Area2D
class_name Collectable

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
