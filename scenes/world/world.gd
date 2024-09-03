extends Node2D
class_name World

var building_data := {

}

@onready var data_grid := Data.data_grid
@onready var building_grid: TileMapLayer = $BuildingGrid

const tile_data_template: Dictionary = {
  "is_used": false,
  "building": null,
  "building_cell": null,
  "preload_type": "outer_wall"
}

func _ready() -> void:
  for cell in data_grid.get_used_cells():
    data_grid.data[cell] = tile_data_template.duplicate()
  $BuildingFactory.world = self
  # $BuildingFactory.data_grid = data_grid
  $BuildingFactory.building_grid = building_grid


  $BuildingFactory.preload_building("none/outer_wall")
  $BuildingFactory.preload_building("decor/path")
  $BuildingFactory.preload_building("none/sand")

    # var preloaded_data = grid.get_cell_tile_data(cell)
    # if preloaded_data and preloaded_data.get_custom_data("Wall"):
    #   grid.tile_data[cell]["preloaded"] = true
    #   var wall = BuildingFactory.create_building("decor/outer_wall")
    #   add_child(wall)
    #   wall.position = grid.map_to_local(cell)


  


  



