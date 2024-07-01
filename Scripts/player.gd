extends CharacterBody2D

# Gravity shit.
var SPEED = 300.0
var JUMP_VELOCITY = -700.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# State definitions go under here,
# is_on_floor should be used as grounded state, probably
var in_air
var endlag 
var walking
var dashing = false # Refers to the secondary dash state, not regular walking. 
var idle
var basic_attack
var spin_attack
var should_handle_endlag


func _ready():
	idle = true
	endlag = false

func _physics_process(delta):
	
	if velocity.x < 0:
		$Sprite2D.flip_h = true
	elif velocity.x > 0:
		$Sprite2D.flip_h = false
	
	if idle or walking == true:
		$AnimationPlayer.play("default")
	if idle == true:
		SPEED = 300.0
	
	if not is_on_floor():
		in_air = true
		velocity.y += gravity * delta
	else:
		in_air = false
	
	if is_on_floor() == false and endlag == false and Input.is_action_just_pressed("fast_fall"):
		velocity.y += 700

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		var walking = true
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if endlag == false and is_on_floor() == true and Input.is_action_just_pressed("sprint"):
		print("switch")
		SPEED = 600
		
	if velocity.x == 0 and velocity.y == 0:
		idle = true
	else:
		idle = false
	
	if is_on_floor() and endlag == false and $BasicAttackTimer.time_left == 0:
		if Input.is_action_just_pressed("attack"):
			should_handle_endlag = true
			basic_attack = true
			endlag = true
			$AnimationPlayer.play("attack")
			
	if in_air == true and endlag == false and Input.is_action_just_pressed("attack"):
		should_handle_endlag = true
		spin_attack = true
		endlag = true
		$AnimationPlayer.play("spin")
	
	if should_handle_endlag == true:
		if endlag == true:
			should_handle_endlag = false
			handle_endlag()
		
	move_and_slide()

func handle_endlag():
	idle = false
	if basic_attack == true:
		$BasicAttackTimer.start()
	
	if spin_attack == true:
		$SpinAttackTimer.start()


func _on_basic_attack_timer_timeout():
	endlag = false
	basic_attack = false
	idle = true


func _on_spin_attack_timer_timeout():
	endlag = false
	spin_attack = false
	idle = true
