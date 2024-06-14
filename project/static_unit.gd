extends StaticBody2D
class_name StaticUnit

@export var upgrada_name_label: Label
@export var upgrade_value_label: Label

var upgrader: Upgradable

class Upgradable:
    var max_u: int
    var name: String
    var value: float

    signal upgraded(value: float)

    func upgrade(new_value: float = value):
        if max_u >= 1:
            upgraded.emit(name, new_value)

    func _init(upgradable_name: String, max_upgrades: int, upgradable_value: float = 0,):
        name = upgradable_name
        value = upgradable_value
        max_u = max_upgrades

func _ready():
    upgrader = Upgradable.new("Level", 1, 1.0)
    upgrader.upgraded.connect(_on_upgraded)

func _on_upgraded(upgrade_name, value):
    if upgrada_name_label.text == upgrade_name:
        upgrade_value_label.text = str(value)
    

