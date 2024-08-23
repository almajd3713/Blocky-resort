@tool
extends Node2D
class_name BuildingTemplate

@export var data: BuildingData
# @onready var shader: Shader = preload("res://assets/shaders/cannot_build.gdshader")

# @onready var building_name := data.name
# @onready var texture := data.sprite
# @onready var cells := data.cells
# @onready var is_enterable := data.is_enterable
# @onready var entrance_cell := data.entrance_cell


func _init(dat = 0) -> void:
  if dat:
    data = dat

func _ready() -> void:
  $Sprite.texture = data.sprite
  $Sprite.self_modulate.a = 1
  # $Sprite.material = shader.duplicate()

func toggle_cannot_build_shader(what: bool):
  $Sprite.material.set_shader_parameter("is_applied", not what)
