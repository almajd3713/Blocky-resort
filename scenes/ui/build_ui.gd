@tool
extends Control

@onready var animation_component : AnimationComponent = $AnimationComponent
@onready var build_categories_ui := $BuildCategoriesUI
@onready var build_details_ui := $BuildDetailedUI
@onready var build_item_container: HBoxContainer = %BuildItemContainer



@onready var size_y_categories = build_categories_ui.get_node('PanelContainer').get_rect().size.y
@onready var size_y_details_cont = build_details_ui.get_rect().size.y
@onready var size_y_details = build_details_ui.get_node('PanelContainer').get_rect().size.y

var build_item_scene: PackedScene = preload('res://scenes/ui/build_item.tscn')

# var details_opened: bool:
  # set(new_val):
    # details_opened = new_val
var current_category: Data.BuildingCategory = Data.BuildingCategory.NONE:
  set(new_val):
    if current_category == new_val or not len(get_buildings(new_val)):
      current_category = Data.BuildingCategory.NONE
      toggle_build_item_menu(false)
    else:
      current_category = new_val
      if len(get_buildings(new_val)): toggle_build_item_menu(true)


func _ready() -> void:
  build_details_ui.position = Vector2(0, size_y_details_cont)

  Signals.open_category.connect(func(val):
    current_category = val
  )

func get_buildings(type: Data.BuildingCategory):
  var arr := []
  for build in Data.building_data.values():
    if build.category == type: arr.append(build)
  return arr 

func set_data(type: Data.BuildingCategory):
  for child in build_item_container.get_children(): child.queue_free()

  if type != Data.BuildingCategory.NONE:
    for build in get_buildings(type):
      var scene = build_item_scene.instantiate()
      build_item_container.add_child(scene)
      scene.data = build
      scene.update_ui()
  else:
    Signals.toggle_none_mode.emit()
  
func toggle_build_item_menu(mode: bool):
  if mode:
    set_data(current_category)
    build_details_ui.get_node("AnimationComponent").add_transition(
      "position",
      Vector2(0, size_y_details_cont - size_y_details - size_y_categories),
    )
  else:
    build_details_ui.get_node("AnimationComponent").add_transition(
      "position",
      Vector2(0, size_y_details_cont),
      func(): set_data(current_category)
    )
