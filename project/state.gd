extends Node

class_name State

@onready var debugger: StateDebugger = %StateDebugger

var machine: StateMachine

func _init():
    machine = StateMachine.new()
    add_child(machine)

func _ready():
    pass

func enter_state(data: Dictionary = {}):
    debugger.states.append(self)
    pass

func update(delta):
    if not machine.state == null:
        machine.state.update(delta)

func exit_state():
    machine.change_state(null)
    debugger.states.erase(self)
