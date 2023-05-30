//
//  ContentView.swift
//  specDemo
//
//  Created by Yiyum on 2023/2/8.
//

import SwiftUI

class APP_SETTING: ObservableObject {
    @Published var REFRESHCHART: Bool = false
    @Published var progress: Float = 0
    @Published var beayTypeNum: Int = 8
    @Published var gotoSpecView: Bool = false
    @Published var acquiredImage: Image = Image("noPhoto")
}

struct ContentView: View {
    
    let setting = APP_SETTING()
    
    var body: some View {
        Tab_View()
            .environmentObject(setting)
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
