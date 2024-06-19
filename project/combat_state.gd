extends State

## Createure is "in_combat"
class_name CombatState

var target: Node2D
@onready var navigate = $Navigate
@onready var collect = $Collect
@onready var actor_core: ActorCore = %ActorCore
@onready var attack = $Attack



@export var attack_range: float = 20.0

func is_close_enough(target: Node2D):
    var distance = actor_core.actor.global_position.distance_to(target.global_position)
    return distance <= attack_range

func enter_state(data: Dictionary = {}):
    super.enter_state()
    target = data.get("target")
    if target and not target == null:
        if is_close_enough(target):
            machine.change_state(attack, {"target": target})
        else:
            machine.change_state(navigate, {"position": target.global_position, "position_tolorance": attack_range})
        
    # Setup this state
    
# DO
func update(delta):
    if not target:
        machine.change_state(null)
    elif is_close_enough(target):
        machine.change_state(attack, {"target": target})
    else:
        machine.change_state(navigate, {"position": target.global_position, "position_tolorance": attack_range})
    #machine.state.update(delta)

# EXIT
func exit_state():
    super.exit_state()
    
