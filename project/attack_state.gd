extends State

## Collect target
class_name CollectState

@onready var animated_sprite = %AnimatedSprite2D

@onready var actor_core = %ActorCore

var target: Node2D

@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer

func is_on_cooldown():
    return not attack_cooldown_timer.is_stopped()

func attack():
    if not target == null and !is_on_cooldown():
        pass
        attack_cooldown_timer.start()
        target.receive_attack(Attack.new())
        #ResourceManager.scrap_collected.emit(actor_core.actor.team)

func enter_state(data: Dictionary = {}):
    super.enter_state()
    target = data.get("target")
    animated_sprite.play("collect_scrap")
    #if target:
        #animated_sprite.play("collect_scrap")

func exit_state():
    super.exit_state()
    animated_sprite.stop()

func update(delta):
    attack()
