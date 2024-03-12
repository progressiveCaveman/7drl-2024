class_name CardDefinitions 
extends Object

# TODO Not currently used because it's weirdly difficult to read to an object. Hopefully fix this eventually

const card_definitions = {
	"Error": {
		"name": "Error",
		"description": "",
	},
	"Pawn": {
		"name": "Pawn",
		"description": "Move to an adjacent square",
	},
	"Rook": {
		"name": "Rook",
		"description": "Move any number of spaces in cardinal directions\n+1 action"
	},
	"Damage1": {
		"name": "+1 Damage",
		"description": "Add 1 damage to next attack",
	},
	"Knight": {
		"name": "Knight",
		"description": "Move 2 spaces in one direction then 1 in another",
	},
	"Queen": {
		"name": "Queen",
		"description": "Move any number of spaces in any direction\n+1 card \n+1 action"
	},
	"King": {
		"name": "King",
		"description": "Move to an adjacent square\n+3 cards \n+1 action"
	},
	"Damage2": {
		"name": "+2 Damage",
		"description": "Add 2 damage to next attack",
	},
	"Trasher": {
		"name": "Trasher",
		"description": "Permanently remove a card from play"
	}
}
