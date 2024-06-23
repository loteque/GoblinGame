extends State

## Choose a random point and go to it, must be a child of an autonomous state parent
class_name ExploreState

var destination: Vector2

@export var position_tolorance: float = 40.0
@export var range_min: float = 100.0
@export var range_max: float = 300.0
@export var stuck_distance: float = 1

@onready var actor_core = %ActorCore
@onready var navigate = $Navigate
@onready var end_signal: Signal = get_parent().state_complete 

@onready var previous_position: Vector2 = actor_core.actor.global_position

func get_random_destination() -> Vector2:
    # Determine a random distance within the range
    var distance = randf_range(range_min, range_max)
    
    # Determine a random angle in radians (0 to 2*PI for 360 degrees)
    var angle = randf() * 2.0 * PI
    
    # Calculate the x and y coordinates using polar coordinates
    var x = distance * cos(angle)
    var y = distance * sin(angle)
    
    # Create the local point as a Vector2
    var local_point = Vector2(x, y)
    
    # Translate the local point to global space
    var global_target = actor_core.actor.global_position + local_point
    
    # Return the global point as a Vector2
    return global_target

func is_actor_stuck():
    return (previous_position - actor_core.actor.global_position).length() < stuck_distance

func is_close_enough(target: Vector2):
    var distance = actor_core.actor.global_position.distance_to(target)
    return distance <= position_tolorance

func enter_state(_delta: Dictionary = {}):
    super.enter_state()
    destination = get_random_destination()

func update(_delta):
    if destination and not destination == null:
        if is_close_enough(destination):
            end_signal.emit()
        elif is_actor_stuck():
            destination = get_random_destination()
            machine.change_state(navigate, {"position": destination, "position_tolorance": position_tolorance}, true)
        else:
            machine.change_state(navigate, {"position": destination, "position_tolorance": position_tolorance}, true)
    previous_position = actor_core.actor.global_position

func exit_state():
    super.exit_state()
