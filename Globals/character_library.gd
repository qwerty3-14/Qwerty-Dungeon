extends Node

var actor_info_dict : Dictionary[String, ActorInfo]
var packed_scene_dict : Dictionary[String, PackedScene] = {
	"Narine": preload("uid://yuvv0y32kwy2"),
	"Bronze": preload("uid://cdo3d45ymn5uf"),
	"Sydney": preload("uid://bbc7pp7114jgg"),
	"Scarlet": preload("uid://cmd7nlwoq1fev")
}

func _ready() -> void:
	print("Actor Library: ")
	var path : String = "res://Combat Objects/Player Characters/"
	for file_name : String in ResourceLoader.list_directory(path):
		#print(file_name)
		if file_name.ends_with(".tres"):
			var info : ActorInfo = load(path + file_name)
			actor_info_dict.get_or_add(info.character_name, info)
			print(info.character_name)
	print("")
