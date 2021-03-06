//
//  ContentView.swift
//  BattleShip
//
//  Created by Maksim Savvin on 10.03.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var game: GameViewModel
    var body: some View {
        VStack{
            FieldView(gameVM: game)
                .foregroundColor(.blue)
                .padding()
            Spacer()
        }
    }
}


struct FieldView:View{
    @ObservedObject var gameVM: GameViewModel
    let cellSize = UIScreen.main.bounds.width / 12
    var body: some View{
        let size = gameVM.interfaceSize
        VStack{
            Text("Shots fired: \(gameVM.movesCount)")
            VStack(spacing: -35.0){
                ForEach(0..<size){col in
                    HStack(spacing: 0.0){
                        ForEach(0..<size){row in
                            let cell = gameVM.playingMap[col*size + row]
                            CellView(cell: cell)
                                .padding(.horizontal, -1.0)
                                .frame(width: cellSize, height: cellSize)
                                .onTapGesture{
                                    gameVM.tapOn(cell)
                                }
                        }
                    }
                }
                .padding()
            }
            .padding(.horizontal)
            restartButton
        }
    }
    private var restartButton: some View{
        Button("Restart"){
            gameVM.restart()
        }
    }
}

struct CellView: View{
    let cell: GameViewModel.FieldCell
    var body: some View{
        let shape = Rectangle()
        ZStack{
            if cell.isGameField{
                shape.foregroundColor(.white)
                shape.strokeBorder(lineWidth: 2)
                Text(cell.content)
            }
            else{
                Text(cell.content)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = GameViewModel()
        ContentView(game: game)
    }
}
