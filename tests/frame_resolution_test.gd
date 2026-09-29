class_name FrameResolutionTests
extends RefCounted


static func run_all() -> void:
	print("=== Test 1 : ligne de 4 cartes, bords compatibles (s'apparient) ===")
	test_matching_line()

	print("\n=== Test 2 : retrait d'une carte au milieu (pouvoir Gorille) ===")
	test_gorilla_removal()

	print("\n=== Test 3 : voisin present MAIS bord non-ouvert en face (cas p.5) ===")
	test_mismatched_neighbor()

	print("\n=== Tous les tests de frames sont passes avec succes ===")


static func make_matching_card(id: String) -> ApeCard:
	var card := ApeCard.new()
	card.identifier = id
	card.ape_type = GameEnums.ApeType.TAMARIN
	card.top_row_frames = [
		{"open_side": "LEFT", "cost": {}, "effect": {GameEnums.RemovalRewardKind.FLOWER: 1}},
		{"open_side": "NONE", "cost": {}, "effect": {GameEnums.RemovalRewardKind.FRUIT: 1}},
		{"open_side": "RIGHT", "cost": {}, "effect": {GameEnums.RemovalRewardKind.GRAIN: 1}},
	]
	return card


static func make_non_matching_card(id: String) -> ApeCard:
	var card := ApeCard.new()
	card.identifier = id
	card.ape_type = GameEnums.ApeType.ORANGUTAN
	card.top_row_frames = [
		{"open_side": "NONE", "cost": {}, "effect": {GameEnums.RemovalRewardKind.ENERGY: 1}},
		{"open_side": "RIGHT", "cost": {}, "effect": {GameEnums.RemovalRewardKind.GRAIN: 1}},
	]
	return card


static func test_matching_line() -> void:
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


static func test_gorilla_removal() -> void:
	var assembly := PrimateAssembly.new()
	for i in range(4):
		assembly.add_card(make_matching_card("card_%d" % i))

	assembly.remove_card_at(1)

	var frames := assembly.resolve_row(GameEnums.RowType.TOP)
	print("  nombre de frames restantes : %d" % frames.size())
	for i in range(frames.size()):
		print("  frame %d -> is_closed = %s" % [i, frames[i].is_closed])

	assert(frames[2].is_closed == false, "carte 0 RIGHT doit se ROUVRIR : le trou bloque l'appariement")
	print("  -> Test 2 OK")


static func test_mismatched_neighbor() -> void:
	var assembly := PrimateAssembly.new()
	assembly.add_card(make_matching_card("card_0"))
	assembly.add_card(make_non_matching_card("card_1"))

	var frames := assembly.resolve_row(GameEnums.RowType.TOP)
	for i in range(frames.size()):
		print("  frame %d -> is_closed = %s" % [i, frames[i].is_closed])

	assert(frames[2].is_closed == false,
		"carte 0 RIGHT doit rester OUVERTE : la voisine n'a pas de frame ouverte en face, malgre sa presence")
	print("  -> Test 3 OK")
