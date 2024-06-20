extends Node

## The core game objects needed for state
class_name ActorCore

@export var actor: Actor
@export var animated_sprite: AnimatedSprite2D
@export var machine: StateMachine

@onready var neutral = %Neutral
@onready var scavange = %Scavange
@onready var follow = %Follow
@onready var combat = %Combat
@onready var thrown = %Thrown

@onready var target_tracker_component = %TargetTrackerComponent

var is_thrown = false
var target: Vector2

func _ready():
    actor.thrown_to.connect(_on_thrown_to)

func _on_thrown_to(position: Vector2):
    is_thrown = true
    target = position


func _physics_process(delta):
    if is_thrown:
        machine.change_state(thrown, {"position": target})
    elif actor.should_follow_player:
        var target = actor.player
        machine.change_state(follow, {"target": target})
    elif target_tracker_component.has_enemies_of(actor.team):
        var target = target_tracker_component.get_closest_enemy_of(actor.team)
        machine.change_state(combat, {"target": target})
    elif target_tracker_component.includes("Scrap"):
        var target = target_tracker_component.get_closest_in_group("Scrap")
        machine.change_state(scavange, {"target": target})
    else:
        machine.change_state(neutral)