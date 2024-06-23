class_name BasePlacer

var num_bases
var game_manager: GameManager
#var base = preload("res://static_unit.tscn").instantiate()
var base = preload("res://base/base.tscn").instantiate()

func place(attachment_node: Node2D, position: Vector2):
    if num_bases >= 1:
        attachment_node.add_child(base)
        base.global_transform.origin = position
        base.game_manager = game_manager
        num_bases = num_bases - 1

func _init(max_bases: int):
    num_bases = max_bases
