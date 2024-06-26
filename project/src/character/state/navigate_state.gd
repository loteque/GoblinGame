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
        pass
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
        #var distance = actor_core.actor.global_position.distance_to(target_position)
        #print(distance)
        nav_agent.set_target_position(target_position)

func update(delta):
    #if nav_agent.is_navigation_finished():
        ##_on_velocity_computed(Vector2.ZERO)
        ##nav_agent.set_velocity(Vector2.ZERO)
    var tolorance = nav_agent.target_desired_distance
    nav_agent.set_target_position(target_position)
    var distance_remaining = (target_position - actor.global_position).length()
    var next_path_position: Vector2 = nav_agent.get_next_path_position()
    var new_velocity: Vector2 = actor_core.actor.global_position.direction_to(next_path_position).normalized() * speed
    #_on_velocity_computed(new_velocity) # 99, -13
    nav_agent.set_velocity(new_velocity)
    handle_animation(delta)

func exit_state():
    #_on_velocity_computed(Vector2.ZERO)
    nav_agent.set_velocity(Vector2.ZERO)
    super.exit_state()

func handle_animation(_delta):
    var x: float = actor.velocity.x
    var y: float = actor.velocity.y
    var is_facing_east: bool
    var is_facing_west: bool
    var is_facing_north: bool
    var is_facing_south: bool

    
    if x > 0 and x > y: 
        is_facing_east = true 
        is_facing_west = false
        is_facing_north = false
        is_facing_south = false

    if x < 0 and x < y: 
        is_facing_east = false
        is_facing_west = true
        is_facing_north = false
        is_facing_south = false


    if y < 0 and y < x:
        is_facing_east = false
        is_facing_west = false
        is_facing_north = true
        is_facing_south = false
    
    if y > 0 and y > x:
        is_facing_east = false
        is_facing_west = false
        is_facing_north = false
        is_facing_south = true

    # run side east    
    if is_facing_east: 
        animated_sprite.play("run_side_0")
        actor.global_transform.x.x = 1

    # run side west
    if is_facing_west:
        animated_sprite.play("run_side_0")
        actor.global_transform.x.x = -1

    # run up north
    if is_facing_north:
        animated_sprite.play("run_up")
        actor.global_transform.x.x = 1

    # run down south
    if is_facing_south:
        animated_sprite.play("run_down")
        actor.global_transform.x.x = 1

    # if actor.velocity.x <= 0:
    #     if actor.velocity.y > 0 and abs(actor.velocity.x) < abs(actor.velocity.y):
    #         animated_sprite.play("run_down")
    #     else:
    #         animated_sprite.play("run_side_0")
    #         actor.global_transform.x.x = -1
    # if actor.velocity.x >= 0:
    #     if actor.velocity.y > 0 and abs(actor.velocity.x) < abs(actor.velocity.y):
    #         animated_sprite.play("run_down")
        
    #     if actor.velocity.y < 0 and abs(actor.velocity.x) <= abs(actor.velocity.y):
    #         animated_sprite.play("run_up")
    #     else:
    #         animated_sprite.play("run_side_0")
    #         actor.global_transform.x.x = 1
