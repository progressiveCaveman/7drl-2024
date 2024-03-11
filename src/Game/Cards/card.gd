class_name Card
extends Resource

enum CardType {
	Error,
	#starting cards
	Pawn,
	Rook,
	Damage1,
	Knight,
	# always available
	Queen,
	King,
	Damage2,
	Bishop,
	# limited selection cards
	Trasher,
	Village,
	Laboratory,
	MagicMissile, # +2 damage range 5
	Fireball, # +3 damage radius 2 range 5
	Cleave, # +1 damage all adjacent # keep cleave as last card or stuff will break
}

const all_types = [
	#starting cards
	CardType.Pawn,
	CardType.Rook,
	CardType.Damage1,
	CardType.Knight,
	# always available
	CardType.Queen,
	CardType.King,
	CardType.Damage2,
	CardType.Bishop,
	# limited selection cards
	CardType.Trasher,
	CardType.Village,
	CardType.Laboratory,
	CardType.MagicMissile, # +2 damage range 5
	CardType.Fireball, # +3 damage radius 2 range 5
	CardType.Cleave, # +1 damage all adjacent # keep cleave as last card or stuff will break
]

@export var type: CardType
@export var name: String
@export var description: String
@export var cost: int

func _init(card: CardType) -> void:		
	match card:
		CardType.Error:
			type = card
			name = "Error card should never be displayed"
			description = """"""
			cost = 0
		CardType.Pawn:
			type = card
			name = "Pawn"
			description = """
Move to an orthogonal square
"""
			cost = 0
		CardType.Rook:
			type = card
			name = "Rook"
			description = """
Move in straight line
+1 card
"""
			cost = 2
		CardType.Damage1:
			type = card
			name = "+1 Damage"
			description = """
Add 1 damage to next attack
"""
			cost = 2
		CardType.Knight:
			type = card
			name = "Knight"
			description = """
Move like knight
+2 actions
"""
			cost = 3
		CardType.Queen:
			type = card
			name = "Queen"
			description = """
Move like queen
+1 card
+1 action
"""
			cost = 5
		CardType.King:
			type = card
			name = "King"
			description = """
Move like King
+3 cards
+1 action
"""
			cost = 5
		CardType.Damage2:
			type = card
			name = "+2 Damage"
			description = """
Add 2 damage to next attack
"""
			cost = 5
		CardType.Bishop:
			type = card
			name = "Bishop"
			description = """
Move like bishop
+2 actions
"""
			cost = 4
		CardType.Trasher:
			type = card
			name = "Trasher"
			description = """
Destroy a card from your hand
"""
			cost = 4
		CardType.Village:
			type = card
			name = "Village"
			description = """
+1 card
+2 actions
"""
			cost = 3
		CardType.Laboratory:
			type = card
			name = "Laboratory"
			description = """
+2 cards
+1 action
"""
			cost = 4
		CardType.MagicMissile:
			type = card
			name = "Magic Missile"
			description = """
+2 damage modifier
Attack nearest enemy
Range 5
"""
			cost = 5
		CardType.Fireball:
			type = card
			name = "Fireball"
			description = """
+3 damage modifier
Attack radius 2 range 5
"""
			cost = 6
		CardType.Cleave:
			type = card
			name = "Cleave"
			description = """
+3 damage modifier
Attack all adjacent enemies
"""
			cost = 6
		_:
			print("uncaught match")

func set_cost(_cost: int) -> void:
	cost = _cost
