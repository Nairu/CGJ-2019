extends Node

const TILE_SIZE = 32
enum FEATURE_TYPE {Door, Wardrobe, Chest, ChestDrawer, Bookcase, Stairs, Bed, Barrel, Lever}
enum ITEM_TYPE {Key, Potion, Treasure}
enum CARDINALITY {North,East,South,West}

var music_seconds = 0

var Inventory = []
var player_health = 0
var player_equipped = null

var title_music : AudioStreamPlayer

func getInventory():
	return Inventory
	
func setInventory(inventory):
	Inventory = inventory
	
func getHealth():
	return player_health
	
func setHealth(health):
	player_health = health
	
func getEquipped():
	return player_equipped
	
func setEquipped(equipped):
	player_equipped = equipped