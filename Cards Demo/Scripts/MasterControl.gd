extends Node

#merge with global_player for one script??
#or keep separate for ease?
#PlayerData Variables to keep between scenes
var loader
var wait_frames
var time_max = 100 # msec
var current_scene = null
var progress = 0.0

#var MOUSE_SENSITIVITY = 0.05
#
#var current_player_aiming_style = 0
#
#var total_points
#
#var Player_Weapon_Mod = 0

#var Options_Data = {
#	master_volume = 0,
#	music_volume = 0,
#	sfx_volume = 0,
#	aiming_cursor_show = 0,
#	slots_hint_show = 0,
#	look_sensitivity = 0.5,
#	language = "English",
#	difficulty = 0 # change to be set on new game setup instead of in options here??
#}

#var Game_Data = {
#	player01_unlocked = true,
#	player02_unlocked = false,
#	player03_unlocked = false,
#	player04_unlocked = true,
#	player05_unlocked = false,
#	player06_unlocked = false,
#	number_of_times_game_completed = 0,
#	arena_open = false
#}
#
#var arena_setup = {
#	difficulty = 1, #1 = easy, 2 = normal, 3 = hard
#	character_selected = 1, # 1 = bob, 2 = frank, 3 = dave, 4 = bobbi, 5 = frankie, 6 = neng
#	drop_rate = 1 # 1 = low, 2 = medium, 3 = hard
#}
#
#var arena_scores = {
#	score1 = 0,
#	score1char = "",
#	score2 = 0,
#	score2char = "",
#	score3 = 0,
#	score3char = "",
#	score4 = 0,
#	score4char = "",
#	score5 = 0,
#	score5char = "",
#}



#variables stored as dictionary for ease when saving
#var Player_Information = {
#	player_name = "",
#	player_sex = "",
#	player_strength = 10,
#	player_speed_max = 6.0,
#	player_speed_accel = 3.0,
#	player_speed_deaccel = 5.0,
#	player_speed_sprint_max = 12.0,
#	player_speed_sprint_accel = 6.0,
#	player_speed_attack_max = 3.0,
#	player_speed_attack_accel = 1.0,
#	player_jump = 5.0,
#
#	player_defence = 1.0,
#	player_defence_fists = 1.0,
#	player_defence_slashing = 1.0,
#	player_defence_trauma = 1.0,
#	player_defence_piercing = 1.0,
#	player_fire_affinity = 0.0,
#	player_ice_affinity = 0.0,
#	player_lightning_affinity = 0.0,
#	player_earth_affinity = 0.0,
#
#	player_level = 1,
#	player_max_level = 81,
#	player_xp = 0,
#	player_xp_next_level = 0,
#	player_xp_to_upgrades = 0,
#	player_upgrade_points = 0,
#	player_max_upgrade_points = 80,
#	player_strength_upgrades = 0,
#	player_speed_upgrades = 0,
#	player_jump_upgrades = 0,
#	player_defence_upgrades = 0,
#	player_fire_affinity_upgrades = 0,
#	player_ice_affinity_upgrades = 0,
#	player_lightning_affinity_upgrades = 0,
#	player_earth_affinity_upgrades = 0,
#
#	player_current_weapon_number = 0,
#	player_current_weapon_slot_number = 1,
#	player_current_armour_number = 0,
#	player_current_shield_number = 0,
#	player_current_helmet_number = 0,
#	player_current_item_number = 0,
#
#	player_weapon_in_scene = 0,
#	player_item_in_scene = 0,
#
#	player_inventory_is_full = false,
#
#	player_has_flame_burst = false,
#	player_has_fireball = false,
#	player_has_ice_spike_front = false,
#	player_has_ice_spikes_surround = false,
#	player_has_quake_spikes = false,
#	player_has_crush = false,
#	player_has_lightning_throw = false,
#	player_has_lightning_surround = false,
#
#	player_health = 100,
#	player_max_health = 150, 
#	player_mana = 50,
#	player_max_mana = 70,
#	player_lives = 5,
#	player_points = 0,
#	player_points_bonus = 0,
#	player_coins = 0,
#
#	player_healing_low_number = 0,
#	player_healing_high_number = 0,
#	player_manamore_low_number = 0,
#	player_manamore_high_number = 0,
#	player_elixer_of_strength_number = 0,
#	player_elixer_of_speed_number = 0,
#	player_elixer_of_fortitude_number = 0,
#	player_torches_number = 0,
#	shards_collected = 0,
#
#	current_level = 1,
#	level01unlocked = true,
#	level02unlocked = false,
#	level03unlocked = false,
#	level04unlocked = false,
#	level05unlocked = false,
#	level06unlocked = false,
#	level07unlocked = false,
#	level08unlocked = false,
#	level09unlocked = false,
#
#	spoken_to_castle_mage = false,
#	spoken_to_guard01 = false,
#	beaten_zombie_boss = false,
#	spoken_to_guard02 = false,
#	spoken_to_citadel_mage = false,
#	spoken_to_boatman = false,
#	beaten_davey_jones = false,
#	spoken_to_lighthouse_mage = false,
#	beaten_creature_boss = false,
#	beaten_sorceror_boss = false
#}

func _ready():
	print ("Main Controller Ready")
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)

#func points_add(points):
#	Player_Information.player_points += points
#	Player_Information.player_points_bonus += points
#	if Player_Information.player_points_bonus >= 200:
#		Player_Information.player_points_bonus -= 200
#		Player_Information.player_coins += 5

#func xp_add(xp_points):
#	Player_Information.player_xp_next_level = Player_Information.player_level * 1000
#	Player_Information.player_xp += xp_points
#	if Player_Information.player_xp >= Player_Information.player_xp_next_level:
#		if Player_Information.player_level < Player_Information.player_max_level:
#			Player_Information.player_level += 1
#			Player_Information.player_upgrade_points += 1

#taken from scene change demos, for loading small scenes
func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function from the running scene.
	# Deleting the current scene at this point might be
	# a bad idea, because it may be inside of a callback or function of it.
	# The worst case will be a crash or unexpected behavior.
	# The way around this is deferring the load to a later time, when
	# it is ensured that no code from the current scene is running:
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
	#immediately free the current scene, no risk here
	current_scene.free()
	#load new scene here
	var s = ResourceLoader.load(path)
	#instance the new scene
	current_scene = s.instantiate()
	#add to the active scene, as a child of root
	get_tree().get_root().add_child(current_scene)
	#optional to make compatible with the scenetree change scene API
	get_tree().set_current_scene(current_scene)

#from background loader examples, for loading bigger scenes
func goto_scene_bg(path): # game requests to switch to this scene
	loader = ResourceLoader.load_threaded_request(path)
	if loader == null: # check for errors
		#show_error()
		return
	set_process(true)
	#change to remove scene when new scene is ready, done below
	#current_scene.queue_free() # get rid of the old scene
	# start your "loading..." animation
	#get_node("animation").play("loading")
	wait_frames = 1


func _process(time):
	if loader == null:
		# no need to process anymore
		set_process(false)
		return
	if wait_frames > 0: # wait for frames to let the "loading" animation to show up
		wait_frames -= 1
		return
	var t = Time.get_ticks_msec()
	while Time.get_ticks_msec() < t + time_max: # use "time_max" to control how much time we block this thread
		# poll your loader
		var err = loader.poll()
		if err == OK: # if loading
			update_progress()
		elif err == ERR_FILE_EOF: # load finished
			var resource = loader.get_resource()
			loader = null
			set_new_scene(resource)
			break
#		if err == ERR_FILE_EOF: # load finished
#			var resource = loader.get_resource()
#			loader = null
#			set_new_scene(resource)
#			break
#		elif err == OK:
#			update_progress()
		else: # error during loading
			#show_error()
			loader = null
			break

func update_progress():
	#print ("get stages = " + str(loader.get_stage()))
	#print ("get stages count = " + str(loader.get_stage_count()))
	progress = float(loader.get_stage()) / loader.get_stage_count()
	# update your progress bar?
	#get_node("progress").set_progress(progress)
	# or update a progress animation?
	#var len = get_node("animation").get_current_animation_length()
	# call this on a paused animation. use "true" as the second parameter to force the animation to update
	#get_node("animation").seek(progress * len, true)

func set_new_scene(scene_resource):
	current_scene.queue_free() #get rid of the old scene here instead
	current_scene = scene_resource.instantiate() #then immediately replace with the loaded scene
	get_node("/root").add_child(current_scene)


