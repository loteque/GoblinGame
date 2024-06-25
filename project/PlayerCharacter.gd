extends CharacterBody2D

@export var speed = 400
@export var throw_target: Marker2D
@export var marker_range: float = 250
@export var cursor: Area2D
@export var follow_target: Marker2D
@export var team: TeamManager.Team = TeamManager.Team.PLAYER
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var health_bar_ui = $HealthBarUi

@onready var health_component = $HealthComponent

@export var game_manager: GameManager
@export var sfx_manager: SfxManager

@export var tutorial_manager: TutorialManager
@export var g_p_messages_cont: VBoxContainer
@export var throw_component: Node
var is_tutorial_section_active: bool = false
var tut_conn: TutorialManager.TutorialConnector

var base_placer = BasePlacer.new(1)
var selected: Node2D

signal called_goblins()
signal died

func _ready():
    base_placer.game_manager = game_manager
    died.connect(_on_died)
    
    # tutorial: play tutorial when player loads
    tut_conn = TutorialManager.TutorialConnector.new(tutorial_manager, self, g_p_messages_cont)
    if tut_conn.connected():
        await get_tree().create_timer(2).timeout
        tut_conn.manager.prompter_ready.emit(
            tut_conn.manager.Section.INSPIRE_PROMPT, 
            tut_conn,
            "call"
        )
        tut_conn.manager.prompter_ready.emit(
            tut_conn.manager.Section.THROW_PROMPT,
            tut_conn,
            "throw"
        )
        tut_conn.manager.prompter_ready.emit(
            tut_conn.manager.Section.BUILD_PROMPT,
            tut_conn,
            "place"
        )

func _on_died():
    game_manager.game_over.emit(GameManager.GameResult.LOSE)
    die()

func die():
    if health_bar_ui:
        health_bar_ui.visible = false
    animated_sprite_2d.play("die")
    process_mode = Node.PROCESS_MODE_DISABLED
    animated_sprite_2d.process_mode = Node.PROCESS_MODE_ALWAYS
    await animated_sprite_2d.animation_finished
    animated_sprite_2d.process_mode = Node.PROCESS_MODE_DISABLED

func update_marker_position(player_direction: Vector2):
    if player_direction.length() == 0:
        return
    var marker_position = global_position + player_direction * marker_range
    throw_target.global_position = marker_position

func receive_attack(attack: Attack):
    sfx_manager.play_rand("hit")
    health_component.receive_attack(attack)

func get_input():
    var input_direction = Input.get_vector("left", "right", "up", "down")
    return input_direction

func update_body():
    var input_direction = get_input()
    update_marker_position(input_direction)
    velocity = input_direction * speed
    move_and_slide()

func call_goblins():
    called_goblins.emit()

func _physics_process(_delta):
    update_body()

func _input(event):
    if event.is_action("place"):
        base_placer.place(get_parent(), throw_target.global_transform.origin)
        
        # tutorial
        if tut_conn.connected():
            if tut_conn.manager.is_tutorial_active():
                tut_conn.manager.section_success.emit(
                    tut_conn.manager.Section.BUILD_PROMPT,
                    tut_conn.manager.Section.BUILD_RESPONSE, 
                    tut_conn
                )

    if event.is_action("place") and selected:
        if selected.is_in_group("Upgradable"):
            selected.upgrader.upgrade()

func _on_cursor_body_entered(body: Node2D):
    selected = body

func _on_cursor_body_exited(_body: Node2D):
    selected = null
