extends Label

func _ready():
    text = "0"
    ResourceManager.scrap_updated.connect(_on_scrap_updated)

func _on_scrap_updated(team: TeamManager.Team, new_amount: int):
    if team == TeamManager.Team.PLAYER:
        text = str(new_amount)
