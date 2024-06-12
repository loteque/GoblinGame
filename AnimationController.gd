extends Node

@export var actor: CharacterBody2D
@export var sprite: AnimatedSprite2D

func _physics_process(_delta):
    if actor.velocity != Vector2.ZERO:
        if actor.velocity.x < 0:
            sprite.play("run_side_0")
            actor.global_transform.x.x = -1
    
        if actor.velocity.x >= 0:
            sprite.play("run_side_0")
            actor.global_transform.x.x = 1
    
    else:
        sprite.play("idle_front")
