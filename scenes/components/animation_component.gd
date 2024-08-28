class_name AnimationComponent extends Node


## If the origin point is centered or not
@export var time := 0.3
@export var transition_type: Tween.TransitionType = Tween.TRANS_LINEAR
@export var ease_type: Tween.EaseType = Tween.EASE_IN
@export var from_center := false

@onready var target := get_parent()

func add_transition(property: String, value):
  var tween = create_tween()
  tween.tween_property(target, property, value, time).set_trans(transition_type).set_ease(ease_type)