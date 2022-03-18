//
//  GameViewModel.swift
//  BattleShip
//
//  Created by Maksim Savvin on 10.03.2022.
//

import Foundation

class GameViewModel: ObservableObject{
    private let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
    private let shipsLen = [1, 1, 1, 1, 2, 2, 2, 3, 3, 4]
    static private let mapSize = 10
    
    var interfaceSize: Int{
        GameViewModel.mapSize + 1
    }
    
    @Published private(set) var game: Game
    
    
    init(){
        game = Game(size: GameViewModel.mapSize, ships: shipsLen)
        //game.getShipsForAI()
    }
    
    func restart(){
        game.restart(shipsLen: shipsLen.reversed())
    }
    
    var playingMap: Array<FieldCell>{
        getMap(gameCells: game.aiField)
    }
    
    private func getMap(gameCells: Array<Game.Cell>) -> Array<FieldCell>{
        var field = [FieldCell]()
        var id = 1
        field.append(FieldCell(id: 0, content: "", ingameCellId: nil, isGameField: false))
        for letter in letters{
            field.append(FieldCell(id: id, content: letter, ingameCellId: nil, isGameField: false))
            id += 1
        }
        var cellId = 0
        for col in 0..<GameViewModel.mapSize{
            field.append(FieldCell(id: id, content: String(col), ingameCellId: nil, isGameField: false))
            for _ in 0..<GameViewModel.mapSize{
                var content = ""
                switch gameCells[cellId].status{
                case .unknown:
                    content = ""
                case .miss:
                    content = "."
                case .shipHit:
                    content = ""
                case .shipKilled:
                    content = ""
                case .ship:
                    content = "⬛️"
                case .empty:
                    content = ""
                case .blocked:
                    content = "X"
                }
                field.append(FieldCell(id: id, content: content, ingameCellId: gameCells[cellId].id, isGameField: true))
                cellId += 1
                id += 1
            }
        }
        return field
    }
    
    func tapOn(_ cell: FieldCell){
        if game.status == Game.GameStatuses.userMove{
            if cell.isGameField{
                game.tapOn(cell.ingameCellId!)
            }
        }
    }
    
    
    struct FieldCell: Identifiable{
        let id: Int
        let content: String
        let ingameCellId: Int?
        let isGameField: Bool
    }
}

