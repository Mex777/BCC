extends TileMap

func export_tilemap(tilemap: TileMap) -> Array:
	var position: Vector2i = tilemap.get_used_rect().position
	var size: Vector2i = tilemap.get_used_rect().size
	print(position)
	print(size)
	
	var matrix = []
	for i in range(position.y, position.y + size.y):
		var row = []
		for j in range(position.x, position.x + size.x):
			var cell: TileData = tilemap.get_cell_tile_data(0, Vector2i(j, i))
			if cell == null:
				row.append(0)
			else:
				row.append(1)
		
		matrix.append(row)
	
	return matrix
