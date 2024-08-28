extends Resource
class_name AgentGenerators

var first_names: Array[String]
var last_names: Array[String]

var trait_list: Array[String] = [
  'Balcoholic', 'Eeper', 'Bambler', 'Youngling' 
]

func _init() -> void:
  var first_names_str = FileAccess.open('res://assets/names/first_names.txt', FileAccess.READ).get_as_text()
  first_names.assign(first_names_str.split(', '))
  var last_names_str = FileAccess.open('res://assets/names/last_names.txt', FileAccess.READ).get_as_text()
  last_names.assign(last_names_str.split(', '))


func generate_first_name(): return first_names.pick_random()
func generate_last_name(): return last_names.pick_random()
func generate_money(min_money := 150, max_money := 500): return randi_range(min_money, max_money)

func generate_traits():
  var attr_count := randi_range(0, 4)
  var list: Array[String] = trait_list.duplicate()
  list.shuffle()
  list = list.slice(0, attr_count)
  return list
