extends Node2D

@export var dialog_timeline: DialogicTimeline
@export var music_player: MusicManager

@onready var start_timer = $StartTimer
@onready var volume_fade_tween := get_tree().create_tween()
@onready var invisible_river_wall = $InvisibleRiverWall
@onready var see_corrupted_goblin_area = $SeeCorruptedGoblin
@onready var game_manager = %GameManager
@onready var enemy_base = get_tree().get_first_node_in_group("Base")

var starting_volume
var fade_out_duration = 2.0

@export var tutorial_manager: TutorialManager

@onready var player = get_tree().get_first_node_in_group("Player")

func _ready():
    player.goblin_call_component.enabled = false
    Dialogic.Inputs.auto_advance.enabled_forced = true
    Dialogic.Inputs.auto_advance.delay_modifier = 0
    Dialogic.Inputs.auto_advance.fixed_delay = 0
    if tutorial_manager == null:
        tutorial_manager = %TutorialManager
    assert(tutorial_manager != null)
    player.lost_follower.connect(_on_player_lost_follower)
    player.lead_goblin.connect(_on_player_lead_goblin)
    player.built_base.connect(_on_player_built_base)
    set_enemy_base_death_event_handling()
    see_corrupted_goblin_area.body_entered.connect(_on_see_corrupted_goblin_body_entered)
    #ResourceManager.scrap_collected.connect(_on_scrap_returned_to_base)
    if start_dialog:
        await start_timer.timeout
        start_dialog()
    var allies_actors = get_tree().get_nodes_in_group("NPC").filter(func(npc): return npc.team == TeamManager.Team.PLAYER)
    for actor in allies_actors:
        actor.collected_scrap.connect(_on_scrap_collected)
    var enemy_actors = get_tree().get_nodes_in_group("NPC").filter(func(npc): return npc.team == TeamManager.Team.CPU)
    for actor in enemy_actors:
        actor.died.connect(_on_corrupted_goblin_died)

func set_enemy_base_death_event_handling():
    enemy_base.died.disconnect(enemy_base._on_died)
    enemy_base.died.connect(_on_enemy_base_destroyed)

func _on_enemy_base_destroyed():
    var _11_ENEMY_BASE_DESTROYED = ResourceLoaderUtil.load_res("res://src/dialog/tutorial/11-enemy-base-destroyed.dtl")
    Dialogic.start(_11_ENEMY_BASE_DESTROYED)
    Dialogic.timeline_ended.connect(_on_enemy_base_destroyed_dialog_ended)
    enemy_base.queue_free()
    enemy_base.died.disconnect(_on_enemy_base_destroyed)

func _on_enemy_base_destroyed_dialog_ended():
    game_manager.game_over.emit(game_manager.GameResult.WIN)


func _on_see_corrupted_goblin_body_entered(body):
    if body.is_in_group("Player"):
        see_corrupted_goblin_area.body_entered.disconnect(_on_see_corrupted_goblin_body_entered)
        activate_enemies()

func activate_enemies():
    var enemy_actors = get_tree().get_nodes_in_group("NPC").filter(func(npc): return npc.team == TeamManager.Team.CPU)
    for actor in enemy_actors:
        actor.process_mode = Node.PROCESS_MODE_INHERIT

func _on_scrap_collected():
    var _05_COLLECTING_SCRAP = ResourceLoaderUtil.load_res("res://src/dialog/tutorial/05-collecting-scrap.dtl")
    Dialogic.start(_05_COLLECTING_SCRAP)
    Dialogic.timeline_ended.connect(_on_scrap_collect_dialog_ended)
    
    var allies_actors = get_tree().get_nodes_in_group("NPC").filter(func(npc): return npc.team == TeamManager.Team.PLAYER)
    for actor in allies_actors:
        if actor.collected_scrap.is_connected(_on_scrap_collected):
            actor.collected_scrap.disconnect(_on_scrap_collected)

func _on_scrap_collect_dialog_ended():
    if get_tree().get_nodes_in_group("Base").filter(func(npc): return npc.team == TeamManager.Team.PLAYER).size() == 0:
        tutorial_manager.prompter_ready.emit(TutorialManager.Section.BUILD_PROMPT, "place")
    if Dialogic.timeline_ended.is_connected(_on_scrap_collect_dialog_ended):
        Dialogic.timeline_ended.disconnect(_on_scrap_collect_dialog_ended)
    

func _on_corrupted_goblin_died():
    var _09_KILLED_CORRUPTED_GOBLIN = ResourceLoaderUtil.load_res("res://src/dialog/tutorial/09-killed-corrupted-goblin.dtl")
    Dialogic.start.call_deferred(_09_KILLED_CORRUPTED_GOBLIN)
    var enemy_actors = get_tree().get_nodes_in_group("NPC").filter(func(npc): return npc.team == TeamManager.Team.CPU)
    for actor in enemy_actors:
        if actor.died.is_connected(_on_corrupted_goblin_died):
            actor.died.disconnect(_on_corrupted_goblin_died)


func _on_player_lead_goblin():
    # TODO: Add player inspired goblins success case dialog
    player.lead_goblin.disconnect(_on_player_lead_goblin)
    var _021_INSPIRE_DONE = ResourceLoaderUtil.load_res("res://src/dialog/tutorial/021-inspire-done.dtl")
    Dialogic.start.call_deferred(_021_INSPIRE_DONE)

func _on_player_lost_follower():
    var _03_FALLING_BEHIND = ResourceLoaderUtil.load_res("res://src/dialog/tutorial/03-falling-behind.dtl")
    Dialogic.start.call_deferred(_03_FALLING_BEHIND)
    tutorial_manager.prompter_ready.emit(TutorialManager.Section.INSPIRE_PROMPT, "call")
    if not player.lead_goblin.is_connected(tutorial_manager._on_player_lead_goblin):
        player.lead_goblin.connect(tutorial_manager._on_player_lead_goblin)
    player.lead_goblin.connect(_on_player_lead_goblin)
    player.lost_follower.disconnect(_on_player_lost_follower)

func _on_player_built_base():
    var _06_BASE_BUILT = ResourceLoaderUtil.load_res("res://src/dialog/tutorial/06-base-built.dtl")
    Dialogic.start.call_deferred(_06_BASE_BUILT)
    player.built_base.disconnect(_on_player_built_base)
    var player_bases = get_tree().get_nodes_in_group("Base").filter(func(base): return base.team == TeamManager.Team.PLAYER)
    for base in player_bases:
        base.unit_spawned.connect(_on_goblin_trained)

func _on_goblin_trained(_unit):
    var _07_GOBLINS_START_TRAINING = ResourceLoaderUtil.load_res("res://src/dialog/tutorial/07-goblins-start-training.dtl")
    Dialogic.start.call_deferred(_07_GOBLINS_START_TRAINING)
    var player_bases = get_tree().get_nodes_in_group("Base").filter(func(npc): return npc.team == TeamManager.Team.PLAYER)
    for base in player_bases:
        if base.unit_spawned.is_connected(_on_goblin_trained):
            base.unit_spawned.disconnect(_on_goblin_trained)

func start_dialog():
    # fade music bus down 6db
    
    Dialogic.timeline_ended.connect(_on_timeline_ended)
    Dialogic.start.call_deferred(dialog_timeline)

func _on_timeline_ended():
    # fade music bus up 6db
    Dialogic.timeline_ended.disconnect(_on_timeline_ended)
    player.goblin_call_component.enabled = true
    invisible_river_wall.queue_free()
    call_goblin_event()

func call_goblin_event():
    tutorial_manager.prompter_ready.emit(TutorialManager.Section.INSPIRE_PROMPT, "call")
    var _02_INSPIRE = ResourceLoaderUtil.load_res("res://src/dialog/tutorial/02-inspire.dtl")
    Dialogic.start(_02_INSPIRE)

func fade_out_music():
    # Start the fade out effect
    
    volume_fade_tween.set_ease(Tween.EASE_IN_OUT)
    volume_fade_tween.set_trans(Tween.TRANS_LINEAR)
    starting_volume = music_player.volume_db
    volume_fade_tween.tween_property(music_player, "volume_db", -12, fade_out_duration)

func fade_in_music():
    # Start the fade out effect
    volume_fade_tween.tween_property(music_player, "volume_db", starting_volume, fade_out_duration)
