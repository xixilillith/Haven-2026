extends Node

#allows it to autoload
"""
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
const Room_Pools := {
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
func generate_dungeon(main_path_length: int = 6, branch count: int = 2):
	#steup function that defines a 6 rooom path whith 2 side branches that lead to nothing
	while not _try_build_layout(main_path_length, branch_count): 
		#makes sure the function keeps trying to generate until it does succeed
		pass
	for coords: Vector2i in dungeon.keys():
		#for loop loops through all coordinates made during the generation and checks its condition
		var cells: Dictionary = dungeon[coords]
		if cell ["kind"] == "boss": 
			#checks for boss room
			cell ["scene"] = BOSS_ROOM_SCENE
		else:
			#if not it converts the rooms doors into a alphabet look up key and then chooses random matching rooms. 
			var key := _get_direction_key(cell["doors"])
			var pool: Array = ROOM_POOL[key]    
			cell["scene"] = pool.pick_random() 
func try_build_layout(main_path_length: int, branch_count: int) -> bool:
	dungeon.clear() 
	#wipes last run
	var main_path: Array[Vector2i] = [Vector2i.ZERO]
	#starts grid of coords from 0
	dungeon[Vector2i.ZERO] = {"doors": [], "scene": "", "kind": "start"}
	#registers the starting room of the dungeon 
	while main_path.size() < main_path_length - 1: 
	#Makes sure that the process loops until the main path is one short of the final room which is the boss room 
		var_current := main_path.back()
		#looks at the room at the tip of the main path
		var open_dirs := _get_unvisited_neighbors(current)
		#finds which adjacent grid spaces are still empty that we can go to
		if open_dirs.is_empty():
			
			return false
		var chosen_dir: String = open_dirs.pick_random()
		var next_coords: Vector2i = current + DIRS[chosen_dir]
		dungeon[next_coords] = {"doors": [], "scene": "", "kind": "normal"}
		_connect_rooms(current,next_coords, chosen_dir)
		main_path.append(next coords) 
"""
var target_door_name: String = "" 
