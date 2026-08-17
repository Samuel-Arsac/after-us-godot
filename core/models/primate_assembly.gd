## Représente la "Primate Assembly" d'un joueur : la ligne de cartes
## constituée chaque round (livret p.4-6).
##
## Point clé n°1 : les emplacements sont conservés même quand une carte est
## retirée (pouvoir Gorille, p.9), pour que le calcul de voisinage reste
## correct. On ne compacte JAMAIS le tableau.
##
## Point clé n°2 (corrigé) : une frame ouverte ne se ferme PAS simplement
## parce qu'une carte existe à côté. Il faut que la carte voisine présente
## ELLE AUSSI une frame ouverte, exactement en face (livret p.5-6 :
## "placing a card WITH AN OPEN FRAME adjacent to it" — une frame ouverte
## n'est qu'une moitié de frame ; il faut les deux moitiés pour l'activer).
class_name PrimateAssembly
extends RefCounted

## Chaque élément est soit une ApeCard, soit `null` (emplacement vide,
## carte retirée par un Gorille).
var slots: Array = []


func add_card(card: ApeCard) -> void:
	slots.append(card)


func remove_card_at(index: int) -> ApeCard:
	var removed: ApeCard = slots[index]
	slots[index] = null
	return removed


func get_ape_type_diversity() -> int:
	var seen_types: Dictionary = {}
	for card in slots:
		if card != null:
			seen_types[card.ape_type] = true
	return seen_types.size()


func get_tamarin_count() -> int:
	var count := 0
	for card in slots:
		if card != null and card.ape_type == GameEnums.ApeType.TAMARIN:
			count += 1
	return count


## Reconstitue, pour une ligne donnée, la liste ordonnée des frames avec
## leur état ouvert/fermé actuel.
func resolve_row(row: GameEnums.RowType) -> Array[Frame]:
	var result: Array[Frame] = []

	for card_index in range(slots.size()):
		var card: ApeCard = slots[card_index]
		if card == null:
			continue

		var cells: Array[Dictionary] = card.get_row_cells(row)

		for cell_index in range(cells.size()):
			var cell_data: Dictionary = cells[cell_index]
			var frame := Frame.new()
			frame.row = row
			frame.cost = cell_data.get("cost", {})
			frame.effect = cell_data.get("effect", {})
			frame.grants_reactivation = cell_data.get("grants_reactivation", false)

			var open_side: String = cell_data.get("open_side", "NONE")
			var is_first_cell := cell_index == 0
			var is_last_cell := cell_index == cells.size() - 1

			frame.is_closed = _is_frame_closed(
				row, open_side, card_index, is_first_cell, is_last_cell
			)
			result.append(frame)

	return result


## Détermine si une cellule est fermée.
## - "NONE"  -> toujours fermée (frame intérieure, par design).
## - "LEFT"  -> fermée seulement si la carte de gauche existe ET que SA
##              dernière cellule de cette ligne a elle-même open_side == "RIGHT".
## - "RIGHT" -> symétrique, avec la première cellule de la carte de droite.
func _is_frame_closed(
	row: GameEnums.RowType,
	open_side: String,
	card_index: int,
	is_first_cell: bool,
	is_last_cell: bool
) -> bool:
	match open_side:
		"NONE":
			return true

		"LEFT":
			if not is_first_cell or card_index == 0:
				return false
			var neighbor: ApeCard = slots[card_index - 1]
			if neighbor == null:
				return false
			var neighbor_cells: Array[Dictionary] = neighbor.get_row_cells(row)
			if neighbor_cells.is_empty():
				return false
			var facing_cell: Dictionary = neighbor_cells[neighbor_cells.size() - 1]
			return facing_cell.get("open_side", "NONE") == "RIGHT"

		"RIGHT":
			if not is_last_cell or card_index == slots.size() - 1:
				return false
			var neighbor2: ApeCard = slots[card_index + 1]
			if neighbor2 == null:
				return false
			var neighbor_cells2: Array[Dictionary] = neighbor2.get_row_cells(row)
			if neighbor_cells2.is_empty():
				return false
			var facing_cell2: Dictionary = neighbor_cells2[0]
			return facing_cell2.get("open_side", "NONE") == "LEFT"

		_:
			push_warning("open_side inconnu: %s" % open_side)
			return false
