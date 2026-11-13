extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var dashing: bool = false
var dashing_endlag := false

func _physics_process(delta: float) -> void:

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var dash_input := Input.is_action_just_pressed("Dash")
	var direction_y := Input.get_axis("Up", "Down")
	var direction_x := Input.get_axis("Left", "Right")
	var input_dir := Vector2(direction_x, direction_y).normalized()
	if not dashing_endlag:
		if not dash_input:
			if not dashing:
				if direction_x:
					velocity.x = input_dir.x * SPEED
				else:
					velocity.x = move_toward(velocity.x, 0, SPEED)
				if direction_y:
					velocity.y = input_dir.y * SPEED
				else:
					velocity.y = move_toward(velocity.y, 0, SPEED)
			if dashing:
				velocity.x = move_toward(velocity.x, 0, 1)
				velocity.y = move_toward(velocity.y, 0, 1)
		else:
			if not dashing:
				dash(input_dir.x, input_dir.y)
			else:
				print("Dash on cooldown.")
	else:
		velocity.x = 0
		velocity.y = 0
		print("Endlag.")

	move_and_slide()

func dash(direction_x, direction_y) -> void:
	if not dashing:
		dashing = true
		if direction_x:
			velocity.x = direction_x * (SPEED * 3)
		if direction_y:
			velocity.y = direction_y * (SPEED * 3)
		await get_tree().create_timer(0.2).timeout
		dashing = false
		dashing_endlag = true
		await get_tree().create_timer(0.2).timeout
		dashing_endlag = false
			
