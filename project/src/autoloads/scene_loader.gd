extends Node

const MAIN = preload("res://src/maps/main.tscn")
const TUTORIAL = preload("res://src/maps/tutorial.tscn")

enum Level {
    MAIN,
    TUTORIAL
}

var levels_dict: Dictionary = {
    Level.MAIN: MAIN,
    Level.TUTORIAL: TUTORIAL
}

func load_scene(level: Level):
    var scene = levels_dict[level]
    get_tree().change_scene_to_packed(scene)
