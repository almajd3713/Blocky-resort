extends Resource
class_name BuildingData

@export_category("General")
@export var name := "New Building"
## Must match directory, starting from scenes/placeables!
## @example decor/outer_wall
@export var code_name := "new_building"
# building | wall | etc...
@export var type := "building"
@export var sprite: Texture2D

@export_category("Dimensions")
@export var cells := Vector2i(1, 1)
@export var unnatural_cells: Array[Vector2i] = []

@export_category("Interactions")
@export var is_enterable := true
@export var entrance_cell := Vector2i(0, 0)

