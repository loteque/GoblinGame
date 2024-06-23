extends State

## go to scavange target, collect when in range
class_name ScavangeState

@onready var navigation_agent_2d: NavigationAgent2D = %NavigationAgent2D
@onready var navigate_to_scrap = $NavigateToNode
@onready var collect = $Collect
@onready var return_to_base = $ReturnToBase
@onready var deliver_scrap = $DeliverScrap
@onready var interact_area = %InteractArea
@onready var actor_core: ActorCore = %ActorCore
@onready var collector: CollectorComponent = %Collector

@export var scavange_range: float = 1
@export var delivery_range: float = 1

var collection_target: Scrap
var is_close_enough_to_base: bool = false
var is_close_enough_to_scrap: bool = false

func _ready():
    interact_area.body_entered.connect(_on_interact_area_body_entered)
    interact_area.body_exited.connect(_on_interact_area_body_exited)

func _on_interact_area_body_entered(body: PhysicsBody2D):
    if body.is_in_group("Scrap"):
        is_close_enough_to_scrap = true
    if body.is_in_group("Base"):
        is_close_enough_to_base = true

func _on_interact_area_body_exited(body: PhysicsBody2D):
    if body.is_in_group("Scrap"):
        is_close_enough_to_scrap = false
    if body.is_in_group("Base"):
        is_close_enough_to_base = false

func is_close_enough(target_obj: Node2D, range: float):
    var distance = actor_core.actor.global_position.distance_to(target_obj.global_position)
    print(distance)
    return distance <= range

func should_deposit():
    var has_scrap = collector.is_carrying_scrap()
    return has_scrap and is_close_enough_to_base

func should_return_to_base():
    if collector.should_return_to_base():
        return true
    return false

func should_collect():
    if !collector.has_remaining_capacity():
        return false
    if collector.current_scrap_node:
        return is_close_enough_to_scrap
    return false

func should_nav_to_scrap():
    return false

func enter_state(data: Dictionary = {}):
    super.enter_state()
    if should_deposit():
        machine.change_state(deliver_scrap)
    elif should_return_to_base():
        var target = collector.get_closest_allied_base()
        machine.change_state(return_to_base, {"position": collector.closest_base.global_position, "position_tolorance": delivery_range})
    elif should_collect():
        machine.change_state(collect, {"target": collector.current_scrap_node})
    else:
        machine.change_state(navigate_to_scrap, {"position": collector.current_scrap_node.global_position, "position_tolorance": scavange_range})

func update(_delta):
    var reachable_position: Vector2 = navigation_agent_2d.get_final_position()
    if should_deposit():
        machine.change_state(deliver_scrap)
    elif should_collect():
        machine.change_state(collect, {"target": collector.current_scrap_node})
    elif should_return_to_base():
        var position = collector.closest_base.global_position
        machine.change_state(return_to_base, {"position": position, "position_tolorance": delivery_range})
    else:
        machine.change_state(navigate_to_scrap, {"position": collector.current_scrap_node.global_position, "position_tolorance": scavange_range})

func exit_state():
    super.exit_state()
