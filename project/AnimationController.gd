extends Node

@export var actor: CharacterBody2D
@export var sprite: AnimatedSprite2D

func play_thrown_animation(rotation_deg: float):
    sprite.play("thrown_down")
    sprite.rotation_degrees = rotation_deg

func _physics_process(_delta):
    if !actor:
        return
    
    sprite.rotation = 0

    if actor.velocity == Vector2.ZERO:
        sprite.play("idle_front")
        return

    if actor.velocity.x < 0:
        if actor.velocity.y > 0 and abs(actor.velocity.x) < abs(actor.velocity.y):
            if actor.is_in_group("throwable") and actor.is_thrown():
                play_thrown_animation(180)
                return
            else:
                sprite.play("run_down")
        else:
            if actor.is_in_group("throwable") and actor.is_thrown():
                play_thrown_animation(180)
                return
            sprite.play("run_side_0")
            actor.global_transform.x.x = -1

    if actor.velocity.x >= 0:
        
        if actor.velocity.y > 0 and abs(actor.velocity.x) < abs(actor.velocity.y):
            sprite.play("run_down")
        
        if actor.velocity.y < 0 and abs(actor.velocity.x) <= abs(actor.velocity.y):
            if actor.is_in_group("throwable") and actor.is_thrown():
                play_thrown_animation(180)
                return
            else:
                sprite.play("run_up") 
        
        else:
            if actor.is_in_group("throwable") and actor.is_thrown():
                play_thrown_animation(180)
                return
            sprite.play("run_side_0")
            actor.global_transform.x.x = 1

    
