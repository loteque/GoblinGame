class_name LoteqStateMachine extends Node


var states: Dictionary
var ready_state: LState


var current_state_name: StringName


func get_state(state_name: StringName):
    return states.get(state_name)


func get_current_state():
    return get_state(current_state_name)


func is_state_current(state_name: StringName):
    return current_state_name == state_name


func is_valid_state(state_name):
    if !get_state(state_name):
        push_warning(str(state_name) + " is not a valid State.")
        return false
    return true


func change_state(state: LState):
    var state_name = states.find_key(state)
    
    if !is_valid_state(state_name):
        change_state(ready_state)
        return

    if is_state_current(state_name):
        return
    
    var current_state = get_current_state()
    if current_state:
        current_state.exit()
    
    state.enter()
    current_state_name = state_name


func _ready():
    change_state(ready_state)
    current_state_name = states.find_key(ready_state)


func _physics_process(_delta):
    get_current_state().physics_update()


func _process(_delta):
    get_current_state().update()


var null_state = LState.new()
func _init(state_dict: Dictionary = {&"null_state": null_state}, ready_state: LState = null_state):
    ready_state = null_state
    states = state_dict


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
