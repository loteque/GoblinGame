extends Node

const MAIN = preload("res://src/maps/main.tscn")
const TUTORIAL = preload("res://src/maps/tutorial.tscn")

## In sequential order
enum Level {
    TUTORIAL,
    MAIN
}

var levels_dict: Dictionary = {
    Level.MAIN: MAIN,
    Level.TUTORIAL: TUTORIAL
}

## In sequential order
var levels = [Level.TUTORIAL, Level.MAIN]

var current_level: Level = Level.TUTORIAL

func load_scene(level: Level):
    var scene = levels_dict[level]
    get_tree().change_scene_to_packed(scene)

func get_next_level():
    var final_level = levels[levels.size() - 1]
    if final_level == current_level:
        return current_level
    current_level = levels[current_level + 1]
    return current_level

func load_next_level():
    var next_level = get_next_level()
    load_scene(next_level)
    play_level()

func play_level():
    await get_tree().create_timer(0).timeout
    var menu = get_tree().get_first_node_in_group("MainMenu")
    menu.play_level()
