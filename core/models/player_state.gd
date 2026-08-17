## État complet d'un joueur pendant la partie.
class_name PlayerState
extends RefCounted

var player_color: String = ""

var resources: Dictionary = {
	GameEnums.ResourceKind.FLOWER: 0,
	GameEnums.ResourceKind.FRUIT: 0,
	GameEnums.ResourceKind.GRAIN: 0,
	GameEnums.ResourceKind.ENERGY: 0,
}

var victory_points: int = 0
var rage: int = 0

var draw_pile: Array[ApeCard] = []
var discard_pile: Array[ApeCard] = []
var assembly: PrimateAssembly = PrimateAssembly.new()

func has_resource(kind: GameEnums.ResourceKind, amount: int) -> bool:
	return resources.get(kind, 0) >= amount

func spend_resource(kind: GameEnums.ResourceKind, amount: int) -> void:
	# TODO: valider le montant dispo, gérer le cas "x3" du plateau joueur (livret p.3)
	resources[kind] = resources.get(kind, 0) - amount

func gain_resource(kind: GameEnums.ResourceKind, amount: int) -> void:
	resources[kind] = resources.get(kind, 0) + amount
