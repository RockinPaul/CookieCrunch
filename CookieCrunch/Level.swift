//
//  Level.swift
//  CookieCrunch
//
//  Created by Pavel on 01.04.16.
//  Copyright © 2016 Pavel Zarudnev. All rights reserved.
//

import Foundation

let NumColumns = 9
let NumRows = 9

class Level {

    private var cookies = Array2D<Cookie>(columns: NumColumns, rows: NumRows)
    private var tiles = Array2D<Tile>(columns: NumColumns, rows: NumRows)
    
    init(filename: String) {
        
        guard let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename), // Загрузка из JSON
              let tilesArray: AnyObject = dictionary["tiles"] else { // Получение списка активных элементов (0 или 1)
                return
        }
        
        for (row, rowArray) in (tilesArray as! [[Int]]).enumerate() {
            let tileRow = NumRows - row - 1
            for (column, value) in rowArray.enumerate() {
                if value == 1 {
                    tiles[column, tileRow] = Tile() // Если элемент существует, создаем Tile
                }
            }
        }
    }
    
    func cookieAtColumn(column: Int, row: Int) -> Cookie? { // Получение значения Cookie по координатам
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return cookies[column, row]
    }
    
    func shuffle() -> Set<Cookie> { // Создать игровое поле, перемешав элементы случайным образом
        return createInitialCookies()
    }
    
    private func createInitialCookies() -> Set<Cookie> { // Инициализировать множество печенек
        var set = Set<Cookie>()
        
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if tiles[column, row] != nil {
                    let cookieType = CookieType.random()
                    let cookie = Cookie(column: column, row: row, cookieType: cookieType)
                    cookies[column, row] = cookie
                    set.insert(cookie)
                }
            }
        }
        return set
    }
    
    func tileAtColumn(column: Int, row: Int) -> Tile? { // Возвращает Tile в соответсвующих координатах
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return tiles[column, row]
    }
    
    func performSwap(swap: Swap) {
        let columnA = swap.cookieA.column
        let rowA = swap.cookieA.row
        let columnB = swap.cookieB.column
        let rowB = swap.cookieB.row
        
        cookies[columnA, rowA] = swap.cookieB
        swap.cookieB.column = columnA
        swap.cookieB.row = rowA
        
        cookies[columnB, rowB] = swap.cookieA
        swap.cookieA.column = columnB
        swap.cookieA.row = rowB
    }
}