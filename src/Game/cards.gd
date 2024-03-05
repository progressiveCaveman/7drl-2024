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

@export var library: Array[CardType] = []
@export var discard: Array[CardType] = []
@export var hand: Array[CardType] = []

class Card:
	@export var name: String
	
	func _init(card: CardType) -> void:
		match card:
			CardType.Error:
				name = "Error card should never be displayed"
			CardType.Pawn:
				name = "Pawn"
			CardType.Rook:
				name = "Rook"
			CardType.Damage1:
				name = "+1 Damage"
			CardType.Knight:
				name = "Knight"
			CardType.Queen:
				name = "Queen"
			CardType.King:
				name = "King"
			CardType.Damage2:
				name = "+2 Damage"
			

func draw_card(): 
	if library.size() == 0:
		shuffle_discard()
	
	if library.size() > 0:
		hand.append(library.pop_front())

func discard_card(card: CardType) -> void: 
	discard.append(card)

func shuffle_discard() -> void:
	library.append_array(discard)
	discard.clear()
	library.shuffle()
