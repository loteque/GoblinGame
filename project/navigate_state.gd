extends State

## Navigate to target
class_name NavigateState

@export var nav_agent: NavigationAgent2D
@onready var actor_core = %ActorCore
@onready var animated_sprite = %AnimatedSprite2D

var target_position: Vector2
var speed = 6000
var movement_delta: float
@export var position_tolorance: float = 20

func _ready():
    if nav_agent == null:
        nav_agent = %NavigationAgent2D

func enter_state(data: Dictionary = {}):
    var new_target_position = data.get("position")
    super.enter_state()
    if new_target_position == target_position:
        return # Do not setup again, already navigating
    target_position = new_target_position
    position_tolorance = data.get("position_tolorance")
    nav_agent.path_desired_distance = position_tolorance
    if target_position:
        var distance = actor_core.actor.global_position.distance_to(target_position)
        print(distance)
        nav_agent.set_target_position(target_position)

func update(delta):
    if nav_agent.is_navigation_finished():
        _on_velocity_computed(Vector2.ZERO)
        return
    movement_delta = speed * delta
    #nav_agent.set_target_position(target.global_position)
    var next_path_position: Vector2 = nav_agent.get_next_path_position()
    var new_velocity: Vector2 = actor_core.actor.global_position.direction_to(next_path_position) * movement_delta

    _on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector2) -> void:
    actor_core.actor.velocity = safe_velocity
    actor_core.actor.move_and_slide()

func exit_state():
    _on_velocity_computed(Vector2.ZERO)
    super.exit_state()
