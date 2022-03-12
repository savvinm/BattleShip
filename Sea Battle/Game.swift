//
//  Game.swift
//  Sea Battle
//
//  Created by Maksim Savvin on 10.03.2022.
//

import Foundation

struct Game{
    
    static let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K"]
    
    private(set) var status: GameStatuses
    
    private(set) var playerCells: [Cell]
    
    private(set) var aiCells: [Cell]
    
    init(){
        status = GameStatuses.start
        playerCells = Game.generateEmptyMap()
        aiCells = Game.generateEmptyMap()
    }
    
    private static func generateEmptyMap() -> [Cell]{
        var cells = Array<Cell>()
        var id = 0
        for letter in Game.letters {
            for index in 0..<10{
                cells.append(Cell(id: id, posLetter: letter, posNumber: index, status: CellStatuses.unknown))
                id += 1
            }
        }
        return cells
    }
    
    struct Cell: Identifiable{
        let id: Int
        let posLetter: String
        let posNumber: Int
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
        case start
        case lose
        case won
        case action
    }
}
