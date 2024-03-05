extends Node

const starting_deck = [Card.CardType.Pawn, Card.CardType.Pawn, Card.CardType.Pawn, Card.CardType.Pawn, Card.CardType.Rook, 
	Card.CardType.Rook, Card.CardType.Damage1, Card.CardType.Damage1, Card.CardType.Damage1, Card.CardType.Damage1]

signal hand_updated()

@export var library: Array[Card] = []
@export var discard: Array[Card] = []
@export var hand: Array[Card] = []

func _init() -> void:
	#player_cards = Cards.new()
	for c in starting_deck:
		self.gain_card(c)
	self.shuffle_discard()
	print("Player hand:")
	for i in range(0,5):
		self.draw_card()
		print(self.hand[i].name)

func draw_card(): 
	if library.size() == 0:
		shuffle_discard()
	
	if library.size() > 0:
		hand.append(library.pop_front())
		emit_signal("hand_updated", hand)

func discard_card(card: Card.CardType) -> void: 
	discard.append(card)

func shuffle_discard() -> void:
	#print(_card_defs.data)
	library.append_array(discard)
	discard.clear()
	library.shuffle()

func gain_card(cardtype: Card.CardType) -> void:
	discard.append(Card.new(cardtype))
