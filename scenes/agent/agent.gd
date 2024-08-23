extends Node2D
class_name Agent

@export var tile_map: TileMapLayer
@onready var astar_grid := AStarGrid2D.new()

var current_id_path: Array[Vector2i]
var target_pos: Vector2
var is_moving: bool



func _ready() -> void:
  astar_grid.region = tile_map.get_used_rect()
  astar_grid.cell_size = Vector2(16, 16)
  astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
  astar_grid.update()
  _config_grid()




func _input(event):
  if not event.is_action_pressed("move"): return

  # var id_path = astar_grid.get_id_path(
    # tile_map.local_to_map(global_position),
    # tile_map.local_to_map(get_global_mouse_position())

  # )
  var mouse_pos = tile_map.local_to_map(get_global_mouse_position())
  if astar_grid.is_in_bounds(mouse_pos.x, mouse_pos.y): 
    var id_path := astar_grid.get_id_path(
      tile_map.local_to_map(target_pos if is_moving else global_position),
      tile_map.local_to_map(get_global_mouse_position())
    )

    if not id_path.is_empty():
      current_id_path = id_path
    else:
      print("Target is unreachable")

  
func _physics_process(_delta: float) -> void:
  if current_id_path.is_empty(): return;

  if not is_moving:
    target_pos = tile_map.map_to_local(current_id_path.front())
    is_moving = true

  global_position = global_position.move_toward(target_pos, 1)

  if global_position == target_pos:
    current_id_path.pop_front()
    if not current_id_path.is_empty():
      target_pos = tile_map.map_to_local(current_id_path.front())
    else:
      is_moving = false


func _config_grid():
  for x in tile_map.get_used_rect().size.x:
    for y in tile_map.get_used_rect().size.y:
      var tile_pos = Vector2i(
        x + tile_map.get_used_rect().position.x,
        y + tile_map.get_used_rect().position.y
      )
      var tile_data = tile_map.get_cell_tile_data(tile_pos)
      if not tile_data or not tile_data.get_custom_data("Walkable"):
        astar_grid.set_point_solid(tile_pos, true)
