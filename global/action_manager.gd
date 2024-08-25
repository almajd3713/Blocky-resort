extends Node

## Set by data_grid script
@onready var data_grid := Data.data_grid





## Finds the best building to satisfy the required action, by distance or whatever
func get_satisfier_building(building: String, id: int):
  var buildings_of_type := []
  if Data.buildings.has(building):
    buildings_of_type = Data.buildings[building]
  # match building:
    # "store":
      # if buildings.has("store"):
        # buildings_of_type = buildings["store"]
  return buildings_of_type[id]

func create_action(_agent_preferences: Dictionary, primitive_action: String, target):
  match primitive_action:
    "walk_to":
      return {
        "type": "walk_to",
        "destination": data_grid.to_global(data_grid.map_to_local(target))
      }
    "walk_to_building":
      var building = get_satisfier_building(target, greg(target))
      var building_entrance = data_grid.to_global(data_grid.map_to_local(building.entrance_tile))
      return {
        "type": "walk_to_building",
        "destination": building_entrance,
        "building": building,
      }
    "walk_in_building":
      return {
        "type": "walk_in_building",
        "building": target,
        "path": target.path_cart,
      } 

var counter := -1
func greg(build: String):
  match build:
    "store":
      counter+=1
      return counter
    "mouse_pos":
      return 
      

func create_action_sequence(agent_preferences: Dictionary, action: String):
  var queue := []
  match action:
    "buy":
      var walk_action = create_action(agent_preferences, "walk_to_building", "store")
      var idle_action = create_action(agent_preferences, "walk_in_building", walk_action["building"])

      queue.append_array([
       walk_action,
       idle_action
      ])
  return queue
