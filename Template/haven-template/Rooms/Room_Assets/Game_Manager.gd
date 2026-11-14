extends Node

#allows it to autoload
const DIRS := {
	#assigns direction to grid offsets
	"N": Vector2i.UP,
	"E": Vector2i.RIGHT,
	"S": Vector2i.DOWN,
	"W": Vector2i.LEFT
}
const OPPOSITE := {
	#shows the direction you arrive in when you go through the door
	"N": "S",
	"S": "N",
	"W": "E",
	"E": "W"
}
const ROOM_POOLS := {
	#1-Door
	"N": ["res://Rooms/Room_Scenes/All_Room_Types/1_Door_Rooms/N.tscn"],
	"E": ["res://Rooms/Room_Scenes/All_Room_Types/1_Door_Rooms/E.tscn"],
	"S": ["res://Rooms/Room_Scenes/All_Room_Types/1_Door_Rooms/S.tscn"],
	"W": ["res://Rooms/Room_Scenes/All_Room_Types/1_Door_Rooms/W.tscn"],
	#2-Doors
	"ES": ["res://Rooms/Room_Scenes/All_Room_Types/2_Door_Rooms/E_S.tscn"],
	"EW": ["res://Rooms/Room_Scenes/All_Room_Types/2_Door_Rooms/E_W.tscn"],
	"EN": ["res://Rooms/Room_Scenes/All_Room_Types/2_Door_Rooms/N_E.tscn"],
	"NS": ["res://Rooms/Room_Scenes/All_Room_Types/2_Door_Rooms/N_S.tscn"],
	"NW": ["res://Rooms/Room_Scenes/All_Room_Types/2_Door_Rooms/N_W.tscn"],
	"SW": ["res://Rooms/Room_Scenes/All_Room_Types/2_Door_Rooms/S_W.tscn"],
	#3-Doors
	"ESW": ["res://Rooms/Room_Scenes/All_Room_Types/3_Door_Rooms/E_S_W.tscn"],
	"ENS": ["res://Rooms/Room_Scenes/All_Room_Types/3_Door_Rooms/N_E_S.tscn"],
	"ENW": ["res://Rooms/Room_Scenes/All_Room_Types/3_Door_Rooms/N_E_W.tscn"],
	"NSW": ["res://Rooms/Room_Scenes/All_Room_Types/3_Door_Rooms/N_S_W.tscn"], 
	#4-Doors
	"ENSW": ["res://Rooms/Room_Scenes/All_Room_Types/4_Door_Rooms/N_S_E_W.tscn"]
}

const BOSS_ROOM_SCENE := "res://Rooms/Room_Scenes/All_Room_Types/1_Door_Rooms/Boss.tscn"
#stores boss scene
#Variables for States
var dungeon: Dictionary = {}
#holds dungeon map
var current_coords: Vector2i = Vector2i.ZERO
#holds the cord in our grid the player is in
var entry_direction: String = ""
#direction you entry from
func generate_dungeon(main_path_length: int = 6, branch_count: int = 2):
	#steup function that defines a 6 rooom path whith 2 side branches that lead to nothing
	while not _try_build_layout(main_path_length, branch_count): 
		#makes sure the function keeps trying to generate until it does succeed
		pass
	for coords: Vector2i in dungeon.keys():
		#for loop loops through all coordinates made during the generation and checks its condition
		var cells: Dictionary = dungeon[coords]
		if cells ["kind"] == "boss": 
			#checks for boss room
			cells ["scene"] = BOSS_ROOM_SCENE
		else:
			#if not it converts the rooms doors into a alphabet look up key and then chooses random matching rooms. 
			var key := _get_direction_key(cells["doors"])
			var pool: Array = ROOM_POOLS[key]    
			cells["scene"] = pool.pick_random() 
func _try_build_layout(main_path_length: int, branch_count: int) -> bool:
	dungeon.clear() 
	#wipes last run
	var main_path: Array[Vector2i] = [Vector2i.ZERO]
	#starts grid of coords from 0
	dungeon[Vector2i.ZERO] = {"doors": [], "scene": "", "kind": "start"}
	#registers the starting room of the dungeon 
	while main_path.size() < main_path_length - 1: 
	#Makes sure that the process loops until the main path is one short of the final room which is the boss room 
		var current: Vector2i = main_path.back()
		#looks at the room at the tip of the main path
		var open_dirs_current := _get_unvisited_neighbors(current)
		#finds which adjacent grid spaces are still empty that we can go to
		if open_dirs_current.is_empty():#checks if the random
			return false
		var chosen_dir: String = open_dirs_current.pick_random()
		var next_coords: Vector2i = current + DIRS[chosen_dir]
		dungeon[next_coords] = {"doors": [], "scene": "", "kind": "normal"}
		_connect_rooms(current,next_coords, chosen_dir)
		main_path.append(next_coords) 
# 2. Place the Boss Room at the end (always 1 step North so it uses a South entrance)
		var pre_boss: Vector2i = main_path.back()
		var boss_coords: Vector2i = pre_boss + DIRS["N"]
		if dungeon.has(boss_coords):
			return false 
		dungeon[boss_coords] = { "doors": [], "scene": "", "kind": "boss" }
		_connect_rooms(pre_boss, boss_coords, "N")
		main_path.append(boss_coords)

	# 3. Add side branches ONLY to 2-door rooms (turns them into 3-door rooms)
		var candidates: Array[Vector2i] = []
		for coords in main_path:
			if dungeon[coords]["kind"] == "normal" and dungeon[coords]["doors"].size() == 2:
				candidates.append(coords)
		candidates.shuffle()
		var branches_added := 0
		for junction in candidates:
			if branches_added >= branch_count:
				break#exits loop
			var open_dirs_junction := _get_unvisited_neighbors(junction)
			if open_dirs_junction.is_empty():
				continue#repeats loop from 103
			var branch_dir: String = open_dirs_junction.pick_random()
			var dead_end: Vector2i = junction + DIRS[branch_dir]
			dungeon[dead_end] = { "doors": [], "scene": "", "kind": "reward" }
			_connect_rooms(junction, dead_end, branch_dir)#adds branch
			branches_added += 1
	return true
func _connect_rooms(a: Vector2i, b: Vector2i, dir_from_a_to_b: String) -> void:
	dungeon[a]["doors"].append(dir_from_a_to_b)#adds direction we add
	dungeon[b]["doors"].append(OPPOSITE[dir_from_a_to_b])#adds direction we add
func _get_unvisited_neighbors(coords: Vector2i) -> Array[String]:
	var available: Array[String] = []
	for dir: String in DIRS.keys():
		if not dungeon.has(coords + DIRS[dir]):
			available.append(dir)
	return available
func _get_direction_key(dirs: Array) -> String:
	var sorted := dirs.duplicate()#takes array and turns it into a room key readable to us
	sorted.sort()
	return "".join(sorted)
func start_run() -> void:
	generate_dungeon(6, 2)
	current_coords = Vector2i.ZERO
	entry_direction = ""
	get_tree().change_scene_to_file.call_deferred(dungeon[current_coords]["scene"])
func move_through_door(exit_direction: String) -> void:
	if not dungeon.has(current_coords):
		return
	current_coords += DIRS[exit_direction]
	entry_direction = OPPOSITE[exit_direction]
	get_tree().change_scene_to_file.call_deferred(dungeon[current_coords]["scene"])
var target_door_name: String = "" 
