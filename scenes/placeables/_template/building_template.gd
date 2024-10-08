@tool
extends Node2D
class_name BuildingTemplate

@export var data: BuildingData

## Relative to data_grid
var origin_tile: Vector2i
var entrance_tile: Vector2i

var assigned_agent: Agent
var agent_in_building: bool

var path: Path2D
## The PathFollow2D
var path_cart: PathFollow2D
# @onready var shader: Shader = preload("res://assets/shaders/cannot_build.gdshader")

# @onready var building_name := data.name
# @onready var texture := data.sprite
# @onready var cells := data.cells
# @onready var is_enterable := data.is_enterable
# @onready var entrance_cell := data.entrance_cell


func _init(dat = 0) -> void:
	if dat:
		data = dat

@onready var detection_area: Area2D = $MouseHoverDetection
func _ready() -> void:
	$Sprite.texture = data.sprite
	$Sprite.self_modulate.a = 1
	var detection_area_dimensions = $Sprite.get_rect().size
	$MouseHoverDetection/CollisionShape2D.shape.size = detection_area_dimensions
	$MouseHoverDetection/CollisionShape2D.position = detection_area_dimensions / 2
	if not data.is_ground:
		detection_area.mouse_entered.connect(_on_mouse_enter)
		detection_area.mouse_exited.connect(_on_mouse_exit)

	if data.has_inner_path:
		path = $Path2D
		path_cart = $Path2D/PathFollow2D
	# $MouseHoverDetection.body_entered.connect(_on_agent_enters)
	# $MouseHoverDetection.body_exited.connect(_on_agent_leaves)
func _physics_process(_delta):
	check_occupation()


func _on_mouse_enter():
	if Data.build_mode == Data.BuildModes.DESTROY:
		toggle_cannot_build_shader(true)
func _on_mouse_exit():
	if Data.build_mode == Data.BuildModes.DESTROY:
		toggle_cannot_build_shader(false)
# func _on_agent_enters(agent: Agent):
# 	if agent == assigned_agent:
# 		agent_in_building = true
# 		print("AA")
# func _on_agent_leaves(agent: Agent):
# 	if agent == assigned_agent:
# 		agent_in_building = false
# 		print("BB")
func check_occupation():
	if not assigned_agent: return
	if not agent_in_building and assigned_agent in detection_area.get_overlapping_bodies():
		agent_in_building = true
	elif agent_in_building and not assigned_agent in detection_area.get_overlapping_bodies():
		agent_in_building = false

# func _exit_tree() -> void:
# 	if assigned_agent and agent_in_building:
# 		var nearest_escape = Data.find_nearest_building(entrance_tile, 10)
# 		var nearest_escape_coord = Data.get_global_from_tile(nearest_escape.origin_tile)
# 		if nearest_escape:
# 			print("Nearest tile to ", entrance_tile, " is ", nearest_escape)
# 			assigned_agent.reparent(get_node('/root/Main'))
# 			assigned_agent.global_position = nearest_escape_coord
# 			assigned_agent.current_dest = nearest_escape_coord
# 	elif assigned_agent:
# 		assigned_agent.action_cleanup()
func _exit_tree() -> void:
	if assigned_agent:
		assigned_agent.action_cleanup(self)
		

		

		


func toggle_cannot_build_shader(what: bool):
	$Sprite.material.set_shader_parameter("is_applied", what)
