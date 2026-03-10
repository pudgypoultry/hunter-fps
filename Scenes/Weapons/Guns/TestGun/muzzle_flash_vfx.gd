extends Node3D
class_name AttackVFX

@export var particles : Array[GPUParticles3D] = []

func _ready():
	for child in get_children():
		if !(child in particles):
			particles.append(child)


func perform_animation():
	# print("Animating")
	rotation.z = randf() * deg_to_rad(90.0)
	for particle in particles:
		particle.emitting = true
