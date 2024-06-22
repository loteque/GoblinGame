extends Marker2D

class_name UnitSpawner

@export var spawn_source: PackedScene
@export var spawn_time: float = 20.0
@onready var spawn_timer = Timer.new()


var map: Node2D
var current_progress: float:
    get: return 1 - spawn_timer.time_left / spawn_time


func _ready():
    add_child(spawn_timer)
    spawn_timer.start(spawn_time)
    get_map()
    spawn_timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
    spawn_unit()

func get_map():
    var node_list = get_tree().get_nodes_in_group("Map")
    if node_list.size() > 0:
        map = node_list[0]
    return map

func spawn_unit():
    if map:
        var unit = spawn_source.instantiate()
        map.add_child(unit)
        unit.global_position = global_position
