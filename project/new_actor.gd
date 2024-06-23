extends CharacterBody2D

class_name Actor

@export var damage: int
@export var move_speed: float = 300.0
@export var throw_multiplier: float
@export var follow_area: Area2D
@export var team: TeamManager.Team = TeamManager.Team.PLAYER
@export var should_follow_player: bool = false
@export var player: Node2D
@export var music_manager: MusicManager
@export var boost_speed_multiplier := 1.05
@export var burst_duration: float = 2.0


var is_boosted:= false
var current_move_speed: float = move_speed

@onready var music_connector = MusicManager.MusicConnector.new(music_manager, self)
@onready var health_component = $HealthComponent
@onready var boost_timer = $BoostTimer
@onready var nav_agent: NavigationAgent2D = %NavigationAgent2D
@onready var actor_core = %ActorCore


signal thrown_to(position: Vector2)
signal hurt

var has_target: bool = false
var target: Node2D
var throw_target: Marker2D

var _is_thrown: bool = false
func is_thrown():
    if _is_thrown:
        return true
    return false

func _ready():
    nav_agent.velocity_computed.connect(_on_velocity_computed)
    if team == TeamManager.Team.CPU:
        set_modulate(Color(0.784, 0.114, 0.8))

func _on_velocity_computed(safe_velocity: Vector2) -> void:
    if !actor_core.is_thrown:
        set_velocity(safe_velocity)
    else:
        pass

func unboost():
    current_move_speed = move_speed
    is_boosted = false

func boost_speed(base_speed: float):
    var boosted_speed = boost_speed_multiplier * base_speed
    is_boosted = true
    current_move_speed = boosted_speed
    await get_tree().create_timer(burst_duration).timeout
    unboost()

func follow(follow_target: Node2D):
    if not is_boosted:
        is_boosted = true
        boost_speed(follow_target.speed)
    should_follow_player = true
    player = follow_target

func unfollow(_unfollow_target: Node2D):
    should_follow_player = false
    player = null

func receive_attack(attack_obj: Attack):
    health_component.receive_attack(attack_obj)
    hurt.emit()
    if self.is_in_group("Enemy"):
        music_connector._manager.damage_taken.emit()

func _physics_process(_delta):
    move_and_slide()

func stop_following():
    should_follow_player = false

# can die
func die():
    queue_free()

# can take damage
signal health_updated(body)

func attack(attack_target):
    print(str(attack_target))
    await get_tree().create_timer(.5).timeout
    attack_target.call_deferred("take_damage", damage)
    target = self
