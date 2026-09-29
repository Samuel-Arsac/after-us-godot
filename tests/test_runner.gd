extends Node

func _ready() -> void:
	FrameResolutionTests.run_all()

	print("\n=== Verification de la carte Tamarin ===")
	CardDataPlayground.print_card(CardDataPlayground.make_tamarin())
