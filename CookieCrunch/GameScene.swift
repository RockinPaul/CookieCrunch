//
//  GameScene.swift
//  CookieCrunch
//
//  Created by Pavel on 30.03.16.
//  Copyright (c) 2016 Pavel Zarudnev. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var level: Level! // Текущий уровень
    
    let TileWidth: CGFloat = 32.0 // Ширина плитки
    let TileHeight: CGFloat = 36.0 // Высота плитки
    
    let gameLayer = SKNode() // Основной слой игры, на нем представлены все объекты
    let cookiesLayer = SKNode() // Слой печенья, единственного интерактивного объекта на игровом поле
    
    let tilesLayer = SKNode() // Слой плитки. Он отображается как фон, на котором расположена печенька
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5) // Определяет координаты начальной позиции для дочерних элементов
        
        let background = SKSpriteNode(imageNamed: "Background")
        background.size = self.size // Задаем фону к размеру экрана
        addChild(background)
        
        addChild(gameLayer) // Добавляем основной слой игры
        
        let layerPosition = CGPoint( // Задаем позицию игрового поля
            x: -TileWidth * CGFloat(NumColumns) / 2,
            y: -TileHeight * CGFloat(NumRows) / 2)
        
        tilesLayer.position = layerPosition
        gameLayer.addChild(tilesLayer) // Добавляем игровое поле
        
        cookiesLayer.position = layerPosition // Позиция печенья аналогична игровому полю
        gameLayer.addChild(cookiesLayer) // Добаляем поле печенья
    }
    
    // Добавляем изображение печенья его фактическому месторасположению
    func addSpritesForCookies(cookies: Set<Cookie>) {
        for cookie in cookies { // Цикл проходит через множество из печенья
            let sprite = SKSpriteNode(imageNamed: cookie.cookieType.spriteName) // spriteName соответствует имени файла
            sprite.position = pointForColumn(cookie.column, row:cookie.row) // Получаем позицию для спрайта
            cookiesLayer.addChild(sprite) // Добавляем спрайт на поле печенья
            cookie.sprite = sprite // Текущему печенью присваиваем значения спрайта (до этого оно у него могло быть nil)
        }
    }
    
    // Позиция на экране, соответствующая положению клетки поля
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth/2,
            y: CGFloat(row)*TileHeight + TileHeight/2)
    }
    
    // Добавляем поле, которое будет фоном для печенья
    func addTiles() {
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if let _ = level.tileAtColumn(column, row: row) {
                    let tileNode = SKSpriteNode(imageNamed: "Tile")
                    tileNode.position = pointForColumn(column, row: row)
                    tilesLayer.addChild(tileNode)
                }
            }
        }
    }
}