extends Control

# This is the basic script that was made by translating many elements from a python script
# There are some issues, and it is incomplete.
# For a more complete version, check the "5CardDrawPokerMore.gd" script.

### KNOWN ISSUES ###
# card duplication
# missing Straight from the card ranks
# anything above One Pair is not finished if both have same rank

### Setup variables for GUI ###
# Textures for card display
onready var cards_back = preload("res://CardImages/CardsBack.png")
onready var hearts_texture = preload("res://CardImages/BaseHeart.png")
onready var diamonds_texture = preload("res://CardImages/BaseDiamond.png")
onready var spades_texture = preload("res://CardImages/BaseSpade.png")
onready var clubs_texture = preload("res://CardImages/BaseClub.png")

# Player cards nodes
onready var player_card1_image = get_node("PlayerStuff/PlayerCard1")
onready var player_card2_image = get_node("PlayerStuff/PlayerCard2")
onready var player_card3_image = get_node("PlayerStuff/PlayerCard3")
onready var player_card4_image = get_node("PlayerStuff/PlayerCard4")
onready var player_card5_image = get_node("PlayerStuff/PlayerCard5")

onready var player_card1_label = get_node("PlayerStuff/PlayerCard1/PlayerCard1Label")
onready var player_card2_label = get_node("PlayerStuff/PlayerCard2/PlayerCard2Label")
onready var player_card3_label = get_node("PlayerStuff/PlayerCard3/PlayerCard3Label")
onready var player_card4_label = get_node("PlayerStuff/PlayerCard4/PlayerCard4Label")
onready var player_card5_label = get_node("PlayerStuff/PlayerCard5/PlayerCard5Label")

# Computer 1 cards nodes
onready var comp1_card1_image = get_node("Comp1Stuff/Comp1Card1")
onready var comp1_card2_image = get_node("Comp1Stuff/Comp1Card2")
onready var comp1_card3_image = get_node("Comp1Stuff/Comp1Card3")
onready var comp1_card4_image = get_node("Comp1Stuff/Comp1Card4")
onready var comp1_card5_image = get_node("Comp1Stuff/Comp1Card5")

onready var comp1_card1_label = get_node("Comp1Stuff/Comp1Card1/Comp1Card1Label")
onready var comp1_card2_label = get_node("Comp1Stuff/Comp1Card2/Comp1Card2Label")
onready var comp1_card3_label = get_node("Comp1Stuff/Comp1Card3/Comp1Card3Label")
onready var comp1_card4_label = get_node("Comp1Stuff/Comp1Card4/Comp1Card4Label")
onready var comp1_card5_label = get_node("Comp1Stuff/Comp1Card5/Comp1Card5Label")

# Display nodes
onready var hands_display_text = get_node("DisplayStuff/CardsRevealDisplay")
onready var winner_display_text = get_node("DisplayStuff/WinnerRevealDisplay")
onready var winning_hand_display_text = get_node("DisplayStuff/WinningHandRevealDisplay")

# Set up the menu button nodes
onready var back_to_main_menu = get_node("ButtonsContainer/ReallyBackToMainBG")
onready var new_game_menu = get_node("ButtonsContainer/ReallyNewGame")

# Set up vars for card set up
var values = ["2","3","4","5","6","7","8","9","10","J","Q","K","A"]

var values_full = ["2","3","4","5","6","7","8","9","10","Jack","Queen","King","Ace"]

var suites = [",H",",D",",C",",S"]

var hand1 #player
var hand2 #comp

var ranks = ["High Card","One Pair","Two Pairs","Three of a Kind","Flush","Full House","Four of a Kind","Straight Flush","Royal Flush"]
#ranks missing straight, should be between 3 of a kind and flush

func _ready():
	# Hide the menu parts not needed yet
	back_to_main_menu.hide()
	new_game_menu.hide()
	# Start a new game on load
	new_game()

# Original function for making hands
# Kept for reference
#func make_hand():
#	#makes a random hand of 5 cards
#	var vlsm = [0,0,0,0,0]
#	for i in vlsm:
#		i = randi()%12
#	var stsm = [0,0,0,0,0]
#	for i in stsm:
#		i = randi()%3
#	var handm = [0,0,0,0,0]
#	for i in handm:
#		i = values[vlsm[i]]+suites[stsm[i]]
#	if len(handm)==5:
#		return handm
#	return make_hand()

# Make the hand for the player 
func make_player_hand():
	# Create the cards data
	var vls = [0,0,0,0,0]
	var sts = [0,0,0,0,0]
	var hand = [0,0,0,0,0]
	var ni 
	for i in range(5):
		ni = randi()%12
		vls[i] = ni
	var mi
	for i in range(5):
		mi = randi()%3
		sts[i] = mi
	var bi
	for i in range(5):
		bi = values[vls[i]]+suites[sts[i]]
		hand[i] = bi
	hand1 = hand
	# Display the cards created
	# Load the card textures based on suits
	# Card 1
	if sts[0] == 0:
		player_card1_image.texture = hearts_texture
	elif sts[0] == 1:
		player_card1_image.texture = diamonds_texture
	elif sts[0] == 2:
		player_card1_image.texture = clubs_texture
	elif sts[0] == 3:
		player_card1_image.texture = spades_texture
	# Card 2
	if sts[1] == 0:
		player_card2_image.texture = hearts_texture
	elif sts[1] == 1:
		player_card2_image.texture = diamonds_texture
	elif sts[1] == 2:
		player_card2_image.texture = clubs_texture
	elif sts[1] == 3:
		player_card2_image.texture = spades_texture
	# Card 3
	if sts[2] == 0:
		player_card3_image.texture = hearts_texture
	elif sts[2] == 1:
		player_card3_image.texture = diamonds_texture
	elif sts[2] == 2:
		player_card3_image.texture = clubs_texture
	elif sts[2] == 3:
		player_card3_image.texture = spades_texture
	# Card 4
	if sts[3] == 0:
		player_card4_image.texture = hearts_texture
	elif sts[3] == 1:
		player_card4_image.texture = diamonds_texture
	elif sts[3] == 2:
		player_card4_image.texture = clubs_texture
	elif sts[3] == 3:
		player_card4_image.texture = spades_texture
	# Card 5
	if sts[4] == 0:
		player_card5_image.texture = hearts_texture
	elif sts[4] == 1:
		player_card5_image.texture = diamonds_texture
	elif sts[4] == 2:
		player_card5_image.texture = clubs_texture
	elif sts[4] == 3:
		player_card5_image.texture = spades_texture
	# Display the card values
	player_card1_label.text = str(values[vls[0]])
	player_card2_label.text = str(values[vls[1]])
	player_card3_label.text = str(values[vls[2]])
	player_card4_label.text = str(values[vls[3]])
	player_card5_label.text = str(values[vls[4]])

# Make the hand for the computer 1
func make_computer_hand():
	# Create the cards data
	var vls2 = [0,0,0,0,0]
	var sts2 = [0,0,0,0,0]
	var hand22 = [0,0,0,0,0]
	var ni 
	for i in range(5):
		ni = randi()%12
		vls2[i] = ni
	var mi
	for i in range(5):
		mi = randi()%3
		sts2[i] = mi
	var bi
	for i in range(5):
		bi = values[vls2[i]]+suites[sts2[i]]
		hand22[i] = bi
	hand2 = hand22
	# Display the cards created
	# Load the card textures based on suits
	# Card 1
	if sts2[0] == 0:
		comp1_card1_image.texture = hearts_texture
	elif sts2[0] == 1:
		comp1_card1_image.texture = diamonds_texture
	elif sts2[0] == 2:
		comp1_card1_image.texture = clubs_texture
	elif sts2[0] == 3:
		comp1_card1_image.texture = spades_texture
	# Card 2
	if sts2[1] == 0:
		comp1_card2_image.texture = hearts_texture
	elif sts2[1] == 1:
		comp1_card2_image.texture = diamonds_texture
	elif sts2[1] == 2:
		comp1_card2_image.texture = clubs_texture
	elif sts2[1] == 3:
		comp1_card2_image.texture = spades_texture
	# Card 3
	if sts2[2] == 0:
		comp1_card3_image.texture = hearts_texture
	elif sts2[2] == 1:
		comp1_card3_image.texture = diamonds_texture
	elif sts2[2] == 2:
		comp1_card3_image.texture = clubs_texture
	elif sts2[2] == 3:
		comp1_card3_image.texture = spades_texture
	# Card 4
	if sts2[3] == 0:
		comp1_card4_image.texture = hearts_texture
	elif sts2[3] == 1:
		comp1_card4_image.texture = diamonds_texture
	elif sts2[3] == 2:
		comp1_card4_image.texture = clubs_texture
	elif sts2[3] == 3:
		comp1_card4_image.texture = spades_texture
	# Card 5
	if sts2[4] == 0:
		comp1_card5_image.texture = hearts_texture
	elif sts2[4] == 1:
		comp1_card5_image.texture = diamonds_texture
	elif sts2[4] == 2:
		comp1_card5_image.texture = clubs_texture
	elif sts2[4] == 3:
		comp1_card5_image.texture = spades_texture
	# Display the card values
	comp1_card1_label.text = str(values[vls2[0]])
	comp1_card2_label.text = str(values[vls2[1]])
	comp1_card3_label.text = str(values[vls2[2]])
	comp1_card4_label.text = str(values[vls2[3]])
	comp1_card5_label.text = str(values[vls2[4]])

# Work out the rank of the hand sent to this function
func rank_the_(hand_sent):
	var hand_val = ["h","h","h","h","h"]
	var hand_suits = ["h","h","h","h","h"]
	var nufi
	var nufi2
	var nufi3
	var nufi4
	var nufi5
	var hs1
	var hs2
	var hs3
	var hs4
	var hs5
	
	# Split the elements of the hand received
	nufi = hand_sent[0]
	hs1 = nufi.split(",",true,1)
	nufi2 = hand_sent[1]
	hs2 = nufi2.split(",",true,1)
	nufi3 = hand_sent[2]
	hs3 = nufi3.split(",",true,1)
	nufi4 = hand_sent[3]
	hs4 = nufi4.split(",",true,1)
	nufi5 = hand_sent[4]
	hs5 = nufi5.split(",",true,1)
	
	# Assign the split elements to values or suits
	hand_val[0] = hs1[0]
	hand_suits[0] = hs1[1]
	hand_val[1] = hs2[0]
	hand_suits[1] = hs2[1]
	hand_val[2] = hs3[0]
	hand_suits[2] = hs3[1]
	hand_val[3] = hs4[0]
	hand_suits[3] = hs4[1]
	hand_val[4] = hs5[0]
	hand_suits[4] = hs5[1]
	# Could have done as hand_suits = [hs1[0],hs2[0],hs3[0],hs4[0],hs5[0]] 
	
	var positions = ["h","h","h","h","h"]
	var ri1
	var ri2
	var ri3
	var ri4
	var ri5
	var pos_hv
	var pos_hv2
	var pos_hv3
	var pos_hv4
	var pos_hv5
	
	pos_hv = hand_val[0]
	ri1 = values.find(pos_hv)+2
	
	pos_hv2 = hand_val[1]
	ri2 = values.find(pos_hv2)+2 
	pos_hv3 = hand_val[2]
	ri3 = values.find(pos_hv3)+2 
	pos_hv4 = hand_val[3]
	ri4 = values.find(pos_hv4)+2 
	pos_hv5 = hand_val[4]
	ri5 = values.find(pos_hv5)+2 
	positions = [ri1,ri2,ri3,ri4,ri5]
	
	var sorted_vals = ["h","h","h","h","h"]
	positions.sort()
	sorted_vals = positions
	# Get the number of times each value is repeated
	var reps_array = [sorted_vals.count(2),sorted_vals.count(3),sorted_vals.count(4),sorted_vals.count(5),sorted_vals.count(6),sorted_vals.count(7),sorted_vals.count(8),sorted_vals.count(9),sorted_vals.count(10),sorted_vals.count(11),sorted_vals.count(12),sorted_vals.count(13),sorted_vals.count(14)]
	
	# Check if all from card suits are same
	# Count the suits, and if any suits count = 5, get the suit
	var hand_suit_counter = ["H","D","C","S"]
	hand_suit_counter = [hand_suits.count("H"),hand_suits.count("D"),hand_suits.count("C"),hand_suits.count("S")]
	hand_suit_counter.find(5)
	var same_suit = false
	if hand_suit_counter.find(5) != -1:
		same_suit = true
	else:
		same_suit = false
	
	if same_suit == true:
		# If cards are the same suit
		if sorted_vals == [10,11,12,13,14]:
			# Royal Flush
			# prints have been kept throughout the code, as they have been used for debugging
			# and some were from the original python code
			# and may still be useful, but commented out so they don't overflow the console
			#print ("royal flush : ", ranks[8])
			return [ranks[8], sorted_vals,0]
		if (sorted_vals[-1]-sorted_vals[0]) == 4:
			# Straight Flush
			#print ("straight flush : ", ranks[7])
			return [ranks[7], sorted_vals,0]
		else:
			# Flush
			#print ("flush : ", ranks[4])
			return [ranks[4], sorted_vals,0]  
			# 0s added to fill out the elements of the arrays in other funcs
	elif same_suit == false:
		# If cards are of different suits
		if (sorted_vals[-1]-sorted_vals[0])==4:
			# Straight
			# After working out this part, realized this is the code for straights
			# but was mislabeled as three of a kind, to use properly, ranks need to be redone
			# Three of a kind
			#print ("three of a kind : ", ranks[3])
			return [ranks[3], sorted_vals,0]
		if 4 in reps_array:
			# Four of a kind
			#print ("four of a kind: ", ranks[6])
			return [ranks[6], sorted_vals, reps_array.find(4)]
		if 3 in reps_array:
			if 2 in reps_array:
				# Full House
				#print ("full house : ", ranks[5])
				# The fourth array element from here hasn't been implemented yet, but is in full code
				return [ranks[5], sorted_vals, reps_array.find(3), reps_array.find(2)]
			# Three of a kind
			#print ("three of a kind : ", ranks[3])
			return [ranks[3], sorted_vals, reps_array.find(3)]
		if reps_array.count(2)==2:
			# Two pair
			#print ("two pair : ", ranks[2])
			return [ranks[2], sorted_vals,0]
		if reps_array.count(2)==1:
			# One pair
			#print ("one pair : ", ranks[1])
			return [ranks[1], sorted_vals, reps_array.find(2)]
	# High Card
	return [ranks[0], sorted_vals,0]

# Check the results of the hands generated
func check_results():
	# Setup vars for use within this func
	var pair1 #player
	var pair2 #comp1
	
	var result1 #player
	var result2 #comp1
	
	var in_both #player
	var in_both2 #comp1
	
	var high_card1 = [0,0,0,0,0] #player
	var high_card2 = [0,0,0,0,0] #comp1
	
	var result1_returned = [0,0,0]
	var result2_returned = [0,0,0]
	result1_returned  = rank_the_(hand1)
	result2_returned = rank_the_(hand2)
	
	result1 = result1_returned[0] #player
	result2 = result2_returned[0] #comp1
	#print ("results back : hand 2: ",result2,", and hand 1: ",result1)
	var result1_pos
	var result2_pos
	result1_pos = ranks.find(result1)
	result2_pos = ranks.find(result2)
	#print ("results position : res 1 : ",result1_pos, " res 2 : ",result2_pos)
	
	in_both = result1_returned[1]
	in_both2 = result2_returned[1]
	
	# Remove the similar values in case of being compared for high card
	var shared_values = []
	for thing in in_both:
		in_both2.find(thing)
		if in_both2.find(thing) != -1:
			shared_values.append(thing)
	#print ("Shared values : ",shared_values)
	# Compare each hand to shared value cards
	# Then can compare remaining cards values from the highest left in array
	high_card1 = in_both
	for samesies in shared_values:
		high_card1.erase(samesies)
		#print ("REMOVED : ",samesies)
		#print ("HIGH CARD LEFT :",high_card1)
	# Check which has high card in case needed
	var highest_card1
	if high_card1 != null:
		if high_card1.size() != 0:
			highest_card1 = high_card1.max()
	elif high_card1 == null:
		highest_card1 = 0
	#print ("HIGHEST PLAYER CARD : ",highest_card1)
	var highest_card1_val
	highest_card1_val = values.find(highest_card1)
	
	high_card2 = in_both2
	for samesies2 in shared_values:
		high_card2.erase(samesies2)
		#print ("REMOVED  FROM COMP : ",samesies2)
		#print ("HIGH CARD LEFT FOR COMP :",high_card2)
	var highest_card2
	
	if high_card2 != null:
		if high_card2.size() != 0:
			highest_card2 = high_card2.max()
	elif high_card2 == null:
		highest_card2 = 0
	
	var highest_card2_val
	highest_card2_val = values.find(highest_card2)
	
	#print ("HIGH CARD VAL :  ", highest_card1) #high_card1)
	#print ("HIGH CARD VAL 2 :  ", highest_card2) #high_card2)
	#print ("You: ", hand1, "-->", result1, "\n", "     highest card val : ", highest_card1_val)
	#print ("Computer: ", hand2, "-->", result2, "\n", "     highest card TWO val : ", highest_card2_val)
	hands_display_text.text = "Player hand : " + str(hand1) + ", and Comp1 hand : " + str(hand2)
	
	if result1==result2:
		# If both have the same hank ranks
		if result1 == "High Card":
			if highest_card2 > highest_card1:
				# If the computer has the highest value card
				#print ("Computer wins ", values_full[highest_card2-2], "over ", values_full[highest_card1-2])
				winner_display_text.text = "Computer 1 wins"
				winning_hand_display_text.text = str(values_full[highest_card2-2]) + "over "+ str(values_full[highest_card1-2])
			elif highest_card1 > highest_card2:
				# If the player has the highest value card
				#print ("Congratulations! You win. ", values_full[highest_card1-2], "over ", values_full[highest_card2-2])
				winner_display_text.text = "Player wins"
				winning_hand_display_text.text = str(values_full[highest_card1-2]) + "over "+ str(values_full[highest_card2-2])
			else:
				# If have same value High Cards
				#print ("draw")
				winner_display_text.text = "Draw"
				winning_hand_display_text.text = ""
		elif result1 == "One Pair":
			# Work out the values of the pairs
			# The code here doesn't work properly, but is fixed in the main version
			pair1 = result1_returned[2]+2
			pair2 = result2_returned[2]+2
			var pair1_val = values.find(pair1)
			var pair2_val = values.find(pair2)
			var pair1_final_value = values_full[pair1_val]
			var pair2_final_value = values_full[pair2_val]
			#print ("You have a pair of ", pair1_final_value, "'s")
			#print ("Computer has a pair of ", pair2_final_value, "'s")
			if pair2_val > pair1_val:
				# If computer has the higher pair
				#print ("Computer wins.")
				winner_display_text.text = "Computer 1 wins"
				winning_hand_display_text.text = ""
			elif pair1_val > pair2_val:
				# If player has the higher pair
				#print ("Congrats, you win.")
				winner_display_text.text = "Player wins"
				winning_hand_display_text.text = ""
			else:
				# If pairs are of the same value, use high cards to determine winner
				if highest_card2 > highest_card1:
					#print ("Computer wins ", values_full[highest_card2-2], "over ", values_full[highest_card1-2])
					winner_display_text.text = "Computer 1 wins"
					winning_hand_display_text.text = str(values_full[highest_card2-2]) + "over "+ str(values_full[highest_card1-2])
				elif highest_card1 > highest_card2:
					#print ("Congratulations! You win. ", values_full[highest_card1-2], "over ", values_full[highest_card2-2])
					winner_display_text.text = "Player wins"
					winning_hand_display_text.text = str(values_full[highest_card1-2]) + "over "+ str(values_full[highest_card2-2])
				else:
					#print ("draw")
					winner_display_text.text = "Draw"
					winning_hand_display_text.text = ""
		
		### NOT YET COMPLETED ###
		# These are incomplete, but have been filled out in the main version
		
		elif result1 == "Two Pairs":
			#print ("unfinished")
			winner_display_text.text = "Unfinished"
			winning_hand_display_text.text = ""
		elif result1 == "Three of a Kind":
			#print ("unfinished")
			winner_display_text.text = "Unfinished"
			winning_hand_display_text.text = ""
		elif result1 == "Full House":
			#print ("unfinished")
			winner_display_text.text = "Unfinished"
			winning_hand_display_text.text = ""
		elif result1 == "Four of a Kind":
			#print ("unfinished")
			winner_display_text.text = "Unfinished"
			winning_hand_display_text.text = ""
	else:
		# If player has the higher ranked hand
		if result1_pos>result2_pos:
			#print ("Congrats, you win the hand.", result1)
			winner_display_text.text = "Player wins"
			winning_hand_display_text.text = "with " + str(result1)
		else:
			# If computer has the higher ranked hand
			#print ("Computer wins.", result2)
			winner_display_text.text = "Computer wins"
			winning_hand_display_text.text = "with " + str(result2)

# Start a new game
func new_game():
	randomize()
	make_player_hand()
	make_computer_hand()
	# Test hands
	#hand2 = ["J,H","10,H","Q,H","K,H","A,H"] #comp
	#hand1 = ["J,D","10,D","K,D","A,D","Q,D"] #player
	#hand2 = ["J,H","J,D","3,H","5,H","7,H"] #comp
	#hand1 = ["J,S","J,C","4,D","6,D","8,D"] #player
	check_results()

### Button funcs ###
# Return to main menu
func _on_BackToMainButton_pressed():
	# Show the confirm dialog for returning to main menu
	back_to_main_menu.show()
	# Make sure that the new game dialog is hidden
	new_game_menu.hide()

func _on_YesMainButton_pressed():
	# Takes us back to the main menu
	get_node("/root/MasterControl").goto_scene("res://Scenes/MainMenu.tscn")

func _on_NoMainButton_pressed():
	# If cancel returning to main, hide the dialogs
	back_to_main_menu.hide()
	new_game_menu.hide()

# Start a new game
func _on_NewGameButton_pressed():
	# Make sure return to main dialog is hidden
	back_to_main_menu.hide()
	# Show the start new game dialog
	new_game_menu.show()

func _on_YesNGButton_pressed():
	# Start a new game
	new_game()
	# Hide the dialog boxes
	back_to_main_menu.hide()
	new_game_menu.hide()

func _on_NoNGButton_pressed():
	# Hide the dialog boxes
	back_to_main_menu.hide()
	new_game_menu.hide()
