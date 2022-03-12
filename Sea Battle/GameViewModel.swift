//
//  GameViewModel.swift
//  Sea Battle
//
//  Created by Maksim Savvin on 10.03.2022.
//

import Foundation

class GameViewModel: ObservableObject{
    let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
    
    @Published private(set) var game: Game
    
    //private(set) var field: Array<FieldCell>
    
    init(){
        game = Game()
    }
    
    var playerMap: Array<FieldCell>{
        getField(gameCells: game.playerCells)
    }
    
    private func getField(gameCells: Array<Game.Cell>) -> Array<FieldCell>{
        var field = [FieldCell]()
        var id = 1
        field.append(FieldCell(id: 0, content: "", ingameCellId: nil, isGameField: false))
        for letter in letters{
            field.append(FieldCell(id: id, content: letter, ingameCellId: nil, isGameField: false))
            id += 1
        }
        var cellId = 0
        for col in 0..<10{
            field.append(FieldCell(id: id, content: String(col), ingameCellId: nil, isGameField: false))
            for _ in 0..<10{
                var content = ""
                switch gameCells[cellId].status{
                case .unknown:
                    content = ""
                case .miss:
                    content = "X"
                case .shipHit:
                    content = ""
                case .shipKilled:
                    content = ""
                case .ship:
                    content = ""
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

