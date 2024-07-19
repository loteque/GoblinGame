extends TileMap


@export var screen_resolution: Vector2 = Vector2(1920, 1080)
@export var num_screens_vert: int = 2
@export var num_screens_horiz: int = 1


var map_size = Vector2i(
    round(screen_resolution.x * num_screens_horiz), 
    round(screen_resolution.y * num_screens_vert)
)


var num_cells = map_size / tile_set.tile_size

func _gen_linear_dirt_map():
    for y in num_cells.y:
        for x in num_cells.x:
            $Debug.append("set cell (index): " + str(x))
            $Debug.append(str(y), false, ",")
            set_cell(-1, Vector2(x,y),7, Vector2.ZERO)
            await get_tree().create_timer(.1).timeout
            x = x - 1
        y = y - 1


func _gen_linear_map_all_tiles():
    var num_erase_idx := 2
    var tile_idx = 0
    var tile_id: int 

    for y in num_cells.y:
        for x in num_cells.x:
            
            tile_id = tile_set.get_source_id(tile_idx)

            $Debug.append("set cell (index): " + str(x))
            $Debug.append(str(y), false, ",")
            $Debug.append("tile source: " + str(tile_id), false, "; ")
            
            set_cell(-1, Vector2(x,y), tile_id, Vector2.ZERO)
           
            await get_tree().create_timer(.1).timeout
            x = x - 1
            
            if tile_idx > tile_set.get_source_count() - num_erase_idx:
                tile_idx = 0
            else:
                tile_idx = tile_idx + 1


        y = y - 1


func _gen_linear_random_map():
    var num_of_erase_idx := 2
    var rand_tile_idx: int
    var rand_source_id: int

    for y in num_cells.y:
        for x in num_cells.x:

            rand_tile_idx = randi_range(0, tile_set.get_source_count() - num_of_erase_idx)
            rand_source_id = tile_set.get_source_id(rand_tile_idx)
            
            set_cell(-1, Vector2(x,y), rand_source_id, Vector2.ZERO)

            $Debug.append("set cell (index): " + str(x))
            $Debug.append(str(y), false, ",")
            $Debug.append("tile source: " + str(rand_source_id), false, "; ")
           
            await get_tree().create_timer(.1).timeout
            x = x - 1


        y = y - 1

class ProcTile:
    var source_id: int
    var source: TileSetSource
    var alt_tile_id: int
    var atlas_coords: Vector2i
    var invalid_left: Array[int]
    var invalid_right: Array[int]

    func _init(
        _source_id: int, 
        _source: TileSetSource, 
        _alt_tile_id: int, 
        _atlas_coords: Vector2i = Vector2i.ZERO, 
        _invalid_left: Array[int] = [], 
        _invalid_right: Array[int] = []
    ):
        source_id = _source_id
        source = _source
        alt_tile_id = _alt_tile_id
        atlas_coords = _atlas_coords
        invalid_left = _invalid_left
        invalid_right = _invalid_right

class ProcTileSet:
    var tile_set: Array[ProcTile]

    func _init(_tile_set: Array[ProcTile]):
        tile_set = _tile_set


func get_tile_alt_ids(source: TileSetSource) -> Array[int]:
    var tile_alt_ids: Array[int]
    for count in source.get_alternative_tiles_count(Vector2i.ZERO):
        var alt_id = source.get_alternative_tile_id(Vector2i.ZERO, count)
        tile_alt_ids.append(alt_id)
    return tile_alt_ids

func gen_proc_tile_set() -> Array[ProcTile]:
    var proc_tile_set: Array[ProcTile]
    for id in tile_set_source_ids:
        var source = tile_set.get_source(id)
        for alt_id in get_tile_alt_ids(source): 
            var proc_tile = ProcTile.new(
                id,
                source,
                alt_id,
            )
            proc_tile_set.append(proc_tile)
    
    return proc_tile_set

# ruleset
var ruleset: Array[Dictionary] = [
    {
        "source_id": 1,
        0: {
            "invalid_down": {
                0: [7],
                90: [4,6,7],
                180: [4,6,7],
                270: [4,6,7],   
            },
            "invalid_right": {
                0: [1,4,6],
                90: [1,4,6],
                180: [1,4,6],
                270: [1,4,6],                   
            },
        },
        90: {
            "invalid_down": {
                0: [1,4,6],
                90: [1],
                180: [1],
                270: [1,4],                   
            },
            "invalid_right": {
                0: [1,4,6,7],
                90: [4,6,7],
                180: [1,4,6,7],
                270: [7],   
            },
        },
        180: {
            "invalid_down": {
                0: [1,5,6],
                90: [7],
                180: [7],
                270: [7],   
            },
            "invalid_right": {
                0: [1],
                90: [7],
                180: [7],
                270: [7],   
            },
        },
        270: {
            "invalid_down": {
                0: [1,4,6],
                90: [7],
                180: [7],
                270: [7],   
            },
            "invalid_right": {
                0: [1],
                90: [7],
                180: [7],
                270: [7],   
            },
        },
    },
    {
        "source_id": 4,
        0: {
            "invalid_down": {
                0: [1,4,6],
                90: [7],
                180: [7],
                270: [7],
            },
            "invalid_right": {
                0: [1,4,6,7],
                90: [7],
                180: [7],
                270: [7],
            },
        },
        90: {
            "invalid_down": {
                0: [1,4,6],
                90: [7],
                180: [7],
                270: [7],
            },
            "invalid_right": {
                0: [1,4,6,7],
                90: [7],
                180: [7],
                270: [7],
            }
        },
        180: {
            "invalid_down": {
                0: [1,4,6],
                90: [7],
                180: [7],
                270: [7],
            },
            "invalid_right": {
                0: [1,4,6,7],
                90: [7],
                180: [7],
                270: [7],
            }
        },
        270: {
            "invalid_down": {
                0: [1,4,6],
                90: [7],
                180: [7],
                270: [7],
            },
            "invalid_right": {
                0: [1,4,6,7],
                90: [7],
                180: [7],
                270: [7],
            }
        },
    },
    {
        "source_id": 6,
        0: {
            "invalid_down": {
                0: [1,4,6],
                90: [7],
                180: [7],
                270: [7],
            },
            "invalid_right": {
                0: [1,4,6],
                90: [7],
                180: [7],
                270: [7],
            },
        },
        90: {
            "invalid_down": {
                0: [1,4,6],
                90: [7],
                180: [7],
                270: [7],
            },
            "invalid_right": {
                0: [1,4,6],
                90: [7],
                180: [7],
                270: [7],
            },
        },
        180: {
            "invalid_down": {
                0: [1,4,6],
                90: [7],
                180: [7],
                270: [7],
            },
            "invalid_right": {
                0: [1,4,6],
                90: [7],
                180: [7],
                270: [7],
            },
        },
        270: {
            "invalid_down": {
                0: [1,4,6],
                90: [7],
                180: [7],
                270: [7],
            },
            "invalid_right": {
                0: [1,4,6],
                90: [7],
                180: [7],
                270: [7],
            },
        },
    },
    {
        "source_id": 7,
        0: {
            "invalid_down": {
                0: [1,4,6],
                90: [7],
                180: [7],
                270: [7],
            },
            "invalid_right": {
                0: [],
                90: [7],
                180: [7],
                270: [7],
            },        
        },
        90: {
            "invalid_down": {
                0: [1,4,6],
                90: [7],
                180: [7],
                270: [7],
            },
            "invalid_right": {
                0: [],
                90: [7],
                180: [7],
                270: [7],
            },        
        },
        180: {
            "invalid_down": {
                0: [1,4,6],
                90: [7],
                180: [7],
                270: [7],
            },
            "invalid_right": {
                0: [],
                90: [7],
                180: [7],
                270: [7],
            },        
        },
        270: {
            "invalid_down": {
                0: [1,4,6],
                90: [7],
                180: [7],
                270: [7],
            },
            "invalid_right": {
                0: [],
                90: [7],
                180: [7],
                270: [7],
            },        
        },
    },
]


# put all possible tile_set tile source ids in an array
var tile_set_source_ids: Array = update_tile_set_source_ids(0)
func update_tile_set_source_ids(num_of_erase_idx):
    for tile_count in tile_set.get_source_count() - num_of_erase_idx:
        tile_set_source_ids.append(tile_set.get_source_id(tile_count))
    return tile_set_source_ids

# create an Array of Dictionaries
# each dictionary maps Array position to an Array of tile source ids at max entropy
var tile_map_possibility_space: Array[Dictionary] = gen_tile_map_possibility_space()
func gen_tile_map_possibility_space():
    var tmps_idx: int = 0
    for y in num_cells.y:
        for x in num_cells.x:
            tile_map_possibility_space.append(
                {
                    &"idx": tmps_idx,
                    &"ps": {
                        0: tile_set_source_ids.slice(0),
                        90: tile_set_source_ids.slice(0),
                        180: tile_set_source_ids.slice(0),
                        270: tile_set_source_ids.slice(0),
                    },
                    &"prev_ps": [],
                }
            )
            tmps_idx = tmps_idx + 1
    
    return tile_map_possibility_space

func get_tmps_idx_by_coords(x, y, x_distance, y_distance, num_indcs_in_grid_row) -> int:
    # (y + (y_distance)) * num_indcs_in_row + (x + (x_distance)) -formula by ghost_burrito
    var tmps_idx = (y + y_distance) * num_indcs_in_grid_row + (x + x_distance)
    
    return tmps_idx

func update_valid_tiles(tmps, ruleset, tile_source_id, target_ps_idx, position_str, rotation_deg: int = 0):
    
    # update the right and down tiles' possibility space
    var current_ruleset_id
    for rule in ruleset:
        var is_match = rule.get("source_id") == tile_source_id
        if is_match: 
            current_ruleset_id = tile_source_id

    # valid ruleset idx is equal to the index of tile_set source id in tile_set_source_ids 
    var current_ruleset_idx = tile_set_source_ids.find(current_ruleset_id)


    if target_ps_idx < tmps.size():
        
        # set right x possibiliy space
        $Debug.append("next invalid rules: ")
        var ps_rot_deg = 0
        var ruleset_at_pos_str = ruleset[current_ruleset_idx][rotation_deg][position_str]
        for rule_idx in ruleset_at_pos_str:
            ps_rot_deg = ps_rot_deg + 90
            if ps_rot_deg > 270: ps_rot_deg = 0
            for rule_at_rotation in ruleset_at_pos_str[rule_idx]:
                var ps_dict = tmps[target_ps_idx]
                var ps_rot_dict = ps_dict["ps"]
                var ps_at_rot = ps_rot_dict[ps_rot_deg]
                ps_at_rot.erase(rule_at_rotation)
                $Debug.append(str(ps_rot_deg), false)
                $Debug.append(str(rule_at_rotation), false, ", ")
        

        $Debug.append("set ruleset: ")
        $Debug.append(str(tmps[target_ps_idx]["ps"]), false)
    
    pass

func get_rnd_alt_tile_id(tile_source: TileSetSource):
    var alt_tiles_count = tile_source.get_alternative_tiles_count(Vector2i(0,0))
    var rnd_alt_tile_id = randi_range(0,alt_tiles_count)
    return rnd_alt_tile_id

func get_rnd_ps_rotation(ps_rotation) -> Array:
    var rnd_ps_rotation: Array = []
    for rot in ps_rotation:
        if ps_rotation[rot].size() > 0:
            rnd_ps_rotation.append(ps_rotation[rot])
    var rnd_ps_rotation_idx = randi_range(0, rnd_ps_rotation.size() - 1)
    if rnd_ps_rotation_idx > -1:
        rnd_ps_rotation = rnd_ps_rotation[rnd_ps_rotation_idx]
    return rnd_ps_rotation

func _gen_linear_wfc_map_020():
    
    var prev_cell_ps

    for y in num_cells.y:

        # generate tiles in cells using WFC    
        for x in num_cells.x:

            # get the current possibility space index
            # (y + (y_distance)) * num_indcs_in_row + (x + (x_distance)) -formula by ghost_burrito
            var current_tmps_index = get_tmps_idx_by_coords(x, y, 0, 0, num_cells.x)

            # get the possiblility space for the current cell
            var current_cell_ps = tile_map_possibility_space[current_tmps_index].get("ps")
            
            #if there is no valid cell gracefully exit
            if !current_cell_ps:

                $Debug.append("----------------")
                $Debug.append("stoppped; current_cell_ps: " + str(current_cell_ps))
                $Debug.append("prev_cell_ps: " + str(prev_cell_ps))
                
                return


            # set cell tile source id
            var rnd_ps_rotation = get_rnd_ps_rotation(current_cell_ps)
            var tile_source_rotation
            var tile_source_id
            var tile_source
            var rnd_alt_tile_id

            if rnd_ps_rotation.size() == 1:
                tile_source_id = rnd_ps_rotation[0]
                tile_source = tile_set.get_source(tile_source_id)
                rnd_alt_tile_id = get_rnd_alt_tile_id(tile_source)
                set_cell(-1, Vector2(x,y), tile_source_id, Vector2.ZERO, rnd_alt_tile_id)
            else:
                var rnd_possibility_idx = randi_range(0, rnd_ps_rotation.size() - 1)
                var rnd_source_id = rnd_ps_rotation[rnd_possibility_idx]
                tile_source_id = rnd_source_id
                tile_source = tile_set.get_source(tile_source_id)
                rnd_alt_tile_id = get_rnd_alt_tile_id(tile_source)
                set_cell(-1, Vector2(x,y), tile_source_id, Vector2.ZERO, rnd_alt_tile_id)
                
                #DEBUG
                prev_cell_ps = current_cell_ps

            var rot_deg: int
            match rnd_alt_tile_id:
                1:
                    rot_deg = 90
                2:
                    rot_deg = 180
                3:
                    rot_deg = 270
                _:
                    rot_deg = 0

            var next_row_x_ps_idx: int = (y + 1) * num_cells.x + (x + 0)
            var right_x_ps_idx: int = (y + 0) * num_cells.x + (x + 1)

            update_valid_tiles( 
                tile_map_possibility_space, 
                ruleset, 
                tile_source_id,
                next_row_x_ps_idx,
                "invalid_down",
                rot_deg
            )

            update_valid_tiles( 
                tile_map_possibility_space, 
                ruleset, 
                tile_source_id,
                right_x_ps_idx,
                "invalid_right",
                rot_deg
            )


            # DEBUG:
            $Debug.append("----------------")
            $Debug.append("TMPS index: " )
            $Debug.append(str(current_tmps_index), false)
            $Debug.append("current ruleset: ")
            $Debug.append(str(current_cell_ps), false)
            $Debug.append("set cell (coord): ")
            $Debug.append(str(x), false)
            $Debug.append(str(y), false, ",")
            $Debug.append("tile source: " + str(tile_source_id), false, "; ")
            # using a delay to visualize process
            # await get_tree().create_timer(.1).timeout

            x = x - 1
        
        y = y - 1


func _clear_all_tiles():
    for y in num_cells.y:
        for x in num_cells.x:
            set_cell(-1, Vector2(x,y), - 1, Vector2.ZERO)

signal test_started

func _ready():
    $Debug.append("Map Cell Size: (x,y):")
    $Debug.append(str(num_cells.x))
    $Debug.append(str(num_cells.y), false, ",")
    $Debug.append((str(tile_set)))
    $Debug.append(str(tile_map_possibility_space))

    var proc_tile_set = ProcTileSet.new(gen_proc_tile_set())
    $Debug.append(str(proc_tile_set.tile_set))

    # test_started.connect(_on_test_started)

    # test_started.emit()

    # _gen_linear_dirt_map()
    # _gen_linear_map_all_tiles()
    # _gen_linear_random_map() 
    # _gen_linear_wfc_map_020()

var num_tests = 1
func _on_test_started():
    if num_tests < 4:
        await get_tree().create_timer(1).timeout
        $Debug.append("----------------")
        $Debug.append("Test " + str(num_tests) + " : ")
        $Debug.append("----------------")
        _clear_all_tiles()
        tile_map_possibility_space.clear()
        gen_tile_map_possibility_space()
        _gen_linear_wfc_map_020()
        $Debug.append("MAP GENERATION FINSISHED")
        test_started.emit()
        num_tests = num_tests + 1
    else:
        $Debug.append("TEST COMPLETE")

