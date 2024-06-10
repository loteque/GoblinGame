extends CharacterBody2D

@export var speed = 400
@export var throw_target: Marker2D

var base = preload("res://static_unit.tscn").instantiate()
var base_placer = BasePlacer.new(1)

func get_input():
    var input_direction = Input.get_vector("left", "right", "up", "down")
    return input_direction

func update_body():    
    var input_direction = get_input()
    velocity = input_direction * speed
    move_and_slide()

func _physics_process(_delta):
    update_body()

func _input(event):
    if event.is_action("place"):
        base_placer.place(base, get_parent(), throw_target.global_transform.origin)

class BasePlacer:
    var num_bases

    func place(base: Node2D, attachment_node: Node2D, position: Vector2):
        if num_bases >= 1:
            attachment_node.add_child(base)
            base.global_transform.origin = position
            num_bases = num_bases - 1

    func _init(max_bases: int):
        num_bases = max_bases

