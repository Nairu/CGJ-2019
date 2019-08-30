extends Node

const TILE_SIZE = 32
enum FEATURE_TYPE {Door, Wardrobe, Chest, ChestDrawer, Bookcase, Stairs, Bed, Barrel, Lever}
enum ITEM_TYPE {Key, Potion}
enum CARDINALITY {North,East,South,West}

var music_seconds = 0

var Inventory = []

func getInventory():
	return Inventory
	
func setInventory(inventory):
	Inventory = inventory