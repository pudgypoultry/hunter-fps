extends Node3D
class_name BaseGun

@export var weapon_manager : WeaponManager
@export var projectile : Area3D
@export var muzzle_position : Node3D
@export var fire_direction : RayCast3D
@export var bullet_behavior : PackedScene
@export var projectile_speed : float = 10.0
@export var bullet_lifetime : float = 2.0
@export var fire_interval : float = 0.5
@export var damage_amount : float = 5.0
@export var weapon_animator : WeaponAnimation
@export var vfx_animator : AttackVFX
@export var player_reference : PlayerController


var is_active_gun : bool = false
var just_fired : bool = false
var active_bullets : Array = []
var timer : float = 0.0

signal gun_ready


func _ready() -> void:
	GameManager.gun_list.append(self)
	if !weapon_manager:
		weapon_manager = get_parent()
	gun_ready.connect(weapon_manager._on_gun_ready)


func _physics_process(delta: float) -> void:
	if just_fired:
		timer += delta
	if timer >= fire_interval:
		timer = 0
		gun_ready.emit(self)
		just_fired = false


func fire():
	just_fired = true
	var bullet = projectile.duplicate()
	var behavior : BaseBullet = bullet_behavior.instantiate()
	bullet.visible = true
	bullet.add_child(behavior)
	get_tree().root.add_child(bullet)
	active_bullets.append(bullet)
	bullet.global_position = muzzle_position.global_position
	bullet.look_at(fire_direction.to_global(fire_direction.target_position))
	behavior.prepare(
		(fire_direction.to_global(fire_direction.target_position) - fire_direction.global_position).normalized(),
		projectile_speed,
		bullet_lifetime,
		self
		)
	# print_debug(weapon_animator)
	weapon_animator.perform_animation()
	vfx_animator.perform_animation()


func equip_gun():
	is_active_gun = true


func unequip_gun():
	is_active_gun = false


func _on_hit(body : Node3D, bullet : BaseBullet):
	print(bullet.name + " found something: " + body.name)
	if body is BaseEnemy:
		body.damage_me(damage_amount, bullet.actor_reference.position, -bullet.actor_reference.basis.z)
	active_bullets.erase(bullet)
	bullet.clean_up()


func _notification(alert):
	if (alert == NOTIFICATION_PREDELETE):
		GameManager.gun_list.erase(self)
