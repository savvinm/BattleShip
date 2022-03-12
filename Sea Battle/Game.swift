//
//  Game.swift
//  Sea Battle
//
//  Created by Maksim Savvin on 10.03.2022.
//

import Foundation

struct Game{
    
    private(set) var status: GameStatuses
    
    private(set) var playerCells: [Cell]
    
    private(set) var aiCells: [Cell]
    
    init(){
        status = GameStatuses.userMove
        playerCells = Game.generateEmptyMap()
        aiCells = Game.generateEmptyMap()
    }
    
    private static func generateEmptyMap() -> [Cell]{
        var cells = Array<Cell>()
        var id = 0
        for row in 0..<10 {
            for col in 0..<10{
                cells.append(Cell(id: id, x: col, y: row, status: CellStatuses.unknown))
                id += 1
            }
        }
        return cells
    }
    
    mutating func tapOn(_ id: Int){
        if let index = playerCells.firstIndex(where: {$0.id == id}){
            playerCells[index].status = CellStatuses.miss
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
        case shipHit
        case shipKilled
        case unknown
        case ship
    }
    
    enum GameStatuses{
        case aiMove
        case lose
        case won
        case userMove
    }
}
