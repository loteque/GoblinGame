extends State

## Collect target
class_name CollectState

@onready var animated_sprite = %AnimatedSprite2D
@onready var actor_core = %ActorCore
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer

var target: Node2D

func is_on_cooldown():
    return not attack_cooldown_timer.is_stopped()

func attack():
    if not target == null and !is_on_cooldown():
        attack_cooldown_timer.start()
        target.receive_attack(Attack.new())

func enter_state(data: Dictionary = {}):
    super.enter_state()
    target = data.get("target")
    animated_sprite.play("collect_scrap")

func exit_state():
    super.exit_state()
    animated_sprite.stop()

func update(delta):
    attack()
