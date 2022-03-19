//
//  Game.swift
//  BattleShip
//
//  Created by Maksim Savvin on 10.03.2022.
//

import Foundation

struct Game{
    private let directions =  [(1,0), (-1,0), (0,1), (0,-1)]
    
    private(set) var movesCount = 0
    
    private(set) var status: GameStatuses
    
    private(set) var playerField: [Cell]
    private(set) var aiField: [Cell]
    private var size: Int
    
    private var playerShipsCount: Int
    private var aiShipsCount: Int
    
    private var aiShips: [Ship]
    
    init(size: Int, ships: [Int]){
        status = GameStatuses.userMove
        self.size = size
        playerField = Game.getEmptyMap(size: size)
        aiField = Game.getEmptyMap(size: size)
        playerShipsCount = ships.count
        aiShipsCount = ships.count
        aiShips = [Ship]()
    }
    
    mutating func getShipsForAI(){
        putShipInRandomPlace(len: 4)
    }
    
    private static func getEmptyMap(size: Int) -> [Cell]{
        var cells = Array<Cell>()
        var id = 0
        for row in 0..<size {
            for col in 0..<size{
                cells.append(Cell(id: id, x: col, y: row, status: .unknown))
                id += 1
            }
        }
        return cells
    }
    
    mutating func restart(shipsLen: [Int]){
        aiField = Game.getEmptyMap(size: size)
        aiShips = [Ship]()
        movesCount = 0
        for len in shipsLen{
            putShipInRandomPlace(len: len)
        }
    }
    
    /// Changes cell status to .shipHit and checks ship for destroy status
    private mutating func hitShipIn(cell index: Int){
        aiField[index].status = .shipHit
        if !checkShipWith(cell: index){
            destroyAndOutlineShipWith(cell: index)
        }
    }
    
    /// Gets all cells of ship and changes their status and set to .empty cells around them
    private mutating func destroyAndOutlineShipWith(cell index: Int){
        let shipCells = aiShips.first(where: { $0.cellsIndexes.contains(index) })!.cellsIndexes
        for index in shipCells{
            destroyAndOutlineShipPartIn(x: aiField[index].x, y: aiField[index].y)
        }
    }
    
    /// This function changes cell status to .shipKilled and modify cells around it
    private mutating func destroyAndOutlineShipPartIn(x xCord: Int, y yCord: Int){
        for x in xCord - 1...xCord + 1{
            for y in yCord - 1...yCord + 1{
                if let index = cellIndexBy(x: x, y: y){
                    if x == xCord && y == yCord{
                        aiField[index].status = .shipKilled
                    }
                    if aiField[index].status != .shipKilled{
                        aiField[index].status = .empty
                    }
                }
            }
        }
    }
    
    /// Returns false if all of it's cells have status .shipHit and true if even one cell have status .ship
    private func checkShipWith(cell index: Int) -> Bool{
        let shipCells = aiShips.first(where: { $0.cellsIndexes.contains(index) })!.cellsIndexes
        for index in shipCells{
            if aiField[index].status == .ship{
                return true
            }
        }
        return false
    }

    /// This function is used to put ship with length of len on field. It chooses a random free cell and tries to fit ship in one of four directions. If it fails, then it calls itself recurrently.
    private mutating func putShipInRandomPlace(len: Int){
        let startIndex = randomFreeCellIndex()
        for direction in directions.shuffled() {
            let res = tryFitShip(len: len, startIndex: startIndex, xdif: direction.0, ydif: direction.1)
            if res{
                return
            }
        }
        putShipInRandomPlace(len: len)
    }
    
    private func cellIndexBy(x: Int, y: Int) -> Int?{
        if (x < 0 || x >= size) || (y < 0 || y >= size){
            return nil
        }
        else{
            return aiField.firstIndex(where: { $0.x == x && $0.y == y })
        }
    }
    
    /// Tries to fit ship with given length from start cell in direction of (x,y) vector. Returns true if ship was placed.
    private mutating func tryFitShip(len: Int, startIndex: Int, xdif: Int, ydif: Int) -> Bool{
        var isFits = true
        for step in 1..<len{
            if let index = cellIndexBy(x: aiField[startIndex].x + step * xdif, y: aiField[startIndex].y + step * ydif){
            if aiField[index].status == .ship || aiField[index].status == .blocked{
                    isFits = false
                    break
                }
            }
            else {
                isFits = false
                break
            }
        }
        if isFits {
            var cells = [Int]()
            for step in 0..<len{
                putShipPartInCell(x: aiField[startIndex].x + step * xdif, y: aiField[startIndex].y + step * ydif)
                cells.append(cellIndexBy(x: aiField[startIndex].x + step * xdif, y: aiField[startIndex].y + step * ydif)!)
            }
            aiShips.append(Ship(id: aiShips.count, len: len, cellsIndexes: cells))
            return true
        }
        else {
            return false
        }
    }
    
    /// This function changes cell state to .ship and state of cells arround this cell to .blocked, so they cant be used for ship.
    private mutating func putShipPartInCell(x xCord: Int, y yCord: Int){
        for x in xCord - 1...xCord + 1{
            for y in yCord - 1...yCord + 1{
                if let index = cellIndexBy(x: x, y: y){
                    if x == xCord && y == yCord{
                        aiField[index].status = .ship
                    }
                    if aiField[index].status != .ship{
                        aiField[index].status = .blocked
                    }
                }
            }
        }
    }
    
    private func cellIndexBy(_ id: Int) -> Int?{
        aiField.firstIndex(where: {$0.id == id})
    }
    
    private func randomFreeCellIndex() -> Int{
        var index = 0
        if let field = aiField.randomElement(){
            if field.status != .ship && field.status != .blocked{
                index = cellIndexBy(field.id)!
            }
            else{
                index = randomFreeCellIndex()
            }
        }
        return index
    }
    
    mutating func tapOn(_ id: Int){
        if let index = aiField.firstIndex(where: {$0.id == id}){
            if aiField[index].status == .unknown || aiField[index].status == .blocked{
                aiField[index].status = .miss
                movesCount += 1
            }
            if aiField[index].status == .ship{
                hitShipIn(cell: index)
                movesCount += 1
            }
        }
    }
    
    struct Cell: Identifiable{
        let id: Int
        let x: Int
        let y: Int
        var status: CellStatuses
    }
    
    struct Ship: Identifiable{
        let id: Int
        let len: Int
        let cellsIndexes: [Int]
    }
    
    enum CellStatuses{
        case miss
        case empty
        case shipHit
        case shipKilled
        case unknown
        case ship
        case blocked
    }
    
    enum GameStatuses{
        case aiMove
        case lose
        case won
        case userMove
    }
    
    private enum Direction{
        case up
        case down
        case left
        case right
    }
}
