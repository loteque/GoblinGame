extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
    start_dialog()
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func start_dialog():
    Dialogic.timeline_ended.connect(_on_timeline_ended)
    Dialogic.start("01-intro")

func _on_timeline_ended():
    Dialogic.timeline_ended.disconnect(_on_timeline_ended)
    # do something else here
