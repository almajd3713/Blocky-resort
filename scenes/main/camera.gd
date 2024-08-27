extends Camera2D

@export var speed := 800

func _ready() -> void:
  reset_directions()

@export var zoom_level := 1.0
@export var zoom_boundaries := [1.0, 2.5]

var dir := Vector2.ZERO
func _input(event: InputEvent) -> void:
  if event.is_action_pressed("cam_up"):
    dir.y -= 1
  if event.is_action_released("cam_up"):
    dir.y += 1
  if event.is_action_pressed("cam_down"):
    dir.y += 1
  if event.is_action_released("cam_down"):
    dir.y -= 1
  if event.is_action_pressed("cam_left"):
    dir.x -= 1
  if event.is_action_released("cam_left"):
    dir.x += 1
  if event.is_action_pressed("cam_right"):
    dir.x += 1
  if event.is_action_released("cam_right"):
    dir.x -= 1
  if event.is_action_pressed("cam_zoom_in") and zoom_level <= zoom_boundaries.max():
    zoom_level += .2
  if event.is_action_pressed("cam_zoom_out") and zoom_level >= zoom_boundaries.min():
    zoom_level -= .2
  






func _process(delta: float) -> void:
  var velocity = speed * delta * dir * (1 / zoom_level)
  global_position += velocity

  zoom.x = zoom_level; zoom.y = zoom_level




func reset_directions():
  dir = Vector2i.ZERO