//
//  Tile.swift
//  CookieCrunch
//
//  Created by Pavel on 01.04.16.
//  Copyright © 2016 Pavel Zarudnev. All rights reserved.
//

class Tile {
    
    private var tiles = Array2D<Tile>(columns: NumColumns, rows: NumRows)
    
    func tileAtColumn(column: Int, row: Int) -> Tile? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return tiles[column, row]
    }
}