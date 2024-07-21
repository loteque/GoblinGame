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


func _gen_linear_wfc_map_019(proc_tile_set):

    var time_accum := 0.0

    for y in num_cells.y:
        
        for x in num_cells.x:

            var iter_start_time = Time.get_ticks_usec()

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

            # TEST STRIPES
            # big = [0,1]
            # small = [1]            
            # for p in small:
            #     valid_tiles = big.filter(func(idx): return idx == p)
            # /TEST STRIPES

            if top_ps == left_ps:
                valid_tiles = left_ps
            
            var inner_inner_inner_for_start = Time.get_ticks_usec() 
            if !top_ps.is_empty() and !left_ps.is_empty():
                for p in small:
                    valid_tiles += big.filter(func(idx): return idx == p)
            print("in_in_in_for time: ", Time.get_ticks_usec() - inner_inner_inner_for_start)

            if top_ps.is_empty():
                valid_tiles = left_ps

            if left_ps.is_empty():
                valid_tiles = top_ps
            
            if top_ps.is_empty() and left_ps.is_empty():
                valid_tiles = proto_valid_tiles
                
            var tile_source_id: int
            var alt_tile_id: int
            var proc_tile: ProcTile

            if valid_tiles.size() == 1:
        
                proc_tile = proc_tile_set.tile_set[valid_tiles[0]]
                tile_source_id = proc_tile.source_id
                alt_tile_id = proc_tile.alt_tile_id
                set_cell(-1, Vector2(x,y), tile_source_id, Vector2.ZERO, alt_tile_id)

            else:
                
                var rnd_valid_idx = randi_range(0, valid_tiles.size() - 1)
                var tile_idx = valid_tiles[rnd_valid_idx]
                proc_tile = proc_tile_set.tile_set[tile_idx]
                tile_source_id = proc_tile.source_id
                alt_tile_id = proc_tile.alt_tile_id
                set_cell(-1, Vector2(x,y), tile_source_id, Vector2.ZERO, alt_tile_id)


            print("iter_time (u): ", Time.get_ticks_usec() - iter_start_time)
            time_accum += Time.get_ticks_usec() - iter_start_time

            # DEBUG:
            $Debug.append("----------------")
            $Debug.append("TMPS index: " )
            $Debug.append("set cell (coord): ")
            $Debug.append(str(x), false)
            $Debug.append(str(y), false, ",")
            $Debug.append("tile source: " + str(tile_source_id), false, "; ")
            # using a delay to visualize process
            # await get_tree().create_timer(0).timeout
    
    print("Map Gen Accum Time (m): ", time_accum / 1000.0)

func _clear_all_tiles():
    for y in num_cells.y:
        for x in num_cells.x:
            set_cell(-1, Vector2(x,y), -1, Vector2.ZERO)

func run_map_gen_x_times(x, proc_tile_set):
    var max_tests = x
    for i in max_tests:
        $Debug.append("----------------")
        $Debug.append("Test " + str(i) + " : ")
        $Debug.append("----------------")
        _clear_all_tiles()
        _gen_linear_wfc_map_019(proc_tile_set)
        $Debug.append("MAP GENERATION FINSISHED")
        await get_tree().create_timer(1).timeout

func _ready():
    $Debug.append(str(num_cells))
    $Debug.append("Map Cell Size: (x,y):")
    $Debug.append(str(num_cells.x - 1))
    $Debug.append(str(num_cells.y - 1), false, ",")
    $Debug.append((str(tile_set)))

    var init_start_time = Time.get_ticks_usec()
    var proc_tile_set: ProcTileSet = ProcTileSet.new(tile_set)
    print("Init Time (m): ", init_start_time / 1000.0)

    Test.Suite.run(self)
    run_map_gen_x_times(1, proc_tile_set)


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

    class Suite:
        
        static func run(tile_map: TileMap):
        
            var proc_tile_set: ProcTileSet = ProcTileSet.new(tile_map.tile_set)
            
            Test.assert_proc_tile_set_size(proc_tile_set.tile_set, 11)

            var tile = proc_tile_set.tile_set[0]
            Test.assert_sockets(tile, [1,0,1,0])
            Test.assert_valid_bottom(tile, [0,2,5,6])
            Test.assert_valid_right(tile, [0,2,3,6,7,8,10])


            # tile = proc_tile_set.tile_set[6]
            # Test.assert_sockets(tile, [1,0,0,0])
            # Test.assert_valid_bottom(tile, [0,3,4,7,8,9,10])

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


