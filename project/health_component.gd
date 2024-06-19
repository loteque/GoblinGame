extends Node

class_name HealthComponent

@export var max_health: int = 10
@export var current_health: int = 10

func receive_attack(attack: Attack):
    current_health -= attack.damage
    #health_updated.emit(health)
    # signal attacked
    print(
        str(self.get_parent().name)
        + " took damage. health: "
        + str(current_health)
    )
    if current_health <= 0:
        die()

func die():
    # Handle death state
    get_parent().queue_free()
    pass
    #signal death
