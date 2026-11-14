extends Area2D
@export_enum("N","S","E","W") var door_direction: String = "E"#export enum sets the dropdown in inspector and allows you to check direction, second part defaults it to E

@onready var tween = get_tree().create_tween()
func _ready() -> void:#godot always automatically calls it when door is added
	body_entered.connect(_on_body_entered)#when a body touches it it calls the on body entered function in line 16
	GameManager.target_door_name = ""#declaring target door name as a string
	for child in get_parent().get_children(): #loops over everything in the room for touching door
		if child is CharacterBody2D:#if the thing that is found is the character
			child.global_position = $Start.global_position#teleport to beginning of door
			$CollisionShape2D.disabled = true #disables collision
			tween.tween_property(child, ":position", $Spawn.global_position, 1)#starts walk animation
			tween.tween_callback(func(): $CollisionShape2D.disabled = false)#reeneables collision
			print("moved the player to", $Spawn.global_position)#debugging
			break#ends function
func _on_body_entered(body: Node2D) -> void: #called when touching door
	if body is CharacterBody2D:#checks if its a 2d body
		GameManager.move_through_door(door_direction)#tells game manager that the player left the room through this doors directions
