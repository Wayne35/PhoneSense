//
//  BuildDataBaseView.swift
//  specDemo
//
//  Created by Yiyum on 2023/5/31.
//

import SwiftUI

struct BuildDataBaseView: View {
    
    
    
    var body: some View {
        ZStack {
            Color(Color.RGBColorSpace.sRGB, red: 24/256, green: 27/256, blue: 29/256, opacity: 1)
                .ignoresSafeArea()
            
            Button {
                
            } label: {
                Text("press me")
            }
        }
    }
}

struct BuildDataBaseView_Previews: PreviewProvider {
    static var previews: some View {
        BuildDataBaseView()
    }
}
