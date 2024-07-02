extends State

## Createure is "in_combat"
class_name CombatState

var target: Node2D
@onready var navigate = $Navigate
@onready var actor_core: ActorCore = %ActorCore
@onready var attack = $Attack

@onready var target_tracker_component = %TargetTrackerComponent
@onready var interact_area = %InteractArea

@export var attack_range: float = 75.0

#func _on_interact_area_body_entered(body: PhysicsBody2D):
    #if body.is_in_group("Base"):
        #is_close_enough_to_base = true
#
#func _on_interact_area_body_exited(body: PhysicsBody2D):
    #if body.is_in_group("Base"):
        #is_close_enough_to_base = false

func is_close_enough(enemy: PhysicsBody2D):
    var can_interact = interact_area.overlaps_body(enemy)
    var distance = actor_core.actor.global_position.distance_to(target.global_position)
    return (distance <= attack_range) or can_interact

func enter_state(data: Dictionary={}):
    super.enter_state()
    target = data.get("target")
    if target and not target == null:
        if is_close_enough(target):
            machine.change_state(attack, {"target": target})
        else:
            machine.change_state(navigate, {"position": target.global_position, "position_tolorance": attack_range})

func update(_delta):
    if not target:
        machine.change_state(null)
    elif is_close_enough(target):
        machine.change_state(attack, {"target": target})
    else:
        machine.change_state(navigate, {"position": target.global_position, "position_tolorance": attack_range})

func exit_state():
    super.exit_state()
