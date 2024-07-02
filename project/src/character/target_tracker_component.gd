extends Area2D

class_name TargetTrackerComponent

@export var actor: Node2D

var tracked_nodes: Array[Node2D] = []

func _ready():
    area_entered.connect(_on_area_entered)
    area_exited.connect(_on_area_exited)
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)

func _on_area_entered(area: Area2D):
    if area.is_in_group("Scrap"):
        tracked_nodes.append(area)

func _on_area_exited(area: Area2D):
    if area.is_in_group("Scrap"):
        tracked_nodes.erase(area)

func _on_body_entered(body: Node2D):
    if body.is_in_group("Actor"):
        tracked_nodes.append(body)
    if body.is_in_group("Scrap"):
        tracked_nodes.append(body)
    if body.is_in_group("Base"):
        tracked_nodes.append(body)

func _on_body_exited(body: Node2D):
    if body.is_in_group("Actor"):
        tracked_nodes.erase(body)
    if body.is_in_group("Scrap"):
        tracked_nodes.erase(body)
    if body.is_in_group("Base"):
        tracked_nodes.erase(body)

func is_not_same_team(npc: Actor):
    var diff_team = npc.team != actor.team
    return diff_team

func get_enemies_of(team: TeamManager.Team):
    var npcs = get_tracked_in_group("Actor")
    var bases = get_tracked_in_group("Base")
    npcs.append_array(bases)
    var enemies: Array[Node2D] = []
    for npc in npcs:
        #print (npc.team == team)
        if npc.team != team:
            enemies.append(npc)
    #var enemies = npcs.filter(is_not_same_team)
    return enemies

func get_closest_enemy_of(team: TeamManager.Team):
    var enemies = get_enemies_of(team)
    var closest = sort_nodes_by_distance(enemies)[0]
    return closest

func has_enemies_of(team: TeamManager.Team):
    return len(get_enemies_of(team)) > 0

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
