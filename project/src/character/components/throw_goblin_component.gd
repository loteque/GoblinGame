extends Node

## Allows the actor to throw goblins on their team
class_name ThrowGoblinComponent

@export var goblin_command_component: GoblinCommandComponent
@export var target: Node2D
@export var player: PhysicsBody2D

func throw_goblin(goblin: Actor):
    if goblin.has_signal("thrown_to"):
        goblin.thrown_to.emit(target.global_position)

func select_goblin() -> Actor:
    return goblin_command_component.pop_closest_follower()

func throw_a_goblin():
    var goblins = goblin_command_component.followers
    if len(goblins) == 0:
        return
    var goblin = select_goblin()
    throw_goblin(goblin)

    # tutorial
    if player.tut_conn.manager.is_tutorial_active():
        player.tut_conn.manager.section_success.emit(
            player.tut_conn.manager.Section.THROW_PROMPT,
            player.tut_conn.manager.Section.THROW_RESPONSE, 
            player.tut_conn
        )        



func _process(_delta):
    if Input.is_action_just_pressed("throw"):
        throw_a_goblin()
