extends Camera2D

@export var speed := 200

func _ready() -> void:
  reset_directions()

var dir := Vector2i.ZERO
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





func _process(delta: float) -> void:
  var velocity = speed * delta * dir
  global_position += velocity




func reset_directions():
  dir = Vector2i.ZERO