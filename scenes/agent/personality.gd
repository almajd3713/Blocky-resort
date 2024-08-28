extends Node
class_name AgentPersonality

static var agent_generators: AgentGenerators = ResourceLoader.load('res://resources/agent_data/agent_generators.tres')

var money: int:
	set(new_val):
		money = new_val
		if money < 0: money = 0
var happiness: int:
	set(new_val):
		happiness = clamp(new_val, 0, 100)

var first_name := "John"
var last_name := "Doe"
var gender := Data.Gender.MALE

var traits: Array[String]

var needs := {

}
var wants := {

}

func _ready() -> void:
	generate_personality()

func generate_personality():
	first_name = agent_generators.generate_first_name()
	last_name = agent_generators.generate_last_name()
	money = agent_generators.generate_money()
	traits = agent_generators.generate_traits()
