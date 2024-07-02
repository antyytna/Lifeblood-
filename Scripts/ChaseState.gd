class_name ChaseState
extends State
@export var DetectionZone: Area2D
@export var Actor: CharacterBody2D
@export var Animator: AnimatedSprite2D
signal lost_player

func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	pass
	
func _exit_state() -> void:
	set_physics_process(false)
	pass

func _physics_process(delta):
	Actor.position = Actor.position - Autoloads.player_pos * delta


func _on_detection_zone_body_exited(body):
	if body.is_in_group("player"):
		lost_player.emit()
