extends Node

signal toggle_build_mode(build_type: String)
signal build_building(build: BuildingTemplate)
signal toggle_destroy_mode(val: bool)
signal destroy_building(build: BuildingTemplate)
signal move_agent(val: bool)
signal store_building(build: BuildingTemplate)
signal create_action_sequence
