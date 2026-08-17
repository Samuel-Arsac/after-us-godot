## Représente une carte de singe (Tamarin ou carte de tribu niveau 1/2).
## C'est une Resource : donnée pure, sauvegardable en .tres, sans comportement visuel.
## Équivalent direct d'un ScriptableObject Unity.
class_name ApeCard
extends Resource

@export var identifier: String            # numéro d'identification (coin bas-gauche, livret p.2 et p.11)
@export var ape_type: GameEnums.ApeType
@export var level: int = 1                # 1 ou 2 (les Tamarins n'ont pas de niveau à proprement parler)

## Récompense reçue si cette carte est retirée du jeu via le pouvoir Gorille
@export var removal_reward_kind: GameEnums.RemovalRewardKind 
@export var removal_reward_amount: int = 0

## Les 3 lignes de la carte, chacune composée de 1 à plusieurs "cellules".
## Chaque cellule est un Dictionary avec ce format :
## {
##   "open_side": "NONE" | "LEFT" | "RIGHT",   -> NONE = toujours fermée (frame intérieure)
##   "cost": {ResourceKind: montant, ...},      -> vide si gratuit
##   "effect": {...},                           -> décrit plus tard (frame_effect_executor.gd)
##   "grants_reactivation": bool,               -> symbole Ω (Chimpanzé)
## }
## Une ligne peut contenir 1, 2 ou 3 cellules selon la carte (voir livret p.5-9).
@export var top_row_frames: Array[Dictionary] = []      # ressources
@export var center_row_frames: Array[Dictionary] = []   # points de victoire
@export var bottom_row_frames: Array[Dictionary] = []   # capacité spéciale


## Renvoie les cellules de la ligne demandée. Évite de dupliquer un `match`
## dans chaque endroit du code qui a besoin de lire une ligne par son type.
func get_row_cells(row: GameEnums.RowType) -> Array[Dictionary]:
	match row:
		GameEnums.RowType.TOP:
			return top_row_frames
		GameEnums.RowType.CENTER:
			return center_row_frames
		GameEnums.RowType.BOTTOM:
			return bottom_row_frames
	return []


## Applique la récompense de retrait à un joueur (pouvoir Gorille, p.9).
## Ex: Mark retire son Tamarin -> apply_removal_reward(mark) lui donne 1 fruit.
func apply_removal_reward(player: PlayerState) -> void:
	if removal_reward_kind == GameEnums.RemovalRewardKind.VICTORY_POINTS:
		player.victory_points += removal_reward_amount
		return
	var resource_kind_as_int: int = int(removal_reward_kind)
	player.gain_resource(resource_kind_as_int as GameEnums.ResourceKind, removal_reward_amount)
