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
    

func _physics_process(_delta):
    move_and_slide()

# actor can be thrown if player is detected
# and player engages throw action
func throw_actor():
    set_collision_layer(0)
    set_collision_mask(0)
    target = throw_target
    _is_thrown = true

func _input(event):
    if event.is_action("throw") and has_target:
        throw_actor()

func connect_called_goblins():
    # set up nav targets on player.called_goblins()
    # so that the actor will go to player
    if !player.called_goblins.is_connected(_on_player_called_goblins):
        player.called_goblins.connect(_on_player_called_goblins)

func _on_follow_area_body_entered(body: Node2D):
    return
    if self.is_in_group("Enemy"):
        return

    if body.is_in_group("Enemy"):
        pass
        #set_up_nav_target(body)

    if body.is_in_group("Player"):
        # make actor aware of player
        player = body
        # connect signal called_goblins
        connect_called_goblins()

    # !this must be the last check
    # turn off actor collisions when they are targeting
    #if target != self:
        #set_collision_mask(0)
        #set_collision_layer(0)

# handle connecting actors to player
# actors get a speed boost on connection
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
    # set up navigation targets
    #set_up_nav_target(player)
    
    # set and unset actor speed burst
    boost_speed(player.speed)

# handle disconecting actors from player

# actor will disconnect from player when player leaves their
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

