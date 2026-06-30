extends Node2D

var SLIME_BOSS 
var slime_boss
var has_spawned
func _ready() -> void:
	%AnimationPlayer.play("disappear")
	SLIME_BOSS = preload("res://slime_boss.tscn")
	has_spawned = false
	%BoomRect.visible = false
	
func _physics_process(_delta: float) -> void:
	if not %AnimationPlayer.is_playing() and not has_spawned:
		slime_boss = SLIME_BOSS.instantiate()
		add_child(slime_boss)
		slime_boss.global_position = Vector2(1300,550)
		has_spawned = true
		InputMap.erase_action("shoot_boom")
	if slime_boss == null and has_spawned == true:
		%Game_Over.visible = true
		%Label.text = "GAME OVER!! (Successfully)\nScore: "+str(Globals.count)


func _on_player_health_depleted() -> void:
	get_tree().paused = true
	%Game_Over.visible = true
	%Label.text = "GAME OVER!!\nScore: "+str(Globals.count)
