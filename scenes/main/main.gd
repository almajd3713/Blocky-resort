extends Node2D

@export var agent_scene: PackedScene = preload("res://scenes/agent/agent.tscn")

@onready var tilemap : BuildingGrid = $WorldGrid
@onready var store : BuildingTemplate = $Store
  
func _ready() -> void:
  $AddStore.pressed.connect(tilemap._on_button_pressed)
  pass


