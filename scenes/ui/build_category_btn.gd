@tool
extends PanelContainer


@export var category: Data.BuildingCategory
@onready var btn := $MarginContainer/Btn



var mouse_inside := false
func _ready() -> void:
  Data.click_listener(btn)
  btn.pressed.connect(func(): Signals.open_category.emit(category))
