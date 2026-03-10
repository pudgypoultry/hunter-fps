extends Node3D
class_name WeaponAnimation

var tween : Tween
var original_position : Vector3
var original_rotation : Vector3
var original_scale : Vector3


func _ready() -> void:
	original_position = position
	original_rotation = rotation
	original_scale = scale


func perform_animation():
	TweenTools.TweenRotation(self, tween, original_rotation + Vector3(deg_to_rad(30), 0, 0), 0.05)
	await get_tree().create_timer(0.1).timeout
	TweenTools.TweenRotation(self, tween, original_rotation, 0.45)
	await get_tree().create_timer(0.4).timeout
