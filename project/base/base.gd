@tool
extends StaticUnit

const ENEMY_BASE_TEXTURE = preload ("res://base/enemy-base-temp.png")
const PLAYER_BASE_TEXTURE = preload ("res://base/base-temp.png")

enum Team {
    PLAYER,
    ENEMY
}

@export var team: Team
@export var base_sprite = Sprite2D

func display_base_sprite():
    if base_sprite:
        if team == Team.PLAYER:
            base_sprite.texture = PLAYER_BASE_TEXTURE
        else:
            base_sprite.texture = ENEMY_BASE_TEXTURE

func _ready():
    display_base_sprite()

func receive_scrap():
    pass
