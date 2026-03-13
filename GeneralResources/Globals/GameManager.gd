extends Node

var player_reference : PlayerController
var enemy_list : Array[BaseEnemy]
var gun_list : Array[BaseGun]
var bullet_list : Array[BaseBullet]
var debug : bool = false

var last_bullet_num : int = 0

func _process(delta : float) -> void:
	if debug:
		if len(bullet_list) != last_bullet_num:
			print(bullet_list)
		last_bullet_num = len(bullet_list)
