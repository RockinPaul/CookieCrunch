//
//  Cookie.swift
//  CookieCrunch
//
//  Created by Pavel on 31.03.16.
//  Copyright © 2016 Pavel Zarudnev. All rights reserved.
//

import SpriteKit

enum CookieType: Int {
    // Перечисление имеет тип Int, поэтому мы можем указать лишь первое значение (Unknown)
    case Unknown = 0, Croissant, Cupcake, Danish, Donut, Macaroon, SugarCookie
    
    var spriteName: String {
        let spriteNames = [
            "Croissant",
            "Cupcake",
            "Danish",
            "Donut",
            "Macaroon",
            "SugarCookie"]
        
        return spriteNames[rawValue - 1] // Первому элементу в списке спрайтов соответствует нулевой в массиве
    }
    
    var highlightedSpriteName: String {
        return spriteName + "-Highlighted"
    }
    
    static func random() -> CookieType { // Выбор случайного элемента
        return CookieType(rawValue: Int(arc4random_uniform(6)) + 1)!
    }
    
    var description: String { // Описание элемента.
        return spriteName
    }
}

func == (lhs: Cookie, rhs: Cookie) -> Bool { // Перегружаем оператор равенства
    return lhs.column == rhs.column && lhs.row == rhs.row
}

class Cookie: CustomStringConvertible, Hashable {
    var column: Int
    var row: Int
    let cookieType: CookieType
    var sprite: SKSpriteNode? // Элемент может и не иметь спрайта
    
    init(column: Int, row: Int, cookieType: CookieType) { // Инициализатор принимает координаты печеньки на поле и тип
        self.column = column
        self.row = row
        self.cookieType = cookieType
    }
    
    var description: String { // Описание
        return "type:\(cookieType) square:(\(column),\(row))"
    }
    
    var hashValue: Int { // Хэш-значение. Именно при реализации протокола Hashable мы должны перегружать оператор равенства
        return row*10 + column
    }
}