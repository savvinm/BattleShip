//
//  Game.swift
//  BattleShip
//
//  Created by Maksim Savvin on 10.03.2022.
//

import Foundation

struct Game{
    private let directions =  [(1,0), (-1,0), (0,1), (0,-1)]
    
    
    private(set) var status: GameStatuses
    
    private(set) var playerField: [Cell]
    private(set) var aiField: [Cell]
    private var size: Int
    
    private var playerShipsCount: Int
    private var aiShipsCount: Int
    
    init(size: Int, ships: [Int]){
        status = GameStatuses.userMove
        self.size = size
        playerField = Game.getEmptyMap(size: size)
        aiField = Game.getEmptyMap(size: size)
        playerShipsCount = ships.count
        aiShipsCount = ships.count
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
        for len in shipsLen{
            putShipInRandomPlace(len: len)
        }
    }
    
    
    private mutating func putShipInRandomPlace(len: Int){
        let startIndex = randomFreeCellIndex()
        let shaffledDirections = directions.shuffled()
        var res = false
        for direction in shaffledDirections {
            res = tryFitShip(len: len, startId: startIndex, xdif: direction.0, ydif: direction.1)
            if res{
                return
            }
        }
        if !res{
            putShipInRandomPlace(len: len)
        }
    }
    
    private func cellIndexBy(x: Int, y: Int) -> Int?{
        if (x < 0 || x >= size) || (y < 0 || y >= size){
            return nil
        }
        else{
            return aiField.firstIndex(where: { $0.x == x && $0.y == y })
        }
    }
    
    private mutating func tryFitShip(len: Int, startId: Int, xdif: Int, ydif: Int) -> Bool{
        if let startIndex = cellIndexBy(startId){
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
                for step in 0..<len{
                    putShipPartInCell(x: aiField[startIndex].x + step * xdif, y: aiField[startIndex].y + step * ydif)
                }
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
    
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
            aiField[index].status = .miss
        }
    }
    
    struct Cell: Identifiable{
        let id: Int
        let x: Int
        let y: Int
        var status: CellStatuses
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
