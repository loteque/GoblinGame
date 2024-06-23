extends Node

## Can collect stuff (mostly scrap)
class_name CollectorComponent

@onready var target_tracker_component: TargetTrackerComponent = %TargetTrackerComponent


var current_scrap: int = 0
var max_scrap: int = 1
var closest_base: Node2D
var current_scrap_node: Scrap
@onready var parent: Actor = get_parent()

var next_target_position: Vector2

func collect(scrap: Scrap):
    if current_scrap < max_scrap:
        current_scrap += 1

func _process(delta):
    if not closest_base:
        closest_base = get_closest_allied_base()

func should_return_to_base():
    var can_return_to_base = closest_base != null
    return !has_remaining_capacity() and can_return_to_base

func deliver_scrap():
    var delivery_amount =  current_scrap
    current_scrap = 0
    return delivery_amount

func _ready():
    if is_near_scrap():
        current_scrap_node = get_closest_scrap()
    closest_base = get_closest_allied_base()

func is_carrying_scrap():
    return current_scrap > 0

func has_remaining_capacity():
    return current_scrap < max_scrap

func get_closest_scrap():
    return target_tracker_component.get_closest_in_group("Scrap")

func is_near_scrap():
    return target_tracker_component.is_tracking_group("Scrap")

func set_collect_target(target: Scrap):
    current_scrap_node = target

func _sort_by_distance(a: Node2D, b: Node2D) -> bool:
    var distance_a = self.global_position.distance_to(a.global_position)
    var distance_b = self.global_position.distance_to(b.global_position)
    return distance_a < distance_b

func get_closest_allied_base():
    var bases: Array[Node] = get_tree().get_nodes_in_group("Base") as Array[Node]
    var allied_bases = bases.filter(func(base): return base.team == parent.team)
    if allied_bases.size() < 1:
        return null
    allied_bases.sort_custom(_sort_by_distance)
    var closest_allied_base = allied_bases[0]
    return closest_allied_base

func get_current_scrap_node_position():
    if current_scrap_node == null:
        return null
    return current_scrap_node.global_position

func return_to_base():
    closest_base = get_closest_allied_base()

func should_collect():
    var is_carrying_scrap = is_carrying_scrap()
    var can_return_to_base = closest_base != null
    var target_node_has_scrap = current_scrap_node and current_scrap_node != null
    var is_near_node = target_tracker_component.includes("Scrap")
    if not current_scrap_node and is_near_node:
        current_scrap_node = get_closest_scrap()
    return (is_carrying_scrap and can_return_to_base) or (is_near_node and has_remaining_capacity()) or (target_node_has_scrap and has_remaining_capacity())

func get_next_target():
    var target: Node2D
    if is_carrying_scrap():
        var base = get_closest_allied_base()
        if base:
            return base
    if current_scrap_node:
        return current_scrap_node
    if is_near_scrap():
        var scrap = get_closest_scrap()
        current_scrap_node = scrap
        return scrap
    return null
