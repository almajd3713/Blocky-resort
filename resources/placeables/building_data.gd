extends Resource
class_name BuildingData

@export_category("General")
@export var name := "New Building"
## Must match directory, starting from scenes/placeables!
## @example decor/outer_wall
@export var code_name := "new_building"
## building | wall | ground | path
@export var type := "building"
@export var category: Data.BuildingCategory = Data.BuildingCategory.ROOM
@export var sprite: Texture2D

@export_category("Dimensions")
@export var cells := Vector2i(1, 1)
@export var unnatural_cells: Array[Vector2i] = []

@export_category("Interactions")
@export var is_enterable := true
@export var entrance_cell := Vector2i(0, 0)
@export var entrance_direction: Data.EntranceDirection = Data.EntranceDirection.EAST
## Once true, the Path2D has to be created inside the scene manually
@export var has_inner_path := false
## This means it can be built on
@export var is_ground := false
## This means that whatever is done there is 'sussy', basically hides the agent when its inside.
@export var is_private := false
