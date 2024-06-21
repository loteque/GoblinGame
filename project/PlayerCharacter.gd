extends CharacterBody2D

@export var speed = 400
@export var throw_target: Marker2D
@export var marker_range: float = 250
@export var cursor: Area2D
@export var follow_target: Marker2D
@export var team: TeamManager.Team = TeamManager.Team.PLAYER

@onready var health_component = $HealthComponent

var base = preload("res://static_unit.tscn").instantiate()
var base_placer = BasePlacer.new(1)
var selected: Node2D

signal called_goblins()

func update_marker_position(player_direction: Vector2):
    if player_direction.length() == 0:
        return
    var marker_position = global_position + player_direction * marker_range
    throw_target.global_position = marker_position

func receive_attack(attack: Attack):
    health_component.receive_attack(attack)

func get_input():
    var input_direction = Input.get_vector("left", "right", "up", "down")
    return input_direction

func update_body():    
    var input_direction = get_input()
    update_marker_position(input_direction)
    velocity = input_direction * speed
    move_and_slide()

func call_goblins():
    called_goblins.emit()

func _physics_process(_delta):
    update_body()

func _input(event):
    if event.is_action("place"):
        base_placer.place(base, get_parent(), throw_target.global_transform.origin)
    if event.is_action("select") and selected:
        if selected.is_in_group("Upgradable"):
            selected.upgrader.upgrade()

func _on_cursor_body_entered(body:Node2D):
    selected = body

func _on_cursor_body_exited(_body:Node2D):
    selected = null

class BasePlacer:
    var num_bases

    func place(base: Node2D, attachment_node: Node2D, position: Vector2):
        if num_bases >= 1:
            attachment_node.add_child(base)
            base.global_transform.origin = position
            num_bases = num_bases - 1

    func _init(max_bases: int):
        num_bases = max_bases
