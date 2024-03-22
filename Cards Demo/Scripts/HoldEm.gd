extends Control
# Adapted from 5 card draw more script #
# major differences
# players get 2 cards instead of 5
# community cards used by all
# best possible 5 card hand from 7 possible cards

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
@onready var cards_back = preload("res://CardImages/CardsBack.png")
@onready var hearts_texture = preload("res://CardImages/BaseHeart.png")
@onready var diamonds_texture = preload("res://CardImages/BaseDiamond.png")
@onready var spades_texture = preload("res://CardImages/BaseSpade.png")
@onready var clubs_texture = preload("res://CardImages/BaseClub.png")

# Player cards nodes
@onready var player_card1_image = get_node("PlayerStuff/PlayerCard1")
@onready var player_card2_image = get_node("PlayerStuff/PlayerCard2")

@onready var player_card1_label = get_node("PlayerStuff/PlayerCard1/PlayerCard1Label")
@onready var player_card2_label = get_node("PlayerStuff/PlayerCard2/PlayerCard2Label")

# Computer 1 cards nodes
@onready var comp1_card1_image = get_node("Comp1Stuff/Comp1Card1")
@onready var comp1_card2_image = get_node("Comp1Stuff/Comp1Card2")

@onready var comp1_card1_label = get_node("Comp1Stuff/Comp1Card1/Comp1Card1Label")
@onready var comp1_card2_label = get_node("Comp1Stuff/Comp1Card2/Comp1Card2Label")

@onready var comp1_card1_change_indicator = get_node("Comp1Stuff/Comp1Card1/Comp1Card1ChangeIndicator")
@onready var comp1_card2_change_indicator = get_node("Comp1Stuff/Comp1Card2/Comp1Card2ChangeIndicator")

@onready var comp1_card1_image_hider = get_node("Comp1Stuff/Comp1Card1/Comp1Card1Hider")
@onready var comp1_card2_image_hider = get_node("Comp1Stuff/Comp1Card2/Comp1Card2Hider")

# Community card nodes
@onready var comm_card1_image = get_node("CommunityStuff/CommCard1")
@onready var comm_card2_image = get_node("CommunityStuff/CommCard2")
@onready var comm_card3_image = get_node("CommunityStuff/CommCard3")
@onready var comm_card4_image = get_node("CommunityStuff/CommCard4")
@onready var comm_card5_image = get_node("CommunityStuff/CommCard5")

@onready var comm_card1_label = get_node("CommunityStuff/CommCard1/CommCard1Label")
@onready var comm_card2_label = get_node("CommunityStuff/CommCard2/CommCard2Label")
@onready var comm_card3_label = get_node("CommunityStuff/CommCard3/CommCard3Label")
@onready var comm_card4_label = get_node("CommunityStuff/CommCard4/CommCard4Label")
@onready var comm_card5_label = get_node("CommunityStuff/CommCard5/CommCard5Label")

@onready var comm_card1_image_hider = get_node("CommunityStuff/CommCard1/CommCard1Hider")
@onready var comm_card2_image_hider = get_node("CommunityStuff/CommCard2/CommCard2Hider")
@onready var comm_card3_image_hider = get_node("CommunityStuff/CommCard3/CommCard3Hider")
@onready var comm_card4_image_hider = get_node("CommunityStuff/CommCard4/CommCard4Hider")
@onready var comm_card5_image_hider = get_node("CommunityStuff/CommCard5/CommCard5Hider")

# Burnt card nodes
@onready var burnt_card1_image = get_node("BurntCardsStuff/BurntCard1")
@onready var burnt_card2_image = get_node("BurntCardsStuff/BurntCard2")
@onready var burnt_card3_image = get_node("BurntCardsStuff/BurntCard3")
@onready var burnt_card4_image = get_node("BurntCardsStuff/BurntCard4")
@onready var burnt_card5_image = get_node("BurntCardsStuff/BurntCard5")

# Display nodes
@onready var hands_display_text = get_node("DisplayStuff/CardsRevealDisplay")
@onready var winner_display_text = get_node("DisplayStuff/WinnerRevealDisplay")
@onready var winning_hand_display_text = get_node("DisplayStuff/WinningHandRevealDisplay")
@onready var winner_bg_texture = get_node("DisplayStuff/DisplayWinnerBG")

@onready var bet_cost_text = get_node("DisplayStuff/BetCostDisplay")
@onready var new_card_cost_text = get_node("DisplayStuff/NewCardCostDisplay")
@onready var current_pot_text = get_node("DisplayStuff/CurrentPotDisplay")
@onready var turn_counter_text = get_node("DisplayStuff/TurnCounterDisplay")

@onready var player_money_display = get_node("PlayerStuff/PlayerMoneyLabel")
@onready var comp1_money_display = get_node("Comp1Stuff/Comp1MoneyLabel")

# Set up the menu button nodes
@onready var back_to_main_menu = get_node("ButtonsContainer/ReallyBackToMainBG")
@onready var new_game_menu = get_node("ButtonsContainer/ReallyNewGame")

# Set up the player action nodes
@onready var player_fold_button = get_node("ButtonsContainer/PlayerButtons/PlayerFoldButton")
@onready var player_bet_button = get_node("ButtonsContainer/PlayerButtons/PlayerBetButton")
@onready var player_place_button = get_node("ButtonsContainer/PlayerButtons/PlayerPlaceButton")

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
var hand_comm # community cards

var hand1_final5
var hand2_final5

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
@onready var comp1_decision_timer = get_node("Comp1Stuff/Comp1DecisionTimer")
@onready var comp1_bet_delay_timer = get_node("Comp1Stuff/Comp1GeneralDelayTimer")

func _ready():
	# Start a new game on load
	new_game()
#	print ("whole deck : ", whole_deck)

func _process(delta):
	#  Always check what to show on the GUI, and update buttons/text as needed
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
				player_fold_button.disabled = false
				player_bet_button.disabled = false
				player_place_button.disabled = true
			elif player_has_bet == true:
				# If player has enough money and has put in bet
				# disable change card and fold buttons, enable place button
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
				player_fold_button.disabled = true
				player_bet_button.disabled = false
				player_place_button.disabled = false
			elif player_has_bet == false:
				# If the player hasn't bet yet, disable buttons so they can't bet, only fold
				# as if player hasn't bet and has 0 money, they don't have enough to bet
				player_fold_button.disabled = false
				player_bet_button.disabled = true
				player_place_button.disabled = true
		
	elif whose_turn == 1:
		# Disable player buttons during computer turns
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
	# Display the player card values
	player_card1_label.text = str(values[vls[0]])
	player_card2_label.text = str(values[vls[1]])
	
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
	# Display the comp1 card values
	comp1_card1_label.text = str(values[vls2[0]])
	comp1_card2_label.text = str(values[vls2[1]])
	
	# Change the display of comm cards, ready for reveal if needed
	# Card 1
	if sts2_comm[0] == 0:
		comm_card1_image.texture = hearts_texture
	elif sts2_comm[0] == 1:
		comm_card1_image.texture = diamonds_texture
	elif sts2_comm[0] == 2:
		comm_card1_image.texture = clubs_texture
	elif sts2_comm[0] == 3:
		comm_card1_image.texture = spades_texture
	# Card 2
	if sts2_comm[1] == 0:
		comm_card2_image.texture = hearts_texture
	elif sts2_comm[1] == 1:
		comm_card2_image.texture = diamonds_texture
	elif sts2_comm[1] == 2:
		comm_card2_image.texture = clubs_texture
	elif sts2_comm[1] == 3:
		comm_card2_image.texture = spades_texture
	# Card 3
	if sts2_comm[2] == 0:
		comm_card3_image.texture = hearts_texture
	elif sts2_comm[2] == 1:
		comm_card3_image.texture = diamonds_texture
	elif sts2_comm[2] == 2:
		comm_card3_image.texture = clubs_texture
	elif sts2_comm[2] == 3:
		comm_card3_image.texture = spades_texture
	# Card 4
	if sts2_comm[3] == 0:
		comm_card4_image.texture = hearts_texture
	elif sts2_comm[3] == 1:
		comm_card4_image.texture = diamonds_texture
	elif sts2_comm[3] == 2:
		comm_card4_image.texture = clubs_texture
	elif sts2_comm[3] == 3:
		comm_card4_image.texture = spades_texture
	# Card 5
	if sts2_comm[4] == 0:
		comm_card5_image.texture = hearts_texture
	elif sts2_comm[4] == 1:
		comm_card5_image.texture = diamonds_texture
	elif sts2_comm[4] == 2:
		comm_card5_image.texture = clubs_texture
	elif sts2_comm[4] == 3:
		comm_card5_image.texture = spades_texture
	# Display the comm card values
	comm_card1_label.text = str(values[vls2_comm[0]])
	comm_card2_label.text = str(values[vls2_comm[1]])
	comm_card3_label.text = str(values[vls2_comm[2]])
	comm_card4_label.text = str(values[vls2_comm[3]])
	comm_card5_label.text = str(values[vls2_comm[4]])
	
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
	
	# Adapt for multiple rounds with different cards?
	check_comp1_possible_hands_()
	var result2_check #comp1
	var high_card2_check = [0,0,0,0,0] #comp1
	var result2_returned_check = [0,0,0,0] # comp1
	result2_returned_check = rank_the_(hand2_final5) # comp1
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
				comp1_bet()
			elif comp1_money < bet_amount:
				comp1_folds()
		# as rounds go on, more likely to fold, if doesn't get better cards?
		elif round_number >= 2:
			if comp1_money >= bet_amount:
				comp1_round_decision = randi()%10+1
				print ("comp round decision was : ",comp1_round_decision)
				if comp1_round_decision <= 3:
					comp1_folds()
				elif comp1_round_decision >= 4:
					comp1_bet()
			elif comp1_money < bet_amount:
				comp1_folds()
	# if have a pair, 2 pair, or 3 of a kind, may change cards, or keep betting
	# to change cards, need to figure out which cards are part of pair etc
	elif result2_returned_check[0] == "One Pair" or "Two Pairs" or "Three of a Kind":
		# Always bet for the first round, may change cards
		if round_number == 1:
			if comp1_money >= bet_amount:
				comp1_bet()
			elif comp1_money < bet_amount:
				comp1_folds()
		elif round_number >= 2:
			if comp1_money >= bet_amount:
				comp1_round_decision = randi()%10+1
				print ("comp round decision was : ",comp1_round_decision)
				if comp1_round_decision <= 2:
					comp1_folds()
				elif comp1_round_decision >= 3:
					comp1_bet()
			elif comp1_money < bet_amount:
				comp1_folds()
	# if have straight or higher, more likely to keep cards, depending on round number
	# eg if have fluch, get to round 4, may still choose fold as player is also still going?
	elif result2_returned_check[0] == "Straight" or "Flush" or "Full House":
		if round_number == 1:
			if comp1_money >= bet_amount:
				comp1_bet()
			elif comp1_money < bet_amount:
				comp1_folds()
		elif round_number >= 2:
			if comp1_money >= bet_amount:
				comp1_round_decision = randi()%10+1
				print ("comp round decision was : ",comp1_round_decision)
				if comp1_round_decision <= 1:
					comp1_folds()
				elif comp1_round_decision >= 2:
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
	# Give pot to player
	player_money += current_pot
	# End the game, displaying winner and why
	hands_display_text.text = ("Computer 1 has folded")
	winner_display_text.text = ("Player Wins")
	winning_hand_display_text.text = ("")

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
	
	# Show the comm cards as in hold'em
	# round number next up, as added to above
	if round_number == 2:
		comm_card1_image_hider.hide()
		comm_card2_image_hider.hide()
		comm_card3_image_hider.hide()
	if round_number == 3:
		comm_card4_image_hider.hide()
	if round_number == 4:
		comm_card5_image_hider.hide()

func end_of_game():
	# Compare the hands to end the game
	check_results()

# CREATE PLAYER CARD ARRAYS #
# could move to top

var vls = [0,0]
var sts = [0,0]
var hand = [0,0]

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
	for i in range(2):
		# range is 2, as thats the number of cards per hand
		# pick a random value from the size of the game deck for 2 cards
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
		game_deck.remove_at(card_to_remove_from_deck)
		hand[i] = bi
	hand1 = hand
	# Could have done the last bit of for loop as "hand1[i] = bi" instead of using hand as a go between
	print ("hand1 : ", hand1)
	print ("Game Deck After Dealing player hand : ", game_deck)

# CREATE CARD ARRAYS FOR COMP1 #
# could move to top

var vls2 = [0,0]
var sts2 = [0,0]
var hand22 = [0,0]

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
	for i in range(2):
		# range is 2, as thats the number of cards per hand
		# pick a random value from the size of the game deck for 2 cards
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
		game_deck.remove_at(card_to_remove_from_deck2)
		hand22[i] = bi2
	hand2 = hand22
	# Put comp1 cards "face down" for now, by hiding them behind other textures
	comp1_card1_image_hider.show()
	comp1_card2_image_hider.show()
	print ("comp hand : ",hand2)
	print ("Game Deck After comp hand : ", game_deck)

# Set up community card vars
var vls2_comm = [0,0,0,0,0]
var sts2_comm = [0,0,0,0,0]
var hand22_comm = [0,0,0,0,0]

# Make the initial computer1 hand
func make_community_cards():
	# Make hand by getting cards from the game deck
	# Then split to get the values and suits
	randomize()
	print ("Game Deck after dealing comm cards : ", game_deck)
	var bi2_comm
	var card_from_deck_split2_comm
	var gdi2_comm
	var gdi22_comm
	for i in range(5):
		# range is 5, as thats the number of cards in the centre
		# pick a random value from the size of the game deck for 5 cards
		# (not 52, as card deck may be smaller if player has already been dealt)
		gdi22_comm = randi()%game_deck.size()
		gdi2_comm = game_deck[gdi22_comm]
		# Split the card selected to get the value and suit data
		card_from_deck_split2_comm = gdi2_comm.split(",",true,1)
		# Get the value
		vls2_comm[i] = values.find(card_from_deck_split2_comm[0])
		# Get the suit
		sts2_comm[i] = suites2.find(card_from_deck_split2_comm[1])
		# Stitch back together for full card using the values and suites arrays
		bi2_comm = values[vls2_comm[i]]+","+suites2[sts2_comm[i]]
		print ("bi2_comm was : ", bi2_comm)
		var card_to_remove_from_deck2_comm = game_deck.find(bi2_comm)
		game_deck.remove_at(card_to_remove_from_deck2_comm)
		hand22_comm[i] = bi2_comm
	hand_comm = hand22_comm
	# Put comm cards "face down" for now, by hiding them behind other textures
	comm_card1_image_hider.show()
	comm_card2_image_hider.show()
	comm_card3_image_hider.show()
	comm_card4_image_hider.show()
	comm_card5_image_hider.show()
	print ("comm cards : ",hand_comm)
	print ("Game Deck After comm cards : ", game_deck)

# Work out the rank of the hands sent to this function
# set up to use 7 cards instead of just 5
# put in 5 at a time different combos for each possible
# differ for comp as well, as needs to know

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
			return [ranks[2], sorted_vals, reps_array.find(2), reps_array.rfind(2)]
		if reps_array.count(2)==1:
			# One pair
			#print ("one pair : ", ranks[1])
			return [ranks[1], sorted_vals, reps_array.find(2), 0]
	# High Card
	return [ranks[0], sorted_vals, 0, 0]

func check_player_possible_hands_():
	# Possible combinations for cards
	# All community cards
	var possible_hand1 = [hand_comm[0], hand_comm[1], hand_comm[2], hand_comm[3], hand_comm[4]]
	
	# One player hole card (card 1)
	var possible_hand2 = [hand1[0], hand_comm[0], hand_comm[1], hand_comm[2], hand_comm[3]]
	var possible_hand3 = [hand1[0], hand_comm[0], hand_comm[1], hand_comm[2], hand_comm[4]]
	var possible_hand4 = [hand1[0], hand_comm[0], hand_comm[1], hand_comm[3], hand_comm[4]]
	var possible_hand5 = [hand1[0], hand_comm[0], hand_comm[2], hand_comm[3], hand_comm[4]]
	var possible_hand6 = [hand1[0], hand_comm[1], hand_comm[2], hand_comm[3], hand_comm[4]]
	
	# One player hole card (card 2)
	var possible_hand7 = [hand1[1], hand_comm[0], hand_comm[1], hand_comm[2], hand_comm[3]]
	var possible_hand8 = [hand1[1], hand_comm[0], hand_comm[1], hand_comm[2], hand_comm[4]]
	var possible_hand9 = [hand1[1], hand_comm[0], hand_comm[1], hand_comm[3], hand_comm[4]]
	var possible_hand10 = [hand1[1], hand_comm[0], hand_comm[2], hand_comm[3], hand_comm[4]]
	var possible_hand11 = [hand1[1], hand_comm[1], hand_comm[2], hand_comm[3], hand_comm[4]]
	
	# Both player hole cards
	var possible_hand12 = [hand1[0], hand1[1], hand_comm[0], hand_comm[1], hand_comm[2]]
	var possible_hand13 = [hand1[0], hand1[1], hand_comm[0], hand_comm[1], hand_comm[3]]
	var possible_hand14 = [hand1[0], hand1[1], hand_comm[0], hand_comm[2], hand_comm[3]]
	var possible_hand15 = [hand1[0], hand1[1], hand_comm[1], hand_comm[2], hand_comm[3]]
	
	var possible_hand16 = [hand1[0], hand1[1], hand_comm[0], hand_comm[1], hand_comm[4]]
	var possible_hand17 = [hand1[0], hand1[1], hand_comm[0], hand_comm[2], hand_comm[4]]
	var possible_hand18 = [hand1[0], hand1[1], hand_comm[1], hand_comm[2], hand_comm[4]]
	
	var possible_hand19 = [hand1[0], hand1[1], hand_comm[0], hand_comm[3], hand_comm[4]]
	var possible_hand20 = [hand1[0], hand1[1], hand_comm[1], hand_comm[3], hand_comm[4]]
	
	var possible_hand21 = [hand1[0], hand1[1], hand_comm[2], hand_comm[3], hand_comm[4]]
	
	# put them all together for later
	var possible_hands_to_choose =[possible_hand1,possible_hand2,possible_hand3,possible_hand4,possible_hand5,possible_hand6,possible_hand7,possible_hand8,possible_hand9,possible_hand10,possible_hand11,possible_hand12,possible_hand13,possible_hand14,possible_hand15,possible_hand16,possible_hand17,possible_hand18,possible_hand19,possible_hand20,possible_hand21]
	
	
	var possible_result1
	var possible_result2
	var possible_result3
	var possible_result4
	var possible_result5
	var possible_result6
	var possible_result7
	var possible_result8
	var possible_result9
	var possible_result10
	var possible_result11
	var possible_result12
	var possible_result13
	var possible_result14
	var possible_result15
	var possible_result16
	var possible_result17
	var possible_result18
	var possible_result19
	var possible_result20
	var possible_result21
	
	var possible_result1_returned = [0,0,0,0]
	var possible_result2_returned = [0,0,0,0]
	var possible_result3_returned = [0,0,0,0]
	var possible_result4_returned = [0,0,0,0]
	var possible_result5_returned = [0,0,0,0]
	var possible_result6_returned = [0,0,0,0]
	var possible_result7_returned = [0,0,0,0]
	var possible_result8_returned = [0,0,0,0]
	var possible_result9_returned = [0,0,0,0]
	var possible_result10_returned = [0,0,0,0]
	var possible_result11_returned = [0,0,0,0]
	var possible_result12_returned = [0,0,0,0]
	var possible_result13_returned = [0,0,0,0]
	var possible_result14_returned = [0,0,0,0]
	var possible_result15_returned = [0,0,0,0]
	var possible_result16_returned = [0,0,0,0]
	var possible_result17_returned = [0,0,0,0]
	var possible_result18_returned = [0,0,0,0]
	var possible_result19_returned = [0,0,0,0]
	var possible_result20_returned = [0,0,0,0]
	var possible_result21_returned = [0,0,0,0]
	
	possible_result1_returned = rank_the_(possible_hand1)
	possible_result2_returned = rank_the_(possible_hand2)
	possible_result3_returned = rank_the_(possible_hand3)
	possible_result4_returned = rank_the_(possible_hand4)
	possible_result5_returned = rank_the_(possible_hand5)
	possible_result6_returned = rank_the_(possible_hand6)
	possible_result7_returned = rank_the_(possible_hand7)
	possible_result8_returned = rank_the_(possible_hand8)
	possible_result9_returned = rank_the_(possible_hand9)
	possible_result10_returned = rank_the_(possible_hand10)
	possible_result11_returned = rank_the_(possible_hand11)
	possible_result12_returned = rank_the_(possible_hand12)
	possible_result13_returned = rank_the_(possible_hand13)
	possible_result14_returned = rank_the_(possible_hand14)
	possible_result15_returned = rank_the_(possible_hand15)
	possible_result16_returned = rank_the_(possible_hand16)
	possible_result17_returned = rank_the_(possible_hand17)
	possible_result18_returned = rank_the_(possible_hand18)
	possible_result19_returned = rank_the_(possible_hand19)
	possible_result20_returned = rank_the_(possible_hand20)
	possible_result21_returned = rank_the_(possible_hand21)
	
	possible_result1 = possible_result1_returned[0]
	possible_result2 = possible_result2_returned[0]
	possible_result3 = possible_result3_returned[0]
	possible_result4 = possible_result4_returned[0]
	possible_result5 = possible_result5_returned[0]
	possible_result6 = possible_result6_returned[0]
	possible_result7 = possible_result7_returned[0]
	possible_result8 = possible_result8_returned[0]
	possible_result9 = possible_result9_returned[0]
	possible_result10 = possible_result10_returned[0]
	possible_result11 = possible_result11_returned[0]
	possible_result12 = possible_result12_returned[0]
	possible_result13 = possible_result13_returned[0]
	possible_result14 = possible_result14_returned[0]
	possible_result15 = possible_result15_returned[0]
	possible_result16 = possible_result16_returned[0]
	possible_result17 = possible_result17_returned[0]
	possible_result18 = possible_result18_returned[0]
	possible_result19 = possible_result19_returned[0]
	possible_result20 = possible_result20_returned[0]
	possible_result21 = possible_result21_returned[0]
	
	# put the ranks returned in an array for searching
	var possibilities_array = ["h","h","h","h","h","h","h","h","h","h","h","h","h","h","h","h","h","h","h","h","h"]
	possibilities_array = [possible_result1,possible_result2,possible_result3,possible_result4,possible_result5,possible_result6,possible_result7,possible_result8,possible_result9,possible_result10,possible_result11,possible_result12,possible_result13,possible_result14,possible_result15,possible_result16,possible_result17,possible_result18,possible_result19,possible_result20,possible_result21]
	
	var hand_to_choose_rank
	var hand_to_choose = ["h","h","h","h","h"]
	
	#Which way would be easier/better, counts, or if checks??
	
	# Check through each rank and see if it's present in any possible hands
	# if it is, assign it to be chosen
	# what if multiples? eg high cards, three pairs, two three of a kinds, full house, straights
	if possibilities_array.find("Royal Flush") != -1:
		hand_to_choose_rank = possibilities_array.find("Royal Flush")
	elif possibilities_array.find("Straight Flush") != -1:
		hand_to_choose_rank = possibilities_array.find("Straight Flush")
	elif possibilities_array.find("Four of a Kind") != -1:
		hand_to_choose_rank = possibilities_array.find("Four of a Kind")
	elif possibilities_array.find("Full House") != -1:
		hand_to_choose_rank = possibilities_array.find("Full House")
	elif possibilities_array.find("Flush") != -1:
		hand_to_choose_rank = possibilities_array.find("Flush")
	elif possibilities_array.find("Straight") != -1:
		hand_to_choose_rank = possibilities_array.find("Straight")
	elif possibilities_array.find("Three of a Kind") != -1:
		hand_to_choose_rank = possibilities_array.find("Three of a Kind")
	elif possibilities_array.find("Two Pairs") != -1:
		hand_to_choose_rank = possibilities_array.find("Two Pairs")
	elif possibilities_array.find("One Pair") != -1:
		hand_to_choose_rank = possibilities_array.find("One Pair")
	elif possibilities_array.find("High Card") != -1:
		hand_to_choose_rank = possibilities_array.find("High Card")
	else:
		print ("Something went wrong.")
	
	hand1_final5 = possible_hands_to_choose[hand_to_choose_rank]

func check_comp1_possible_hands_():
	# Possible combinations for cards
	# All community cards
	var possible_hand1 = [hand_comm[0], hand_comm[1], hand_comm[2], hand_comm[3], hand_comm[4]]
	
	# One player hole card (card 1)
	var possible_hand2 = [hand2[0], hand_comm[0], hand_comm[1], hand_comm[2], hand_comm[3]]
	var possible_hand3 = [hand2[0], hand_comm[0], hand_comm[1], hand_comm[2], hand_comm[4]]
	var possible_hand4 = [hand2[0], hand_comm[0], hand_comm[1], hand_comm[3], hand_comm[4]]
	var possible_hand5 = [hand2[0], hand_comm[0], hand_comm[2], hand_comm[3], hand_comm[4]]
	var possible_hand6 = [hand2[0], hand_comm[1], hand_comm[2], hand_comm[3], hand_comm[4]]
	
	# One player hole card (card 2)
	var possible_hand7 = [hand2[1], hand_comm[0], hand_comm[1], hand_comm[2], hand_comm[3]]
	var possible_hand8 = [hand2[1], hand_comm[0], hand_comm[1], hand_comm[2], hand_comm[4]]
	var possible_hand9 = [hand2[1], hand_comm[0], hand_comm[1], hand_comm[3], hand_comm[4]]
	var possible_hand10 = [hand2[1], hand_comm[0], hand_comm[2], hand_comm[3], hand_comm[4]]
	var possible_hand11 = [hand2[1], hand_comm[1], hand_comm[2], hand_comm[3], hand_comm[4]]
	
	# Both player hole cards
	var possible_hand12 = [hand2[0], hand2[1], hand_comm[0], hand_comm[1], hand_comm[2]]
	var possible_hand13 = [hand2[0], hand2[1], hand_comm[0], hand_comm[1], hand_comm[3]]
	var possible_hand14 = [hand2[0], hand2[1], hand_comm[0], hand_comm[2], hand_comm[3]]
	var possible_hand15 = [hand2[0], hand2[1], hand_comm[1], hand_comm[2], hand_comm[3]]
	
	var possible_hand16 = [hand2[0], hand2[1], hand_comm[0], hand_comm[1], hand_comm[4]]
	var possible_hand17 = [hand2[0], hand2[1], hand_comm[0], hand_comm[2], hand_comm[4]]
	var possible_hand18 = [hand2[0], hand2[1], hand_comm[1], hand_comm[2], hand_comm[4]]
	
	var possible_hand19 = [hand2[0], hand2[1], hand_comm[0], hand_comm[3], hand_comm[4]]
	var possible_hand20 = [hand2[0], hand2[1], hand_comm[1], hand_comm[3], hand_comm[4]]
	
	var possible_hand21 = [hand2[0], hand2[1], hand_comm[2], hand_comm[3], hand_comm[4]]
	
	# put them all together for later
	var possible_hands_to_choose =[possible_hand1,possible_hand2,possible_hand3,possible_hand4,possible_hand5,possible_hand6,possible_hand7,possible_hand8,possible_hand9,possible_hand10,possible_hand11,possible_hand12,possible_hand13,possible_hand14,possible_hand15,possible_hand16,possible_hand17,possible_hand18,possible_hand19,possible_hand20,possible_hand21]
	
	
	var possible_result1
	var possible_result2
	var possible_result3
	var possible_result4
	var possible_result5
	var possible_result6
	var possible_result7
	var possible_result8
	var possible_result9
	var possible_result10
	var possible_result11
	var possible_result12
	var possible_result13
	var possible_result14
	var possible_result15
	var possible_result16
	var possible_result17
	var possible_result18
	var possible_result19
	var possible_result20
	var possible_result21
	
	var possible_result1_returned = [0,0,0,0]
	var possible_result2_returned = [0,0,0,0]
	var possible_result3_returned = [0,0,0,0]
	var possible_result4_returned = [0,0,0,0]
	var possible_result5_returned = [0,0,0,0]
	var possible_result6_returned = [0,0,0,0]
	var possible_result7_returned = [0,0,0,0]
	var possible_result8_returned = [0,0,0,0]
	var possible_result9_returned = [0,0,0,0]
	var possible_result10_returned = [0,0,0,0]
	var possible_result11_returned = [0,0,0,0]
	var possible_result12_returned = [0,0,0,0]
	var possible_result13_returned = [0,0,0,0]
	var possible_result14_returned = [0,0,0,0]
	var possible_result15_returned = [0,0,0,0]
	var possible_result16_returned = [0,0,0,0]
	var possible_result17_returned = [0,0,0,0]
	var possible_result18_returned = [0,0,0,0]
	var possible_result19_returned = [0,0,0,0]
	var possible_result20_returned = [0,0,0,0]
	var possible_result21_returned = [0,0,0,0]
	
	possible_result1_returned = rank_the_(possible_hand1)
	possible_result2_returned = rank_the_(possible_hand2)
	possible_result3_returned = rank_the_(possible_hand3)
	possible_result4_returned = rank_the_(possible_hand4)
	possible_result5_returned = rank_the_(possible_hand5)
	possible_result6_returned = rank_the_(possible_hand6)
	possible_result7_returned = rank_the_(possible_hand7)
	possible_result8_returned = rank_the_(possible_hand8)
	possible_result9_returned = rank_the_(possible_hand9)
	possible_result10_returned = rank_the_(possible_hand10)
	possible_result11_returned = rank_the_(possible_hand11)
	possible_result12_returned = rank_the_(possible_hand12)
	possible_result13_returned = rank_the_(possible_hand13)
	possible_result14_returned = rank_the_(possible_hand14)
	possible_result15_returned = rank_the_(possible_hand15)
	possible_result16_returned = rank_the_(possible_hand16)
	possible_result17_returned = rank_the_(possible_hand17)
	possible_result18_returned = rank_the_(possible_hand18)
	possible_result19_returned = rank_the_(possible_hand19)
	possible_result20_returned = rank_the_(possible_hand20)
	possible_result21_returned = rank_the_(possible_hand21)
	
	possible_result1 = possible_result1_returned[0]
	possible_result2 = possible_result2_returned[0]
	possible_result3 = possible_result3_returned[0]
	possible_result4 = possible_result4_returned[0]
	possible_result5 = possible_result5_returned[0]
	possible_result6 = possible_result6_returned[0]
	possible_result7 = possible_result7_returned[0]
	possible_result8 = possible_result8_returned[0]
	possible_result9 = possible_result9_returned[0]
	possible_result10 = possible_result10_returned[0]
	possible_result11 = possible_result11_returned[0]
	possible_result12 = possible_result12_returned[0]
	possible_result13 = possible_result13_returned[0]
	possible_result14 = possible_result14_returned[0]
	possible_result15 = possible_result15_returned[0]
	possible_result16 = possible_result16_returned[0]
	possible_result17 = possible_result17_returned[0]
	possible_result18 = possible_result18_returned[0]
	possible_result19 = possible_result19_returned[0]
	possible_result20 = possible_result20_returned[0]
	possible_result21 = possible_result21_returned[0]
	
	# put the ranks returned in an array for searching
	var possibilities_array = ["h","h","h","h","h","h","h","h","h","h","h","h","h","h","h","h","h","h","h","h","h"]
	possibilities_array = [possible_result1,possible_result2,possible_result3,possible_result4,possible_result5,possible_result6,possible_result7,possible_result8,possible_result9,possible_result10,possible_result11,possible_result12,possible_result13,possible_result14,possible_result15,possible_result16,possible_result17,possible_result18,possible_result19,possible_result20,possible_result21]
	
	var hand_to_choose_rank
	var hand_to_choose = ["h","h","h","h","h"]
	
	# Check through each rank and see if it's present in any possible hands
	# if it is, assign it to be chosen
	# what if multiples? eg high card, three pairs, two three of a kinds, full house, straights
	if possibilities_array.find("Royal Flush") != -1:
		hand_to_choose_rank = possibilities_array.find("Royal Flush")
	elif possibilities_array.find("Straight Flush") != -1:
		hand_to_choose_rank = possibilities_array.find("Straight Flush")
	elif possibilities_array.find("Four of a Kind") != -1:
		hand_to_choose_rank = possibilities_array.find("Four of a Kind")
	elif possibilities_array.find("Full House") != -1:
		hand_to_choose_rank = possibilities_array.find("Full House")
	elif possibilities_array.find("Flush") != -1:
		hand_to_choose_rank = possibilities_array.find("Flush")
	elif possibilities_array.find("Straight") != -1:
		hand_to_choose_rank = possibilities_array.find("Straight")
	elif possibilities_array.find("Three of a Kind") != -1:
		hand_to_choose_rank = possibilities_array.find("Three of a Kind")
	elif possibilities_array.find("Two Pairs") != -1:
		hand_to_choose_rank = possibilities_array.find("Two Pairs")
	elif possibilities_array.find("One Pair") != -1:
		hand_to_choose_rank = possibilities_array.find("One Pair")
	elif possibilities_array.find("High Card") != -1:
		hand_to_choose_rank = possibilities_array.find("High Card")
	else:
		print ("Something went wrong.")
	
	hand2_final5 = possible_hands_to_choose[hand_to_choose_rank]
	

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
	
	# Find the best hands they have
	check_player_possible_hands_()
	check_comp1_possible_hands_()
	
	# Adapt for multiple possibilities from player and comp ?
	result1_returned  = rank_the_(hand1_final5) # player
	result2_returned = rank_the_(hand2_final5) # comp1
	
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
	winner_bg_texture.show()
	# Show comp1 hand
	comp1_card1_image_hider.hide()
	comp1_card2_image_hider.hide()
	
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
	current_pot = 0
	
	# Hide the elements not needed yet
	
	# Set up the main text elements
	hands_display_text.text = ("")
	winner_display_text.text = ("")
	winning_hand_display_text.text = ("")
	winner_bg_texture.hide()
	
	bet_cost_text.text = ("Bet Cost : " + str(bet_amount))
	new_card_cost_text.text = ("New Card Cost : " + str(new_card_amount))
	current_pot_text.text = ("Current Pot : " + str(current_pot))
	turn_counter_text.text = ("Current Round : " + str(round_number))
	
	# Make the hands
	make_player_hand()
	make_comp1_hand()
	
	# Make the community cards
	make_community_cards()
	# Hide the community cards until needed
	comm_card1_image_hider.show()
	comm_card2_image_hider.show()
	comm_card3_image_hider.show()
	comm_card4_image_hider.show()
	comm_card5_image_hider.show()
	
	# Test hands

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

func _on_PlayerFoldButton_pressed():
	player_folds()

func _on_PlayerBetButton_pressed():
	player_bet()

func _on_PlayerPlaceButton_pressed():
	if player_has_bet == true:
		player_finish_bet()

func _on_Comp1DecisionTimer_timeout():
	comp1_actions()

func _on_Comp1GeneralDelayTimer_timeout():
	comp1_finish_bet()

