## Singleton global (Autoload) : orchestre la partie.
## Équivalent de ton DialogueEventBus côté architecture événementielle,
## mais Godot fournit les signaux nativement, pas besoin de bus custom.
extends Node

signal phase_changed(new_phase: GameEnums.GamePhase)
signal frame_activated(player: PlayerState, frame: Frame)
signal victory_points_changed(player: PlayerState, new_total: int)
signal game_ended(winner: PlayerState)

var players: Array[PlayerState] = []
var current_phase: GameEnums.GamePhase = GameEnums.GamePhase.ASSEMBLING_THE_TRIBE

func _ready() -> void:
	# TODO: point d'entrée d'une partie (setup, cf. livret p.3)
	pass

func start_new_round() -> void:
	# TODO: enchaîner P1 -> P2 -> P3 (state machine à extraire dans
	# core/engine/game_state_machine.gd une fois la logique de base posée)
	pass
