class_name Cards
extends Object

enum CardType {
	Error,
	Pawn,
	Rook,
	Damage1,
	Knight,
	Queen,
	King,
	Damage2,
}

@export var library: Array[Card] = []
@export var discard: Array[Card] = []
@export var hand: Array[Card] = []

#var _card_defs: Dictionary

class Card extends Resource:
	@export var type: CardType
	@export var name: String
	@export var description: String
	
	func _init(card: CardType) -> void:		
		match card:
			CardType.Error:
				type = card
				name = "Error card should never be displayed"
				description = """"""
			CardType.Pawn:
				type = card
				name = "Pawn"
				description = """
Move to an adjacent square
"""
			CardType.Rook:
				type = card
				name = "Rook"
				description = """
Move any number of spaces in cardinal directions
+1 action
"""
			CardType.Damage1:
				type = card
				name = "+1 Damage"
				description = """
Add 1 damage to next attack
"""
			CardType.Knight:
				type = card
				name = "Knight"
				description = """
Move 2 spaces in one direction then 1 in another
"""
			CardType.Queen:
				type = card
				name = "Queen"
				description = """
Move any number of spaces in any direction
+1 card
+1 action
"""
			CardType.King:
				type = card
				name = "King"
				description = """
Move to an adjacent square
+3 cards
+1 action
"""
			CardType.Damage2:
				type = card
				name = "+2 Damage"
				description = """
Add 2 damage to next attack
"""

func draw_card(): 
	if library.size() == 0:
		shuffle_discard()
	
	if library.size() > 0:
		hand.append(library.pop_front())

func discard_card(card: CardType) -> void: 
	discard.append(card)

func shuffle_discard() -> void:
	#print(_card_defs.data)
	library.append_array(discard)
	discard.clear()
	library.shuffle()

func gain_card(cardtype: CardType) -> void:
	discard.append(Card.new(cardtype))
