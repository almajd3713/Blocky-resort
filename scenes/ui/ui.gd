extends CanvasLayer


@onready var buildStore := %BuildStore
@onready var buildPath := %BuildPath
@onready var controlToggle := %ControlAgentToggle


func _ready() -> void:
  buildStore.pressed.connect(func(): Signals.toggle_build_mode.emit("store"))
  buildPath.pressed.connect(func(): Signals.toggle_build_mode.emit("decor/path"))

  controlToggle.toggled.connect(func(val): Signals.move_agent.emit(val))
  