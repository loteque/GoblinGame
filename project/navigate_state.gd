extends State

## Navigate to target
class_name NavigateState

@export var nav_agent: NavigationAgent2D
@onready var actor_core = %ActorCore
@onready var animated_sprite = %AnimatedSprite2D
@onready var actor: Actor = actor_core.actor
var target_position: Vector2
var speed: float:
    get: return actor.current_move_speed
var movement_delta: float
@export var position_tolorance: float = 20

func _ready():
    if nav_agent == null:
        nav_agent = %NavigationAgent2D

func enter_state(data: Dictionary={}):
    var new_target_position = data.get("position")
    super.enter_state()
    if new_target_position == target_position:
        pass
        #return # Do not setup again, already navigating
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
        nav_agent.set_target_position(target_position)
    var next_path_position: Vector2 = nav_agent.get_next_path_position()
    var new_velocity: Vector2 = actor_core.actor.global_position.direction_to(next_path_position).normalized() * speed
    _on_velocity_computed(new_velocity) # 99, -13
    handle_animation(delta)

func _on_velocity_computed(safe_velocity: Vector2) -> void:
    actor_core.actor.set_velocity(safe_velocity)

func exit_state():
    _on_velocity_computed(Vector2.ZERO)
    super.exit_state()

func handle_animation(_delta):
    if actor.velocity.x < 0:
        if actor.velocity.y > 0 and abs(actor.velocity.x) < abs(actor.velocity.y):
            animated_sprite.play("run_down")
        else:
            animated_sprite.play("run_side_0")
            actor.global_transform.x.x = -1
    if actor.velocity.x >= 0:
        if actor.velocity.y > 0 and abs(actor.velocity.x) < abs(actor.velocity.y):
            animated_sprite.play("run_down")
        
        if actor.velocity.y < 0 and abs(actor.velocity.x) <= abs(actor.velocity.y):
            animated_sprite.play("run_up")
        else:
            animated_sprite.play("run_side_0")
            actor.global_transform.x.x = 1
