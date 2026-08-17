## Se lance avec :
##   godot --headless --script res://tests/frame_resolution_test.gd
extends SceneTree


func _init() -> void:
	print("=== Test 1 : ligne de 4 cartes, bords compatibles (s'apparient) ===")
	test_matching_line()

	print("\n=== Test 2 : retrait d'une carte au milieu (pouvoir Gorille) ===")
	test_gorilla_removal()

	print("\n=== Test 3 : voisin present MAIS bord non-ouvert en face (cas p.5) ===")
	test_mismatched_neighbor()

	quit()


## Carte "symetrique" : ouverte a gauche ET a droite, fermee au centre.
## Deux cartes de ce type mises cote a cote s'apparient parfaitement.
func make_matching_card(id: String) -> ApeCard:
	var card := ApeCard.new()
	card.identifier = id
	card.ape_type = GameEnums.ApeType.TAMARIN
	card.top_row_frames = [
		{"open_side": "LEFT", "cost": {}, "effect": {"gain_flower": 1}},
		{"open_side": "NONE", "cost": {}, "effect": {"gain_fruit": 1}},
		{"open_side": "RIGHT", "cost": {}, "effect": {"gain_grain": 1}},
	]
	return card


## Carte dont la cellule de gauche est FERMEE par design (pas ouverte),
## bien qu'elle se trouve visuellement au bord de la carte. C'est ce type
## de carte qui, place a cote d'une frame ouverte voisine, la laisse
## ouverte quand meme -- exactement le cas que tu as repere p.5.
func make_non_matching_card(id: String) -> ApeCard:
	var card := ApeCard.new()
	card.identifier = id
	card.ape_type = GameEnums.ApeType.ORANGUTAN
	card.top_row_frames = [
		{"open_side": "NONE", "cost": {}, "effect": {"gain_energy": 1}},
		{"open_side": "RIGHT", "cost": {}, "effect": {"gain_grain": 1}},
	]
	return card


func test_matching_line() -> void:
	var assembly := PrimateAssembly.new()
	for i in range(4):
		assembly.add_card(make_matching_card("card_%d" % i))

	var frames := assembly.resolve_row(GameEnums.RowType.TOP)
	for i in range(frames.size()):
		print("  frame %d -> is_closed = %s" % [i, frames[i].is_closed])

	assert(frames[0].is_closed == false, "carte 0 LEFT : ouverte, debut de ligne")
	assert(frames[1].is_closed == true, "carte 0 NONE : toujours fermee")
	assert(frames[2].is_closed == true, "carte 0 RIGHT : fermee, s'apparie avec carte 1 LEFT")
	assert(frames[frames.size() - 1].is_closed == false, "derniere carte RIGHT : ouverte, fin de ligne")
	print("  -> Test 1 OK")


func test_gorilla_removal() -> void:
	var assembly := PrimateAssembly.new()
	for i in range(4):
		assembly.add_card(make_matching_card("card_%d" % i))

	assembly.remove_card_at(1)  # trou au milieu

	var frames := assembly.resolve_row(GameEnums.RowType.TOP)
	print("  nombre de frames restantes : %d" % frames.size())
	for i in range(frames.size()):
		print("  frame %d -> is_closed = %s" % [i, frames[i].is_closed])

	assert(frames[2].is_closed == false, "carte 0 RIGHT doit se ROUVRIR : le trou bloque l'appariement")
	print("  -> Test 2 OK")


func test_mismatched_neighbor() -> void:
	var assembly := PrimateAssembly.new()
	assembly.add_card(make_matching_card("card_0"))       # cellule RIGHT ouverte
	assembly.add_card(make_non_matching_card("card_1"))   # cellule gauche FERMEE par design

	var frames := assembly.resolve_row(GameEnums.RowType.TOP)
	for i in range(frames.size()):
		print("  frame %d -> is_closed = %s" % [i, frames[i].is_closed])

	assert(frames[2].is_closed == false,
		"carte 0 RIGHT doit rester OUVERTE : la voisine n'a pas de frame ouverte en face, malgre sa presence")
	print("  -> Test 3 OK : confirme le cas que tu as repere page 5")
