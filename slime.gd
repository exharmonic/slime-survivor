extends CharacterBody2D

var player
var health = 3
@onready var orb = preload("res://orb.tscn")

func _ready() -> void:
	player = get_node("/root/Game/Player")
	%Slime.play_walk()


func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 300
	move_and_slide()
	
func take_damage():
	health-=1
	%Slime.play_hurt()
	if health == 0:
		slime_kill()

func slime_kill():
		queue_free()
		Globals.count+=1
		get_parent().find_child("Slimes count").find_child("slimes_count").text = "Slimes killed: "+str(Globals.count)
		const SMOKE_EXPLOSION = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke_explosion = SMOKE_EXPLOSION.instantiate()
		get_parent().add_child(smoke_explosion)
		smoke_explosion.global_position = global_position
		var new_orb = orb.instantiate()
		get_parent().add_child(new_orb)
		new_orb.global_position = global_position
		
