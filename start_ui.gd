extends Control

func _physics_process(_delta: float) -> void:
		%AnimationPlayer.play("(un)zoom")

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit(0)
