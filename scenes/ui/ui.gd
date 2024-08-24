extends CanvasLayer


@onready var buildStore := %BuildStore
@onready var buildPath := %BuildPath
@onready var createActSeq := %CreateActionSeq
@onready var controlToggle := %ControlAgentToggle


func _ready() -> void:
  buildStore.pressed.connect(func(): Signals.toggle_build_mode.emit("store"))
  buildPath.pressed.connect(func(): Signals.toggle_build_mode.emit("decor/path"))
  createActSeq.pressed.connect(func(): Signals.create_action_sequence.emit())
  controlToggle.toggled.connect(func(val): Signals.move_agent.emit(val))
  