extends CharacterBody2D

var player
var health = 75
var can_move := true
var is_moving := false
var jump_speed := 800.0
var phase
var health_bar
@onready var orb = preload("res://orb.tscn")

func _ready() -> void:
	player = get_node("/root/Boss_Battle/Player")
	phase = 1
	%AnimationPlayer.speed_scale = 2.5
	health_bar = get_node("/root/Boss_Battle/GUI/BossHealth")
	health_bar.visible = true

func _physics_process(_delta: float) -> void:
	health_bar.value = health
	# Allow next jump when cooldown ends
	if health <= 30 and phase == 1:
		print("Enterred phase 2")
		phase = 2
		%AnimationPlayer.speed_scale = 4
		%Timer.wait_time = 0.5
		jump_speed = 1000
		
	
	if %Timer.is_stopped():
		can_move = true

	# Start a jump burst
	if can_move:
		start_jump()

	# Apply movement while jumping
	if is_moving:
		move_and_slide()

func take_damage():
	health-=1
	print(health)
	if health == 0:
		slime_boss_kill()
	
func start_jump() -> void:
	can_move = false
	is_moving = true

	%AnimationPlayer.play("jump")
	%Timer.start()

	var direction = global_position.direction_to(player.global_position)
	velocity = direction * jump_speed
	#print(velocity)

func end_jump() -> void:
	is_moving = false
	velocity = Vector2.ZERO

func slime_boss_kill():
		queue_free()
		Globals.count+=10
		#get_parent().find_child("Slimes count").find_child("slimes_count").text = "Slimes killed: "+str(Globals.count)
		const SMOKE_EXPLOSION = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke_explosion = SMOKE_EXPLOSION.instantiate()
		smoke_explosion.scale = Vector2(5,5)
		get_parent().add_child(smoke_explosion)
		smoke_explosion.global_position = global_position
		var new_orb = orb.instantiate()
		var new_orb1 = orb.instantiate()
		var new_orb2 = orb.instantiate()
		var new_orb3 = orb.instantiate()
		var new_orb4 = orb.instantiate()
		get_parent().add_child(new_orb)
		get_parent().add_child(new_orb1)
		get_parent().add_child(new_orb2)
		get_parent().add_child(new_orb3)
		get_parent().add_child(new_orb4)
		new_orb.global_position = global_position
		new_orb1.global_position = global_position
		new_orb2.global_position = global_position
		new_orb3.global_position = global_position
		new_orb4.global_position = global_position
