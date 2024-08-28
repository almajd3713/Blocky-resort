extends CharacterBody2D
class_name Agent



@onready var nav_agent: NavigationAgent2D = $NavAgent
@onready var personality := $Personality

func _ready():
  input_event.connect(_input_event)

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
  if event.is_action_pressed('lmb_click'):
    # print("Aye frm btn")
    Signals.toggle_character_ui.emit(self)