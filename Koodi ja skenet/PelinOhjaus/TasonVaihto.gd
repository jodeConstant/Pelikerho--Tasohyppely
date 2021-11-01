extends Area2D

# Tarkastelussa tähän asetetaan halutun tason
# tiedostopolku.
#	(String, FILE) lisää kansio-napin kentän viereen,
#	josta voi hakea tiedoston
export (String, FILE) var polku

func _on_TasonVaihto_body_entered(body):
	if body is Pelaaja:
		Peli.taso_suoritettu(polku)
