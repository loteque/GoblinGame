extends Label

class_name StateDebugger

@export var follow_target: Node2D

var states: Array[State] = []
func _process(_delta):
    global_position = follow_target.global_position
    var states_str_arr = states.map(func(state: State): return state.name)
    text = states_str_arr.reduce(func(a, b): return a + " > " + b, "").substr(3)
