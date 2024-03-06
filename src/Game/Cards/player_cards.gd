extends Node

const starting_deck = [
	Card.CardType.Pawn, Card.CardType.Pawn, 
	Card.CardType.Knight, Card.CardType.Knight, 
	Card.CardType.Rook, Card.CardType.Rook, 
	Card.CardType.Damage1, Card.CardType.Damage1, Card.CardType.Damage1, Card.CardType.Damage1]

signal hand_updated()

@export var library: Array[Card] = []
@export var discard: Array[Card] = []
@export var hand: Array[Card] = []
@export var damage_mod = 0 # amt of damage played, this shouldn't live here but it's convenient for now

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
		var card = hand[i]
		if card.type == cardtype:
			discard.append(card)
			hand.remove_at(i)
			print_state()
			emit_signal("hand_updated")
			return true
	
	return false

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
