extends TileMap

@export var screen_resolution: Vector2 = Vector2(1920, 1080)
@export var num_screens_vert: int = 2
@export var num_screens_horiz: int = 1


var map_size = Vector2i(
    round(screen_resolution.x * num_screens_horiz), 
    round(screen_resolution.y * num_screens_vert)
)
var num_cells = map_size / tile_set.tile_size


class ProcTile:
    var source_id: int
    var source: TileSetSource
    var alt_tile_id: int
    var atlas_coords: Vector2i
    var sockets: Array

    func _init(
        _source_id: int, 
        _source: TileSetSource, 
        _alt_tile_id: int,
        _sockets: Array = [], 
        _atlas_coords: Vector2i = Vector2i.ZERO, 
        
    ):
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


    func _init(_map_tile_set: TileSet, _tile_set_source_ids: Array[int], _tile_sockets_dict: Dictionary):
        map_tile_set = _map_tile_set
        tile_set_source_ids = _tile_set_source_ids
        tile_sockets_dict = _tile_sockets_dict
        tile_set = ProcTileSet.gen_proc_tile_set(map_tile_set, tile_set_source_ids, tile_sockets_dict)

    static func get_tile_alt_ids(source: TileSetSource) -> Array[int]:
        var tile_alt_ids: Array[int]
        for count in source.get_alternative_tiles_count(Vector2i.ZERO):
            var alt_id = source.get_alternative_tile_id(Vector2i.ZERO, count)
            tile_alt_ids.append(alt_id)
        return tile_alt_ids


    static func gen_proc_tile_set(
        _map_tile_set, 
        _tile_set_source_ids, 
        _tile_sockets_dict: Dictionary
    ) -> Array[ProcTile]:
    
        var proc_tile_set: Array[ProcTile]
        for id in _tile_set_source_ids:
            var source = _map_tile_set.get_source(id)
            var tile_alt_ids = ProcTileSet.get_tile_alt_ids(source)
            for alt_id in tile_alt_ids: 
                var proc_tile = ProcTile.new(
                    id,
                    source,
                    alt_id,
                    _tile_sockets_dict[id]
                )
                proc_tile_set.append(proc_tile)
        
        return proc_tile_set


var sockets: Dictionary = {
    0: [1,0,1,0],
    1: [0,1,0,1],
    2: [1,1,0,0],
    3: [0,1,1,0],
    4: [0,0,1,1],
    5: [1,0,0,1],
    6: [1,0,0,0],
    7: [0,1,0,0],
    8: [0,0,1,0],
    9: [0,0,0,1],
    10: [0,0,0,0]
}


# put all possible tile_set tile source ids in an array
var tile_set_source_ids: Array[int] = update_tile_set_source_ids(0)
func update_tile_set_source_ids(num_of_erase_idx):
    for tile_count in tile_set.get_source_count() - num_of_erase_idx:
        tile_set_source_ids.append(tile_set.get_source_id(tile_count))
    return tile_set_source_ids


var proc_tile_set: ProcTileSet = ProcTileSet.new(tile_set, tile_set_source_ids, sockets)

var proc_tile_set_idc: Array = gen_proc_tile_set_idc()
func gen_proc_tile_set_idc():
    var idc: Array[int] = []
    var i = 0
    for tile in proc_tile_set.tile_set:
        idc.append(i)
        i = i + 1
    return idc

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
                    &"prev_ps": [],
                }
            )
            tmps_idx = tmps_idx + 1
    
    return tile_map_possibility_space

func get_tmps_idx_by_coords(x, y, x_distance, y_distance, num_indcs_in_grid_row) -> int:
    # (y + (y_distance)) * num_indcs_in_row + (x + (x_distance)) -formula by ghost_burrito
    var tmps_idx = (y + y_distance) * num_indcs_in_grid_row + (x + x_distance)
    
    return tmps_idx

func update_valid_tiles(tmps_idx, current_proc_tile_sockets, edge_idx):
    if tmps_idx > 24:
        return

    var ps = tile_map_possibility_space[tmps_idx]["ps"]
    
    var matching_edge_idx
    match edge_idx:
        0:
            matching_edge_idx = 2
        1:
            matching_edge_idx = 3
        2: 
            matching_edge_idx = 0
        3:
            matching_edge_idx = 1

    var matching_edge_sockets = current_proc_tile_sockets[matching_edge_idx]
    var i = 0
    for tile_set_idx in ps:
        var tile_set_array = proc_tile_set.tile_set
        var proc_tile = tile_set_array[tile_set_idx]
        var tile_sockets = proc_tile["sockets"]
        var edge_socket = tile_sockets[edge_idx] 
        if edge_socket != matching_edge_sockets:
            ps.remove_at(i)
            i = i + 1
        

    
    pass
# /TILE MAP POSSIBLITY SPACE


func _gen_linear_wfc_map_019(proc_tile_set: ProcTileSet):
    
    var prev_cell_ps

    for y in num_cells.y:
   
        for x in num_cells.x:

            # get the current possibility space index
            var current_tmps_index = get_tmps_idx_by_coords(x, y, 0, 0, num_cells.x)

            # get the possiblility space for the current cell
            var current_cell_ps = tile_map_possibility_space[current_tmps_index].get("ps")
            
            #if there is no valid cell gracefully exit
            if !current_cell_ps:

                $Debug.append("----------------")
                $Debug.append("stoppped; current_cell_ps: " + str(current_cell_ps))
                $Debug.append("prev_cell_ps: " + str(prev_cell_ps))
                
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
                var rnd_possibility_idx = randi_range(0, current_cell_ps.size())
                proc_tile = proc_tile_set.tile_set[rnd_possibility_idx]
                tile_source_id = proc_tile.source_id
                alt_tile_id = proc_tile.alt_tile_id
                set_cell(-1, Vector2(x,y), tile_source_id, Vector2.ZERO, alt_tile_id)
                
                #DEBUG
                prev_cell_ps = current_cell_ps

            var next_row_x_ps_idx: int = get_tmps_idx_by_coords(x, y, 0, 1, num_cells.x)
            var right_x_ps_idx: int = get_tmps_idx_by_coords(x, y, 1, 0, num_cells.x)
            var current_tile_sockets = proc_tile.sockets

            update_valid_tiles(
                next_row_x_ps_idx,
                current_tile_sockets,
                2
            )

            update_valid_tiles( 
                right_x_ps_idx,
                current_tile_sockets,
                1
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

    test_started.connect(_on_test_started)
    test_started.emit()


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
        _gen_linear_wfc_map_019(proc_tile_set)
        $Debug.append("MAP GENERATION FINSISHED")
        test_started.emit()
        num_tests = num_tests + 1
    else:
        $Debug.append("TEST COMPLETE")

