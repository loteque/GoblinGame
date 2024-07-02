extends Node

@export var actor: CharacterBody2D
@export var sprite: AnimatedSprite2D

# func play_thrown_animation(rotation_deg: float):
#     sprite.play("thrown_down")
#     sprite.rotation_degrees = rotation_deg

func _physics_process(_delta):
    if !actor:
        return
    
    if actor.velocity == Vector2.ZERO:
        sprite.play("idle_front")
        return

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
        sprite.play("run_side_0")
        actor.global_transform.x.x = 1

    # run side west
    if is_facing_west:
        sprite.play("run_side_0")
        actor.global_transform.x.x = -1

    # run up north
    if is_facing_north:
        sprite.play("run_up")
        actor.global_transform.x.x = 1

    # run down south
    if is_facing_south:
        sprite.play("run_down")
        actor.global_transform.x.x = 1

    # sprite.rotation = 0

    # if actor.velocity == Vector2.ZERO:
    #     sprite.play("idle_front")
    #     return

    # if actor.velocity.x < 0:
    #     if actor.velocity.y > 0 and abs(actor.velocity.x) < abs(actor.velocity.y):
    #         if actor.is_in_group("throwable") and actor.is_thrown():
    #             play_thrown_animation(180)
    #             return
    #         else:
    #             sprite.play("run_down")
    #     else:
    #         if actor.is_in_group("throwable") and actor.is_thrown():
    #             play_thrown_animation(180)
    #             return
    #         sprite.play("run_side_0")
    #         actor.global_transform.x.x = -1

    # if actor.velocity.x >= 0:
        
    #     if actor.velocity.y > 0 and abs(actor.velocity.x) < abs(actor.velocity.y):
    #         sprite.play("run_down")
        
    #     if actor.velocity.y < 0 and abs(actor.velocity.x) <= abs(actor.velocity.y):
    #         if actor.is_in_group("throwable") and actor.is_thrown():
    #             play_thrown_animation(180)
    #             return
    #         else:
    #             sprite.play("run_up") 
        
    #     else:
    #         if actor.is_in_group("throwable") and actor.is_thrown():
    #             play_thrown_animation(180)
    #             return
    #         sprite.play("run_side_0")
    #         actor.global_transform.x.x = 1

    
