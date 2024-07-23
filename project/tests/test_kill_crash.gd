extends Node2D

@onready var enemy_base = $DemoLevel/Base

func _ready():
    #ResourceManager.change_scrap(ResourceManager.Team.CPU, 40)
    enemy_base.spawner.spawn_unit()
    enemy_base.spawner.spawn_unit()
    enemy_base.spawner.spawn_unit()
    enemy_base.spawner.spawn_unit()
    
