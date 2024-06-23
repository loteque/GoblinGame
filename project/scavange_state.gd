extends State

## go to scavange target, collect when in range
class_name ScavangeState

#var target: Node2D
@onready var navigate_to_scrap = $NavigateToNode
@onready var collect = $Collect
@onready var return_to_base = $ReturnToBase
@onready var deliver_scrap = $DeliverScrap


@onready var actor_core: ActorCore = %ActorCore
@onready var collector: CollectorComponent = %Collector


@export var scavange_range: float = 100.0
@export var delivery_range: float = 200.0

var collection_target: Scrap

func is_close_enough(target_obj: Node2D):
    var distance = actor_core.actor.global_position.distance_to(target_obj.global_position)
    return distance <= scavange_range

func should_deposit():
    var has_scrap = collector.is_carrying_scrap()
    var is_close_enough_to_base = collector.closest_base != null and is_close_enough(collector.closest_base)
    return has_scrap and is_close_enough_to_base

func should_return_to_base():
    if collector.should_return_to_base():
        return true
    return false

func should_collect():
    if !collector.has_remaining_capacity():
        return false
    if collector.current_scrap_node:
        return is_close_enough(collector.current_scrap_node)
    return false

func should_nav_to_scrap():
    return false

func enter_state(data: Dictionary = {}):
    super.enter_state()
    #target = collector.get_next_target()
    #if target and not target == null:
    if should_deposit():
        #target = deliver_scrap_target
        machine.change_state(deliver_scrap)
    elif should_return_to_base():
        var target = collector.get_closest_allied_base()
        machine.change_state(return_to_base, {"position": collector.closest_base.global_position, "position_tolorance": delivery_range})
    elif should_collect():
        machine.change_state(collect, {"target": collector.current_scrap_node})
    #else should_nav_to_scrap():
        #machine.change_state(nav_to_scrap, {"target": target})
    else:
        machine.change_state(navigate_to_scrap, {"position": collector.current_scrap_node.global_position, "position_tolorance": scavange_range})

func update(_delta):
    #if not target:
        #machine.change_state(null)
    if should_deposit():
        #target = deliver_scrap_target
        machine.change_state(deliver_scrap)
    elif should_return_to_base():
        machine.change_state(return_to_base, {"position": collector.closest_base.global_position, "position_tolorance": delivery_range})
    elif should_collect():
        machine.change_state(collect, {"target": collector.current_scrap_node})
    else:
        machine.change_state(navigate_to_scrap, {"position": collector.current_scrap_node.global_position, "position_tolorance": scavange_range})

func exit_state():
    super.exit_state()
