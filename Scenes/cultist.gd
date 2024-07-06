extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var fsm = $FiniteStateMachine
@onready var wanderstate = $FiniteStateMachine/WanderState
@onready var chasestate = $FiniteStateMachine/ChaseState

func _ready():
	wanderstate.found_player.connect(fsm.change_state.bind(chasestate))
	chasestate.lost_player.connect(fsm.change_state.bind(wanderstate))

func _physics_process(delta):
	
	if velocity.x < 0:
		$AnimatedSprite2D.scale = Vector2(-0.3, 0.3)
	elif velocity.x > 0:
		$AnimatedSprite2D.scale = Vector2(0.3, 0.3)
	
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()



func _on_hitbox_area_entered(area):
	if area.is_in_group("player_attack"):
		print("enemy hit")
