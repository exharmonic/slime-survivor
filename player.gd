extends CharacterBody2D

signal health_depleted	
var health = 100.0
var DAMAGE_RATE
var experience_level
var experience 
var collected_experience
var boom_timer

#BOOMERANG VARIABLES
var BOOMERANG
var boom_speed
var boomable_slimes = []
var boom_index
var boom
var boom_count

func _ready() -> void:
	experience_level = 1
	experience = 0
	collected_experience = 0	
	set_expbar(experience, calculate_experiencecap())
	boom_timer = %BoomTimer
	boom_speed = 1000
	boom_count = 10
	BOOMERANG = preload("res://boomerang.tscn")
	%ProgressBar.get("theme_override_styles/fill").bg_color = Color(0.0, 1.0, 0.0, 1.0)
func _physics_process(delta: float) -> void: 
	
	DAMAGE_RATE = 15.0
	
	var direction = Input.get_vector("move_left", "move_right", "move_up","move_down")
	velocity = direction * 600
	move_and_slide()

	if(velocity.length()>0.0): 
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()
		
	var overlapping_slimes = %hurt_box.get_overlapping_bodies()
	if overlapping_slimes.size() > 0:
		if not overlapping_slimes[0].has_method("slime_kill"):
			DAMAGE_RATE = 200
		health-=DAMAGE_RATE * overlapping_slimes.size() * delta
		%ProgressBar.value = health
		%AnimationPlayer.play("new_animation")
		var green = %ProgressBar.get("theme_override_styles/fill").bg_color.g
		var red = %ProgressBar.get("theme_override_styles/fill").bg_color.r
		if health >= 60:
			%ProgressBar.get("theme_override_styles/fill").bg_color.r=red + 0.5 * delta
		else:
			%ProgressBar.get("theme_override_styles/fill").bg_color.g=green - 0.55 * delta
			
		if health <= 0.0:
			health_depleted.emit()
	else:
		%AnimationPlayer.play("RESET")
	
	if InputMap.has_action("shoot_boom") and Input.is_action_just_pressed("shoot_boom"):
		throw_boomerang()
		
#	BOOMERANG CODE!!
	if experience_level >= 5:
		boom_count	= 15
	elif experience_level >= 10:
		boom_count = 20
		

	if boom_timer.is_stopped():
		%BoomRect.self_modulate = Color(1.0, 1.0, 1.0, 0.29)
		%BoomRect.get_child(0).self_modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	else:
		%BoomRect.self_modulate = Color(0.471, 0.471, 0.471, 0.675)
		%BoomRect.get_child(0).self_modulate = Color(0.471, 0.471, 0.471, 0.675)
	if boom == null:
		return
	if (boom_index >= boomable_slimes.size()):
		if boom.global_position.distance_to(global_position) <= boom_count:
			boom.queue_free()
			boom = null
			return
		boom.rotation = (global_position-boom.global_position).normalized().angle()
		boom.global_position = boom.global_position.move_toward(global_position, boom_speed * delta)
		return
	var target = boomable_slimes[boom_index]
	if not is_instance_valid(target):
		boom_index += 1
		return
	var boom_dir = (target.global_position-boom.global_position).normalized()
	boom.global_position = boom.global_position.move_toward(target.global_position, boom_speed * delta)
	boom.rotation = boom_dir.angle()
	if boom.global_position.distance_to(target.global_position) <= 10	:
			if target.has_method("slime_kill"):
				target.slime_kill()
			boom_index += 1
			
	
func _on_collect_area_area_entered(area: Area2D) -> void:
	area.target = self

func _on_grab_area_area_entered(area: Area2D) -> void:
	var orb_experience = area.collect()
	calculate_experience(orb_experience)

func calculate_experience(orb_experience):
	var experience_required = calculate_experiencecap()
	collected_experience+=orb_experience
	if experience+collected_experience >= experience_required:
		collected_experience -= experience_required-experience
		experience_level += 1
		%Level.text = str(experience_level)
		experience = 0
		calculate_experience(0)
	else:
		experience += collected_experience
		collected_experience = 0
	set_expbar(experience, calculate_experiencecap())

func calculate_experiencecap():
	var exp_cap
	if experience_level < 5:
		exp_cap = experience_level*5
	elif experience_level < 10:
		exp_cap = 95 + (experience_level-5)*8
	else:
		exp_cap = 255 + (experience_level-9)*12
	return exp_cap
	
func set_expbar(set_value = 1, set_max_value = 100):
	%LevelBar.value = set_value
	%LevelBar.max_value = set_max_value

func throw_boomerang():
	boomable_slimes = %BoomerangArea.get_overlapping_bodies().slice(0,boom_count)
	if boom_timer.is_stopped() and boomable_slimes.size()>0:
		boom = BOOMERANG.instantiate()
		add_child(boom)
		boom_index = 0
		boom.global_position = global_position
		boom_timer.start()
	
