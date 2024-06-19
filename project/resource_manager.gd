extends Node

const TeamManager = preload("res://team_manager.gd")

const Team = TeamManager.Team

signal scrap_collected(team: Team)
signal scrap_updated(team: Team, new_value: int)

class TeamResources:
    var scrap: int = 0

var player: TeamResources
var cpu: TeamResources

func get_scrap_count_by_team(team: Team):
    match team:
        Team.PLAYER:
            return player.scrap
        Team.CPU:
            return cpu.scrap

func _init():
    scrap_collected.connect(_on_scrap_collected)
    player = TeamResources.new()
    cpu = TeamResources.new()

func _ready():
    scrap_collected.connect(_on_scrap_collected)

func _on_scrap_collected(team: Team):
    
    match team:
        Team.PLAYER:
            print("player collected scrap")
            player.scrap += 1
        Team.CPU:
            cpu.scrap += 1
    scrap_updated.emit(team, get_scrap_count_by_team(team))
