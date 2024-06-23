extends Marker2D

class_name UnitSpawner

@export var spawn_source: PackedScene
@export var spawn_time: float = 20.0
var team: TeamManager.Team
@export var scrap_cost: int = 5
@onready var spawn_timer = Timer.new()

var map: Node2D
var current_progress: float:
    get: return 1 - spawn_timer.time_left / spawn_time

func has_enough_scrap():
    var scrap_amount = ResourceManager.get_scrap_count_by_team(team)
    return scrap_amount >= scrap_cost

func _ready():
    spawn_timer.one_shot = true
    ResourceManager.scrap_updated.connect(_on_scrap_updated)
    add_child(spawn_timer)
    if has_enough_scrap() and spawn_timer.is_stopped():
        spawn_timer.start(spawn_time)
    get_map()
    spawn_timer.timeout.connect(_on_timer_timeout)

func _on_scrap_updated(collecting_team: TeamManager.Team, value: int):
    if collecting_team == team:
        if has_enough_scrap() and spawn_timer.is_stopped():
            spawn_timer.start(spawn_time)
            ResourceManager.change_scrap(team, -scrap_cost)

func _on_timer_timeout():
    spawn_unit()
    if has_enough_scrap() and spawn_timer.is_stopped():
        spawn_timer.start(spawn_time)
        ResourceManager.change_scrap(team, -scrap_cost)

func get_map():
    var node_list = get_tree().get_nodes_in_group("Map")
    if node_list.size() > 0:
        map = node_list[0]
    return map

func spawn_unit():
    if map:
        var unit = spawn_source.instantiate()
        unit.team = team
        map.add_child(unit)
        unit.global_position = global_position
