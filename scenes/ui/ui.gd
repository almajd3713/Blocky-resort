@tool
extends CanvasLayer

@onready var game_ui := $GameUI


func _ready() -> void:
  game_ui.buildStore.pressed.connect(func(): Signals.toggle_build_mode.emit("store"))
  game_ui.buildPath.pressed.connect(func(): Signals.toggle_build_mode.emit("decor/path"))
  game_ui.delBuilding.toggled.connect(func(val): Signals.toggle_destroy_mode.emit(val))
  game_ui.createActSeq.pressed.connect(func(): Signals.create_action_sequence.emit())
  game_ui.controlToggle.toggled.connect(func(val): Signals.move_agent.emit(val))
  
