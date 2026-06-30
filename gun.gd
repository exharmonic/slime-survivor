extends Area2D

func _physics_process(_delta: float) -> void:
	#var enemies_in_range = get_overlapping_bodies()
	#if enemies_in_range.size()>0:
		#var target_enemy = enemies_in_range.front()	
		look_at(get_global_mouse_position())
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shoot()

func shoot():
	const BULLET = preload("res://bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %shooting_point.global_position
	new_bullet.global_rotation = %shooting_point.global_rotation
	%shooting_point.add_child(new_bullet)
