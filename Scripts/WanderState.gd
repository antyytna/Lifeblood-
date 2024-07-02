class_name WanderState
extends State
@export var DetectionZone: Area2D
@export var Actor: CharacterBody2D
@export var Animator: AnimatedSprite2D
@export var ChangeMov: Timer
var speed

signal found_player

func _ready():
	speed = randf_range(-100, 100)
	ChangeMov.start()

func _enter_state() -> void:
	set_physics_process(true)
	ChangeMov.start()
	
func _physics_process(delta):
	Actor.velocity.x = speed * delta
	
	Actor.move_and_slide()
	
func _exit_state() -> void:
	set_physics_process(false)
	pass


func _on_wander_timer_timeout():
	print(speed)
	print("timeout")
	speed = randf_range(-100, 100)

func _on_detection_zone_body_entered(body):
	if body.is_in_group("player"):
		found_player.emit()
