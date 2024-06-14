extends CharacterBody2D

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
var player_inside_follow_area: bool = false

var _is_thrown: bool = false
func is_thrown():
	if _is_thrown:
		return true
	return false

func _ready() -> void:
	nav_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	nav_agent.target_reached.connect(_on_target_reached)

func _set_movement_target(movement_target: Vector2):
	nav_agent.set_target_position(movement_target)

func _physics_process(_delta):

	if nav_agent.is_navigation_finished(): 
		
		if (
			player_inside_follow_area 
			and self.global_transform.origin.distance_to(
					player.follow_target.global_transform.origin
				) < nav_agent.target_desired_distance
		):
			velocity = Vector2.ZERO
			return

		if (
			player_inside_follow_area 
			and self.global_transform.origin.distance_to(
					player.follow_target.global_transform.origin
				) > nav_agent.target_desired_distance
		):
			target = player.follow_target
			has_target = true
			_set_movement_target(target.global_transform.origin)
			
		velocity = Vector2.ZERO
		return

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

func _input(event):
	if event.is_action("throw") and has_target:
		set_collision_layer(0)
		set_collision_mask(0)
		target = throw_target
		_is_thrown = true
		_set_movement_target(target.global_transform.origin)

func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	move_and_slide()


var _is_burst: bool = false
func is_burst():
	if _is_burst:
		return true
	return false

func boost_speed():
		_is_burst = true
		burst_speed = player.speed
		await get_tree().create_timer(burst_duration).timeout
		_is_burst = false

func target_is_self():
	if target == self:
		return true
	return false

func _on_follow_area_body_entered(body:Node2D):
	
	if self.is_in_group("Enemy"):
		return


	if body.is_in_group("Player"):
		# make actor aware of player
		player = body

		# set up nav targets on player.called_goblins()
		# so that the actor will go to player
		if !player.called_goblins.is_connected(_on_player_called_goblins):
			player.called_goblins.connect(_on_player_called_goblins)

	#this must be the last check
	if !target_is_self():
		set_collision_mask(0)
		set_collision_layer(0)

func _on_player_called_goblins():
	# set up navigation targets
	target = player.follow_target
	has_target = true
	player_inside_follow_area = true
	throw_target = player.throw_target
	_set_movement_target(player.follow_target.global_transform.origin)
	
	# set and unset actor speed burst
	boost_speed()
		

func _on_follow_area_body_exited(body:Node2D):
	if body.is_in_group("Player"):
		has_target = false
		target = self
		player_inside_follow_area = false
		throw_target = null
		print("body exited")

		if player and player.called_goblins.is_connected(_on_player_called_goblins):
			player.called_goblins.disconnect(_on_player_called_goblins)

func _on_target_reached():
	_is_thrown = false
	follow_area.monitoring = true
	set_collision_layer(1)
	set_collision_mask(1)
	target = self
