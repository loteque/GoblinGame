extends State

## go to scavange target, collect when in range
class_name ScavangeState

var target: Node2D
@onready var navigate = $Navigate
@onready var collect = $Collect
@onready var actor_core: ActorCore = %ActorCore

signal target_reached
signal scavange_complete

var scavange_range = 20


func is_close_enough(target: Node2D):
    var distance = actor_core.actor.global_position.distance_to(target.global_position)
    return distance <= scavange_range

# Called when the node enters the scene tree for the first time.
func _ready():
    target_reached.connect(_on_target_reached)
    pass # Replace with function body.

func _on_target_reached():
    machine.change_state(collect, {"target": target})

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func enter_state(data: Dictionary = {}):
    super.enter_state()
    target = data.get("target")
    if target and not target == null:
        if is_close_enough(target):
            machine.change_state(collect, {"target": target})
        else:
            machine.change_state(navigate, {"position": target.global_position, "position_tolorance": scavange_range})
        
    # Setup this state
    
# DO
func update(delta):
    if not target:
        machine.change_state(null)
    elif is_close_enough(target):
            machine.change_state(collect, {"target": target})
    #machine.state.update(delta)

# EXIT
func exit_state():
    super.exit_state()
    
