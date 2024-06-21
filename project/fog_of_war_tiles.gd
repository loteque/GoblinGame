extends TileMap

@export var reveal_radius : int = 5
@export var fog_tile_id : int = 0 # Replace with your fog tile ID
@export var revealed_tile_id : int = 1 # Replace with your revealed tile ID
@export var partially_revealed_tile_id : int = 2 # Replace with your partially revealed tile ID
@export var player: Node2D

var player_position : Vector2

func _ready():
    visible = true
    # Initially cover the entire map with fog
    #cover_map_with_fog()

func _process(_delta):
    # Update the player's position (you might get this from your player node)
    #var player = get_node("../Player") # Adjust the path as needed
    player_position = Vector2i(player.global_position) / Vector2i(tile_set.tile_size)

    # Reveal tiles around the player
    reveal_area(player_position, reveal_radius)

func cover_map_with_fog():
    for x in range(get_used_rect().position.x, get_used_rect().size.x):
        for y in range(get_used_rect().position.y, get_used_rect().size.y):
            set_cell(0, Vector2(x, y), fog_tile_id) # Layer 0 is assumed for fog layer
    return

func reveal_area(center : Vector2, radius : int):
    for x in range(center.x - radius, center.x + radius + 1):
        for y in range(center.y - radius, center.y + radius + 1):
            var distance = center.distance_to(Vector2(x, y))
            if distance <= radius:
                set_cell(0, Vector2(x, y), revealed_tile_id) # Layer 0 is assumed for revealed layer

    # Optionally, you might want to update partially revealed tiles
    for x in range(center.x - radius - 1, center.x + radius + 2):
        for y in range(center.y - radius - 1, center.y + radius + 2):
            if not is_cell_revealed(x, y):
                set_cell(0, Vector2(x, y), partially_revealed_tile_id) # Layer 0 is assumed for partially revealed layer

func is_cell_revealed(x: int, y: int) -> bool:
    # Check if a cell should be fully revealed
    return get_cell_source_id(0, Vector2i(x, y)) == revealed_tile_id
