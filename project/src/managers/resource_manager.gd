extends Node

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

func reset():
    player.scrap = 0
    scrap_updated.emit(Team.PLAYER, 0)
    cpu.scrap = 0
    scrap_updated.emit(Team.CPU, 0)

func _init():
    scrap_collected.connect(_on_scrap_collected)
    player = TeamResources.new()
    cpu = TeamResources.new()

func change_scrap(team: Team, delta: int):
    match team:
        Team.PLAYER:
            player.scrap += delta
            scrap_updated.emit(team, player.scrap)
        Team.CPU:
            cpu.scrap += delta
            scrap_updated.emit(team, cpu.scrap)

func _on_scrap_collected(team: Team):
    match team:
        Team.PLAYER:
            print("player collected scrap")
            player.scrap += 1
        Team.CPU:
            cpu.scrap += 1
    scrap_updated.emit(team, get_scrap_count_by_team(team))
