extends Area2D

class_name TargetTrackerComponent

var tracked_nodes: Array[Node2D] = []

func _ready():
    area_entered.connect(_on_area_entered)
    area_exited.connect(_on_area_exited)
    var areas = get_overlapping_areas()
    areas

func _on_area_entered(area: Area2D):
    if area.is_in_group("Scrap"):
        tracked_nodes.append(area)

func _on_area_exited(area: Area2D):
    if area.is_in_group("Scrap"):
        tracked_nodes.erase(area)

func _process(_delta):
    print(tracked_nodes)
    #var areas = get_overlapping_areas()
    #if len(areas) > len(tracked_nodes):
        #tracked_nodes = areas.duplicate()
    
func get_tracked_in_group(group_name: String):
    return tracked_nodes.filter(func (node: Node2D): return node.is_in_group(group_name))

func is_tracking_group(group_name: String):
    var tracked_in_group = get_tracked_in_group(group_name)
    if len(tracked_in_group) > 0:
        return true
    return false

func includes(group_name: String):
    return is_tracking_group(group_name)

func _sort_by_distance(a: Node2D, b: Node2D) -> bool:
    var distance_a = self.global_position.distance_to(a.global_position)
    var distance_b = self.global_position.distance_to(b.global_position)
    return distance_a < distance_b

func sort_nodes_by_distance(nodes: Array[Node2D]):
    var sorted_arr = nodes.duplicate()
    sorted_arr.sort_custom(_sort_by_distance)
    return sorted_arr

func get_closest_in_group(group_name: String):
    var tracked_in_group = get_tracked_in_group(group_name)
    if len(tracked_in_group) < 1:
        return null
    var sorted = sort_nodes_by_distance(tracked_in_group)
    return sorted[0]
