extends Node

class_name State

var machine: StateMachine

func _init():
    machine = StateMachine.new()

func _ready():
    pass

func enter_state():
    pass
    # Setup this state
    
# DO
func update(_delta):
    pass

# EXIT
func exit_state():
    # Clean up this state
    pass
