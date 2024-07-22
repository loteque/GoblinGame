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
@export var sfx_manager: SfxManager

var is_boosted:= false
var current_move_speed: float = move_speed

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var health_bar_ui = $HealthBarUi
@onready var music_connector = MusicManager.MusicConnector.new(music_manager, self)
@onready var health_component = $HealthComponent
@onready var nav_agent: NavigationAgent2D = %NavigationAgent2D
@onready var actor_core = %ActorCore
@onready var lights = $Lights

# can take damage
signal health_updated(body)
signal thrown_to(position: Vector2)
signal hurt
signal died
signal collected_scrap

var has_target: bool = false
var target: Node2D
var throw_target: Marker2D

var _is_thrown: bool = false
func is_thrown():
    if _is_thrown:
        return true
    return false

func _ready():
    died.connect(die)
    nav_agent.velocity_computed.connect(_on_velocity_computed)
    if team == TeamManager.Team.CPU:
        add_to_group(&"Enemy")
        set_modulate(Color8(255, 88, 218))
    
    if team == TeamManager.Team.PLAYER:
        add_to_group(&"Ally")
        

func _on_died():
    die()

# can die
func die():
    if health_bar_ui:
        health_bar_ui.visible = false
    animated_sprite_2d.play("die")
    process_mode = Node.PROCESS_MODE_DISABLED    
    animated_sprite_2d.process_mode = Node.PROCESS_MODE_ALWAYS
    await animated_sprite_2d.animation_finished
    z_index = 0
    animated_sprite_2d.process_mode = Node.PROCESS_MODE_DISABLED
    if lights:
        lights.queue_free()

    var death_despawn_timer_delay = 600
    var timer = Timer.new()
    timer.one_shot = true
    get_parent().add_child(timer)
    timer.start(death_despawn_timer_delay)
    await timer.timeout
    timer.queue_free()
    queue_free()
    
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

func attack(attack_target):
    print(str(attack_target))
    await get_tree().create_timer(.5).timeout
    attack_target.call_deferred("take_damage", damage)
    target = self
