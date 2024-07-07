extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var fsm = $FiniteStateMachine
@onready var wanderstate = $FiniteStateMachine/WanderState
@onready var chasestate = $FiniteStateMachine/ChaseState
@onready var hurtstate = $FiniteStateMachine/HurtState

func _ready():
	wanderstate.found_player.connect(fsm.change_state.bind(chasestate))
	chasestate.lost_player.connect(fsm.change_state.bind(wanderstate))
	chasestate.hurt.connect(fsm.change_state.bind(hurtstate))
	hurtstate.finished.connect(fsm.change_state.bind(wanderstate))

func _physics_process(delta):
	
	if velocity.x < 0:
		$Sprite2D.scale = Vector2(-1.0, 1.0)
	elif velocity.x > 0:
		$Sprite2D.scale = Vector2(1.0, 1.0)
	
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()



func _on_hitbox_area_entered(area):
	if area.is_in_group("player_attack"):
		print("enemy hit")
