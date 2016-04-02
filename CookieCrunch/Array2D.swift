//
//  Array2D.swift
//  CookieCrunch
//
//  Created by Pavel on 01.04.16.
//  Copyright © 2016 Pavel Zarudnev. All rights reserved.
//

struct Array2D<T> { // Мы будем харнить тут Cookies и Tiles. <T> - любой тип
    
    let columns: Int // Столбец
    let rows: Int   // Строка
    private var array: Array<T?> // Приватная переменная. <T?> обуславливает, что значение может быть nil
    
    init(columns: Int, rows: Int) { // Инициализация массива
        self.columns = columns
        self.rows = rows
        array = Array<T?>(count: rows*columns, repeatedValue: nil)
    }
    
    subscript(column: Int, row: Int) -> T? { // Представляем одномерный массив как двумерный
        get {
            return array[row*columns + column]
        }
        set {
            array[row*columns + column] = newValue
        }
    }
}