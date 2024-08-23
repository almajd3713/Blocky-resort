@tool
extends Node2D
class_name BuildingTemplate

@export var data: BuildingData

@onready var building_name := data.name
@onready var texture := data.sprite
@onready var cells := data.cells
@onready var is_enterable := data.is_enterable
@onready var entrance_cell := data.entrance_cell


func _init(dat = 0) -> void:
  if dat:
    data = dat 

var dimensions := Vector2i(0, 0)
func _ready() -> void:
  $Sprite.texture = texture
  $Sprite.self_modulate.a = 1
  dimensions = $Sprite.get_rect().size

func toggle_cannot_build_shader(what: bool):
  $Sprite.material.set_shader_parameter("is_applied", what)
