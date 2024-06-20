extends State

## Createure is "in_combat"
class_name ThrownState

@onready var actor_core = %ActorCore
@onready var animated_sprite = %AnimatedSprite2D

@onready var actor: Actor = actor_core.actor
var target_position: Vector2
var movement_delta: float

@export var speed = 8000
@export var position_tolorance: float = 40

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
        return # Do not setup again, already navigating
    actor.should_follow_player = false
    target_position = new_target_position
    animated_sprite.play("thrown_down")
    set_thrown_collisions()
    handle_animation()

func update(delta):
    if is_close_enough():
        actor_core.is_thrown = false
    movement_delta = speed * delta
    var new_velocity: Vector2 = actor_core.actor.global_position.direction_to(target_position) * movement_delta

    _on_velocity_computed(new_velocity)
    #handle_animation()

func _on_velocity_computed(safe_velocity: Vector2) -> void:
    actor_core.actor.velocity = safe_velocity
    actor_core.actor.move_and_slide()

func exit_state():
    _on_velocity_computed(Vector2.ZERO)
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
            actor.global_transform.y.y = -1
        
        if actor.velocity.y < 0 and abs(actor.velocity.x) <= abs(actor.velocity.y):
            animated_sprite.play("thrown_down") 
        else:
            animated_sprite.play("thrown_down")
            actor.global_transform.x.x = 1
