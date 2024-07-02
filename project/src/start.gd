extends Node

const TUTORIAL = preload("res://src/maps/tutorial.tscn")
const MAIN = preload("res://src/maps/main.tscn")

func _ready():
    if OS.has_feature("tutorial"):
        get_tree().change_scene_to_packed.call_deferred(TUTORIAL)
    else:
        get_tree().change_scene_to_packed(MAIN)
