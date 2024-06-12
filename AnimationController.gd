extends Node

@export var actor: CharacterBody2D
@export var sprite: AnimatedSprite2D

func _physics_process(_delta):
    if !actor:
        return
    
    if actor.velocity != Vector2.ZERO:
        if actor.velocity.x < 0:
            if actor.velocity.y > 0 and abs(actor.velocity.x) < abs(actor.velocity.y):
                sprite.play("run_down")
            else:
                sprite.play("run_side_0")
                actor.global_transform.x.x = -1
    
        if actor.velocity.x >= 0:
            if actor.velocity.y < 0 and abs(actor.velocity.x) < abs(actor.velocity.y):
               sprite.play("run_up") 
            elif actor.velocity.y > 0 and abs(actor.velocity.x) < abs(actor.velocity.y):
                sprite.play("run_down")
            else: 
                sprite.play("run_side_0")
                actor.global_transform.x.x = 1

        
    else:
        sprite.play("idle_front")
