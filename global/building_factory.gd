extends Node

@export var world: Node2D
@export var data_grid: TileMapLayer
@export var building_grid: TileMapLayer

var buildings: Dictionary

func store_building(build: BuildingTemplate):
  if buildings.has(build.name):
    buildings[build.name].push(build)
  else:
    buildings[build.name] = [build]

var buildings_names = [
  "store", "decor/outer_wall"
]

var current_placement_building: BuildingTemplate

func _init() -> void:
  for build in buildings_names:
    var full_path = get_building_scene_path(build)
    buildings[build] = load(full_path)


func _ready() -> void:
  current_placement_building = create_building("store")

func _toggle_build_mode():
  toggle_building = !toggle_building
  if toggle_building:
    current_placement_building = create_building("store")
    current_placement_building.position = get_snapped_mouse_pos()
    add_child(current_placement_building)
  else:
    remove_child(current_placement_building)
    current_placement_building.queue_free()

  # else:
    # remove_child(current_placement_building)

var toggle_building := false
func _input(event: InputEvent) -> void:
  if event.is_action_pressed("a_key") and toggle_building:
    var at = data_grid.local_to_map(current_placement_building.position)
    if can_place_building(current_placement_building, at):
      place_building(building_grid, current_placement_building, at)
      store_building(current_placement_building)
      current_placement_building = create_building("store")
      current_placement_building.position = get_snapped_mouse_pos()
      add_child(current_placement_building)



var can_build := true
func _physics_process(_delta: float) -> void:
  if not toggle_building: pass;

  if is_instance_valid(current_placement_building) and can_build:
    current_placement_building.position = get_snapped_mouse_pos()
    current_placement_building.toggle_cannot_build_shader(
      can_place_building(
        current_placement_building, 
        data_grid.local_to_map(current_placement_building.position))
    )

func get_snapped_mouse_pos():
  var mouse_pos = world.get_local_mouse_position()
  var tile_pos = data_grid.local_to_map(mouse_pos) 
  var snapped_mouse_pos = tile_pos * data_grid.size
  return snapped_mouse_pos

func map_to_local(at: Vector2i):
  return data_grid.map_to_local(at)

func get_building_scene_path(build: String):
  return "res://scenes/placeables/" + build + ".tscn"

func create_building(build: String):
  var building = buildings[build].instantiate()
  return building

# `at` is relative to data_grid
func can_place_building(build: BuildingTemplate, at: Vector2i):
  var building_cells := get_building_tiles(data_grid, build, at)
  var has_collisions = false
  for cell in building_cells:
    if data_grid.data[cell]["is_used"]:
      has_collisions = true
      break
  if has_collisions:
    return false
  else:
    return true


func place_building(grid: TileMapLayer, build: BuildingTemplate, at: Vector2i) -> void:
  var building_tiles = get_building_tiles(data_grid, build, at)
  # print(building_tiles)
  # var building_pos = data_grid.to_local(build.global_position)
  var building_pos = building_tiles.map(func(tile): return data_grid.map_to_local(tile))
  var building_tile_origin = data_grid.local_to_map(building_pos[0])
  for cell in building_tiles:
    data_grid.data[cell]["is_used"] = true  
    data_grid.data[cell]["building"] = build
    data_grid.data[cell]["building_cell"] = cell - building_tile_origin
    if cell == building_tile_origin:
      print(cell - building_tile_origin)
      build.position = building_pos[0] - Vector2(8, 8)
  


  




func get_building_tiles(grid: TileMapLayer, building: BuildingTemplate, at: Vector2i) -> Array[Vector2i]:
  var build_dims = building.get_node("Sprite").get_rect().size
  var offset = Vector2(
    build_dims.x / building.data.cells.x,
    build_dims.y / building.data.cells.y
  )
  var build_cells: Array[Vector2i] = []
  for x in range(building.data.cells.x):
    for y in range(building.data.cells.x):
      build_cells.append(
        grid.local_to_map(map_to_local(at) + Vector2(x, y) * offset)
      )
  return build_cells


func preload_building(build: String):
# for cell in get_used_cells():
#   tile_data[cell] = tile_data_template.duplicate()
#   var preloaded_data = get_cell_tile_data(cell)
#   if preloaded_data and preloaded_data.get_custom_data("Wall"):
#     tile_data[cell]["preloaded"] = true
#     var wall = BuildingFactory.create_building("decor/outer_wall")
#     wall.position = map_to_local(cell)
#     add_child(wall)
  for cell in data_grid.get_used_cells():
    var preloaded_data = data_grid.get_cell_tile_data(cell)
    if preloaded_data and preloaded_data.get_custom_data(build):
      var building = create_building(build)
      var building_tiles = get_building_tiles(data_grid, building, cell)
      var can_build_preload = true
      for preload_cell in building_tiles:
        print(preload_cell)
        if not data_grid.get_cell_tile_data(preload_cell) or not data_grid.get_cell_tile_data(preload_cell).get_custom_data(build):
          can_build_preload = false;
          break;

      if can_place_building(building, cell) and can_build_preload: 
        add_child(building)
        place_building(building_grid, building, cell)