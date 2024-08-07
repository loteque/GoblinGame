extends State

## Patrol froom one navagation point ot the next.
class_name PatrolState

var target: Node2D
@export var follow_distance: float = 40.0
@export var throw_distance: float = 300.0

@onready var actor_core = %ActorCore
@onready var idle = $Idle
@onready var navigate = $Navigate

func is_close_enough(target: Node2D):
    var distance = actor_core.actor.global_position.distance_to(target.global_position)
    return distance <= follow_distance

func enter_state(data: Dictionary = {}):
    super.enter_state()
    target = data.get("target")

func update(delta):
    if target and not target == null:
        if is_close_enough(target):
            machine.change_state(idle)
        else:
            machine.change_state(navigate, {"position": target.global_position, "position_tolorance": follow_distance}, true)

func exit_state():
    super.exit_state()
