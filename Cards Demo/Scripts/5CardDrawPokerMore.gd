extends Control

### KNOWN ISSUES ###
# card duplication 
# avoided by choosing cards from 52 element array, and deleting the element once chosen
# missing Straight from the card ranks
# added "Straight" to the ranks, adjusted the other ranks to fit
# anything above One Pair is not finished if both have same rank hands
# added in code based on the One Pair and High Card codes
# including code for if both hands are equal, for future use and as a fallback

### FEATURES TO ADD FOR FULLER GAME ###
# option to fold - Added
# ends game, count as loss, lose money put in, option to start new game

# option to change up to 4 cards - Added, currently can change all 5 though
# how? create array for which cards want to change, and call a create card function
# (seperate from main hand create?), to generate new unique cards, 
# and then insert into the positions indicated by the array

# betting options - keep simple - Added, fixed bet and card costs
# can bet up to all money in last round?
# fixed betting amounts per round?

# computer AI - Added, but currently random and not yet fully complete
# whether or not to bet, fold, etc
# use AI or just random?
# Random choice, based on current cards held, the better the hand, the less likely to fold

# hide computer cards until reveal - Added, use extra textures above cards to hide them

# add in rounds for betting etc - Added, comp and player take turns, after both, rounds go up
# do computer stuff before or after player?
# when starting, randomly determine who starts (high card draw??)

# add a randomised delay of a few seconds to computer turn to simulate player? - Added
# use timers, can randomize time later

# prevent starting new game if in a game
# make it so starting a new game is either only doable after game end, or make it count as a fold?
# not yet done

# add randomised time fot timers when comp is "deciding" and is comp turn
# not yet done

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

onready var comp1_card1_change_indicator = get_node("Comp1Stuff/Comp1Card1/Comp1Card1ChangeIndicator")
onready var comp1_card2_change_indicator = get_node("Comp1Stuff/Comp1Card2/Comp1Card2ChangeIndicator")
onready var comp1_card3_change_indicator = get_node("Comp1Stuff/Comp1Card3/Comp1Card3ChangeIndicator")
onready var comp1_card4_change_indicator = get_node("Comp1Stuff/Comp1Card4/Comp1Card4ChangeIndicator")
onready var comp1_card5_change_indicator = get_node("Comp1Stuff/Comp1Card5/Comp1Card5ChangeIndicator")

onready var comp1_card1_image_hider = get_node("Comp1Stuff/Comp1Card1/Comp1Card1Hider")
onready var comp1_card2_image_hider = get_node("Comp1Stuff/Comp1Card2/Comp1Card2Hider")
onready var comp1_card3_image_hider = get_node("Comp1Stuff/Comp1Card3/Comp1Card3Hider")
onready var comp1_card4_image_hider = get_node("Comp1Stuff/Comp1Card4/Comp1Card4Hider")
onready var comp1_card5_image_hider = get_node("Comp1Stuff/Comp1Card5/Comp1Card5Hider")

# Display nodes
onready var hands_display_text = get_node("DisplayStuff/CardsRevealDisplay")
onready var winner_display_text = get_node("DisplayStuff/WinnerRevealDisplay")
onready var winning_hand_display_text = get_node("DisplayStuff/WinningHandRevealDisplay")

onready var bet_cost_text = get_node("DisplayStuff/BetCostDisplay")
onready var new_card_cost_text = get_node("DisplayStuff/NewCardCostDisplay")
onready var current_pot_text = get_node("DisplayStuff/CurrentPotDisplay")
onready var turn_counter_text = get_node("DisplayStuff/TurnCounterDisplay")

onready var player_money_display = get_node("PlayerStuff/PlayerMoneyLabel")
onready var comp1_money_display = get_node("Comp1Stuff/Comp1MoneyLabel")

# Set up the menu button nodes
onready var back_to_main_menu = get_node("ButtonsContainer/ReallyBackToMainBG")
onready var new_game_menu = get_node("ButtonsContainer/ReallyNewGame")

# Set up the player action nodes
onready var player_card1_change_keep_button = get_node("ButtonsContainer/PlayerButtons/PlayerCard1ChangeKeepButton")
onready var player_card2_change_keep_button = get_node("ButtonsContainer/PlayerButtons/PlayerCard2ChangeKeepButton")
onready var player_card3_change_keep_button = get_node("ButtonsContainer/PlayerButtons/PlayerCard3ChangeKeepButton")
onready var player_card4_change_keep_button = get_node("ButtonsContainer/PlayerButtons/PlayerCard4ChangeKeepButton")
onready var player_card5_change_keep_button = get_node("ButtonsContainer/PlayerButtons/PlayerCard5ChangeKeepButton")

onready var player_card1_change_indicator = get_node("PlayerStuff/PlayerCard1/PlayerCard1ChangeIndicator")
onready var player_card2_change_indicator = get_node("PlayerStuff/PlayerCard2/PlayerCard2ChangeIndicator")
onready var player_card3_change_indicator = get_node("PlayerStuff/PlayerCard3/PlayerCard3ChangeIndicator")
onready var player_card4_change_indicator = get_node("PlayerStuff/PlayerCard4/PlayerCard4ChangeIndicator")
onready var player_card5_change_indicator = get_node("PlayerStuff/PlayerCard5/PlayerCard5ChangeIndicator")

onready var player_fold_button = get_node("ButtonsContainer/PlayerButtons/PlayerFoldButton")
onready var player_bet_button = get_node("ButtonsContainer/PlayerButtons/PlayerBetButton")
onready var player_place_button = get_node("ButtonsContainer/PlayerButtons/PlayerPlaceButton")

### Set up vars for card set up ###

# New vars for deck setup, so there are no duplicates,
# uses an array with all cards instead of creating the cards through code.
# use the same element layout as from the way cards were created using code
# so that the rank and check code can be preserved and still used

# Create the individual suits
var hearts_suit = ["2,H","3,H","4,H","5,H","6,H","7,H","8,H","9,H","10,H","J,H","Q,H","K,H","A,H"]
var diamonds_suit = ["2,D","3,D","4,D","5,D","6,D","7,D","8,D","9,D","10,D","J,D","Q,D","K,D","A,D"]
var clubs_suit = ["2,C","3,C","4,C","5,C","6,C","7,C","8,C","9,C","10,C","J,C","Q,C","K,C","A,C"]
var spades_suit = ["2,S","3,S","4,S","5,S","6,S","7,S","8,S","9,S","10,S","J,S","Q,S","K,S","A,S"]
# Add all the suits together to get a whole deck
# this needs doing at the start of every new game as well
# for reasons I haven't worked out yet, but isn't a problem
var whole_deck = hearts_suit + diamonds_suit + clubs_suit + spades_suit
# game_deck var is used for the actual game deck, later it copies the whole_deck
# and then removes cards which have been "dealt", so that duplicates can't happen
var game_deck 

### Card setup vars ###
# The card values, Aces are always high
# This var is used for hand ranking and display of card values on cards shown
var values = ["2","3","4","5","6","7","8","9","10","J","Q","K","A"]
# This var is used when displaying the winner, it shows the full names of the character and ace cards
var values_full = ["2","3","4","5","6","7","8","9","10","Jack","Queen","King","Ace"]
# This var is used to check the suits (it is "suites2" as it was modified from the "suites" in the basic version)
var suites2 = ["H","D","C","S"]
# Hand ranks, used for determining the best hands
var ranks = ["High Card","One Pair","Two Pairs","Three of a Kind","Straight","Flush","Full House","Four of a Kind","Straight Flush","Royal Flush"]

# Hand vars
var hand1 # player hand
var hand2 # comp hand
# Card change vars, 0 = keep card, 1 = change card
var player_cards_to_replace = [0,0,0,0,0] 
var comp1_cards_to_replace = [0,0,0,0,0]

### Betting vars ###
# Cost to bet per round
var bet_amount = 500
# Cost to change a card
var new_card_amount = 200
# The amount currently in the pot, that can be won at the end of the game
var current_pot = 0
# Round number, there are 4 rounds per game at present
var round_number = 0
# To determine turn order of the rounds, 0 = player, 1 = comp1
var whose_turn = 0
# Vars to check what actions the player/comp has done this turn
var player_has_bet = false
var player_has_changed_cards = false
var comp1_has_bet = false
var comp1_has_changed_cards = false
# Used to decide what the computer will do, randomized per turn
var comp1_round_decision = 0
# Starting monies, doesn't reset between games, but resets on scene load
var player_money = 5000
var comp1_money = 5000

### Set up the timers ###
onready var comp1_decision_timer = get_node("Comp1Stuff/Comp1DecisionTimer")
onready var comp1_change_timer = get_node("Comp1Stuff/Comp1ChangeTimer")
onready var comp1_bet_delay_timer = get_node("Comp1Stuff/Comp1GeneralDelayTimer")

func _ready():
	# Start a new game on load
	new_game()
#	print ("whole deck : ", whole_deck)

func _process(delta):
	#  Always check what to show on the GUI, and update buttons/text as needed
	if player_cards_to_replace[0] == 1:
		player_card1_change_indicator.show()
		player_card1_change_keep_button.text = "Keep"
	elif player_cards_to_replace[0] == 0:
		player_card1_change_indicator.hide()
		player_card1_change_keep_button.text = "Change"
	
	if player_cards_to_replace[1] == 1:
		player_card2_change_indicator.show()
		player_card2_change_keep_button.text = "Keep"
	elif player_cards_to_replace[1] == 0:
		player_card2_change_indicator.hide()
		player_card2_change_keep_button.text = "Change"
	
	if player_cards_to_replace[2] == 1:
		player_card3_change_indicator.show()
		player_card3_change_keep_button.text = "Keep"
	elif player_cards_to_replace[2] == 0:
		player_card3_change_indicator.hide()
		player_card3_change_keep_button.text = "Change"
	
	if player_cards_to_replace[3] == 1:
		player_card4_change_indicator.show()
		player_card4_change_keep_button.text = "Keep"
	elif player_cards_to_replace[3] == 0:
		player_card4_change_indicator.hide()
		player_card4_change_keep_button.text = "Change"
	
	if player_cards_to_replace[4] == 1:
		player_card5_change_indicator.show()
		player_card5_change_keep_button.text = "Keep"
	elif player_cards_to_replace[4] == 0:
		player_card5_change_indicator.hide()
		player_card5_change_keep_button.text = "Change"
	
	if player_has_bet == false:
		player_bet_button.text = "Bet"
	elif player_has_bet == true:
		player_bet_button.text = "Withdraw"
	
	# Player can only bet if they have enough money
	if whose_turn == 0:
		if player_money >= bet_amount:
			if player_has_bet == false:
				# If player has enough money and hasn't done anything yet
				# all buttons enabled, except place button
				player_card1_change_keep_button.disabled = false
				player_card2_change_keep_button.disabled = false
				player_card3_change_keep_button.disabled = false
				player_card4_change_keep_button.disabled = false
				player_card5_change_keep_button.disabled = false
				player_fold_button.disabled = false
				player_bet_button.disabled = false
				player_place_button.disabled = true
			elif player_has_bet == true:
				# If player has enough money and has put in bet
				# disable change card and fold buttons, enable place button
				player_card1_change_keep_button.disabled = true
				player_card2_change_keep_button.disabled = true
				player_card3_change_keep_button.disabled = true
				player_card4_change_keep_button.disabled = true
				player_card5_change_keep_button.disabled = true
				player_fold_button.disabled = true
				player_bet_button.disabled = false
				player_place_button.disabled = false
		# If the player doesn't have enough money, disable bet and place buttons
		# although card change button options are dealt with in the button funcs, disable as well
		# Fold button left enabled, as only player option left
		else:
			if player_has_bet == true:
				# If the player has bet this round, disable the card change and fold buttons
				# But still enable the bet/withdraw and place buttons
				# If player has bet needs to be known, as otherwise player money can hit 0 after betting
				# which can disable the place button
				player_card1_change_keep_button.disabled = true
				player_card2_change_keep_button.disabled = true
				player_card3_change_keep_button.disabled = true
				player_card4_change_keep_button.disabled = true
				player_card5_change_keep_button.disabled = true
				player_fold_button.disabled = true
				player_bet_button.disabled = false
				player_place_button.disabled = false
			elif player_has_bet == false:
				# If the player hasn't bet yet, disable buttons so they can't bet, only fold
				# as if player hasn't bet and has 0 money, they don't have enough to bet
				player_card1_change_keep_button.disabled = true
				player_card2_change_keep_button.disabled = true
				player_card3_change_keep_button.disabled = true
				player_card4_change_keep_button.disabled = true
				player_card5_change_keep_button.disabled = true
				player_fold_button.disabled = false
				player_bet_button.disabled = true
				player_place_button.disabled = true
		
	elif whose_turn == 1:
		# Disable player buttons during computer turns
		player_card1_change_keep_button.disabled = true
		player_card2_change_keep_button.disabled = true
		player_card3_change_keep_button.disabled = true
		player_card4_change_keep_button.disabled = true
		player_card5_change_keep_button.disabled = true
		player_fold_button.disabled = true
		player_bet_button.disabled = true
		player_place_button.disabled = true
	
	# Update the player card displays
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
	# Display the player card values
	player_card1_label.text = str(values[vls[0]])
	player_card2_label.text = str(values[vls[1]])
	player_card3_label.text = str(values[vls[2]])
	player_card4_label.text = str(values[vls[3]])
	player_card5_label.text = str(values[vls[4]])
	
	# Change the display of comp1 cards, ready for reveal if needed
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
	# Display the comp1 card values
	comp1_card1_label.text = str(values[vls2[0]])
	comp1_card2_label.text = str(values[vls2[1]])
	comp1_card3_label.text = str(values[vls2[2]])
	comp1_card4_label.text = str(values[vls2[3]])
	comp1_card5_label.text = str(values[vls2[4]])
	# Update the text elements of display
	update_monies_display()

func update_monies_display():
	bet_cost_text.text = ("Bet Cost : " + str(bet_amount))
	new_card_cost_text.text = ("New Card Cost : " + str(new_card_amount))
	current_pot_text.text = ("Current Pot : " + str(current_pot))
	turn_counter_text.text = ("Current Round : " + str(round_number))
	player_money_display.text = "Player Money : " + str(player_money)
	comp1_money_display.text = "Comp1 Money : " + str(comp1_money)

### Comp1 funcs ###
func comp1_actions():
	#Computer AI here, random for now
	#even though randomize, account for if comp has money
	randomize() # do I need to call this here?
	# Make decision based on current cards
	# Call the ranking func, then decide based on current hand
	# eg if hand is high card, keep the high card, and change 1-4 other cards (not yet done)
	# if hand is 3 of a kind or better, change 1 or both kickers (not yet done)
	# if hand is flush or better, keep all cards
	
	var result2_check #comp1
	var high_card2_check = [0,0,0,0,0] #comp1
	var result2_returned_check = [0,0,0,0] # comp1
	result2_returned_check = rank_the_(hand2) # comp1
	result2_check = result2_returned_check[0] #comp1
	
	print ("Check hand for comp to determine what to do : ", result2_returned_check[0])
	
	# Decision also depends on round number, if first round always bet if have funds
	# If comp doesn't have enough moeny to bet, fold
	# If comp has enough to bet, but not enough to bet and change cards,
	# options are to fold or bet only
	# In actual games, make it so a new game can't be started if the computer or player doesn't have enough money
	# not yet done
	var change_all_cards_cost = new_card_amount * 5
	var full_change_and_bet_amount = change_all_cards_cost + bet_amount
	
	if result2_returned_check[0] == "High Card":
		# Always bet for the first round, may change cards
		if round_number == 1:
			# options in here depending on money available
			if comp1_money >= bet_amount:
				if comp1_money >= full_change_and_bet_amount:
					comp1_round_decision = randi()%2
					print ("comp round decision was : ",comp1_round_decision)
					if comp1_round_decision == 0:
						comp1_change_timer.start()
					elif comp1_round_decision == 1:
						comp1_bet()
				else:
					comp1_bet()
			elif comp1_money < bet_amount:
				comp1_folds()
		# as rounds go on, more likely to fold, if doesn't get better cards?
		elif round_number >= 2:
			if comp1_money >= bet_amount:
				if comp1_money >= full_change_and_bet_amount:
					comp1_round_decision = randi()%10+1
					print ("comp round decision was : ",comp1_round_decision)
					if comp1_round_decision <= 3:
						comp1_folds()
					elif comp1_round_decision > 3 and comp1_round_decision < 7:
						comp1_change_timer.start()
					elif comp1_round_decision >= 7:
						comp1_bet()
				else:
					comp1_bet()
			elif comp1_money < bet_amount:
				comp1_folds()
	# if have a pair, 2 pair, or 3 of a kind, may change cards, or keep betting
	# to change cards, need to figure out which cards are part of pair etc
	elif result2_returned_check[0] == "One Pair" or "Two Pairs" or "Three of a Kind":
		# Always bet for the first round, may change cards
		if round_number == 1:
			if comp1_money >= bet_amount:
				if comp1_money >= full_change_and_bet_amount:
					comp1_round_decision = randi()%2
					print ("comp round decision was : ",comp1_round_decision)
					if comp1_round_decision == 0:
						comp1_change_timer.start()
					elif comp1_round_decision == 1:
						comp1_bet()
				else:
					comp1_bet()
			elif comp1_money < bet_amount:
				comp1_folds()
		elif round_number >= 2:
			if comp1_money >= bet_amount:
				if comp1_money >= full_change_and_bet_amount:
					comp1_round_decision = randi()%10+1
					print ("comp round decision was : ",comp1_round_decision)
					if comp1_round_decision <= 2:
						comp1_folds()
					elif comp1_round_decision >= 3:
						comp1_bet()
				else:
					comp1_bet()
			elif comp1_money < bet_amount:
				comp1_folds()
	# if have straight or higher, more likely to keep cards, depending on round number
	# eg if have fluch, get to round 4, may still choose fold as player is also still going?
	elif result2_returned_check[0] == "Straight" or "Flush" or "Full House":
		if round_number == 1:
			if comp1_money >= bet_amount:
				if comp1_money >= full_change_and_bet_amount:
					comp1_round_decision = randi()%2
					print ("comp round decision was : ",comp1_round_decision)
					if comp1_round_decision == 0:
						comp1_change_timer.start()
					elif comp1_round_decision == 1:
						comp1_bet()
				else:
					comp1_bet()
			elif comp1_money < bet_amount:
				comp1_folds()
		elif round_number >= 2:
			if comp1_money >= bet_amount:
				if comp1_money >= full_change_and_bet_amount:
					comp1_round_decision = randi()%10+1
					print ("comp round decision was : ",comp1_round_decision)
					if comp1_round_decision <= 1:
						comp1_folds()
					elif comp1_round_decision >= 2:
						comp1_bet()
				else:
					comp1_bet()
			elif comp1_money < bet_amount:
				comp1_folds()
	# if have 4 of a kind or better, bet until the end
	elif result2_returned_check[0] == "Four of a Kind" or "Straight Flush" or "Royal Flush":
		print ("comp round decision was : BET AWAY!!!!!")
		if comp1_money >= bet_amount:
			# If comp has these hands, always bet, as long as it has the money
			comp1_bet() 
		elif comp1_money < bet_amount:
			# If the comp doesn't have the funds, they have to fold
			comp1_folds()
	
	### Original Randomised Code ###
#	comp1_round_decision = randi()%3
#	print ("comp round decision was : ",comp1_round_decision)
#	# 0 = fold, player wins, reveal
#	# 1 = change cards and bet, move to player turn if comp1 went first, move to next round if went second
#	# 2 = keep cards and bet, move rounds as described above
#	# all set to bet at the moment to test games til end, change to different chances later
#	if comp1_round_decision == 0:
#		comp1_bet()
#		# comp folds
##		comp1_folds()
#	elif comp1_round_decision == 1:
#		comp1_bet()
#		#comp1_change_and_bet()
##		comp1_change_timer.start()
#
#	elif comp1_round_decision == 2:
#		# comp1 bets
#		comp1_bet()

func comp1_folds():
	#reveal comp1 cards?
	# or keep hidden, as they don't matter?
	# uncomment these if you want to show the cards
#	comp1_card1_image_hider.hide()
#	comp1_card2_image_hider.hide()
#	comp1_card3_image_hider.hide()
#	comp1_card4_image_hider.hide()
#	comp1_card5_image_hider.hide()
	# Give pot to player
	player_money += current_pot
	# End the game, displaying winner and why
	hands_display_text.text = ("Computer 1 has folded")
	winner_display_text.text = ("Player Wins")
	winning_hand_display_text.text = ("")

func comp1_change_and_bet():
	# If changing cards, randomly pick which one to replace
	randomize() # need to be called here?
	var comp1_card1_replace_choice = randi()%2
	var comp1_card2_replace_choice = randi()%2
	var comp1_card3_replace_choice = randi()%2
	var comp1_card4_replace_choice = randi()%2
	var comp1_card5_replace_choice = randi()%2
	comp1_cards_to_replace = [comp1_card1_replace_choice,comp1_card2_replace_choice,comp1_card3_replace_choice,comp1_card4_replace_choice,comp1_card5_replace_choice]
	
	# comp version of player change cards
	randomize() # needed here?
	# Card 1
	var bi3comp
	var card_from_deck_split3comp
	var gdi3comp
	var gdi23comp
	# Card 2
	var bi32comp
	var card_from_deck_split32comp
	var gdi32comp
	var gdi232comp
	# Card 3
	var bi33comp
	var card_from_deck_split33comp
	var gdi33comp
	var gdi233comp
	# Card 4
	var bi34comp
	var card_from_deck_split34comp
	var gdi34comp
	var gdi234comp
	# Card 5
	var bi35comp
	var card_from_deck_split35comp
	var gdi35comp
	var gdi235comp
	# Go through each part of the comp1_cards_to_replace array, checking for cards to replace
	if comp1_cards_to_replace[0] == 1:
		# Show which cards the comp is changing (make optional?)
		# Pick a random number based on the number of cards left in the game deck
		gdi23comp = randi()%game_deck.size()
		# Assign temp vars based on randomly chosen element
		gdi3comp = game_deck[gdi23comp]
		# Split the card selected to get the value and suit data
		card_from_deck_split3comp = gdi3comp.split(",",true,1)
		# Get the value
		vls2[0] = values.find(card_from_deck_split3comp[0])
		# Get the suit
		sts2[0] = suites2.find(card_from_deck_split3comp[1])
		# Stitch back together for full card using the values and suites arrays
		# the addition of the comma in the middle is needed, as it identifies where to split elements
		# which will be needed again later when ranking the cards
		bi3comp = values[vls2[0]]+","+suites2[sts2[0]]
		print ("bi3comp was : ", bi3comp)
		# Remove the card from the game deck, so it can't be duplicated
		var card_to_remove_from_deck3comp = game_deck.find(bi3comp)
		game_deck.remove(card_to_remove_from_deck3comp)
		# Insert the new card into the player hand
		hand2[0] = bi3comp
		print ("compcard was : ",0)
	# The rest work as above, but comments have been reduced
	if comp1_cards_to_replace[1] == 1:
		gdi232comp = randi()%game_deck.size()
		gdi32comp = game_deck[gdi232comp]
		# Split the card to get data
		card_from_deck_split32comp = gdi32comp.split(",",true,1)
		# Get the value
		vls2[1] = values.find(card_from_deck_split32comp[0])
		# Get the suit
		sts2[1] = suites2.find(card_from_deck_split32comp[1])
		# Stitch back together using values and suites arrays
		bi32comp = values[vls2[1]]+","+suites2[sts2[1]]
		print ("bi32comp was : ", bi32comp)
		# Remove from the game deck
		var card_to_remove_from_deck32comp = game_deck.find(bi32comp)
		game_deck.remove(card_to_remove_from_deck32comp)
		# Insert the new card
		hand2[1] = bi32comp
		print ("compcard2 was : ",1)
	
	if comp1_cards_to_replace[2] == 1:
		gdi233comp = randi()%game_deck.size()
		gdi33comp = game_deck[gdi233comp]
		# Split the card to get data
		card_from_deck_split33comp = gdi33comp.split(",",true,1)
		# Get the value
		vls2[2] = values.find(card_from_deck_split33comp[0])
		# Get the suit
		sts2[2] = suites2.find(card_from_deck_split33comp[1])
		# Stitch back together using values and suites arrays
		bi33comp = values[vls2[2]]+","+suites2[sts2[2]]
		print ("bi33comp was : ", bi33comp)
		# Remove the card from the game deck
		var card_to_remove_from_deck33comp = game_deck.find(bi33comp)
		game_deck.remove(card_to_remove_from_deck33comp)
		# Insert the new card
		hand2[2] = bi33comp
		print ("compcard3 was : ",3)
	
	if comp1_cards_to_replace[3] == 1:
		gdi234comp = randi()%game_deck.size()
		gdi34comp = game_deck[gdi234comp]
		# Split the card to get data
		card_from_deck_split34comp = gdi34comp.split(",",true,1)
		# Get the value
		vls2[3] = values.find(card_from_deck_split34comp[0])
		# Get the suit
		sts2[3] = suites2.find(card_from_deck_split34comp[1])
		# Stitch back together using values and suites arrays
		bi34comp = values[vls2[3]]+","+suites2[sts2[3]]
		print ("bi34comp was : ", bi34comp)
		# Remove the card from the game deck
		var card_to_remove_from_deck34comp = game_deck.find(bi34comp)
		game_deck.remove(card_to_remove_from_deck34comp)
		# Insert the new card
		hand2[3] = bi34comp
		print ("compcard4 was : ",4)
	
	if comp1_cards_to_replace[4] == 1:
		gdi235comp = randi()%game_deck.size()
		gdi35comp = game_deck[gdi235comp]
		# Split the card to get data
		card_from_deck_split35comp = gdi35comp.split(",",true,1)
		# Get the value
		vls2[4] = values.find(card_from_deck_split35comp[0])
		# Get the suit
		sts2[4] = suites2.find(card_from_deck_split35comp[1])
		# Stitch back together using values and suites arrays
		bi35comp = values[vls2[4]]+","+suites2[sts2[4]]
		print ("bi35comp was : ", bi35comp)
		# Remove the card from the game deck
		var card_to_remove_from_deck35comp = game_deck.find(bi35comp)
		game_deck.remove(card_to_remove_from_deck35comp)
		# Insert the new card
		hand2[4] = bi35comp
		print ("compcard5 was : ",5)
	# Now finish the comp1 bet
	# add a delay to simulate time to get new cards, use a timer
	print (" comp CHANGED CARDS : ", hand2)
	
	# Work out how many cards have been changed and how much money to put in pot
	var comp_number_of_cards_replaced
	var comp_cost_of_cards_replaced
#	comp1_cards_to_replace.count(1)
	comp_number_of_cards_replaced = comp1_cards_to_replace.count(1)
	comp_cost_of_cards_replaced = comp_number_of_cards_replaced * new_card_amount
	comp1_money -= comp_cost_of_cards_replaced
	current_pot += comp_cost_of_cards_replaced
	
	# Finish with placing bet
	comp1_bet()

func comp1_bet():
	# Comp1 adding bet to pot
	comp1_money -= bet_amount
	current_pot += bet_amount
	# Start "place bet" timer, to simulate time to do things
	comp1_bet_delay_timer.start()

func comp1_finish_bet(): 
	# Once the timer ends, end comp1 turn
	comp1_has_bet = true
	if player_has_bet == true:
		# If the player has already taken their turn, end the round
		end_of_round()
	elif player_has_bet == false:
		# If the player hasn't had a turn yet, move to the player turn
		whose_turn = 0

### Player funcs ###
func player_folds():
	# Give pot to comp
	comp1_money += current_pot
	# End the game, displaying winner and why
	hands_display_text.text = ("Player has folded")
	winner_display_text.text = ("Computer 1 Wins")
	winning_hand_display_text.text = ("")

func player_bet():
	# Let the player add a bet if they haven't yet
	if player_has_bet == false:
		player_money -= bet_amount
		current_pot += bet_amount
		player_has_bet = true
	# If player has bet, let them withdraw to choose another option
	elif player_has_bet == true:
		player_money += bet_amount
		current_pot -= bet_amount
		player_has_bet = false

func player_finish_bet(): 
	# If comp1 has bet this round, end the round
	if comp1_has_bet == true:
		end_of_round()
	# If comp1 hasn't bet this round, make it their turn
	elif comp1_has_bet == false:
		whose_turn = 1
		comp1_decision_timer.start()

### Game funcs ###
func end_of_round():
	# Reset some vars ready for new round
	comp1_has_bet = false
	player_has_bet = false
	player_has_changed_cards = false
	player_cards_to_replace = [0,0,0,0,0]
	comp1_cards_to_replace = [0,0,0,0,0]
	
	# Only 4 rounds per game
	if round_number >= 4:
		end_of_game()
		# If not been 4 rounds yet, add to the round counter and reset turns
	elif round_number <=3:
		round_number += 1
		if whose_turn == 0:
			whose_turn = 1
			comp1_decision_timer.start()
		elif whose_turn == 1:
			whose_turn = 0

func end_of_game():
	# Compare the hands to end the game
	check_results()

# CREATE PLAYER CARD ARRAYS #
# could move to top
var vls = [0,0,0,0,0]
var sts = [0,0,0,0,0]
var hand = [0,0,0,0,0]

# Make the initial player hand
func make_player_hand():
	# Make hand by getting cards from the game deck
	# Then split to get the values and suits
	randomize()
	print ("Game Deck : ", game_deck)
	var bi
	var card_from_deck_split
	var gdi
	var gdi2
	for i in range(5):
		# range is 5, as thats the number of cards per hand
		# pick a random value from the size of the game deck for 5 cards
		# (not 52, as card deck may be smaller if comp has already been dealt)
		gdi2 = randi()%game_deck.size()
		gdi = game_deck[gdi2]
		# Split the card selected to get the value and suit data
		card_from_deck_split = gdi.split(",",true,1)
		# Get the value
		vls[i] = values.find(card_from_deck_split[0])
		# Get the suit
		sts[i] = suites2.find(card_from_deck_split[1])
		# Stitch back together for full card using the values and suites arrays
		bi = values[vls[i]]+","+suites2[sts[i]]
		print ("bi was : ", bi)
		var card_to_remove_from_deck = game_deck.find(bi)
		game_deck.remove(card_to_remove_from_deck)
		hand[i] = bi
	hand1 = hand
	# Could have done the last bit of for loop as "hand1[i] = bi" instead of using hand as a go between
	print ("hand1 : ", hand1)
	print ("Game Deck After Dealing player hand : ", game_deck)

func change_player_cards():
	randomize() # needed here?
	#print ("Game Deck : ", game_deck)
	# Temp vars for use in creating cards
	# These could be better labelled, they were all named quickly to test and just got left as is
	# Card 1
	var bi3
	var card_from_deck_split3
	var gdi3
	var gdi23
	# Card 2
	var bi32
	var card_from_deck_split32
	var gdi32
	var gdi232
	# Card 3
	var bi33
	var card_from_deck_split33
	var gdi33
	var gdi233
	# Card 4
	var bi34
	var card_from_deck_split34
	var gdi34
	var gdi234
	# Card 5
	var bi35
	var card_from_deck_split35
	var gdi35
	var gdi235
	# Go through each part of the player_cards_to_replace array, checking for cards to replace
	if player_cards_to_replace[0] == 1:
		# Pick a random number based on the number of cards left in the game deck
		gdi23 = randi()%game_deck.size()
		# Assign temp vars based on randomly chosen element
		gdi3 = game_deck[gdi23]
		# Split the card selected to get the value and suit data
		card_from_deck_split3 = gdi3.split(",",true,1)
		# Get the value
		vls[0] = values.find(card_from_deck_split3[0])
		# Get the suit
		sts[0] = suites2.find(card_from_deck_split3[1])
		# Stitch back together for full card using the values and suites arrays
		# the addition of the comma in the middle is needed, as it identifies where to split elements
		# which will be needed again later when ranking the cards
		bi3 = values[vls[0]]+","+suites2[sts[0]]
		print ("bi3 was : ", bi3)
		# Remove the card from the game deck, so it can't be duplicated
		var card_to_remove_from_deck3 = game_deck.find(bi3)
		game_deck.remove(card_to_remove_from_deck3)
		# Insert the new card into the player hand
		hand1[0] = bi3
		print ("card was : ",0)
	# The rest work as above, but comments have been reduced
	if player_cards_to_replace[1] == 1:
		gdi232 = randi()%game_deck.size()
		gdi32 = game_deck[gdi232]
		# Split the card to get data
		card_from_deck_split32 = gdi32.split(",",true,1)
		# Get the value
		vls[1] = values.find(card_from_deck_split32[0])
		# Get the suit
		sts[1] = suites2.find(card_from_deck_split32[1])
		# Stitch back together using values and suites arrays
		bi32 = values[vls[1]]+","+suites2[sts[1]]
		print ("bi32 was : ", bi32)
		# Remove from the game deck
		var card_to_remove_from_deck32 = game_deck.find(bi32)
		game_deck.remove(card_to_remove_from_deck32)
		# Insert the new card
		hand1[1] = bi32
		print ("card2 was : ",1)
	
	if player_cards_to_replace[2] == 1:
		gdi233 = randi()%game_deck.size()
		gdi33 = game_deck[gdi233]
		# Split the card to get data
		card_from_deck_split33 = gdi33.split(",",true,1)
		# Get the value
		vls[2] = values.find(card_from_deck_split33[0])
		# Get the suit
		sts[2] = suites2.find(card_from_deck_split33[1])
		# Stitch back together using values and suites arrays
		bi33 = values[vls[2]]+","+suites2[sts[2]]
		print ("bi33 was : ", bi33)
		# Remove the card from the game deck
		var card_to_remove_from_deck33 = game_deck.find(bi33)
		game_deck.remove(card_to_remove_from_deck33)
		# Insert the new card
		hand1[2] = bi33
		print ("card3 was : ",3)
	
	if player_cards_to_replace[3] == 1:
		gdi234 = randi()%game_deck.size()
		gdi34 = game_deck[gdi234]
		# Split the card to get data
		card_from_deck_split34 = gdi34.split(",",true,1)
		# Get the value
		vls[3] = values.find(card_from_deck_split34[0])
		# Get the suit
		sts[3] = suites2.find(card_from_deck_split34[1])
		# Stitch back together using values and suites arrays
		bi34 = values[vls[3]]+","+suites2[sts[3]]
		print ("bi34 was : ", bi34)
		# Remove the card from the game deck
		var card_to_remove_from_deck34 = game_deck.find(bi34)
		game_deck.remove(card_to_remove_from_deck34)
		# Insert the new card
		hand1[3] = bi34
		print ("card4 was : ",4)
	
	if player_cards_to_replace[4] == 1:
		gdi235 = randi()%game_deck.size()
		gdi35 = game_deck[gdi235]
		# Split the card to get data
		card_from_deck_split35 = gdi35.split(",",true,1)
		# Get the value
		vls[4] = values.find(card_from_deck_split35[0])
		# Get the suit
		sts[4] = suites2.find(card_from_deck_split35[1])
		# Stitch back together using values and suites arrays
		bi35 = values[vls[4]]+","+suites2[sts[4]]
		print ("bi35 was : ", bi35)
		# Remove the card from the game deck
		var card_to_remove_from_deck35 = game_deck.find(bi35)
		game_deck.remove(card_to_remove_from_deck35)
		# Insert the new card
		hand1[4] = bi35
		print ("card5 was : ",5)
	# Now finish the player bet
	# add a delay to simulate time to get new cards, use a timer
	print ("CHANGED CARDS : ", hand1)
	player_finish_bet()

# CREATE CARD ARRAYS FOR COMP1 #
# could move to top
var vls2 = [0,0,0,0,0]
var sts2 = [0,0,0,0,0]
var hand22 = [0,0,0,0,0]

# Make the initial computer1 hand
func make_comp1_hand():
	# Make hand by getting cards from the game deck
	# Then split to get the values and suits
	randomize()
	print ("Game Deck b c h d : ", game_deck)
	var bi2
	var card_from_deck_split2
	var gdi2
	var gdi22
	for i in range(5):
		# range is 5, as thats the number of cards per hand
		# pick a random value from the size of the game deck for 5 cards
		# (not 52, as card deck may be smaller if player has already been dealt)
		gdi22 = randi()%game_deck.size()
		gdi2 = game_deck[gdi22]
		# Split the card selected to get the value and suit data
		card_from_deck_split2 = gdi2.split(",",true,1)
		# Get the value
		vls2[i] = values.find(card_from_deck_split2[0])
		# Get the suit
		sts2[i] = suites2.find(card_from_deck_split2[1])
		# Stitch back together for full card using the values and suites arrays
		bi2 = values[vls2[i]]+","+suites2[sts2[i]]
		print ("bi2 was : ", bi2)
		var card_to_remove_from_deck2 = game_deck.find(bi2)
		game_deck.remove(card_to_remove_from_deck2)
		hand22[i] = bi2
	hand2 = hand22
	# Put comp1 cards "face down" for now, by hiding them behind other textures
	comp1_card1_image_hider.show()
	comp1_card2_image_hider.show()
	comp1_card3_image_hider.show()
	comp1_card4_image_hider.show()
	comp1_card5_image_hider.show()
	print ("comp hand : ",hand2)
	print ("Game Deck After comp hand : ", game_deck)

# Work out the rank of the hands sent to this function
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
	# This could have done as hand_suits = [hs1[0],hs2[0],hs3[0],hs4[0],hs5[0]] 
	
	# Get the positions of the cards in a hand
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
	
	# Sort the cards so they're in order
	var sorted_vals = ["h","h","h","h","h"]
	positions.sort()
	sorted_vals = positions
	# Get the number of times each value is repeated
	var reps_array = [sorted_vals.count(2),sorted_vals.count(3),sorted_vals.count(4),sorted_vals.count(5),sorted_vals.count(6),sorted_vals.count(7),sorted_vals.count(8),sorted_vals.count(9),sorted_vals.count(10),sorted_vals.count(11),sorted_vals.count(12),sorted_vals.count(13),sorted_vals.count(14)]
	
	# Check if all card suits are the same
	# Count them, and if any suits count = 5, get the suit
	var hand_suit_counter = ["H","D","C","S"]
	hand_suit_counter = [hand_suits.count("H"),hand_suits.count("D"),hand_suits.count("C"),hand_suits.count("S")]
	hand_suit_counter.find(5)
	var same_suit = false
	if hand_suit_counter.find(5) != -1:
		same_suit = true
	else:
		same_suit = false
	
	# Now assign ranks to hands
	if same_suit == true:
		# If cards are the same suit
		if sorted_vals == [10,11,12,13,14]:
			# Royal Flush
			#print ("royal flush : ", ranks[8])
			return [ranks[9], sorted_vals, 0, 0]
		if (sorted_vals[-1]-sorted_vals[0]) == 4:
			# this works fine for same suit, as can only == 4, as one of each between
			#Straight Flush
			#print ("straight flush : ", ranks[7])
			return [ranks[8], sorted_vals, 0, 0]
		else:
			# Flush
			#print ("flush : ", ranks[4]) 
			return [ranks[5], sorted_vals, 0, 0]  
			#0s added for padding in array elements
	elif same_suit == false:
		# If cards are of different suits
		if (sorted_vals[-1]-sorted_vals[0])==4:
			# Straight
			# possible straight, but mistakes can be made
			# By keep checking downwards through cards to check that they are in sequence
			if (sorted_vals[3]-sorted_vals[0])==3:
				if (sorted_vals[2]-sorted_vals[0])==2:
					if (sorted_vals[1]-sorted_vals[0])==1:
						return [ranks[4], sorted_vals, 0, 0]
		if 4 in reps_array:
			# Four of a kind
			#print ("four of a kind: ", ranks[6])
			#print ("reps in 4 in array for reps")
			return [ranks[7], sorted_vals, reps_array.find(4), 0]
		if 3 in reps_array:
			if 2 in reps_array:
				#Full House
				#print ("full house : ", ranks[5])
				return [ranks[6], sorted_vals, reps_array.find(3), reps_array.find(2)]
			# Or Three of a kind
			#print ("three of a kind : ", ranks[3])
			return [ranks[3], sorted_vals, reps_array.find(3), 0]
		if reps_array.count(2)==2:
			# Two pair
			#print ("two pair : ", ranks[2])
			return [ranks[2], sorted_vals, reps_array.find(2), reps_array.find_last(2)]
		if reps_array.count(2)==1:
			# One pair
			#print ("one pair : ", ranks[1])
			return [ranks[1], sorted_vals, reps_array.find(2), 0]
	# High Card
	return [ranks[0], sorted_vals, 0, 0]

# Check the results of the hands generated
func check_results():
	var pair1 #player
	var pair2 #comp1
	
	var second_pair1 # player
	var second_pair2 # comp1
	
	var player_three_kind
	var comp1_three_kind
	
	var player_four_kind
	var comp1_four_kind
	
	var result1 #player
	var result2 #comp1
	
	var in_both #player
	var in_both2 #comp1
	
	var high_card1 = [0,0,0,0,0] #player
	var high_card2 = [0,0,0,0,0] #comp1
	
	var result1_returned = [0,0,0,0] # player
	var result2_returned = [0,0,0,0] # comp1
	result1_returned  = rank_the_(hand1) # player
	result2_returned = rank_the_(hand2) # comp1
	
	result1 = result1_returned[0] #player
	result2 = result2_returned[0] #comp1
	#print ("results back : hand 2: ",result2,", and hand 1: ",result1)
	var result1_pos # player
	var result2_pos # comp1
	result1_pos = ranks.find(result1) # player
	result2_pos = ranks.find(result2) # comp1
	#print ("results position : res 1 : ",result1_pos, " res 2 : ",result2_pos)
	
	in_both = result1_returned[1] # player
	in_both2 = result2_returned[1] # comp1
	
	var shared_values = [] # Cards that are shared between participants (player and comp)
	var highest_card1 # player
	var highest_card1_val # player
	var highest_card2 # comp1
	var highest_card2_val # comp1
	
	# Display the hands in text format (not yet ordered)
	hands_display_text.text = "Player hand : " + str(hand1) + ", and Comp1 hand : " + str(hand2)
	# Show comp1 hand
	comp1_card1_image_hider.hide()
	comp1_card2_image_hider.hide()
	comp1_card3_image_hider.hide()
	comp1_card4_image_hider.hide()
	comp1_card5_image_hider.hide()
	
	if result1==result2:
		# If player and comp hands are the same
		if result1 == "High Card":
			# Create the shared values array (if there are any the same value)
			for thing in in_both:
				in_both2.find(thing)
				if in_both2.find(thing) != -1:
					shared_values.append(thing)
			# Get the player's highest card
			high_card1 = in_both
			for samesies in shared_values:
				high_card1.erase(samesies)
			if high_card1 != null:
				if high_card1.size() != 0:
					highest_card1 = high_card1.max()
			elif high_card1 == null:
				highest_card1 = 0
			highest_card1_val = values.find(highest_card1)
			# Get the computer's highest card
			high_card2 = in_both2
			for samesies2 in shared_values:
				high_card2.erase(samesies2)
			if high_card2 != null:
				if high_card2.size() != 0:
					highest_card2 = high_card2.max()
			elif high_card2 == null:
				highest_card2 = 0
			highest_card2_val = values.find(highest_card2)
			# Now compare the high cards
			if highest_card2 > highest_card1:
				#print ("Computer wins ", values_full[highest_card2-2], "over ", values_full[highest_card1-2])
				comp1_money += current_pot
				winner_display_text.text = "Computer 1 wins. They got " + str(current_pot)
				winning_hand_display_text.text = str(values_full[highest_card2-2]) + " over "+ str(values_full[highest_card1-2])
				current_pot = 0
			elif highest_card1 > highest_card2:
				#print ("Congratulations! You win. ", values_full[highest_card1-2], "over ", values_full[highest_card2-2])
				player_money += current_pot
				winner_display_text.text = "Player wins. You got " + str(current_pot)
				winning_hand_display_text.text = str(values_full[highest_card1-2]) + " over "+ str(values_full[highest_card2-2])
				current_pot = 0
			else:
				#print ("draw")
				comp1_money += current_pot/2
				player_money += current_pot/2
				winner_display_text.text = "Draw"
				winning_hand_display_text.text = "You got half the pot. You got " + str(current_pot/2)
				current_pot = 0
		elif result1 == "One Pair":
			#if both have pairs, base winner on highest pair value
			pair1 = result1_returned[2]
			pair2 = result2_returned[2]
			# can move vars to main loop, or doesn't matter as only used here?
			var pair1_val = values[pair1]
			var pair2_val = values[pair2]
			var pair1_final_value = values_full[pair1]
			var pair2_final_value = values_full[pair2]
			#print ("You have a pair of ", pair1_final_value, "'s")
			#print ("Computer has a pair of ", pair2_final_value, "'s")
			# Determine highest value of pairs
			print ("PAIRS WERE : player : ", pair1, ", comp1 : ", pair2)
			print ("PAIRS VALS : player : ", pair1_val, ", comp1 : ", pair2_val)
			print ("pair values : player : ", pair1_final_value, ", comp1 : ", pair2_final_value)
			if pair2_final_value > pair1_final_value:
				#print ("Computer wins.")
				comp1_money += current_pot
				winner_display_text.text = "Computer 1 wins. They got " + str(current_pot)
				winning_hand_display_text.text = "Pair of " + str(pair2_final_value) + " over "+ str(pair1_final_value)
				current_pot = 0
				print ("pair values HERE : player : ", pair1_final_value, ", comp1 : ", pair2_final_value)
			elif pair1_final_value > pair2_final_value:
				#print ("Congrats, you win.")
				player_money += current_pot
				winner_display_text.text = "Player wins. You got " + str(current_pot)
				winning_hand_display_text.text = "Pair of " + str(pair1_final_value) + " over "+ str(pair2_final_value)
				current_pot = 0
				print ("pair values THEREERER : player : ", pair1_final_value, ", comp1 : ", pair2_final_value)
			else:
				# If both have pairs of the same value, use highest card
				for thing in in_both:
					in_both2.find(thing)
					if in_both2.find(thing) != -1:
						shared_values.append(thing)
				# Get the player's highest card
				high_card1 = in_both
				for samesies in shared_values:
					high_card1.erase(samesies)
				if high_card1 != null:
					if high_card1.size() != 0:
						highest_card1 = high_card1.max()
				elif high_card1 == null:
					highest_card1 = 0
				highest_card1_val = values.find(highest_card1)
				# Get the computer's highest card
				high_card2 = in_both2
				for samesies2 in shared_values:
					high_card2.erase(samesies2)
				if high_card2 != null:
					if high_card2.size() != 0:
						highest_card2 = high_card2.max()
				elif high_card2 == null:
					highest_card2 = 0
				highest_card2_val = values.find(highest_card2)
				# Now compare the high cards
				if highest_card2 > highest_card1:
					#print ("Computer wins ", values_full[highest_card2-2], "over ", values_full[highest_card1-2])
					comp1_money += current_pot
					winner_display_text.text = "Computer 1 wins. They got " + str(current_pot)
					winning_hand_display_text.text = str(values_full[highest_card2-2]) + " over "+ str(values_full[highest_card1-2])
					current_pot = 0
				elif highest_card1 > highest_card2:
					#print ("Congratulations! You win. ", values_full[highest_card1-2], "over ", values_full[highest_card2-2])
					player_money += current_pot
					winner_display_text.text = "Player wins. You got " + str(current_pot)
					winning_hand_display_text.text = str(values_full[highest_card1-2]) + " over "+ str(values_full[highest_card2-2])
					current_pot = 0
				else:
					comp1_money += current_pot/2
					player_money += current_pot/2
					winner_display_text.text = "Draw"
					winning_hand_display_text.text = "You got half the pot. You got " + str(current_pot/2)
					current_pot = 0
#					print ("draw")
		elif result1 == "Two Pairs":
			#if both have  2 pairs, base winner on highest pair value, not highest next card
			pair1 = result1_returned[2]
			second_pair1 = result1_returned[3]
			pair2 = result2_returned[2]
			second_pair2 = result2_returned[3]
			# can move vars to main loop, or doesn't matter as only used here?
			#player pairs
			var two_pair1_val = values[pair1]
			var two_second_pair1_val = values[second_pair1]
			var two_pair1_final_value_t = values_full[pair1]
			var two_second_pair1_final_value_t = values_full[second_pair1]
			var two_pair1_final_value
			# only one, as is final value from the 2 pairs in each hand
			#comp1 pairs
			var two_pair2_val = values[pair2]
			var two_second_pair2_val = values[second_pair2]
			var two_pair2_final_value_t = values_full[pair2]
			var two_second_pair2_final_value_t = values_full[second_pair2]
			var two_pair2_final_value
			#print ("You have a pair of ", pair1_final_value, "'s")
			#print ("Computer has a pair of ", pair2_final_value, "'s")
			# Determine highest value of pairs
			print ("TWO PAIRS WERE : player : ", pair1, " and ", second_pair1, ", comp1 : ", pair2, " and ", second_pair2)
			#print ("TWO PAIRS VALS : player : ", two_pair1_val, ", comp1 : ", two_pair2_val) # add if needed
			print ("Two pair values : player : ", two_pair1_final_value_t, " and ", two_second_pair1_final_value_t, ", comp1 : ", two_pair2_final_value_t, " and ",two_second_pair2_final_value_t)
			#compare each participant's pairs to get the highest pair from each hand
			if two_pair1_final_value_t > two_second_pair1_final_value_t:
				two_pair1_final_value = two_pair1_final_value_t
			elif two_second_pair1_final_value_t > two_pair1_final_value_t:
				two_pair1_final_value = two_second_pair1_final_value_t
			print ("player highest pair was : ", two_pair1_final_value)
			
			if two_pair2_final_value_t > two_second_pair2_final_value_t:
				two_pair2_final_value = two_pair2_final_value_t
			elif two_second_pair2_final_value_t > two_pair2_final_value_t:
				two_pair2_final_value = two_second_pair2_final_value_t
			print ("comp1 highest pair was : ", two_pair2_final_value)
			
			#then compare as above between the highest pairs from each hand
			if two_pair2_final_value > two_pair1_final_value:
				#print ("Computer wins.")
				comp1_money += current_pot
				winner_display_text.text = "Computer 1 wins. They got " + str(current_pot)
				winning_hand_display_text.text = "Pair of " + str(two_pair2_final_value) + " over "+ str(two_pair1_final_value)
				current_pot = 0
				print ("pair values HERE : player : ", two_pair1_final_value, ", comp1 : ", two_pair2_final_value)
			elif two_pair1_final_value > two_pair2_final_value:
				#print ("Congrats, you win.")
				player_money += current_pot
				winner_display_text.text = "Player wins. You got " + str(current_pot)
				winning_hand_display_text.text = "Pair of " + str(two_pair1_final_value) + " over "+ str(two_pair2_final_value)
				current_pot = 0
				print ("pair values THEREERER : player : ", two_pair1_final_value, ", comp1 : ", two_pair2_final_value)
			else:
				# If both have a high pair of the same value, use highest card
				for thing in in_both:
					in_both2.find(thing)
					if in_both2.find(thing) != -1:
						shared_values.append(thing)
				# Get the player's highest card
				high_card1 = in_both
				for samesies in shared_values:
					high_card1.erase(samesies)
				if high_card1 != null:
					if high_card1.size() != 0:
						highest_card1 = high_card1.max()
				elif high_card1 == null:
					highest_card1 = 0
				highest_card1_val = values.find(highest_card1)
				# Get the computer's highest card
				high_card2 = in_both2
				for samesies2 in shared_values:
					high_card2.erase(samesies2)
				if high_card2 != null:
					if high_card2.size() != 0:
						highest_card2 = high_card2.max()
				elif high_card2 == null:
					highest_card2 = 0
				highest_card2_val = values.find(highest_card2)
				# Now compare the high cards
				if highest_card2 > highest_card1:
					#print ("Computer wins ", values_full[highest_card2-2], "over ", values_full[highest_card1-2])
					comp1_money += current_pot
					winner_display_text.text = "Computer 1 wins. They got " + str(current_pot)
					winning_hand_display_text.text = str(values_full[highest_card2-2]) + " over "+ str(values_full[highest_card1-2])
					current_pot = 0
				elif highest_card1 > highest_card2:
					#print ("Congratulations! You win. ", values_full[highest_card1-2], "over ", values_full[highest_card2-2])
					player_money += current_pot
					winner_display_text.text = "Player wins. You got " + str(current_pot)
					winning_hand_display_text.text = str(values_full[highest_card1-2]) + " over "+ str(values_full[highest_card2-2])
					current_pot = 0
				else:
					comp1_money += current_pot/2
					player_money += current_pot/2
					winner_display_text.text = "Draw"
					winning_hand_display_text.text = "You got half the pot. You got " + str(current_pot/2)
					current_pot = 0
#					print ("draw")
		elif result1 == "Three of a Kind":
			#if both have three of a kind, base winner on highest value, not highest next card
			player_three_kind = result1_returned[2]
			comp1_three_kind = result2_returned[2]
			# can move vars to main loop, or doesn't matter as only used here?
			var player_three_kind_val = values[player_three_kind]
			var comp1_three_kind_val = values[comp1_three_kind]
			var player_three_kind_final_value = values_full[player_three_kind]
			var comp1_three_kind_final_value = values_full[comp1_three_kind]
			#print ("You have a pair of ", pair1_final_value, "'s")
			#print ("Computer has a pair of ", pair2_final_value, "'s")
			# Determine highest value of three of a kind
			print ("THREE OF A KIND WERE : player : ", player_three_kind, ", comp1 : ", comp1_three_kind)
			print ("THREE OF A KIND VALS : player : ", player_three_kind_val, ", comp1 : ", comp1_three_kind_val)
			print ("Three of a kind values : player : ", player_three_kind_final_value, ", comp1 : ", comp1_three_kind_final_value)
			if comp1_three_kind_final_value > player_three_kind_final_value:
				#print ("Computer wins.")
				comp1_money += current_pot
				winner_display_text.text = "Computer 1 wins. They got " + str(current_pot)
				winning_hand_display_text.text = "Three of a kind of " + str(comp1_three_kind_final_value) + " over "+ str(player_three_kind_final_value)
				current_pot = 0
				print ("THREE of a kind values HERE : player : ", player_three_kind_final_value, ", comp1 : ", comp1_three_kind_final_value)
			elif player_three_kind_final_value > comp1_three_kind_final_value:
				#print ("Congrats, you win.")
				player_money += current_pot
				winner_display_text.text = "Player wins. You got " + str(current_pot)
				winning_hand_display_text.text = "Three of a kind of " + str(player_three_kind_final_value) + " over "+ str(comp1_three_kind_final_value)
				current_pot = 0
				print ("Three of a kind values THEREERER : player : ", player_three_kind_final_value, ", comp1 : ", comp1_three_kind_final_value)
			else:
				# If both have three of a kind of the same value, use highest card
				# can't happen if using one deck, but pu in in case of games with multiple decks
				for thing in in_both:
					in_both2.find(thing)
					if in_both2.find(thing) != -1:
						shared_values.append(thing)
				# Get the player's highest card
				high_card1 = in_both
				for samesies in shared_values:
					high_card1.erase(samesies)
				if high_card1 != null:
					if high_card1.size() != 0:
						highest_card1 = high_card1.max()
				elif high_card1 == null:
					highest_card1 = 0
				highest_card1_val = values.find(highest_card1)
				# Get the computer's highest card
				high_card2 = in_both2
				for samesies2 in shared_values:
					high_card2.erase(samesies2)
				if high_card2 != null:
					if high_card2.size() != 0:
						highest_card2 = high_card2.max()
				elif high_card2 == null:
					highest_card2 = 0
				highest_card2_val = values.find(highest_card2)
				# Now compare the high cards
				if highest_card2 > highest_card1:
					#print ("Computer wins ", values_full[highest_card2-2], "over ", values_full[highest_card1-2])
					comp1_money += current_pot
					winner_display_text.text = "Computer 1 wins. They got " + str(current_pot)
					winning_hand_display_text.text = str(values_full[highest_card2-2]) + " over "+ str(values_full[highest_card1-2])
					current_pot = 0
				elif highest_card1 > highest_card2:
					#print ("Congratulations! You win. ", values_full[highest_card1-2], "over ", values_full[highest_card2-2])
					player_money += current_pot
					winner_display_text.text = "Player wins. You got " + str(current_pot)
					winning_hand_display_text.text = str(values_full[highest_card1-2]) + " over "+ str(values_full[highest_card2-2])
					current_pot = 0
				else:
					comp1_money += current_pot/2
					player_money += current_pot/2
					winner_display_text.text = "Draw"
					winning_hand_display_text.text = "You got half the pot. You got " + str(current_pot/2)
					current_pot = 0
#					print ("draw")
		elif result1 == "Straight":
			# 5 cards in sequence, different suits
			# as 5 cards in sequence, comes down to highest card if both players have it
			# Reuse highest card code
			# Create the shared values array (if there are any the same value)
			for thing in in_both:
				in_both2.find(thing)
				if in_both2.find(thing) != -1:
					shared_values.append(thing)
			# Get the player's highest card
			high_card1 = in_both
			for samesies in shared_values:
				high_card1.erase(samesies)
			if high_card1 != null:
				if high_card1.size() != 0:
					highest_card1 = high_card1.max()
			elif high_card1 == null:
				highest_card1 = 0
			highest_card1_val = values.find(highest_card1)
			# Get the computer's highest card
			high_card2 = in_both2
			for samesies2 in shared_values:
				high_card2.erase(samesies2)
			if high_card2 != null:
				if high_card2.size() != 0:
					highest_card2 = high_card2.max()
			elif high_card2 == null:
				highest_card2 = 0
			highest_card2_val = values.find(highest_card2)
			# Now compare the high cards
			if highest_card2 > highest_card1:
				#print ("Computer wins ", values_full[highest_card2-2], "over ", values_full[highest_card1-2])
				comp1_money += current_pot
				winner_display_text.text = "Computer 1 wins. They got " + str(current_pot)
				winning_hand_display_text.text = str(values_full[highest_card2-2]) + " over "+ str(values_full[highest_card1-2])
				current_pot = 0
			elif highest_card1 > highest_card2:
				#print ("Congratulations! You win. ", values_full[highest_card1-2], "over ", values_full[highest_card2-2])
				player_money += current_pot
				winner_display_text.text = "Player wins. You got " + str(current_pot)
				winning_hand_display_text.text = str(values_full[highest_card1-2]) + " over "+ str(values_full[highest_card2-2])
				current_pot = 0
			else:
				#print ("draw")
				comp1_money += current_pot/2
				player_money += current_pot/2
				winner_display_text.text = "Draw"
				winning_hand_display_text.text = "You got half the pot. You got " + str(current_pot/2)
				current_pot = 0

		elif result1 == "Flush":
			# 5 cards same suit, not in sequence
			# as they will be different suits, this comes down to high card if both have it
			# Reuse highest card code
			# Create the shared values array (if there are any the same value)
			for thing in in_both:
				in_both2.find(thing)
				if in_both2.find(thing) != -1:
					shared_values.append(thing)
			# Get the player's highest card
			high_card1 = in_both
			for samesies in shared_values:
				high_card1.erase(samesies)
			if high_card1 != null:
				if high_card1.size() != 0:
					highest_card1 = high_card1.max()
			elif high_card1 == null:
				highest_card1 = 0
			highest_card1_val = values.find(highest_card1)
			# Get the computer's highest card
			high_card2 = in_both2
			for samesies2 in shared_values:
				high_card2.erase(samesies2)
			if high_card2 != null:
				if high_card2.size() != 0:
					highest_card2 = high_card2.max()
			elif high_card2 == null:
				highest_card2 = 0
			highest_card2_val = values.find(highest_card2)
			# Now compare the high cards
			if highest_card2 > highest_card1:
				#print ("Computer wins ", values_full[highest_card2-2], "over ", values_full[highest_card1-2])
				comp1_money += current_pot
				winner_display_text.text = "Computer 1 wins. They got " + str(current_pot)
				winning_hand_display_text.text = str(values_full[highest_card2-2]) + " over "+ str(values_full[highest_card1-2])
				current_pot = 0
			elif highest_card1 > highest_card2:
				#print ("Congratulations! You win. ", values_full[highest_card1-2], "over ", values_full[highest_card2-2])
				player_money += current_pot
				winner_display_text.text = "Player wins. You got " + str(current_pot)
				winning_hand_display_text.text = str(values_full[highest_card1-2]) + " over "+ str(values_full[highest_card2-2])
				current_pot = 0
			else:
				#print ("draw")
				comp1_money += current_pot/2
				player_money += current_pot/2
				winner_display_text.text = "Draw"
				winning_hand_display_text.text = "You got half the pot. You got " + str(current_pot/2)
				current_pot = 0
		elif result1 == "Full House":
			# combine three of a kind and one pair
			# reuse three of a kind code, as the values of the pairs will be the same
			# no point working out the value of pairs from pair if not needed
			# if both have three of a kind, base winner on highest value
			player_three_kind = result1_returned[2]
			comp1_three_kind = result2_returned[2]
			# can move vars to main loop, or doesn't matter as only used here?
			var player_three_kind_val = values[player_three_kind] #.find(pair1)
			var comp1_three_kind_val = values[comp1_three_kind] #.find(pair2)
			var player_three_kind_final_value = values_full[player_three_kind]
			var comp1_three_kind_final_value = values_full[comp1_three_kind]
			#print ("You have a pair of ", pair1_final_value, "'s")
			#print ("Computer has a pair of ", pair2_final_value, "'s")
			# Determine highest value of threes
			print ("THREE IN FULL HOUSE WERE : player : ", player_three_kind, ", comp1 : ", comp1_three_kind)
			print ("THREE IN FULL HOUSE VALS : player : ", player_three_kind_val, ", comp1 : ", comp1_three_kind_val)
			print ("Three in full house values : player : ", player_three_kind_final_value, ", comp1 : ", comp1_three_kind_final_value)
			if comp1_three_kind_final_value > player_three_kind_final_value:
				#print ("Computer wins.")
				comp1_money += current_pot
				winner_display_text.text = "Computer 1 wins. They got " + str(current_pot)
				winning_hand_display_text.text = "Three in Full House of " + str(comp1_three_kind_final_value) + " over "+ str(player_three_kind_final_value)
				current_pot = 0
				print ("THREE in full house values HERE : player : ", player_three_kind_final_value, ", comp1 : ", comp1_three_kind_final_value)
			elif player_three_kind_final_value > comp1_three_kind_final_value:
				#print ("Congrats, you win.")
				player_money += current_pot
				winner_display_text.text = "Player wins. You got " + str(current_pot)
				winning_hand_display_text.text = "Three in Full House of " + str(player_three_kind_final_value) + " over "+ str(comp1_three_kind_final_value)
				current_pot = 0
				print ("Three in full house values THEREERER : player : ", player_three_kind_final_value, ", comp1 : ", comp1_three_kind_final_value)
			else:
				# If both three of a kind are of the same value, use highest pair
				# Using high card code instead of pair code, as it's simpler
				for thing in in_both:
					in_both2.find(thing)
					if in_both2.find(thing) != -1:
						shared_values.append(thing)
				# Get the player's highest card
				high_card1 = in_both
				for samesies in shared_values:
					high_card1.erase(samesies)
				if high_card1 != null:
					if high_card1.size() != 0:
						highest_card1 = high_card1.max()
				elif high_card1 == null:
					highest_card1 = 0
				highest_card1_val = values.find(highest_card1)
				# Get the computer's highest card
				high_card2 = in_both2
				for samesies2 in shared_values:
					high_card2.erase(samesies2)
				if high_card2 != null:
					if high_card2.size() != 0:
						highest_card2 = high_card2.max()
				elif high_card2 == null:
					highest_card2 = 0
				highest_card2_val = values.find(highest_card2)
				# Now compare the high cards
				if highest_card2 > highest_card1:
					#print ("Computer wins ", values_full[highest_card2-2], "over ", values_full[highest_card1-2])
					comp1_money += current_pot
					winner_display_text.text = "Computer 1 wins. They got " + str(current_pot)
					#winner_display_text.text = "Computer 1 wins"
					winning_hand_display_text.text = str(values_full[highest_card2-2]) + " over "+ str(values_full[highest_card1-2])
					current_pot = 0
				elif highest_card1 > highest_card2:
					#print ("Congratulations! You win. ", values_full[highest_card1-2], "over ", values_full[highest_card2-2])
					player_money += current_pot
					winner_display_text.text = "Player wins. You got " + str(current_pot)
					winning_hand_display_text.text = str(values_full[highest_card1-2]) + " over "+ str(values_full[highest_card2-2])
					current_pot = 0
				else:
					comp1_money += current_pot/2
					player_money += current_pot/2
					winner_display_text.text = "Draw"
					winning_hand_display_text.text = "You got half the pot. You got " + str(current_pot/2)
					current_pot = 0
#					print ("draw")
		elif result1 == "Four of a Kind":
			#if both have four of a kind, base winner on highest value
			player_four_kind = result1_returned[2]
			comp1_four_kind = result2_returned[2]
			# can move vars to main loop, or doesn't matter as only used here?
			var player_four_kind_val = values[player_four_kind]
			var comp1_four_kind_val = values[comp1_four_kind]
			var player_four_kind_final_value = values_full[player_four_kind]
			var comp1_four_kind_final_value = values_full[comp1_four_kind]
			#print ("You have a pair of ", pair1_final_value, "'s")
			#print ("Computer has a pair of ", pair2_final_value, "'s")
			# Determine highest value of fours
			print ("FOUR OF A KIND WERE : player : ", player_four_kind, ", comp1 : ", comp1_four_kind)
			print ("FOUR OF A KIND VALS : player : ", player_four_kind_val, ", comp1 : ", comp1_four_kind_val)
			print ("Four of a kind values : player : ", player_four_kind_final_value, ", comp1 : ", comp1_four_kind_final_value)
			if comp1_four_kind_final_value > player_four_kind_final_value:
				#print ("Computer wins.")
				comp1_money += current_pot
				winner_display_text.text = "Computer 1 wins. They got " + str(current_pot)
				winning_hand_display_text.text = "Four of a kind of " + str(comp1_four_kind_final_value) + " over "+ str(player_four_kind_final_value)
				current_pot = 0
				print ("FOUR of a kind values HERE : player : ", player_four_kind_final_value, ", comp1 : ", comp1_four_kind_final_value)
			elif player_four_kind_final_value > comp1_four_kind_final_value:
				#print ("Congrats, you win.")
				player_money += current_pot
				winner_display_text.text = "Player wins. You got " + str(current_pot)
				winning_hand_display_text.text = "Four of a kind of " + str(player_four_kind_final_value) + " over "+ str(comp1_four_kind_final_value)
				current_pot = 0
				print ("FOUR of a kind values THEREERER : player : ", player_four_kind_final_value, ", comp1 : ", comp1_four_kind_final_value)
			else:
				# If both have fours of the same value, use highest card
				# can't happen if using only one deck, but added in case use multiple decks
				for thing in in_both:
					in_both2.find(thing)
					if in_both2.find(thing) != -1:
						shared_values.append(thing)
				# Get the player's highest card
				high_card1 = in_both
				for samesies in shared_values:
					high_card1.erase(samesies)
				if high_card1 != null:
					if high_card1.size() != 0:
						highest_card1 = high_card1.max()
				elif high_card1 == null:
					highest_card1 = 0
				highest_card1_val = values.find(highest_card1)
				# Get the computer's highest card
				high_card2 = in_both2
				for samesies2 in shared_values:
					high_card2.erase(samesies2)
				if high_card2 != null:
					if high_card2.size() != 0:
						highest_card2 = high_card2.max()
				elif high_card2 == null:
					highest_card2 = 0
				highest_card2_val = values.find(highest_card2)
				# Now compare the high cards
				if highest_card2 > highest_card1:
					#print ("Computer wins ", values_full[highest_card2-2], "over ", values_full[highest_card1-2])
					comp1_money += current_pot
					winner_display_text.text = "Computer 1 wins. They got " + str(current_pot)
					#winner_display_text.text = "Computer 1 wins"
					winning_hand_display_text.text = str(values_full[highest_card2-2]) + " over "+ str(values_full[highest_card1-2])
					current_pot = 0
				elif highest_card1 > highest_card2:
					#print ("Congratulations! You win. ", values_full[highest_card1-2], "over ", values_full[highest_card2-2])
					player_money += current_pot
					winner_display_text.text = "Player wins. You got " + str(current_pot)
					winning_hand_display_text.text = str(values_full[highest_card1-2]) + " over "+ str(values_full[highest_card2-2])
					current_pot = 0
				else:
					comp1_money += current_pot/2
					player_money += current_pot/2
					winner_display_text.text = "Draw"
					winning_hand_display_text.text = "You got half the pot. You got " + str(current_pot/2)
					current_pot = 0
#					print ("draw")
		elif result1 == "Straight Flush":
			# 5 cards in sequence of the same suit
			# if both have, becomes high card, as both can have by having different suits
			# Reuse highest card code
			# Create the shared values array (if there are any the same value)
			for thing in in_both:
				in_both2.find(thing)
				if in_both2.find(thing) != -1:
					shared_values.append(thing)
			# Get the player's highest card
			high_card1 = in_both
			for samesies in shared_values:
				high_card1.erase(samesies)
			if high_card1 != null:
				if high_card1.size() != 0:
					highest_card1 = high_card1.max()
			elif high_card1 == null:
				highest_card1 = 0
			highest_card1_val = values.find(highest_card1)
			# Get the computer's highest card
			high_card2 = in_both2
			for samesies2 in shared_values:
				high_card2.erase(samesies2)
			if high_card2 != null:
				if high_card2.size() != 0:
					highest_card2 = high_card2.max()
			elif high_card2 == null:
				highest_card2 = 0
			highest_card2_val = values.find(highest_card2)
			# Now compare the high cards
			if highest_card2 > highest_card1:
				#print ("Computer wins ", values_full[highest_card2-2], "over ", values_full[highest_card1-2])
				comp1_money += current_pot
				winner_display_text.text = "Computer 1 wins. They got " + str(current_pot)
				winning_hand_display_text.text = str(values_full[highest_card2-2]) + " over "+ str(values_full[highest_card1-2])
				current_pot = 0
			elif highest_card1 > highest_card2:
				#print ("Congratulations! You win. ", values_full[highest_card1-2], "over ", values_full[highest_card2-2])
				player_money += current_pot
				winner_display_text.text = "Player wins. You got " + str(current_pot)
				winning_hand_display_text.text = str(values_full[highest_card1-2]) + " over "+ str(values_full[highest_card2-2])
				current_pot = 0
			else:
				#print ("draw")
				comp1_money += current_pot/2
				player_money += current_pot/2
				winner_display_text.text = "Draw"
				winning_hand_display_text.text = "You got half the pot. You got " + str(current_pot/2)
				current_pot = 0
		elif result1 == "Royal Flush":
			# as straight flush, but with the highest cards, 10, J, Q, K, and A
			# if both have this, draw, as the highest in both is ACE
			# so just cut straight to draw
			#print ("draw")
			comp1_money += current_pot/2
			player_money += current_pot/2
			winner_display_text.text = "Draw"
			winning_hand_display_text.text = "You got half the pot. You got " + str(current_pot/2)
			current_pot = 0
	else:
		# If player and comp hands are different, rank by hands
		if result1_pos>result2_pos:
			#print ("Congrats, you win the hand.", result1)
			player_money += current_pot
			winner_display_text.text = "Player wins. You got " + str(current_pot)
			winning_hand_display_text.text = "with " + str(result1)
			# add what the winning cards were, not just the hand, eg pair of 10s, not just pair
			current_pot = 0
		else:
			#print ("Computer wins.", result2)
			comp1_money += current_pot
			winner_display_text.text = "Computer 1 wins. They got " + str(current_pot)
			winning_hand_display_text.text = "with " + str(result2)
			current_pot = 0

# Start a new game
func new_game():
	# Create a full new deck by adding the suit arrays together
	whole_deck = hearts_suit + diamonds_suit + clubs_suit + spades_suit
	print ("whole deck : ", whole_deck)
	# Create the game deck by copying the whole deck
	game_deck = whole_deck
	# Shuffle the deck if desired, not used in this verion, as card choosing uses randomize instead
	#game_deck.shuffle()
	# Set the round number to 1
	round_number = 1
	# Randomize here for all the random start variables (cards dealt, play order, etc)
	randomize()
	# Determine play order, randomize at some point
	whose_turn = 0
	# Hide the menu parts not needed yet
	back_to_main_menu.hide()
	new_game_menu.hide()
	
	### Reset vars for new games ###
	comp1_has_bet = false
	player_has_bet = false
	player_has_changed_cards = false
	player_cards_to_replace = [0,0,0,0,0]
	comp1_cards_to_replace = [0,0,0,0,0]
	current_pot = 0
	
	# Hide the elements not needed yet
	comp1_card1_change_indicator.hide()
	comp1_card2_change_indicator.hide()
	comp1_card3_change_indicator.hide()
	comp1_card4_change_indicator.hide()
	comp1_card5_change_indicator.hide()
	
	player_card1_change_indicator.hide()
	player_card2_change_indicator.hide()
	player_card3_change_indicator.hide()
	player_card4_change_indicator.hide()
	player_card5_change_indicator.hide()
	
	player_card1_change_keep_button.text = ("Change Card")
	player_card2_change_keep_button.text = ("Change Card")
	player_card3_change_keep_button.text = ("Change Card")
	player_card4_change_keep_button.text = ("Change Card")
	player_card5_change_keep_button.text = ("Change Card")
	
	# Set up the main text elements
	hands_display_text.text = ("")
	winner_display_text.text = ("")
	winning_hand_display_text.text = ("")
	
	bet_cost_text.text = ("Bet Cost : " + str(bet_amount))
	new_card_cost_text.text = ("New Card Cost : " + str(new_card_amount))
	current_pot_text.text = ("Current Pot : " + str(current_pot))
	turn_counter_text.text = ("Current Round : " + str(round_number))
	
	# Make the hands
	make_player_hand()
	make_comp1_hand()
	
	# Test hands
#	hand2 = ["J,H","10,H","Q,H","K,H","A,H"] #comp
#	hand2 = ["J,S","10,S","K,S","A,S","Q,S"] #comp1 royal flush spades
#	hand1 = ["J,D","10,D","K,D","A,D","Q,D"] #player royal flush diamonds
#	hand1 = ["J,D","10,D","8,D","9,D","Q,D"] #player straight flush diamonds
#	hand1 = ["J,S","10,D","8,D","9,C","Q,H"] #player straight 
#	hand2 = ["J,H","J,D","3,H","5,H","7,H"] #comp
#	hand1 = ["Q,S","Q,C","Q,D","6,D","8,D"] #player 3 of kind
#	hand2 = ["J,H","J,D","J,S","5,H","7,H"] #comp 3 of kind
#	hand1 = ["K,C","Q,H","10,C","10,S","9,C"] #player hand mistaken by wrong code as straight, figured out

### Button funcs ###
# Return to main menu
func _on_BackToMainButton_pressed():
	# Sshow the confirm dialog for returning to main
	back_to_main_menu.show()
	# Make sure that the new game dialog is hidden
	new_game_menu.hide()

func _on_YesMainButton_pressed():
	# Takes us back to the main menu
	get_node("/root/MasterControl").goto_scene("res://Scenes/MainMenu.tscn")

func _on_NoMainButton_pressed():
	# If cancel returning to main menu, hide dialogs
	back_to_main_menu.hide()
	new_game_menu.hide()

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

### Player Actions Buttons ###
func _on_PlayerCard1ChangeKeepButton_pressed():
	if player_cards_to_replace[0] == 1:
		player_cards_to_replace[0] = 0
		#player_has_changed_cards = false
		current_pot -= new_card_amount
		player_money += new_card_amount
	elif player_cards_to_replace[0] == 0:
		if player_money >= bet_amount + new_card_amount:
			player_cards_to_replace[0] = 1
			#player_has_changed_cards = true
			current_pot += new_card_amount
			player_money -= new_card_amount

func _on_PlayerCard2ChangeKeepButton_pressed():
	if player_cards_to_replace[1] == 1:
		player_cards_to_replace[1] = 0
		#player_has_changed_cards = false
		current_pot -= new_card_amount
		player_money += new_card_amount
	elif player_cards_to_replace[1] == 0:
		if player_money >= bet_amount + new_card_amount:
			player_cards_to_replace[1] = 1
			#player_has_changed_cards = true
			current_pot += new_card_amount
			player_money -= new_card_amount

func _on_PlayerCard3ChangeKeepButton_pressed():
	if player_cards_to_replace[2] == 1:
		player_cards_to_replace[2] = 0
		#player_has_changed_cards = false
		current_pot -= new_card_amount
		player_money += new_card_amount
	elif player_cards_to_replace[2] == 0:
		if player_money >= bet_amount + new_card_amount:
			player_cards_to_replace[2] = 1
			#player_has_changed_cards = true
			current_pot += new_card_amount
			player_money -= new_card_amount

func _on_PlayerCard4ChangeKeepButton_pressed():
	if player_cards_to_replace[3] == 1:
		player_cards_to_replace[3] = 0
		#player_has_changed_cards = false
		current_pot -= new_card_amount
		player_money += new_card_amount
	elif player_cards_to_replace[3] == 0:
		if player_money >= bet_amount + new_card_amount:
			player_cards_to_replace[3] = 1
			#player_has_changed_cards = true
			current_pot += new_card_amount
			player_money -= new_card_amount

func _on_PlayerCard5ChangeKeepButton_pressed():
	if player_cards_to_replace[4] == 1:
		player_cards_to_replace[4] = 0
		#player_has_changed_cards = false
		current_pot -= new_card_amount
		player_money += new_card_amount
	elif player_cards_to_replace[4] == 0:
		if player_money >= bet_amount + new_card_amount:
			player_cards_to_replace[4] = 1
			#player_has_changed_cards = true
			current_pot += new_card_amount
			player_money -= new_card_amount

func _on_PlayerFoldButton_pressed():
	player_folds()

func _on_PlayerBetButton_pressed():
	player_bet()

func _on_PlayerPlaceButton_pressed():
	# Check if changing any cards
	if player_cards_to_replace.has(1):
		player_has_changed_cards = true
	else:
		player_has_changed_cards = false
	print ("player changed cards : ", player_has_changed_cards, " because : ",player_cards_to_replace)
	if player_has_bet == true:
		if player_has_changed_cards == true:
			change_player_cards()
		elif player_has_changed_cards == false:
			player_finish_bet()

func _on_Comp1DecisionTimer_timeout():
	comp1_actions()

func _on_Comp1ChangeTimer_timeout():
	comp1_change_and_bet()

func _on_Comp1GeneralDelayTimer_timeout():
	comp1_finish_bet()

