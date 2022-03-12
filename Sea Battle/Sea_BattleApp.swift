//
//  Sea_BattleApp.swift
//  Sea Battle
//
//  Created by Maksim Savvin on 10.03.2022.
//

import SwiftUI

@main
struct Sea_BattleApp: App {
    var body: some Scene {
        WindowGroup {
            let game = GameViewModel()
            ContentView(game: game)
        }
    }
}
