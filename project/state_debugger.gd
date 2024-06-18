extends Label

class_name StateDebugger

@export var follow_target: Node2D

var states: Array[State] = []
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    global_position = follow_target.global_position

    var states_str_arr = states.map(func(state: State): return state.name)
    text = states_str_arr.reduce(func(a, b): return a + " > " + b, "").substr(3)
