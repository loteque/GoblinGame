class_name LoteqStateMachine extends Node

@export var states: Array[LState]
@export var ready_state: LState

var current_state: LState

func is_state_current(state: LState):
    return current_state == state

func change_state(state):
    if states.find(state) == -1:
        push_warning(str(state) + " is not a valid State.")
        change_state(ready_state)
        return

    if is_state_current(state):
        return
    
    if current_state:
        current_state.exit()
    
    state.enter()
    current_state = state
    
func _ready():
    change_state(ready_state)
    current_state = ready_state


func _physics_process(_delta):
    current_state.physics_update()


func _process(_delta):
    current_state.update()

func _init(state_array: Array[LState]):
    states = state_array

class LState extends Node:
    signal state_exited
    signal state_entered
    

    func enter():
        state_entered.emit()


    func exit():
        state_exited.emit()


    func update():
        pass


    func physics_update():
        pass


    func _init():
        pass

class LStateCondition:
    pass


class LStatePriorityList extends State:
    pass
