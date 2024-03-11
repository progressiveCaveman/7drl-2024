extends Node

const starting_deck = [
	Card.CardType.Pawn, Card.CardType.Pawn, 
	Card.CardType.Knight, Card.CardType.Knight, 
	Card.CardType.Rook, Card.CardType.Rook, 
	Card.CardType.Damage1, Card.CardType.Damage1, Card.CardType.Damage1, Card.CardType.Damage1
]

signal hand_updated()
signal store_updated()
signal actions_changed(actions)
signal damage_changed(damage)

@export var available_to_buy: Array[Card] = [
	Card.new(Card.CardType.Damage1), Card.new(Card.CardType.Pawn), Card.new(Card.CardType.Knight), Card.new(Card.CardType.Rook), 
	Card.new(Card.CardType.Bishop), Card.new(Card.CardType.Queen), Card.new(Card.CardType.King), Card.new(Card.CardType.Damage2), 
]
@export var library: Array[Card] = []
@export var discard: Array[Card] = []
@export var hand: Array[Card] = []
@export var damage_mod = 0: # amt of damage played, this shouldn't live here but it's convenient for now
	set(value):
		damage_mod = value
		emit_signal('damage_changed', value)
@export var actions = 1:  # num actions remaining until enemies act
	set(value):
		actions = value
		emit_signal('actions_changed', value)

func _init() -> void:
	for c in starting_deck:
		self.gain_card(c)
	self.shuffle_discard()
	for i in range(0,5):
		self.draw_card()

func draw_card(): 
	if library.size() == 0:
		shuffle_discard()
	
	if library.size() > 0:
		hand.append(library.pop_front())
		emit_signal("hand_updated")

func draw_to_five():
	while hand.size() < 5 && (library.size() > 0 || discard.size() > 0):
		draw_card()

func discard_card(card: Card.CardType) -> void: 
	discard.append(card)

func shuffle_discard() -> void:
	library.append_array(discard)
	discard.clear()
	library.shuffle()

func gain_card(cardtype: Card.CardType) -> void:
	discard.append(Card.new(cardtype))

func play_card(cardtype) -> bool:
	for i in range(0, hand.size()):
		if hand[i].type == cardtype:
			var card = hand[i]
			discard.append(card)
			hand.remove_at(i)
			#print_state()
			emit_signal("hand_updated")
			return true
			
	return false

func add_to_store(card: Card):
	available_to_buy.append(card)
	emit_signal('store_updated')

func print_state():
	print("Library:")
	for card in library:
		print("  %s" % card.name)
	print("Hand:")
	for card in hand:
		print("  %s" % card.name)
	print("Discard:")
	for card in discard:
		print("  %s" % card.name)

func title_to_type(title) -> Card.CardType:
	if title == "Pawn":
		return Card.CardType.Pawn
	if title == "Bishop":
		return Card.CardType.Bishop
	if title == "Rook":
		return Card.CardType.Rook
	if title == "Knight":
		return Card.CardType.Knight
	if title == "Queen":
		return Card.CardType.Queen
	if title == "King":
		return Card.CardType.King
	if title == "+1 Damage":
		return Card.CardType.Damage1
	if title == "+2 Damage":
		return Card.CardType.Damage2
		
	print("failed to find card")
	return Card.CardType.Error
	
	#
	#"Pawn" : [Vector2( 1, 1), false],
	#"Bishop" : [Vector2( 1, 1), true],
	#"Rook" : [Vector2( 1, 0), true],
	#"Knight" : [Vector2( 2, 1), false],
	#"Queen" : [Vector2( 1, 1), true, Vector2(1, 0)],
	#"King" : [Vector2( 1, 1), false, Vector2(1, 0)],
	#"Error" : [Vector2( 0, 0), false],
