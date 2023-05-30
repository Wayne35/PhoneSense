//
//  coolButton.swift
//  specDemo
//
//  Created by Yiyum on 2023/2/24.
//

import SwiftUI

struct CustomButton: View {
    var progress: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple]), startPoint: .leading, endPoint: .trailing))
                .frame(height: 100)
            
            Rectangle()
                .fill(Color.white)
                .frame(width: progress, height: 100)
        }
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton()
    }
}
