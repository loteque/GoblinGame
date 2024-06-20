extends State

## Automatically moves from one child state to the next
class_name AutoAdvanceState

var target: Node2D
@export var follow_distance: float = 40.0
@export var throw_distance: float = 300.0

@onready var actor_core = %ActorCore
@onready var idle = $Idle
@onready var navigate = $Navigate
@onready var explore = $Explore
@onready var patrol = $Patrol
@onready var state_list: Array[Node] = get_children().filter(func(node: Node): return node.has_method("enter_state"))

signal state_complete

func _ready():
    state_complete.connect(_on_state_complete)

var state_index = 0
@onready var current_state: State = state_list[0]

var is_first = true

func advance_next_state():
    is_first = true
    if state_list.size() == 0:
        return null  # Return null if the sequence is empty
    var next_num = state_list[state_index]
    state_index = (state_index + 1) % state_list.size()
    current_state = state_list[state_index]

func _on_state_complete():
    advance_next_state()

func enter_state(data: Dictionary = {}):
    super.enter_state()
    #target = data.get("target")

func update(delta):
    for state in state_list:
        if state == current_state:
            machine.change_state(state, {}, is_first)
            is_first = false

func exit_state():
    super.exit_state()
