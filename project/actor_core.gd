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
@onready var hurt = %Hurt
@onready var target_tracker_component = %TargetTrackerComponent
@onready var patrol_auto_advance = %PatrolAutoAdvance
@onready var collector: CollectorComponent = %Collector

var is_thrown = false
var target: Vector2
var is_hurt = false

func _ready():
    actor.thrown_to.connect(_on_thrown_to)
    actor.hurt.connect(_on_hurt)

func _on_thrown_to(position: Vector2):
    is_thrown = true
    target = position

func _on_hurt():
    is_hurt = true

func should_scavange():
    return collector.should_collect()

func _physics_process(_delta):
    if is_hurt:
        machine.change_state(hurt, {"position": target})
    elif is_thrown:
        machine.change_state(thrown, {"position": target})
    elif actor.should_follow_player:
        var new_target = actor.player
        machine.change_state(follow, {"target": new_target})
    elif target_tracker_component.has_enemies_of(actor.team):
        var new_target = target_tracker_component.get_closest_enemy_of(actor.team)
        machine.change_state(combat, {"target": new_target})
    elif should_scavange():
        machine.change_state(scavange)
    elif actor.team == TeamManager.Team.CPU:
        machine.change_state(patrol_auto_advance)
    else:
        machine.change_state(neutral)
