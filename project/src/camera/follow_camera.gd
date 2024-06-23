extends Camera2D

@export var follow_target: Node2D 

var last_position: Vector2

func _process(_delta):
    if follow_target:
        last_position = follow_target.global_position
        global_position = follow_target.global_position
    else:
        global_position = last_position
