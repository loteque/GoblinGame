extends TileMap

@export var screen_resolution: Vector2 = Vector2(1920, 1080)
@export var num_screens_horiz: int = 3
@export var num_screens_vert: int = 2
@export var scrap_scene: PackedScene

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
    var valid_top: Array
    var valid_right: Array
    var valid_left: Array
    var valid_bottom: Array

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
    var tile_set: Array[ProcTile]


    func _init(_map_tile_set: TileSet):
        map_tile_set = _map_tile_set
        tile_set = ProcTileSet.gen_proc_tile_set(map_tile_set)

    static func get_tile_alt_ids(source: TileSetSource) -> Array[int]:
        var tile_alt_ids: Array[int]
        for count in source.get_alternative_tiles_count(Vector2i.ZERO):
            var alt_id = source.get_alternative_tile_id(Vector2i.ZERO, count)
            tile_alt_ids.append(alt_id)
        return tile_alt_ids


    static func gen_proc_tile_set(_map_tile_set: TileSet) -> Array[ProcTile]:
        
        var proc_tile_set: Array[ProcTile]
        var idx = 0; for tile_count in _map_tile_set.get_source_count():
            
            var id: int = _map_tile_set.get_source_id(tile_count)
            var source: TileSetAtlasSource = _map_tile_set.get_source(id)
            var alt_ids := ProcTileSet.get_tile_alt_ids(source)
            
            for alt_id in alt_ids:
                
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

        for tile in proc_tile_set:
            var sockets = tile.sockets
            var valid_right = tile.valid_right
            var valid_bottom = tile.valid_bottom
            var tile_source = tile.source

            for c_tile in proc_tile_set:
                var c_set_idx = c_tile.set_idx
                var c_sockets = c_tile.sockets

                if sockets[1] == c_sockets[3]:
                    valid_right.append(c_set_idx)   
            
                if sockets[2] == c_sockets[0]:
                    valid_bottom.append(c_set_idx)
            
            for c_tile in proc_tile_set:
                (
                    tile_source.get_tile_data(
                        Vector2i.ZERO, 
                        tile.alt_tile_id
                    )
                    .set_custom_data(
                        "valid_right", 
                        tile.valid_right
                    )
                )
                (
                    tile_source.get_tile_data(
                        Vector2i.ZERO, 
                        tile.alt_tile_id
                    )
                    .set_custom_data(
                        "valid_bottom", 
                        tile.valid_bottom
                    )
                )
        
        return proc_tile_set


func place_prop(x: int, y: int, prop: PackedScene, tile_map: TileMap, step_size: int = 32, rotation_idx: int = 0):

    var values = [12, 3, 10, 5]

    var steps: Dictionary = {
        "top_right": [Vector2i(values[0], -values[1]), Vector2i(values[2], -values[1]), Vector2i(values[2], -values[3])],
        "bottom_right": [Vector2i(values[0], values[1]), Vector2(values[2], values[1]), Vector2i(values[2], values[3])],
        "bottom_left": [Vector2i(-values[0], values[1]), Vector2(-values[2], values[1]), Vector2i(-values[2], values[3])],
        "top_left": [Vector2i(-values[0], -values[1]), Vector2i(-values[2], -values[1]), Vector2i(-values[2], -values[3])],
    }

    var calc = func(n, step_size, k, i, xy):
        if xy == "x":
            return step_size * steps[k][i].x + n + 30
        else:
            return step_size * steps[k][i].y + n - 30

    var get_placement = func(x, y, key) -> Array[Vector2]:
        return(
            [
                Vector2(calc.call(x, step_size, key, 0, "x"), calc.call(y, step_size, key, 0, "y")),
                Vector2(calc.call(x, step_size, key, 1, "x"), calc.call(y, step_size, key, 1, "y")),
                Vector2(calc.call(x, step_size, key, 2, "x"), calc.call(y, step_size, key, 2, "y"))  
            ]
        )

    var placements: Dictionary = {
        "top_right": get_placement.call(x, y, "top_right"),
        "bottom_right": get_placement.call(x, y, "bottom_right"),
        "bottom_left": get_placement.call(x, y, "bottom_left"),
        "top_left": get_placement.call(x, y, "top_left")
    }
    
    var prop_node_0: Node2D = prop.instantiate()
    var prop_node_1: Node2D = prop.instantiate()
    var prop_node_2: Node2D = prop.instantiate()

    

    var place = func(p_key):

        var global_adjustment = Vector2(0, 0)
        
        placements[p_key].shuffle()
        
        var placement = placements[p_key].pop_back()  
        prop_node_0.global_transform.origin = placement - global_adjustment
        tile_map.add_child(prop_node_0)
        
        placement = placements[p_key].pop_back()  
        prop_node_1.global_transform.origin = placement - global_adjustment
        tile_map.add_child(prop_node_1)
        
        placement = placements[p_key].pop_back()  
        prop_node_2.global_transform.origin = placement - global_adjustment
        tile_map.add_child(prop_node_2)

    match rotation_idx:
        0:
            place.call("top_right")
        1:
            place.call("bottom_right")
        2:
            place.call("bottom_left")
        3:
            place.call("top_left")


func _gen_linear_wfc_map_019(proc_tile_set):

    # var time_accum := 0.0

    for y in num_cells.y:
        
        for x in num_cells.x:

            # var iter_start_time = Time.get_ticks_usec()

            var top_cell_coords := Vector2i(x, y - 1)
            var left_cell_coords := Vector2i(x - 1, y)
            
            
            var top_cell_data: TileData = self.get_cell_tile_data(-1, top_cell_coords)
            var left_cell_data: TileData = self.get_cell_tile_data(-1, left_cell_coords)
            
            var top_ps: Array
            var left_ps: Array
            if top_cell_data:
                top_ps = top_cell_data.get_custom_data("valid_bottom") 

            
            if left_cell_data:
                left_ps = left_cell_data.get_custom_data("valid_right")


            var proto_valid_tiles = [0,1,2,3,4,5,6,7,8,9,10]
            var valid_tiles: Array = []
            
            var big = left_ps
            var small = top_ps
            if top_ps.size() > left_ps.size():
                big = top_ps
                small = left_ps

            if top_ps == left_ps:
                valid_tiles = left_ps
             
            if !top_ps.is_empty() and !left_ps.is_empty():
                
                var inner_inner_inner_for_start = Time.get_ticks_usec()
                for p in small:
                    valid_tiles += big.filter(func(idx): return idx == p)
                print("in_in_in_for time: ", Time.get_ticks_usec() - inner_inner_inner_for_start)

            if top_ps.is_empty():
                valid_tiles = left_ps

            if left_ps.is_empty():
                valid_tiles = top_ps
            
            if top_ps.is_empty() and left_ps.is_empty():
                valid_tiles = proto_valid_tiles

            # valid_tiles = Test.test_stripes(big, small, valid_tiles)

            var tile_source_id: int
            var alt_tile_id: int
            var proc_tile: ProcTile
            var roll = randi_range(0, 2)
            var can_place_prop = roll == 0 or roll == 2


            if valid_tiles.size() == 1:
        
                proc_tile = proc_tile_set.tile_set[valid_tiles[0]]
                tile_source_id = proc_tile.source_id
                alt_tile_id = proc_tile.alt_tile_id
                set_cell(-1, Vector2(x,y), tile_source_id, Vector2.ZERO, alt_tile_id)
                
                if [2,3,4,5].has(proc_tile.set_idx) and can_place_prop:
                    var cell_center_pos = map_to_local(Vector2i(x,y))
                    var rot_idx = proc_tile.set_idx - 2
                    place_prop(cell_center_pos.x, cell_center_pos.y, scrap_scene, self, 16, rot_idx)


            else:
                
                var rnd_valid_idx = randi_range(0, valid_tiles.size() - 1)
                var tile_idx = valid_tiles[rnd_valid_idx]
                proc_tile = proc_tile_set.tile_set[tile_idx]
                tile_source_id = proc_tile.source_id
                alt_tile_id = proc_tile.alt_tile_id
                set_cell(-1, Vector2(x,y), tile_source_id, Vector2.ZERO, alt_tile_id)

                if [2,3,4,5].has(proc_tile.set_idx) and can_place_prop:
                    var cell_center_pos = map_to_local(Vector2i(x,y))
                    var rot_idx = proc_tile.set_idx - 2
                    place_prop(cell_center_pos.x, cell_center_pos.y, scrap_scene, self, 16, rot_idx)


            # print("iter_time (u): ", Time.get_ticks_usec() - iter_start_time)
            # time_accum += Time.get_ticks_usec() - iter_start_time
    
    # print("Map Gen Accum Time (m): ", time_accum / 1000.0)


func _ready():

    # var init_start_time = Time.get_ticks_usec()
    var proc_tile_set: ProcTileSet = ProcTileSet.new(tile_set)
    # print("Init Time (m): ", init_start_time / 1000.0)

    _gen_linear_wfc_map_019(proc_tile_set)

    # Test.Suite.run(self)
    #Test.run_map_gen_x_times(4, _gen_linear_wfc_map_019, self, proc_tile_set)


class Test:
    
    static var proc_tile_set_names: Array = [
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


    static func test_stripes(big_array_ref: Array, small_array_ref: Array, valid_tiles_ref: Array):
        big_array_ref = [0,1]
        small_array_ref = [1]            
        for p in small_array_ref:
            valid_tiles_ref = big_array_ref.filter(func(idx): return idx == p)
        
        return valid_tiles_ref

    static func clear_all_tiles(num_cells: Vector2i, tile_map: TileMap):
        for y in num_cells.y:
            for x in num_cells.x:
                tile_map.set_cell(-1, Vector2(x,y), -1, Vector2.ZERO)


    static func run_map_gen_x_times(x: int, gen_func: Callable, tile_map: TileMap, proc_tile_set: ProcTileSet):

        var max_tests = x
        for i in max_tests:

            Test.clear_all_tiles(tile_map.num_cells, tile_map)
            gen_func.call(proc_tile_set)
            await tile_map.get_tree().create_timer(1).timeout


    class Suite:
        
        static func run(tile_map: TileMap):
        
            var proc_tile_set: ProcTileSet = ProcTileSet.new(tile_map.tile_set)
            
            Test.assert_proc_tile_set_size(proc_tile_set.tile_set, 11)

            var tile = proc_tile_set.tile_set[0]
            Test.assert_sockets(tile, [1,0,1,0])
            Test.assert_valid_bottom(tile, [0,2,5,6])
            Test.assert_valid_right(tile, [0,2,3,6,7,8,10])


            tile = proc_tile_set.tile_set[6]
            Test.assert_sockets(tile, [1,0,0,0])
            Test.assert_valid_bottom(tile, [0,3,4,7,8,9,10])

            tile = proc_tile_set.tile_set[7]
            Test.assert_sockets(tile, [0,1,0,0])
            Test.assert_valid_bottom(tile, [1,3,4,7,8,9,10])
    

    static func assert_proc_tile_set_size(proc_tile_set, size):

        assert(proc_tile_set.size() == size)

    static func assert_sockets(proc_tile, assert_sockets):

        var sockets = proc_tile.sockets
        assert(sockets == assert_sockets)
    
    static func assert_valid_bottom(proc_tile: ProcTile, assert_valid_bottom):
            
        var valid_bottom = proc_tile.valid_bottom
        var assert_names = assert_valid_bottom.map(func(n): return Test.proc_tile_set_names[n])
        var names = valid_bottom.map(func(n): return Test.proc_tile_set_names[n])
        assert(valid_bottom == assert_valid_bottom)
    
    static func assert_valid_right(proc_tile: ProcTile, assert_valid_right):
            
        var valid_right = proc_tile.valid_right
        assert(valid_right == assert_valid_right)


