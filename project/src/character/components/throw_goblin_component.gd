extends Node

## Allows the actor to throw goblins on their team
class_name ThrowGoblinComponent

@export var goblin_command_component: GoblinCommandComponent
@export var cursor: Node2D
@export var player: PhysicsBody2D

# Max distance to check for non-colliding points
var max_check_distance = 200

# Number of steps to check between the ally's position and the target
var check_steps = 10

var furthest_distance: float

func _ready():
    assert(cursor != null)
    furthest_distance = player.global_position.distance_to(cursor.global_position)

func throw_goblin(goblin: Actor):
    if goblin.has_signal("thrown_to"):
        goblin.thrown_to.emit(cursor.global_position)

func select_goblin() -> Actor:
    return goblin_command_component.pop_closest_follower()

func throw_a_goblin():
    var goblins = goblin_command_component.followers
    if len(goblins) == 0:
        return
    var goblin = select_goblin()
    throw_goblin(goblin)
    player.threw_goblin.emit()

#func get_furthest_non_colliding_position():
    #

func _process(_delta):
    
    if Input.is_action_just_pressed("throw"):
        throw_a_goblin()
