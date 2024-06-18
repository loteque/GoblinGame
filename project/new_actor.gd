extends CharacterBody2D

@export var health: int
@export var damage: int
@export var move_speed: float
@export var burst_speed: float
@export var burst_duration: float
@export var throw_multiplier: float
@export var nav_agent: NavigationAgent2D
@export var follow_area: Area2D

var has_target: bool = false
var target: Node2D
var throw_target: Marker2D
var player: Node2D
var should_follow_player: bool = false

var _is_thrown: bool = false
func is_thrown():
    if _is_thrown:
        return true
    return false

# set up nav loop
func _ready() -> void:
    pass
    #nav_agent.velocity_computed.connect(Callable(_on_velocity_computed))
    #nav_agent.target_reached.connect(_on_target_reached)

# nav loop
func _set_movement_target(movement_target: Vector2):
    nav_agent.set_target_position(movement_target)

func stop_moving():
    velocity = Vector2.ZERO

func follow_player():
    if player:
        target = player.follow_target
        has_target = true
        _set_movement_target(target.global_transform.origin)

func player_is_within_max_target_distance():
    if not player:
        return false
    return self.global_transform.origin.distance_to(
    player.follow_target.global_transform.origin
) < nav_agent.target_desired_distance

func handle_new_navigation():
    if should_follow_player:
            if !player_is_within_max_target_distance():
                follow_player()
            else: # Close enough
                stop_moving()
    else: # Nothing to be done.
        stop_moving()

func handle_current_navigation():
    if has_target or throw_target:
        _set_movement_target(target.global_transform.origin)
    
    var new_velocity: Vector2
    var next_path_position: Vector2 = nav_agent.get_next_path_position()
    if !is_burst():
        new_velocity = global_position.direction_to(next_path_position) * move_speed
    else:
        new_velocity = global_position.direction_to(next_path_position) * burst_speed

    if !follow_area.monitoring:
        new_velocity = new_velocity * throw_multiplier

    _on_velocity_computed(new_velocity)

func _physics_process(_delta):
    return
    if nav_agent.is_navigation_finished():
        handle_new_navigation()
    else:
        handle_current_navigation()

func _on_velocity_computed(safe_velocity: Vector2):
    velocity = safe_velocity
    move_and_slide()

# actor can be thrown if player is detected
# and player engages throw action
func throw_actor():
    set_collision_layer(0)
    set_collision_mask(0)
    target = throw_target
    _is_thrown = true
    if target:
        _set_movement_target(target.global_transform.origin)

func _input(event):
    if event.is_action("throw") and has_target:
        throw_actor()

# body proximity detection
func target_is_self():
    if target == self:
        return true
    return false

func connect_called_goblins():
    # set up nav targets on player.called_goblins()
    # so that the actor will go to player
    if !player.called_goblins.is_connected(_on_player_called_goblins):
        player.called_goblins.connect(_on_player_called_goblins)

func _on_follow_area_body_entered(body: Node2D):
    
    if self.is_in_group("Enemy"):
        return

    if body.is_in_group("Enemy"):
        set_up_nav_target(body)

    if body.is_in_group("Player"):
        # make actor aware of player
        player = body
        # connect signal called_goblins
        connect_called_goblins()

    # !this must be the last check
    # turn off actor collisions when they are targeting
    if !target_is_self():
        set_collision_mask(0)
        set_collision_layer(0)

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

func set_up_nav_target(nav_target: Node2D):
    if nav_target.is_in_group("Player"):
        target = nav_target.follow_target
        should_follow_player = true
        throw_target = nav_target.throw_target
    
    if nav_target.is_in_group("Enemy"):
        target = nav_target
        throw_target = null

    has_target = true
    _set_movement_target(target.global_transform.origin)

func _on_player_called_goblins():
    # set up navigation targets
    set_up_nav_target(player)
    
    # set and unset actor speed burst
    boost_speed(player.speed)

# handle disconecting actors from player
func disconnect_called_goblins():
    if player and player.called_goblins.is_connected(_on_player_called_goblins):
        player.called_goblins.disconnect(_on_player_called_goblins)

func unset_nav_target(nav_target):
    if nav_target.is_in_group("Player"):
        has_target = false
        target = self
        should_follow_player = false
        throw_target = null
        print("body exited")
        disconnect_called_goblins()

# actor will disconnect from player when player leaves their
# detection radius
func _on_follow_area_body_exited(body: Node2D):
    unset_nav_target(body)

# can die
func die():
    queue_free()

# can take damage
signal health_updated(body)

func take_damage(amount: int):
    health = health - amount
    health_updated.emit(health)
    print(
        str(self.name)
        + " took damage. health: "
        + str(health)
    )

func attack(attack_target):
    print(str(attack_target))
    await get_tree().create_timer(.5).timeout
    attack_target.call_deferred("take_damage", damage)
    
    target = self

# handle exit of nav loop
func _on_target_reached():
    if self.is_in_group("NPC") and target.is_in_group("Enemy"):
        attack(target)
        if target.health < 0:
            target.die()
    else:
        _is_thrown = false
        follow_area.monitoring = true
        set_collision_layer(1)
        set_collision_mask(1)
        target = self
