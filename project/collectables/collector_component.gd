extends Area2D


func _ready():
    pass

func collect(collectable: Collectable):
    collectable.collect()
    pass
