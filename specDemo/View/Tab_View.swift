//
//  VeteranView.swift
//  specDemo
//
//  Created by Yiyum on 2023/2/8.
//

import SwiftUI

struct Tab_View: View {
    
    @State private var selection: Int = 1
    //@Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            TabView(selection: $selection){
                MainView()
                    .tabItem {
                        Image(self.selection == 1 ? "homeSelect" : "home")
                        }
                    .tag(1)
                DataBaseView()
                    .tabItem {
                        Image(self.selection == 2 ? "dataSelect" : "data")
                    }
                    .tag(2)
                LoginView()
                    .tabItem {
                        Image(self.selection == 3 ? "loginSelect" : "login")
                    }
                    .tag(3)
            }
        }
    }
}

struct VeteranView_Previews: PreviewProvider {
    static var previews: some View {
        Tab_View()
            //.environment(\.colorScheme, .light)
    }
}
