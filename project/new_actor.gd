extends CharacterBody2D

class_name Actor

@export var damage: int
@export var move_speed: float
@export var burst_speed: float
@export var burst_duration: float
@export var throw_multiplier: float
@export var nav_agent: NavigationAgent2D
@export var follow_area: Area2D
@export var team: TeamManager.Team = TeamManager.Team.PLAYER
@export var should_follow_player: bool = false
@export var player: Node2D

@onready var health_component = $HealthComponent

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
    if team == TeamManager.Team.CPU:
        set_modulate(Color(0.784, 0.114, 0.8))

func follow(target: Node2D):
    should_follow_player = true
    player = target

func unfollow(target: Node2D):
    should_follow_player = false
    player = null

func receive_attack(attack: Attack):
    health_component.receive_attack(attack)
    hurt.emit()
    

func _physics_process(_delta):
    move_and_slide()



func get_thrown_to(position: Vector2):
    stop_following()
    queue_free()

func stop_following():
    should_follow_player = false

func connect_called_goblins():
    # set up nav targets on player.called_goblins()
    # so that the actor will go to player
    if !player.called_goblins.is_connected(_on_player_called_goblins):
        player.called_goblins.connect(_on_player_called_goblins)

var _is_burst: bool = false
func is_burst():
    if _is_burst:
        return true
    return false

func boost_speed(speed):
        _is_burst = true
        burst_speed = speed
        await get_tree().create_timer(burst_duration).timeout
        _is_burst = false

func _on_player_called_goblins():

    boost_speed(player.speed)

# detection radius
func _on_follow_area_body_exited(body: Node2D):
    return
    #unset_nav_target(body)

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
