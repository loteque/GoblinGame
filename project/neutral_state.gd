extends State

class_name NeutralState

@onready var animated_sprite = %AnimatedSprite2D
@onready var actor_core = %ActorCore

@onready var follow = %Follow
@onready var idle: State = $Idle
@onready var scavange: State = %Scavange
@onready var target_tracker_component: TargetTrackerComponent = %TargetTrackerComponent

func enter_state(_data: Dictionary = {}):
    super.enter_state()
    machine.change_state(idle)

func exit_state():
    super.exit_state()
