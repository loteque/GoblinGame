extends Node

## The core game objects needed for state
class_name ActorCore

@export var actor: Actor
@export var animated_sprite: AnimatedSprite2D
@export var machine: StateMachine

@onready var neutral = %Neutral
@onready var scavange = %Scavange
@onready var follow = %Follow

@onready var target_tracker_component = %TargetTrackerComponent


func _ready():
    pass 

func _physics_process(delta):
    if actor.should_follow_player:
        var target = actor.player
        machine.change_state(follow, {"target": target})
    elif false: # there is an enemy
        pass
        # Start combat
    elif target_tracker_component.includes("Scrap"):
        var target = target_tracker_component.get_closest_in_group("Scrap")
        machine.change_state(scavange, {"target": target})
    else:
        machine.change_state(neutral)
