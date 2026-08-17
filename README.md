# After Us — Adaptation vidéoludique (projet perso / apprentissage)

Adaptation non-officielle du jeu de société **After Us** (Florian Sirieix, illustré par Vincent
Dutrait, édité par Catch Up Games). Projet réalisé à but personnel/apprentissage, pour découvrir
le moteur Godot.

## Prérequis

- [Godot 4.3+](https://godotengine.org/download) (version standard, pas besoin du build .NET pour l'instant : le projet démarre en GDScript)

## Ouvrir le projet

1. Lancer Godot.
2. "Import" → sélectionner le fichier `project.godot` à la racine de ce dossier.
3. Ouvrir le projet.

## Structure du projet

```
data/                   Données statiques et enums globaux
  enums.gd               ApeType, ResourceKind, RowType, GamePhase
  cards/                 Resources .tres décrivant chaque carte (à venir)
  objects/               Resources .tres décrivant les 7 tuiles objets (à venir)

core/                   Moteur de règles — AUCUNE dépendance à l'affichage.
                        Doit pouvoir tourner en mode --headless.
  models/                 Structures de données du jeu
    ape_card.gd             Une carte de singe (Resource)
    frame.gd                Une case activable sur une carte
    primate_assembly.gd     La ligne de cartes d'un joueur pendant un round
    player_state.gd         État complet d'un joueur (ressources, VP, rage, deck)
  engine/                 Logique d'exécution des règles
    ape_abilities/          Une capacité spéciale par type de singe (Chimpanzé, Gorille...)
    (assembly_resolver.gd, frame_effect_executor.gd, game_state_machine.gd — à venir)

autoload/
  GameManager.gd          Singleton global (Autoload Godot), orchestre la partie,
                          expose des signaux (phase_changed, frame_activated...)

ui/                      Scenes et scripts d'affichage (à construire une fois
                        le moteur de règles validé et testé)

tests/                   Scènes de test headless pour valider la logique de jeu
                        indépendamment de tout visuel
```

## État d'avancement

- [x] Squelette de projet + structure de dossiers
- [x] Enums de base (ApeType, ResourceKind...)
- [x] Modèles de données de base (ApeCard, Frame, PrimateAssembly, PlayerState)
- [ ] Algorithme de calcul frames ouvertes/fermées
- [ ] Résolution complète d'une Primate Assembly (Phase 1)
- [ ] Capacités spéciales par type de singe
- [ ] Phase 2 (attraction de nouveaux singes, discs d'action)
- [ ] Phase 3 (repos / fin de round)
- [ ] Condition de fin de partie (80 VP)
- [ ] UI

## Licence / attribution

Ce projet est une adaptation fan-made non-officielle à but d'apprentissage personnel. Tous les
droits sur le jeu original (règles, textes, illustrations) appartiennent à Florian Sirieix,
Vincent Dutrait et Catch Up Games / Blackrock Games.
