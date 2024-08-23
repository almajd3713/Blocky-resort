extends CharacterBody2D
class_name Agent



var speed := 1500
var accel := 7


@onready var nav_agent :NavigationAgent2D= $NavAgent

var control_agent := false
func _ready() -> void:
  Signals.move_agent.connect(func(val): 
    control_agent = val
    if not control_agent:
      nav_agent.target_position = global_position  
  )

func _input(event: InputEvent) -> void:
  if event.is_action_pressed("lmb_click") and control_agent:
    makepath()



func makepath() -> void:
  nav_agent.target_position = get_global_mouse_position()
  if not nav_agent.is_target_reachable():
    nav_agent.target_position = global_position


func _physics_process(delta: float) -> void:
  var dir = to_local(nav_agent.get_next_path_position()).normalized() 
  velocity = dir * speed * delta
  move_and_slide()

  