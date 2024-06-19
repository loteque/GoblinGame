extends Node
class_name StateMachine

@onready var combat: State = $Combat
@onready var neutral: State = $Neutral
@onready var collect: State = $Collect
@onready var follow: State = $Follow

@export var starting_state: State

var actor
var animation_player
var player_input
var state: State
var prev_data: Dictionary = {}

func change_state(new_state: State, data: Dictionary = {}, force: bool = false):
    if state != null and new_state != null and force == true:
        state.exit_state()
        state = new_state
        state.enter_state(data)
    elif new_state == null and not state == null:
        state.exit_state()
        state = new_state
    elif state and state != new_state:
        state.exit_state()
        state = new_state
        state.enter_state(data)
    elif not state and new_state:
        state = new_state
        state.enter_state(data)
    #elif JSON.stringify(data) != JSON.stringify(prev_data) and new_state == state:
    elif data != prev_data and new_state == state and not new_state == null:
        state.exit_state()
        state = new_state
        state.enter_state(data)
    prev_data = data

func _ready():
    change_state(neutral)

func _physics_process(delta):
    if state:
        state.update(delta)

func exit():
    state = null
