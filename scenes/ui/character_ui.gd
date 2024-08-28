@tool
extends Control

@onready var ui_container: PanelContainer = $VBoxContainer/CharacterUIPanelContainer
@onready var animation_component := $AnimationComponent 
@onready var close_button := %CloseButton

@onready var character_name = %CharacterName
@onready var gender = %Gender
@onready var trait_list = %TraitList
@onready var traits_label = %Traits

var selectedAgent: Agent:
  set(new_agent):
    selectedAgent = new_agent
    set_data()

var size_x: float
var size_y: float

func set_new_sizes():
  size_x = ui_container.get_rect().size.x
  size_y = ui_container.get_rect().size.y / 2
func _ready() -> void:
  position = Vector2(-size.x, 0)
  scale = Vector2.ZERO
  
  Signals.toggle_character_ui.connect(func(agent):
    if agent:
      selectedAgent = agent
    else:
      selectedAgent = null  
  )
  setup_close_button()



func set_data():
  if selectedAgent:
    character_name.text = str(
      "Name: ", 
      selectedAgent.personality.first_name, " ",
      selectedAgent.personality.last_name  
    )
    gender.text = str('Gender: ', "Man" if selectedAgent.personality.gender == Data.Gender.MALE else "Woman")
    traits_label = "Traits: " if len(selectedAgent.personality.traits) else ""
    for old_trait in trait_list.get_children(): old_trait.queue_free()
    if len(selectedAgent.personality.traits):
      for new_trait in selectedAgent.personality.traits: 
        var trait_ = Label.new()
        trait_.text = new_trait
        trait_list.add_child(trait_)
    set_new_sizes()
    animation_component.add_transition("position", Vector2.ZERO)
    animation_component.add_transition("scale", Vector2.ONE)
  else:
    animation_component.add_transition("position", Vector2(-size_x, 0))
    animation_component.add_transition("scale", Vector2.ZERO)


func setup_close_button():
  close_button.pressed.connect(func():
    selectedAgent = null  
  )
  close_button.mouse_entered.connect(func():
    mouse_default_cursor_shape = CURSOR_POINTING_HAND
  )
  close_button.mouse_exited.connect(func():
    mouse_default_cursor_shape = CURSOR_ARROW
  )
