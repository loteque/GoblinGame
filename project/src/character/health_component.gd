extends Node

class_name HealthComponent

@export var max_health: int = 10
@export var current_health: int = 10

signal health_changed(new_val: int)

func receive_attack(attack: Attack):
    current_health -= attack.damage
    print(
        str(self.get_parent().name)
        + " took damage. health: "
        + str(current_health)
    )
    health_changed.emit(current_health)
    if current_health <= 0:
        die()

func die():
    get_parent().died.emit()
