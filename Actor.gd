extends CharacterBody2D

@export var move_speed: float
@export var nav_agent: NavigationAgent2D

var has_target: bool = false
var target: CharacterBody2D

func _ready() -> void:
    nav_agent.velocity_computed.connect(Callable(_on_velocity_computed))

func set_movement_target(movement_target: Vector2):
    nav_agent.set_target_position(movement_target)

func _physics_process(_delta):
    
    if has_target:
 
        set_movement_target(target.global_transform.origin)
    
    if nav_agent.is_navigation_finished(): return

    var next_path_position: Vector2 = nav_agent.get_next_path_position()
    var new_velocity: Vector2 = global_position.direction_to(next_path_position) * move_speed

    _on_velocity_computed(new_velocity)


func _on_velocity_computed(safe_velocity: Vector2):
    velocity = safe_velocity
    move_and_slide()


func _on_follow_area_body_entered(body:Node2D):
    
    if body.is_in_group("Player"):
        has_target = true
        target = body


func _on_follow_area_body_exited(body:Node2D):
    if body.is_in_group("Player"):
        has_target = false
        target = self
        print("body exited")
