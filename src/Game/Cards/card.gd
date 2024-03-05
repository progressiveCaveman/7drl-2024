class_name Card
extends Resource

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
#var _card_defs: Dictionary

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
Move in straight line
+1 card
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
Move like knight
+1 action
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
