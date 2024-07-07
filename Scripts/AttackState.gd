class_name AttackState
extends State
signal lost_player
signal attack_finished

func _enter_state() -> void:
	set_physics_process(true)
	
func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	pass
