extends CharacterBody2D
class_name Agent

var speed := 2000
var accel := 7

signal reached_true_destination

func _reached_real_destination_check():
  # print(Data.get_tile_from_global(global_position))
  # print(Data.get_tile_from_global(nav_agent.target_position))
  # print(current_dest)
  # print(nav_agent.target_position)
  # print(global_position)
  # print('-----------')
  pass
  # if global_position.is_equal_approx(nav_agent.target_position) and current_dest and current_dest.is_equal_approx(nav_agent.target_position):
    # print_info()
    

@onready var nav_agent :NavigationAgent2D= $NavAgent
@onready var sleeper: Timer = $Sleeper

## `push_pack, pop_front` for queue-like behavior
var action_queue := []

var control_agent := false
func _ready() -> void:
  Signals.move_agent.connect(func(val): 
    control_agent = val
    if not control_agent:
      nav_agent.target_position = global_position  
  )
  Signals.create_action_sequence.connect(create_action)
  
  nav_agent.target_reached.connect(_reached_real_destination_check)
  sleeper.timeout.connect(execute_next_action)

func _input(event: InputEvent) -> void:
  if event.is_action_pressed("lmb_click") and control_agent:
    makepath_mouse()


var is_moving := false
func makepath_mouse() -> void:
  if is_moving: return
  is_moving = true
  var mouse_tile = Data.get_tile_from_global(get_global_mouse_position())
  current_dest = mouse_tile
  var action = ActionManager.create_action({}, "walk_to", mouse_tile)
  action_queue.push_back(action)
  print(action_queue)
  sleeper.start()
  # nav_agent.target_position = get_global_mouse_position()
  # if not nav_agent.is_target_reachable():
  #   nav_agent.target_position = global_position
  #   is_moving = false

var current_dest: Vector2
var is_target_reachable := true
func makepath_destination(dest: Vector2i) -> void:
  is_moving = true
  current_dest = dest
  nav_agent.target_position = dest
  if not nav_agent.is_target_reachable():
    nav_agent.target_position = global_position
    is_moving = false

var mode := "navigate"
func _physics_process(delta: float) -> void:
  var current_tile = Data.get_tile_from_global(global_position)
  var target_tile = Data.get_tile_from_global(nav_agent.target_position)
  # print(current_tile, target_tile, current_tile == target_tile)
  if current_tile != target_tile:
  # if is_moving:
    nav_agent.target_position = current_dest
    set_velocity_custom(delta)
    move_and_slide()
  elif is_moving:
    global_position = Data.get_global_from_tile(target_tile)
    is_moving = false
    print("dest reached!")
    sleeper.start()
    # if nav_agent.is_navigation_finished():
    #   nav_agent.target_position = global_position
    #   is_moving = false
  # else if mode == "follow":

func set_velocity_custom(delta: float):
  if is_moving:
    var dir = to_local(nav_agent.get_next_path_position()).normalized() 
    velocity = dir * speed * delta 
  else:
    velocity = Vector2(0,0)


func create_action():
  var action_seq = ActionManager.create_action_sequence({}, "buy")
  for el in action_seq: action_queue.push_back(el)
  is_moving = true
  start_sleeper()

func get_next_action():
  return action_queue.pop_front()

func execute_next_action():
  var action = get_next_action()
  if action:
    print(action)
    if action['type'] == 'walk_to':
      makepath_destination(action['destination'])
    if action['type'] == "walk_to_building":
      makepath_destination(action["destination"])
      if action['building'].data.has_inner_path:
        action['building'].assigned_agent = self
    elif action['type'] == "walk_in_building":
      # action['building'].is_occupied = true
      is_moving = false
      reparent(action["path"], true)
      action["path"].assign_and_start(action["building"], self)
    else:
      sleeper.start()
  else:
    start_sleeper()

func finish_inner_building_path(build: BuildingTemplate = null):
  # var action = ActionManager.create_action({}, "walk_to", build.data.code_name)
  # action_queue.push_back(action)
  # var action2 = ActionManager.create_action({}, "walk_to", "decor/path")
  # action_queue.push_back(action2)
  # execute_next_action()
  # if build: build.is_occupied = false
  start_sleeper()



func start_sleeper():
  # if is_moving:
  sleeper.start()
func print_info():
  print("Current target: ", nav_agent.target_position)
  print("Target reached: ", nav_agent.is_target_reached())
  # print("Is target reachable: ", nav_agent.is_target_reachable())
  print("Current saved target: ", current_dest)
  # print("Is navigation finished: ", nav_agent.is_navigation_finished())
  print("------------------")