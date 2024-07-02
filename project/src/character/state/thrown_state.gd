extends State

## Createure is "in_combat"
class_name ThrownState

@onready var actor_core = %ActorCore
@onready var animated_sprite = %AnimatedSprite2D
@onready var nav_agent: NavigationAgent2D = %NavigationAgent2D
@onready var actor: Actor = actor_core.actor
var target_position: Vector2
var movement_delta: float
var throw_velocity: Vector2
@export var speed = 400
@export var position_tolorance: float = 5

func is_close_enough():
    var distance = actor.global_position.distance_to(target_position)
    return distance <= position_tolorance

func set_thrown_collisions():
    actor.set_collision_layer(0)
    actor.set_collision_mask(0)

func unset_thrown_collisions():
    actor.set_collision_layer(1)
    actor.set_collision_mask(1)

func enter_state(data: Dictionary = {}):
    var new_target_position = data.get("position")
    super.enter_state()
    if new_target_position == target_position:
        return
    actor.should_follow_player = false
    target_position = new_target_position
    animated_sprite.play("thrown_down")
    set_thrown_collisions()
    handle_animation()
    throw_velocity = actor.global_position.direction_to(target_position) * speed
    actor.sfx_manager.play_rand("throw")
    
func update(delta):
    if is_close_enough():
        actor_core.is_thrown = false
    actor.set_velocity(throw_velocity)

func exit_state():
    animated_sprite.stop()
    unset_thrown_collisions()
    super.exit_state()

func handle_animation():
    if actor.velocity.x < 0:
        if actor.velocity.y > 0 and abs(actor.velocity.x) < abs(actor.velocity.y):
            animated_sprite.play("thrown_down")
        else:
            animated_sprite.play("thrown_down")
            actor.global_transform.x.x = -1
    if actor.velocity.x >= 0:
        if actor.velocity.y > 0 and abs(actor.velocity.x) < abs(actor.velocity.y):
            animated_sprite.play("thrown_down")
        
        if actor.velocity.y < 0 and abs(actor.velocity.x) <= abs(actor.velocity.y):
            animated_sprite.play("thrown_down") 
        else:
            animated_sprite.play("thrown_down")
            actor.global_transform.x.x = 1
