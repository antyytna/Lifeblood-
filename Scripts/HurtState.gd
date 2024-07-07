class_name HurtState
extends State
signal finished
var direction

@export var Actor: CharacterBody2D
@export var Animator: AnimationPlayer
@export var HurtTimer: Timer
@export var Hitbox: Area2D

var knockback = 30

func _enter_state() -> void:
	direction = (Autoloads.player_pos - Actor.position).normalized()
	HurtTimer.start()
	set_physics_process(true)
	
func _exit_state() -> void:
	set_physics_process(false)

func _ready():
	set_physics_process(false)
	
func _physics_process(delta):
	Actor.position -= direction * knockback * delta


func _on_hurt_timer_timeout():
	finished.emit()
