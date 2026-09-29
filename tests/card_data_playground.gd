class_name CardDataPlayground
extends RefCounted

static func make_tamarin() -> ApeCard:
	var card := ApeCard.new();
	card.identifier = "18";
	card.ape_type = GameEnums.ApeType.TAMARIN;
	card.removal_reward_kind = GameEnums.RemovalRewardKind.ENERGY;
	card.removal_reward_amount = 1;
	
	card.top_row_frames = [
		{"open_side":"LEFT","cost":{}, "effect":{GameEnums.RemovalRewardKind.FLOWER: 1}},
		{"open_side":"RIGHT","cost":{}, "effect":{GameEnums.RemovalRewardKind.GRAIN: 1}},
	]
	
	card.center_row_frames = [
		{"open_side":"NONE", "cost":{GameEnums.ResourceKind.ENERGY:1}, 
		"effect":{GameEnums.RemovalRewardKind.VICTORY_POINTS:1}}
	]
	
	card.bottom_row_frames = [
		{"open_side":"RIGHT", "cost":{GameEnums.ResourceKind.FLOWER:1, GameEnums.ResourceKind.GRAIN:1},
		"effect":{}}
	]
	
	return card;
	
static func print_card(card: ApeCard) -> void:
	print("=== Carte %s (%s) ===" % [card.identifier, GameEnums.ApeType.find_key(card.ape_type)])
	print("  Recompense de retrait : type %s, montant %d" % [GameEnums.RemovalRewardKind.find_key(card.removal_reward_kind), card.removal_reward_amount])
	print("  Ligne du haut   : %s" % [card.top_row_frames])
	print("  Ligne du milieu : %s" % [card.center_row_frames])
	print("  Ligne du bas    : %s" % [card.bottom_row_frames])
