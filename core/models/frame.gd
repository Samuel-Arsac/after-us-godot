## Une "frame" = une case activable sur une carte (livret p.5-6).
## Ce n'est PAS une Resource Godot : c'est un objet léger recréé/évalué
## à chaque fois qu'on a besoin de connaître l'état (ouvert/fermé) d'une carte,
## car cet état dépend des cartes voisines dans la Primate Assembly.
class_name Frame
extends RefCounted

## Ligne à laquelle appartient la frame (TOP, CENTER, BOTTOM)
var row: GameEnums.RowType

## Résultat du calcul de PrimateAssembly : true si cette frame est activable
## dans l'état ACTUEL de la ligne (dépend des voisins, donc recalculé à chaque
## fois que la composition de la Primate Assembly change).
var is_closed: bool = false

## Coût à payer pour activer l'effet (peut être vide = gratuit)
## Format libre pour l'instant, ex: {ResourceKind.FLOWER: 1, ResourceKind.FRUIT: 1}
var cost: Dictionary = {}

## Condition requise pour activer l'effet (ex: "au moins 3 types d'apes différents")
## TODO: modéliser proprement une fois toutes les conditions du livret recensées
var condition: Callable

## Effet produit à l'activation : gain de ressources, VP, ou capacité spéciale
## TODO: remplacer par une classe FrameEffect dédiée (cf. frame_effect_executor.gd)
var effect: Callable

## Symbole Chimpanzé (Ω) : permet de réactiver une autre frame fermée
var grants_reactivation: bool = false
