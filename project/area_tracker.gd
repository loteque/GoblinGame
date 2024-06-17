extends Area2D


var tracked_nodes: Array[Node2D] = []

# Called when the node enters the scene tree for the first time.
func _ready():
    area_entered.connect(_on_area_entered)
    area_exited.connect(_on_area_exited)

func _on_area_entered(area: Area2D):
    if area.is_in_group("Scrap"):
        tracked_nodes.append(area)

func _on_area_exited(area: Area2D):
    if area.is_in_group("Scrap"):
        tracked_nodes.erase(area)

func _process(_delta):
    print(tracked_nodes)
