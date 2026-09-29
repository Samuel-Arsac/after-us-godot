extends RefCounted

static func make_tamarin() -> ApeCard:
	var card := ApeCard.new();
	card.identifier = "18";
	card.ape_type = GameEnums.ApeType.TAMARIN;
	card.removal_reward_kind = GameEnums.RemovalRewardKind.ENERGY;
	return card;
