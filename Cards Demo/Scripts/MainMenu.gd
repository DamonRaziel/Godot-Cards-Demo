extends Control

# Base Poker code
# Basic 5 card stud
# Basic hold'em
# Basic solitaire?
# Basic Blackjack?
# Basic Pusoy Dos?

func _ready():
	pass 

#func _process(delta):
#	pass

func _on_Basic5CardDrawButton_pressed():
	get_node("/root/MasterControl").goto_scene("res://Scenes/5CardDrawPokerBasic.tscn")

func _on_5CardDrawButton_pressed():
	#res://Scenes/5CardDrawPokerMore.tscn
	#get_node("/root/MasterControl").goto_scene("res://Scenes/Texas.tscn")
	get_node("/root/MasterControl").goto_scene("res://Scenes/5CardDrawPokerMore.tscn")

func _on_HoldEmButton_pressed():
	get_node("/root/MasterControl").goto_scene("res://Scenes/HoldEm.tscn")
