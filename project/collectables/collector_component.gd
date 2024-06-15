extends Area2D
class_name CollectorComponent

func _ready():
	pass

func collect(collectable: Collectable):
	collectable.collect()
	pass
