extends KinematicBody2D

export var nopeus: float = 180
#var _kiinni_maahan: bool = true
#export var tarttumisen_vektori: Vector2 = Vector2(0,32)
export var suunta_oikealle: bool = true

onready var _animoitu_kuva = $AnimatedSprite
onready var _iskualue = $Area2D

var _nopeus_vektori: Vector2

func _vaihda_suunta():
	suunta_oikealle = !suunta_oikealle
	_animoitu_kuva.flip_h = !_animoitu_kuva.flip_h
	_iskualue.position.x *= -1

func _ready():
	if not suunta_oikealle:
		_animoitu_kuva.flip_h = !_animoitu_kuva.flip_h
		_iskualue.position.x *= -1

func _physics_process(delta):
	# Asetetaan aluksi nopeus vaakasuunnassa valittuun suuntaan
	#	ehtolause:
	#	<vaihtoehto jos tosi> if <ehto> else <vaihtoehto jos epätosi>
	_nopeus_vektori.x = nopeus if suunta_oikealle else -nopeus
	
	_nopeus_vektori.y += 980.0 * delta
		
	_nopeus_vektori = move_and_slide_with_snap(
		_nopeus_vektori,
		Vector2(0,32),#tarttumisen_vektori if _kiinni_maahan else Vector2.ZERO,
		Vector2.UP
		)
		
	# Funktio joka liikuttaa hahmoa palauttaa vektorin joka
	# kuvaa onnistuneen liikkeen nopeutta. Jos sen x-luku on hyvin
	# pieni, hahmo ei onnistunut liikkumaan vaakasuunnassa, ja
	# pitää luultavasti vaihtaa suuntaa.
	#	'abs(luku)' palauttaa luvun itseisarvon,
	#	eli eron nollasta. Tässä tapauksessa se poistaa
	#	miinusmerkin jos luku on pienempi kuin 0
	if abs(_nopeus_vektori.x) < 0.01:
		_vaihda_suunta()


func _on_Area2D_body_entered(body):
	# Muista asettaa Collision niin että huomataan vain pelaaja
	if body is Pelaaja:
		Peli.tappio()