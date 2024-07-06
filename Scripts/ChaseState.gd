class_name ChaseState
extends State
@export var DetectionZone: Area2D
@export var Actor: CharacterBody2D
@export var Animator: AnimatedSprite2D
@export var AttackTimer: Timer
@export var AttackArea: Area2D
signal lost_player
signal in_range
var player_range

func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	pass
	
func _exit_state() -> void:
	set_physics_process(false)
	pass

func _physics_process(delta):
	var direction = (Autoloads.player_pos - Actor.position).normalized()
	Actor.position += direction * Actor.SPEED * delta
	
	if AttackTimer.time_left == 0 and player_range == true:
		print("in range")
		AttackTimer.start()
		in_range.emit()


func _on_detection_zone_body_exited(body):
	if body.is_in_group("player"):
		lost_player.emit()


func _on_attack_area_body_entered(body):
	if body.is_in_group("player"):
		player_range = true
