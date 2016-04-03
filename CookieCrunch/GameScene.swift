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
    
    var swipeFromColumn: Int? // Столбец и строка, которые пользователь нажимал
    var swipeFromRow: Int?    // сразу перед тем, как произвести свайп
    
    var swipeHandler: ((Swap) -> ())?
    
    var selectionSprite = SKSpriteNode()
    
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
        
        swipeFromColumn = nil
        swipeFromRow = nil
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) { // Пользователь нажал на игровое поле
        let touch = touches.first! as UITouch
        let location = touch.locationInNode(cookiesLayer)
        let (success, column, row) = convertPoint(location) // Конвертация позиции элемента к
        if success {
            if let cookie = level.cookieAtColumn(column, row: row) {
                // Запоминаем стартовые значения индексов. От них выполняется свайп
                swipeFromColumn = column
                swipeFromRow = row
                
                showSelectionIndicatorForCookie(cookie)
            }
        }
    }
    
    func convertPoint(point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        if point.x >= 0 && point.x < CGFloat(NumColumns)*TileWidth &&
            point.y >= 0 && point.y < CGFloat(NumRows)*TileHeight {
                return (true, Int(point.x / TileWidth), Int(point.y / TileHeight))
        } else {
            return (false, 0, 0)  // invalid location
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if swipeFromColumn == nil { return }
        
        let touch = touches.first! as UITouch
        let location = touch.locationInNode(cookiesLayer)
        
        let (success, column, row) = convertPoint(location)
        if success {
            var horzDelta = 0, vertDelta = 0
            if column < swipeFromColumn! {          // swipe left
                horzDelta = -1
            } else if column > swipeFromColumn! {   // swipe right
                horzDelta = 1
            } else if row < swipeFromRow! {         // swipe down
                vertDelta = -1
            } else if row > swipeFromRow! {         // swipe up
                vertDelta = 1
            }
            if horzDelta != 0 || vertDelta != 0 {
                trySwapHorizontal(horzDelta, vertical: vertDelta)
                swipeFromColumn = nil
                
                hideSelectionIndicator()
            }
        }
    }
    
    func trySwapHorizontal(horzDelta: Int, vertical vertDelta: Int) { // Если возможно, выполняет свайп
        let toColumn = swipeFromColumn! + horzDelta
        let toRow = swipeFromRow! + vertDelta
        if toColumn < 0 || toColumn >= NumColumns { return } // Если свайп невозможно выполнить,
        if toRow < 0 || toRow >= NumRows { return }          // из за границ игрового поля
        if let toCookie = level.cookieAtColumn(toColumn, row: toRow) {
            if let fromCookie = level.cookieAtColumn(swipeFromColumn!, row: swipeFromRow!) {
                if let handler = swipeHandler {
                    let swap = Swap(cookieA: fromCookie, cookieB: toCookie)
                    handler(swap)
                }
            }
        }
    }
    
    // По окончанию свайпа обнуляем значения стартовых координат
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if selectionSprite.parent != nil && swipeFromColumn != nil {
            hideSelectionIndicator()
        }
        swipeFromColumn = nil
        swipeFromRow = nil
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        touchesEnded(touches!, withEvent: event)
    }
    
    // Анимация замены элементов
    func animateSwap(swap: Swap, completion: () -> ()) {
        let spriteA = swap.cookieA.sprite!
        let spriteB = swap.cookieB.sprite!
        
        spriteA.zPosition = 100
        spriteB.zPosition = 90
        
        let Duration: NSTimeInterval = 0.3
        
        let moveA = SKAction.moveTo(spriteB.position, duration: Duration)
        moveA.timingMode = .EaseOut
        spriteA.runAction(moveA, completion: completion)
        
        let moveB = SKAction.moveTo(spriteA.position, duration: Duration)
        moveB.timingMode = .EaseOut
        spriteB.runAction(moveB)
    }
    
    func showSelectionIndicatorForCookie(cookie: Cookie) {
        if selectionSprite.parent != nil {
            selectionSprite.removeFromParent()
        }
        
        if let sprite = cookie.sprite {
            let texture = SKTexture(imageNamed: cookie.cookieType.highlightedSpriteName)
            selectionSprite.size = texture.size()
            selectionSprite.runAction(SKAction.setTexture(texture))
            
            sprite.addChild(selectionSprite)
            selectionSprite.alpha = 1.0
        }
    }
    
    func hideSelectionIndicator() {
        selectionSprite.runAction(SKAction.sequence([
            SKAction.fadeOutWithDuration(0.3),
            SKAction.removeFromParent()]))
    }
}