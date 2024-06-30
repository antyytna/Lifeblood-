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


func _ready():
	idle = true
	endlag = false

func _physics_process(delta):
	print(velocity.x)
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
	if direction and endlag == false:
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
		
	move_and_slide()
