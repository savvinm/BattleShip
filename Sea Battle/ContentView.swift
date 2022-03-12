//
//  ContentView.swift
//  Sea Battle
//
//  Created by Maksim Savvin on 10.03.2022.
//

import SwiftUI

struct ContentView: View {
    let game: GameViewModel
    var body: some View {
        ScrollView{
            FieldView(dimension: 10, field: game.playerCells, coordLeters: game.coordLeters)
                .onTapGesture{
                    print(game.playersField)
                }
            /*LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem(), GridItem()], spacing: 0){
                ForEach(game.playerCells){cell in
                    CellView(status: cell.status, content: cell.content)
                        .aspectRatio(1, contentMode: .fit)
                }
            }
            .foregroundColor(.blue)
            .padding()*/
        }
    }
}


struct FieldView:View{
    let dimension: Int
    let field: Array<GameViewModel.FieldCell>
    let coordLeters: Array<String>
    let cellWidth = UIScreen.main.bounds.width / 13
    var body: some View{
        ForEach(field){cell in
            ZStack{
                Rectangle().strokeBorder(lineWidth: 3)
            }
        }
    }
}

struct CellView: View{
    let status: Game.CellStatuses
    let content: String
    var body: some View{
        let shape = RoundedRectangle(cornerRadius: 0)
        ZStack{
            shape
            Text(content)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = GameViewModel()
        ContentView(game: game)
    }
}
