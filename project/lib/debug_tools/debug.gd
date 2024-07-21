extends TextEdit
class_name LDebug

signal appended

func append(append_text: String = "", nl: bool = true, d: String = ""):
    if nl:
        text = text + "\n" + append_text
        appended.emit()
        return
    
    text = text + d + append_text
    appended.emit()

func _ready():
    appended.connect(_on_appended)

func _on_appended():
    var cl = get_line_count()
    set_caret_line(cl)
