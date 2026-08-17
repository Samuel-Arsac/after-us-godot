## Enums centraux du jeu.
## Fichier "class_name" global : accessible partout sans préfixe, ex: ApeType.GORILLA
class_name GameEnums

enum ApeType {
	TAMARIN,
	CHIMPANZEE,
	GORILLA,
	MANDRILL,
	ORANGUTAN,
}

enum ResourceKind {
	FLOWER,
	FRUIT,
	GRAIN,
	ENERGY,
}

## Une ligne de carte (top = ressources, center = points, bottom = capacité spéciale)
enum RowType {
	TOP,
	CENTER,
	BOTTOM,
}

## Phase du tour de jeu (voir livret p.4 : P1, P2, P3)
enum GamePhase {
	ASSEMBLING_THE_TRIBE,   # Phase 1
	ATTRACTING_NEW_APES,    # Phase 2
	RESTING,                # Phase 3
}

## Type de récompense obtenue en retirant une carte du jeu via le pouvoir
## Gorille (livret p.9). Contrairement à ce qu'on pourrait croire, ce n'est
## JAMAIS de la rage : la rage est uniquement le COÛT pour déclencher le
## retrait (4 points), pas ce qu'on reçoit en échange. La récompense est
## une ressource classique OU des points de victoire, selon la carte.
## Exemple livret p.9 : Mark dépense 4 rage, reçoit 1 fruit.
enum RemovalRewardKind {
	FLOWER,
	FRUIT,
	GRAIN,
	ENERGY,
	VICTORY_POINTS,
}
