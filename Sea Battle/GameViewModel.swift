//
//  GameViewModel.swift
//  Sea Battle
//
//  Created by Maksim Savvin on 10.03.2022.
//

import Foundation

class GameViewModel{
    private(set) var game: Game
    
    //private(set) var field: Array<FieldCell>
    
    init(){
        game = Game()
    }
    
    var playersField: Array<FieldCell>{
        getField(gameCells: game.playerCells)
    }
    
    private func getField(gameCells: Array<Game.Cell>) -> Array<FieldCell>{
        var field = [FieldCell]()
        var id = 1
        field.append(FieldCell(id: 0, content: "", ingameCellId: nil))
        for letter in coordLeters{
            field.append(FieldCell(id: id, content: letter, ingameCellId: nil))
            id += 1
        }
        var cellId = 0
        for row in 0..<10{
            for col in 0..<10{
                if row == 0{
                    field.append(FieldCell(id: id, content: String(col), ingameCellId: nil))
                }
                else{
                    field.append(FieldCell(id: id, content: String(gameCells[cellId].id), ingameCellId: gameCells[cellId].id))
                    cellId += 1
                }
                id += 1
            }
        }
        return field
    }
    
    var playerCells: Array<Game.Cell>{
        game.playerCells
    }
    
    var coordLeters: Array<String>{
        Game.letters
    }
    
    struct FieldCell: Identifiable{
        let id: Int
        let content: String
        let ingameCellId: Int?
        let isGameField = false
    }
}

