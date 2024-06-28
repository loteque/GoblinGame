extends Node

const TUTORIAL = preload("res://tutorial.tscn")
const MAIN = preload("res://main.tscn")

func _ready():
    if OS.has_feature("tutorial") or true:
        get_tree().change_scene_to_packed.call_deferred(TUTORIAL)
    else:
        get_tree().change_scene_to_packed(MAIN)
