class_name BasePlacer

var num_bases
var game_manager: GameManager
#var base = preload("res://static_unit.tscn").instantiate()
var base = preload("res://base/base.tscn").instantiate()
var preview_node: Node2D
var can_be_placed: bool = false:
    get: return preview_node != null and preview_node.can_be_placed

func is_previewing():
    return preview_node != null

func place(attachment_node: Node2D, position: Vector2):
    if !preview_node.can_be_placed:
        return
    if num_bases >= 1 and preview_node != null:
        cancel_preview()
        attachment_node.add_child(base)
        base.global_transform.origin = position
        base.game_manager = game_manager
        num_bases = num_bases - 1

func preview(attach_node: Node2D):
    var preview_source = base.get_node("%preview")
    if preview_source == null:
        return
    preview_node = preview_source.duplicate()
    preview_source.queue_free()
    attach_node.add_child(preview_node)
    preview_node.visible = true
    preview_node.global_position = attach_node.global_position
    
func cancel_preview():
    preview_node.visible = false
    preview_node.queue_free()

func _init(max_bases: int):
    num_bases = max_bases
