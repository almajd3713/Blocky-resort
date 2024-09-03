@tool
extends PanelContainer


@export var data: BuildingData

@onready var building_name: Label = %BuildingName
@onready var building_icon: TextureRect = %BuildingIcon

func _ready() -> void:
  Data.click_listener(self)


func update_ui():
  building_name.text = data.name
  building_icon.texture = data.sprite

func _gui_input(event: InputEvent) -> void:
  if event is InputEventMouseButton and event.is_pressed():
    Signals.toggle_build_mode.emit(data.code_name)