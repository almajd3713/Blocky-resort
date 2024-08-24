extends PathFollow2D
## If has_inner_path is true, add checkpoints
## Format: [String]: [float]
@export var checkpoints: Dictionary
@onready var checkpoint_places = checkpoints.keys()
@onready var checkpoint_queue: Array = checkpoint_places.map(func(): return false)

var assigned_building: BuildingTemplate
var assigned_agent: Agent

@export var movement_speed := .01

@onready var delay: Timer = $Delay

func _ready() -> void:
  # Don't ask why, it just works somehow
  delay.timeout.connect(self.progress)
  draw_path()

var is_running: bool = false
func _process(_delta: float) -> void:
  if is_running:
    if progress_ratio <= .99:
      var no_checkpoint_reached := true
      for i in len(checkpoint_queue):
        if progress_ratio >= checkpoint_places[i].to_float() and not checkpoint_queue[i]:
          no_checkpoint_reached = false
          delay.start(checkpoints[i])
          break
      if no_checkpoint_reached:
        progress()
    else:
      finish_path()

      
func progress():
  progress_ratio += movement_speed

      

func assign_and_start(build: BuildingTemplate, agent: Agent):
  progress_ratio = 0
  assigned_building = build
  assigned_agent = agent
  assigned_agent.position = Vector2(0,0)
  is_running = true
  
func finish_path():
  is_running = false
  assigned_agent.reparent(get_node("/root/Main"))
  print("Internal Tour Done")
  assigned_agent.finish_inner_building_path(assigned_building)

  assigned_agent = null
  assigned_building = null
  

func draw_path():
  var l := Line2D.new()   
  l.default_color = Color(1,1,1,1)  
  l.width = 20  
  for point in get_parent().curve.get_baked_points():  
    l.add_point(point + get_parent().position) 