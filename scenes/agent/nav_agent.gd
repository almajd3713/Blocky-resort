extends NavigationAgent2D


var speed := 2000
var accel := 7

func _reached_real_destination_check():
  pass
var action_queue := []
var current_action

@onready var agent: CharacterBody2D = get_parent()

var control_agent := false
func _ready() -> void:
  Signals.move_agent.connect(func(val): 
    control_agent = val
    if not control_agent:
      action_queue = action_queue.filter(func(ent): return ent['type'] != 'walk_to')
      if current_action['type'] == 'walk_to': current_action = null
  )
  Signals.create_action_sequence.connect(create_action)
  Signals.build_building.connect(recalculate_path)
  
  # target_reached.connect(_reached_real_destination_check)
  # sleeper.timeout.connect(execute_next_action)

func _input(event: InputEvent) -> void:
  if event.is_action_pressed("lmb_click") and control_agent:
    makepath_mouse()


# var is_moving := false
func makepath_mouse() -> void:
  var mouse_tile = Data.get_tile_from_global(agent.get_global_mouse_position())
  # current_dest = mouse_tile
  var action = ActionManager.create_action({}, "walk_to", mouse_tile)
  action_queue.push_back(action)
  # target_position = get_global_mouse_position()
  # if not is_target_reachable():
  #   target_position = global_position
  #   is_moving = false

var current_dest: Vector2
func makepath_destination(dest: Vector2i, build: BuildingTemplate = null) -> bool:
  current_dest = dest
  target_position = dest
  if not is_target_reachable():
    action_cleanup(build)
    return false
  return true

var mode := "navigate"
func _physics_process(delta: float) -> void:
  if not current_action: 
    execute_next_action()
    return
  match current_action['type']:
    "walk_to_building", "walk_to":
      var current_tile = Data.get_tile_from_global(agent.global_position)
      var target_tile = Data.get_tile_from_global(target_position)
      # print(current_tile, target_tile, current_tile == target_tile)

      if current_tile != target_tile:
        target_position = current_dest
        set_velocity_custom(delta)
        agent.move_and_slide()
      else:
        action_cleanup()
    _: return  

func set_velocity_custom(delta: float):
  if current_action:
    var dir = agent.to_local(get_next_path_position()).normalized() 
    agent.velocity = dir * speed * delta 
  else:
    agent.velocity = Vector2(0,0)

func recalculate_path():
  get_next_path_position()

func create_action():
  var action_seq = ActionManager.create_action_sequence({}, "buy")
  for el in action_seq: action_queue.push_back(el)

func get_next_action():
  return action_queue.pop_front()

func execute_next_action():
  print("Current queue", action_queue)
  if not current_action:
    var action = get_next_action()
    if action:
      print("Next action: ", action)
      set_action(action)
      match action['type']:
        'walk_to':
          var _is_reachable = makepath_destination(action['destination'])

        'walk_to_building':
          var _is_reachable = makepath_destination(action["destination"], action['building'])

          if action['building'].data.has_inner_path:
            action['building'].assigned_agent = agent
            
        'walk_in_building':
          if is_instance_valid(action['building']):
            agent.reparent(action["path"], true)
            action["path"].assign_and_start(action["building"], agent)
          else: 
            action_cleanup()
            return
        _:
          print("Action unknown")
          action_cleanup()

func finish_inner_building_path(_build: BuildingTemplate = null):
  action_cleanup()

func set_action(action: Dictionary):
  current_action = action

func action_cleanup(build = null):
  if build:
    action_queue = action_queue.filter(func(item):
      if item.has('building') and build == item['building']: return false
      else: return true
    )
    print(action_queue)
  current_action = null