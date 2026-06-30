extends Node2D

var player
var boss_dir
var boss_dist

func _ready() -> void:
	find_children("AnimationPlayer")[0].play("disappear")
	find_children("ColorRectAP")[0].play("Day Night Cycle")
	spawn_mob()
	spawn_mob()
	player = get_node("/root/Game/Player")
	%ArenaLabel.text = "Step in to challenge Slime Boss\n(Level requirement: 5)"
	
func _physics_process(_delta: float) -> void:
	boss_dir = (%BossFightLocation.global_position-player.global_position).normalized()
	%CompassNeedle.rotation = boss_dir.angle()
	boss_dist = player.global_position.distance_to(%BossFightLocation.global_position)- 318.52
	%BossDist.text = "Boss location: " + str(int(boss_dist))
	

func spawn_mob():
	if 0.7 <= %ColorRectAP.current_animation_position and %ColorRectAP.current_animation_position <= 1.3:
		%Timer1.wait_time = 0.5
	var new_mob = preload("res://slime.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)
	
func spawn_tree():
	var new_tree = preload("res://tree.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_tree.global_position = %PathFollow2D.global_position
	add_child(new_tree)

func _on_timer_timeout() -> void:
	spawn_mob()

func _on_tree_timer_timeout() -> void:
	spawn_tree()

func _on_player_health_depleted() -> void:
	get_tree().paused = true
	%Game_Over.visible = true
	%Label.text = "GAME OVER!!\nScore: "+str(Globals.count)


func _on_boss_fight_area_body_entered(body: Node2D) -> void:
	if body.has_method("throw_boomerang") and body.experience_level >= 2:
		get_tree().change_scene_to_file("res://boss_battle.tscn")
	else:
		print("Level not 2")
