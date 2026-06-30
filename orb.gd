extends Area2D

@export var exp_val = 1
 
var target = null
var speed = -1

@onready var _animated_sprite = $AnimatedSprite2D

func _ready() -> void:
	_animated_sprite.play("Orb")


func _physics_process(delta: float) -> void:
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 3*delta
		
func collect():
	queue_free()
	return exp_val
