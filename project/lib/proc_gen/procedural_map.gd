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
                   &"ps": tile_set_source_ids.slice(0),
                   &"prev_ps": [],
                }
            )
            tmps_idx = tmps_idx + 1
    
    return tile_map_possibility_space


func update_valid_tiles(x, y, tmps, ruleset, tile_source_id):
    
    # update the right and down tiles' possibility space
    var current_ruleset_id
    for rule in ruleset:
        var is_match = rule.get("source_id") == tile_source_id
        if is_match: 
            current_ruleset_id = tile_source_id

    # valid ruleset idx is equal to the index of tile_set source id in tile_set_source_ids 
    var current_ruleset_idx = tile_set_source_ids.find(current_ruleset_id)
    
    # get next row at x possibiliy space idx
    var next_row_x_ps_idx: int = (y + 1) * num_cells.x + (x + 0)
    if next_row_x_ps_idx < tmps.size():
        
        # set next row at x possibiliy space
        $Debug.append("down invalid rules: ")
        for rule in ruleset[current_ruleset_idx].get("invalid_down"):
            var dict = tmps[next_row_x_ps_idx]
            var array = dict.get("ps")
            array.erase(rule)

            $Debug.append(str(rule), false, ", ")
        
        $Debug.append("next down ruleset: ")
        $Debug.append(str(tmps[next_row_x_ps_idx]["ps"]), false)

    # get right x possibility space idx
    var right_x_ps_idx: int = (y + 0) * num_cells.x + (x + 1)
    if right_x_ps_idx < tmps.size():
        
        # set right x possibiliy space
        $Debug.append("right invalid rules: ")
        for rule in ruleset[current_ruleset_idx].get("invalid_right"):
            var dict = tmps[right_x_ps_idx]
            var array = dict.get("ps")
            array.erase(rule)

            $Debug.append(str(rule), false, ", ")
        

        $Debug.append("next right ruleset: ")
        $Debug.append(str(tmps[right_x_ps_idx]["ps"]), false)
    
    pass

func _gen_linear_wfc_map_020():

    # ruleset
    var ruleset: Array[Dictionary] = [
        {
            "source_id": 1,
            "valid_down": [1,4,5,6],
            "invalid_down": [7],
            "valid_right": [4,6,7],
            "invalid_right": [1,5]
        },
        {
            "source_id": 4,
            "valid_down": [7],
            "invalid_down": [1,4,5,6],
            "valid_right": [5],
            "invalid_right": [1,4,6,7]
        },
        {
            "source_id": 5,
            "valid_down": [7],
            "invalid_down": [1,4,5,6],
            "valid_right": [7],
            "invalid_right": [1,4,5,6]
        },
        {
            "source_id": 6,
            "valid_down": [7],
            "invalid_down": [1,4,5,6],
            "valid_right": [7],
            "invalid_right": [1,4,5,6]
        },
        {
            "source_id": 7,
            "valid_down": [7],
            "invalid_down": [1,4,5,6],
            "valid_right": [1,4,6,7],
            "invalid_right": [5]
        },
    ]
    
    var prev_cell_ps

    for y in num_cells.y:

        # generate tiles in cells using WFC    
        for x in num_cells.x:

            # get the current possibility space index
            # (y + (y_distance)) * num_indcs_in_row + (x + (x_distance)) -formula by ghost_burrito
            var current_tmps_index = (y + 0) * num_cells.x + (x + 0)
            
            # get the possiblility space for the current cell
            var current_cell_ps = tile_map_possibility_space[current_tmps_index].get("ps")
            

            if !current_cell_ps:

                $Debug.append("----------------")
                $Debug.append("stoppped; current_cell_ps: " + str(current_cell_ps))
                $Debug.append("prev_cell_ps: " + str(prev_cell_ps))
                
                return


            # set cell tile source id
            var tile_source_id

            if current_cell_ps.size() - 1 == 0:
                tile_source_id = current_cell_ps[0]
                set_cell(-1, Vector2(x,y), tile_source_id, Vector2.ZERO)
            else:
                var rnd_possibility_idx = randi_range(0, current_cell_ps.size() - 1)
                var rnd_source_id = current_cell_ps[rnd_possibility_idx]
                tile_source_id = rnd_source_id
                set_cell(-1, Vector2(x,y), tile_source_id, Vector2.ZERO)
                
                #DEBUG
                prev_cell_ps = current_cell_ps

            update_valid_tiles(
                x, 
                y, 
                tile_map_possibility_space, 
                ruleset, 
                tile_source_id
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
            set_cell(-1, Vector2(x,y), -1, Vector2.ZERO)

signal test_started

func _ready():
    $Debug.append("Map Cell Size: (x,y):")
    $Debug.append(str(num_cells.x))
    $Debug.append(str(num_cells.y), false, ",")
    $Debug.append((str(tile_set)))
    $Debug.append(str(tile_map_possibility_space))

    test_started.connect(_on_test_started)

    test_started.emit()

    # _gen_linear_dirt_map()
    # _gen_linear_map_all_tiles()
    # _gen_linear_random_map() 
    # _gen_linear_wfc_map_020()

    
    
    # for i in 10:
    #     await self.map_generation_finished
    #     $Debug.append("MAP GENERATION FINSISHED")
    #     await get_tree().create_timer(.5).timeout
    #     $Debug.append("----------------")
    #     $Debug.append("Test " + str(i) + " : ")
    #     $Debug.append("----------------")
    #     _clear_all_tiles()
    #     _gen_linear_wfc_map_020()
    #     i+=i

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

