extends Node
class_name StateMachine

@onready var combat: State = $Combat
@onready var neutral: State = $Neutral
@onready var collect: State = $Collect
@onready var follow: State = $Follow


# Signals cause state machine changes?
# lost_target


# Core?

var actor
var animation_player
var player_input
var state: State

func change_state(new_state: State):
    if state and state != new_state:
        state.exit_state()
    state = new_state
    state.enter_state()

func _ready():
    state = neutral
    pass # Replace with function body.


func _physics_process(delta):
    if state:
        state.update(delta)

func exit():
    state = null
