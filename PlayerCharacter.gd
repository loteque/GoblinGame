extends CharacterBody2D

@export var speed = 400

func get_input():
    var input_direction = Input.get_vector("left", "right", "up", "down")
    return input_direction

func update_body():    
    var input_direction = get_input()
    velocity = input_direction * speed
    move_and_slide()

func _physics_process(_delta):
    update_body()