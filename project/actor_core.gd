extends Node

## The core game objects needed for state
class_name ActorCore

@export var animated_sprite: AnimatedSprite2D

func _ready():
    get_children()
