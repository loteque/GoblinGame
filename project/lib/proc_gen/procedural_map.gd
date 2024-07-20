extends TileMap

@export var screen_resolution: Vector2 = Vector2(1920, 1080)
@export var num_screens_vert: int = 3
@export var num_screens_horiz: int = 3

var screen_map_size := Vector2i(1920, 1152)
var map_size = Vector2i(
    screen_map_size.x * num_screens_horiz, 
    screen_map_size.y * num_screens_vert
)
var num_cells: Vector2i = set_num_cells()
func set_num_cells() -> Vector2i:
    num_cells.x = map_size.x / tile_set.tile_size.x
    num_cells.y = map_size.y / tile_set.tile_size.y
    return num_cells
   
class ProcTile:
    var set_idx: int
    var source_id: int
    var source: TileSetSource
    var alt_tile_id: int
    var atlas_coords: Vector2i
    var sockets: Array

    func _init(
        _set_idx: int,
        _source_id: int, 
        _source: TileSetSource, 
        _alt_tile_id: int,
        _sockets: Array = [], 
        _atlas_coords: Vector2i = Vector2i.ZERO, 
        
    ):
        set_idx = _set_idx
        source_id = _source_id
        source = _source
        alt_tile_id = _alt_tile_id
        atlas_coords = _atlas_coords
        sockets = _sockets


class ProcTileSet:

    var map_tile_set: TileSet
    var tile_set_source_ids: Array[int]
    var tile_sockets_dict: Dictionary
    var tile_set: Array[ProcTile]


    func _init(_map_tile_set: TileSet, _tile_set_source_ids: Array[int]):
        map_tile_set = _map_tile_set
        tile_set_source_ids = _tile_set_source_ids
        tile_set = ProcTileSet.gen_proc_tile_set(map_tile_set, tile_set_source_ids)

    static func get_tile_alt_ids(source: TileSetSource) -> Array[int]:
        var tile_alt_ids: Array[int]
        for count in source.get_alternative_tiles_count(Vector2i.ZERO):
            var alt_id = source.get_alternative_tile_id(Vector2i.ZERO, count)
            tile_alt_ids.append(alt_id)
        return tile_alt_ids


    static func gen_proc_tile_set(
        _map_tile_set, 
        _tile_set_source_ids, 
    ) -> Array[ProcTile]:
        
        var proc_tile_set: Array[ProcTile]
        var idx = 0; for id in _tile_set_source_ids:
            var source: TileSetAtlasSource = _map_tile_set.get_source(id)
            var tile_alt_ids = ProcTileSet.get_tile_alt_ids(source)
            for alt_id in tile_alt_ids:

                var tile_data: TileData = source.get_tile_data(Vector2i.ZERO, alt_id)

                var sockets: Array = (
                    tile_data
                    .get_custom_data("sockets")
                )

                var proc_tile = ProcTile.new(
                    idx,
                    id,
                    source,
                    alt_id,
                    sockets
                )

                proc_tile_set.append(proc_tile)
                idx = idx + 1
        
        return proc_tile_set


# put all possible tile_set tile source ids in an array
var tile_set_source_ids: Array[int] = update_tile_set_source_ids(0)
func update_tile_set_source_ids(num_of_erase_idx):
    for tile_count in tile_set.get_source_count() - num_of_erase_idx:
        tile_set_source_ids.append(tile_set.get_source_id(tile_count))
    return tile_set_source_ids

#var sockets: Dictionary

var proc_tile_set: ProcTileSet = ProcTileSet.new(tile_set, tile_set_source_ids)

var proc_tile_set_idc: Array = gen_proc_tile_set_idc()
func gen_proc_tile_set_idc():
    var idc: Array[int] = []
    var i = 0
    for tile in proc_tile_set.tile_set:
        idc.append(i)
        i = i + 1
    return idc


var proc_tile_set_names: Array = [
    "full_river_top_bottom",
    "full_river_right_left",
    "angled_river_top_right",
    "angled_river_right_bottom",
    "angled_river_bottom_left",
    "angled_river_left_top",
    "half_river_top",
    "half_river_right",
    "half_river_bottom",
    "half_river_left",
    "dirt"
]

# TILE MAP POSSIBILITY SPACE
# create an Array of Dictionaries
# each dictionary maps Array position to an Array of tile source ids
var tile_map_possibility_space: Array[Dictionary] = gen_tile_map_possibility_space()
func gen_tile_map_possibility_space():
    var tmps_idx: int = 0
    for y in num_cells.y:
        for x in num_cells.x:
            tile_map_possibility_space.append(
                {
                    &"idx": tmps_idx,
                    &"ps": proc_tile_set_idc.slice(0),
                }
            )
            tmps_idx = tmps_idx + 1
    
    return tile_map_possibility_space

func get_tmps_idx_by_coords(x, y, x_distance, y_distance, num_indcs_in_grid_row) -> int:
    # (y + (y_distance)) * num_indcs_in_row + (x + (x_distance)) -formula by ghost_burrito
    var tmps_idx = (y + y_distance) * num_indcs_in_grid_row + (x + x_distance)
    
    return tmps_idx


func update_valid_tiles(tmps_idx, current_proc_tile, socket_idx):
    
    if tmps_idx > num_cells.x * num_cells.y - 1:
        return

    var current_tile = current_proc_tile
    var current_proc_tile_sockets = current_tile.sockets 
    var current_tile_set_idx = current_tile.set_idx

    var matching_socket_idx
    match socket_idx:
        0:
            matching_socket_idx = 2
        1:
            matching_socket_idx = 3
        2: 
            matching_socket_idx = 0
        3:
            matching_socket_idx = 1

    var matching_cell_ps: Array = tile_map_possibility_space[tmps_idx]["ps"]
    var tile_set_array = proc_tile_set.tile_set
    var erasables: Array = []
    
    for matching_tile_set_idx in matching_cell_ps:
        
        var _matching_tile_set_idx = matching_tile_set_idx
        var matching_tile = tile_set_array[_matching_tile_set_idx]
        var matching_tile_idx = matching_tile.set_idx
        var matching_tile_sockets = matching_tile.sockets
        var matching_socket = matching_tile_sockets[matching_socket_idx] 
        var current_tile_socket = current_proc_tile_sockets[socket_idx]
        var is_socket_match = matching_socket == current_tile_socket 
        
        if is_socket_match == false:
            erasables.append(matching_tile_idx)
        else:
            pass

    for erasable in erasables:
        # var start_clock_time = Time.get_ticks_usec()
        matching_cell_ps.erase(erasable)
        # print("erase: " + str(Time.get_ticks_usec() - start_clock_time))

        # VALID
        # var index_of_value = matching_cell_ps.find(erasable)    
        # assert(index_of_value == -1)

    pass
# /TILE MAP POSSIBLITY SPACE


func _gen_linear_wfc_map_019():

    var prev_tile
    var time_since_last_op = 0
    var time_accum := 0

    for y in num_cells.y:
        
        for x in num_cells.x:
            var iter_start_time = Time.get_ticks_usec()
            # set_cell(-1, Vector2(x,y), 1, Vector2.ZERO, 0)
            # continue

            # get the current possibility space index
            var current_tmps_index = get_tmps_idx_by_coords(x, y, 0, 0, num_cells.x)

            # get the possiblility space for the current cell
            var current_cell_ps = tile_map_possibility_space[current_tmps_index].get("ps")
            
            var current_cell_ps_names = current_cell_ps.map(func(idx): return proc_tile_set_names[idx])

            #if there is no valid cell gracefully exit
            if !current_cell_ps:
                
                return

            var tile_source_id: int
            var alt_tile_id: int
            var proc_tile: ProcTile

            if current_cell_ps.size() == 1:
                proc_tile = proc_tile_set.tile_set[current_cell_ps[0]]
                tile_source_id = proc_tile.source_id
                alt_tile_id = proc_tile.alt_tile_id
                set_cell(-1, Vector2(x,y), tile_source_id, Vector2.ZERO, alt_tile_id)
            
            else:
                
                # var start_clock_time = Time.get_ticks_usec() 
                
                var rnd_possibility_idx = randi_range(0, current_cell_ps.size() - 1)
                
                # print("randi_range: " + str(Time.get_ticks_usec() - start_clock_time))

                var ps_index = current_cell_ps[rnd_possibility_idx]
                proc_tile = proc_tile_set.tile_set[ps_index]
                tile_source_id = proc_tile.source_id
                alt_tile_id = proc_tile.alt_tile_id
                set_cell(-1, Vector2(x,y), tile_source_id, Vector2.ZERO, alt_tile_id)
                

            prev_tile = proc_tile_set_names[proc_tile.set_idx] 

            var next_row_x_ps_idx: int = get_tmps_idx_by_coords(x, y, 0, 1, num_cells.x)
            var right_x_ps_idx: int = get_tmps_idx_by_coords(x, y, 1, 0, num_cells.x)


            
            update_valid_tiles(
                next_row_x_ps_idx,
                proc_tile,
                2
            )


            update_valid_tiles( 
                right_x_ps_idx,
                proc_tile,
                1
            )

            print("iter_start_time: ", Time.get_ticks_usec() - iter_start_time)
            time_accum += Time.get_ticks_usec() - iter_start_time

            # DEBUG:
            $Debug.append("----------------")
            $Debug.append("TMPS index: " )
            $Debug.append(str(current_cell_ps), false)
            $Debug.append("set cell (coord): ")
            $Debug.append(str(x), false)
            $Debug.append(str(y), false, ",")
            $Debug.append("tile source: " + str(tile_source_id), false, "; ")
            # using a delay to visualize process
            # await get_tree().create_timer(0).timeout
    print("Total Time: ", time_accum)

func _clear_all_tiles():
    for y in num_cells.y:
        for x in num_cells.x:
            set_cell(-1, Vector2(x,y), -1, Vector2.ZERO)


func _ready():
    $Debug.append(str(num_cells))
    $Debug.append("Map Cell Size: (x,y):")
    $Debug.append(str(num_cells.x - 1))
    $Debug.append(str(num_cells.y - 1), false, ",")
    $Debug.append((str(tile_set)))
    $Debug.append(str(tile_map_possibility_space))

    # test_started.connect(_on_test_started)
    # test_started.emit()
    var max_tests = 1
    for i in max_tests:
        $Debug.append("----------------")
        $Debug.append("Test " + str(i) + " : ")
        $Debug.append("----------------")
        _clear_all_tiles()
        tile_map_possibility_space.clear()
        
        var gen_ps_space_start_time = Time.get_ticks_usec()
        gen_tile_map_possibility_space()
        print("gen_ps_start_time: ", Time.get_ticks_usec() - gen_ps_space_start_time)
        
        _gen_linear_wfc_map_019()

        $Debug.append("MAP GENERATION FINSISHED")
        await get_tree().create_timer(1).timeout


    # VALID
    # var set_idx = 6
    # var proc_tile = proc_tile_set.tile_set[set_idx]
    # var proc_tile_set_idx = proc_tile.set_idx
    # var proc_tile_source_id = proc_tile.source_id
    # var proc_tile_alt_id = proc_tile.alt_tile_id
    # set_cell(-1, Vector2(0,0), proc_tile_source_id, Vector2.ZERO, proc_tile_alt_id)
    # $Debug.append(str(proc_tile_source_id))
    # $Debug.append(str(proc_tile_alt_id))
    # $Debug.append(str(proc_tile_set_idx))
    # var procts = proc_tile_set.tile_set
    # var procts_tile = procts[set_idx]
    # var procts_tile_setidx = procts_tile.set_idx
    # pass

