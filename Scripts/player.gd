extends CharacterBody2D

# Gravity shit.
var SPEED = 300.0
var JUMP_VELOCITY = -1000.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const FALL_GRAVITY = 2500

# State definitions go under here,
# is_on_floor should be used as grounded state, probably
var in_air
var endlag 
var walking
var dashing = false # Refers to the secondary dash state, not regular walking. 
var idle
var basic_attack
var spin_attack
var dash_attack
var should_handle_endlag
var direction
var combo_basic = 0

func _ready():
	idle = true
	endlag = false

func _physics_process(delta):
	Autoloads.player_pos = self.position
	
	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 4
	
	if velocity.x < 0:
		$Sprite2D.scale = Vector2(-0.3, 0.3)
	elif velocity.x > 0:
		$Sprite2D.scale = Vector2(0.3, 0.3)
	
	if idle or walking == true:
		$AnimationPlayer.play("default")
	if idle == true:
		SPEED = 300.0
	
	if not is_on_floor():
		in_air = true
		velocity.y += get_gravity(velocity) * delta
	else:
		in_air = false
	
	if is_on_floor() == false and endlag == false and Input.is_action_just_pressed("fast_fall"):
		velocity.y += 700

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and endlag == false:
		velocity.y = JUMP_VELOCITY
		
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction and endlag == false:
		var walking = true
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if endlag == false and is_on_floor() == true and Input.is_action_just_pressed("sprint"):
		SPEED = 600
		
	if endlag == false and Input.is_action_just_released("sprint"):
		SPEED = 300
		
	if velocity.x == 0 and velocity.y == 0:
		idle = true
	else:
		idle = false
	
	if is_on_floor() and endlag == false and $BasicAttackTimer.time_left == 0 and SPEED < 600:
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
		
	if SPEED == 600 and Input.is_action_just_pressed("attack") and endlag == false and $DashAttackTimer.time_left == 0:
		dash_attack = true
		should_handle_endlag = true
		endlag = true
		$AnimationPlayer.play("attack")
	
	if should_handle_endlag == true:
		SPEED = 0
		if endlag == true:
			should_handle_endlag = false
			
			handle_endlag(direction)
		
	move_and_slide()

func handle_endlag(direction):
	idle = false
	if basic_attack == true:
		velocity.x = 0
		$BasicAttackTimer.start()
		$BasicAttackComboTimer.start()
		if combo_basic < 4 and $BasicAttackTimer.is_processing and $BasicAttackComboTimer.time_left == 0 and Input.is_action_just_pressed("attack"):
			$AnimationPlayer.play("attack")
			$BasicAttackTimer.start()
			combo_basic += 1
			
	
	if spin_attack == true:
		velocity.x = 300 * direction
		$SpinAttackTimer.start()
		
	if dash_attack == true:
		velocity.x = 600 * direction
		$DashAttackTimer.start()
			


func _on_basic_attack_timer_timeout():
	endlag = false
	basic_attack = false
	idle = true


func _on_spin_attack_timer_timeout():
	endlag = false
	spin_attack = false
	idle = true


func _on_dash_attack_timer_timeout():
	endlag = false
	dash_attack = false
	idle = true

func get_gravity(velocity: Vector2):
	if velocity.y < 0:
		return gravity
	
	else:
		return FALL_GRAVITY


func _on_hitbox_body_entered(body):
	if body.is_in_group("enemy"):
		print("hit")

func FrameFreeze(timeScale, duration):
	Engine.time_scale = timeScale
	await get_tree().create_timer(duration * timeScale).timeout
	Engine.time_scale = 1.0
	


func _on_hitbox_area_entered(area):
	if area.name == "ValveArea":
		print("valve")
		if spin_attack == true:
			print("true")
