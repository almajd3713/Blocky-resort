extends TileMapLayer

@export var size := Vector2i(16, 16)


# @onready var 

var data: Dictionary = {}

func _init() -> void:
    Data.data_grid = self

# func _init() -> void:
#     ActionManager.data_grid = self

# const tile_data_template: Dictionary = {
#   "is_used": false,
#   "building": null,
#   "building_cell": null,
#   "preloaded": false,
#   "preload_type": "outer_wall"
# }

# func _ready() -> void:
#   # for cell in get_used_cells():
#   #   tile_data[cell] = tile_data_template.duplicate()
#   #   var preloaded_data = get_cell_tile_data(cell)
#   #   if preloaded_data and preloaded_data.get_custom_data("Wall"):
#   #     tile_data[cell]["preloaded"] = true
#   #     var wall = BuildingFactory.create_building("decor/outer_wall")
#   #     add_child(wall)
#   #     wall.position = map_to_local(cell)
#   pass
    
  

# func _input(event: InputEvent) -> void:
#   if event.is_action_pressed("lmb_click") and is_building_mode:
#     var building_pos = to_local(store.global_position)
#     var building_tile = local_to_map(building_pos)
#     # if not cannot_build:
    #   for cell in get_building_tiles(store):
    #     tile_data[cell]["building"] = store
    #     tile_data[cell]["is_used"] = true  
    #     tile_data[cell]["building_cell"] = cell - building_tile
    #     set_cell(cell, 0, Vector2i(1, 1))
    
    # var mouse_pos = get_local_mouse_position()
    # var tile_pos = local_to_map(mouse_pos) 

    # print(tile_data[tile_pos])
    # set_cell(tile_pos, 0, Vector2i(1, 1))


# var is_building_mode := false
# func _on_button_pressed():
#   is_building_mode = !is_building_mode
#   print("Building is now ", "enabled" if is_building_mode else "disabled")
#   if is_building_mode:
#     Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
#   else:
#     Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
  
# var cannot_build: bool
# func _physics_process(_delta: float) -> void:
#   var mouse_pos = get_local_mouse_position()
#   var tile_pos = local_to_map(mouse_pos) 
#   var snapped_mouse_pos = tile_pos * size   
#   if is_building_mode:
#     cannot_build = false
#     store.position = snapped_mouse_pos 
#     # var building_pos = to_local(store.global_position)
#     # var building_tile = local_to_map(building_pos)
#     # set_cell(building_tile, 0, Vector2i(1, 1))
#     for cell in get_building_tiles(store):
#       if tile_data[cell]["is_used"]:
#         cannot_build = true
#         break
#     store.toggle_cannot_build_shader(cannot_build)
  
