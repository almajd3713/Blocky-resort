extends Node

## Set by data_grid script
@onready var data_grid := DataGridAutoload.data_grid

func _ready() -> void:
  Signals.store_building.connect(store_building)


var buildings: Dictionary
func store_building(build: BuildingTemplate):
  if not buildings.has(build.data.code_name):
    buildings[build.data.code_name] = Array()
  buildings[build.data.code_name].append(build)



## Finds the best building to satisfy the required action, by distance or whatever
func get_satisfier_building(building: String, id: int):
  var buildings_of_type := []
  if buildings.has(building):
    buildings_of_type = buildings[building]
  # match building:
    # "store":
      # if buildings.has("store"):
        # buildings_of_type = buildings["store"]
  return buildings_of_type[id]

func create_action(_agent_preferences: Dictionary, primitive_action: String, target):
  match primitive_action:
    "walk_to":
      var building = get_satisfier_building(target, greg(target))
      var building_entrance = data_grid.to_global(data_grid.map_to_local(building.entrance_tile))
      return {
        "destination": building_entrance,
        "building": building,
      }
    "walk_in_building":
      return {
        "building": target,
        "path": target.path_cart,
      } 

func greg(build: String):
  match build:
    "decor/path":
      return 36
    "store":
      return 0
      

func create_action_sequence(agent_preferences: Dictionary, action: String):
  var queue := []
  match action:
    "buy":
      var walk_action = create_action(agent_preferences, "walk_to", "store")
      var idle_action = create_action(agent_preferences, "walk_in_building", walk_action["building"])
      var walk_action2 = create_action(agent_preferences, "walk_to", "decor/path")

      queue.append_array([walk_action, idle_action, walk_action2])
  return queue
