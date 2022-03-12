//
//  BattleShipApp.swift
//  BattleShip
//
//  Created by Maksim Savvin on 10.03.2022.
//

import SwiftUI

@main
struct BattleShipApp: App {
    private let game = GameViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(game: game)
        }
    }
}
