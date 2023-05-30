//
//  NavigationBootcamp.swift
//  SwiftfulThinkingBootCamp
//
//  Created by HUAHUA on 2022/10/27.
//

import SwiftUI

struct DataBaseView: View {
    
    let WIDTH: CGFloat = UIScreen.main.bounds.width
    let HEIGHT: CGFloat = UIScreen.main.bounds.height
    
    @State var select: Int = 1
    @State var showSpecView: Bool = false
    @EnvironmentObject var settings: APP_SETTING
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(Color.RGBColorSpace.sRGB, red: 24/256, green: 27/256, blue: 29/256, opacity: 1)
                    .ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 50) {
                        First_View()
                            .padding(.top, 30)
                        Second_View()
                        Third_View()
                    }
                    .animation(.spring())
                }
            }
        }
        .navigationTitle("phoneSense")
    }
}

struct First_View: View {
    
    var body: some View {
        NavigationLink(destination: dataView()) {
            HStack() {
                Image("showData")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .padding(.leading, 50)
                Spacer()
                VStack() {
                    Text("查看数据")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .opacity(0.8)
                    Text("show Data".uppercased())
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                }
                .padding(.trailing, 80)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .foregroundStyle(.white.opacity(0.9))
            .background(Color(Color.RGBColorSpace.sRGB, red: 24/256, green: 27/256, blue: 29/256, opacity: 1), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: Color.black.opacity(0.6), radius: 10, x: 10, y: 10)
            .shadow(color: Color.white.opacity(0.1), radius: 5, x: -5, y: -5)
            .animation(.spring())
            .padding(.horizontal, 18)
        }
    }
}

struct Second_View: View {
    var body: some View {
        NavigationLink(destination: BuildDataBaseView()) {
            HStack {
                Image("buildDatabase")
                    .resizable()
                    .frame(width: 60, height: 70)
                    .padding(.leading, 50)
                Spacer()
                VStack {
                    Text("新建数据库")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .opacity(0.8)
                    Text("Build DataBase".uppercased())
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                }
                .padding(.trailing, 80)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .foregroundStyle(.white.opacity(0.9))
            .background(Color(Color.RGBColorSpace.sRGB, red: 24/256, green: 27/256, blue: 29/256, opacity: 1), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: Color.black.opacity(0.6), radius: 10, x: 10, y: 10)
            .shadow(color: Color.white.opacity(0.1), radius: 5, x: -5, y: -5)
            .padding(.horizontal, 18)
            .animation(.spring())
        }
    }
}

struct Third_View: View {
    
    var body: some View {
        NavigationLink(destination: MLView()) {
            HStack {
                Image("neural")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .padding(.leading, 50)
                Spacer()
                VStack {
                    Text("训练模型")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .opacity(0.8)
                    Text("Train Model".uppercased())
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                }
                .padding(.trailing, 80)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150)
        .foregroundStyle(.white.opacity(0.9))
        .background(Color(Color.RGBColorSpace.sRGB, red: 24/256, green: 27/256, blue: 29/256, opacity: 1), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.6), radius: 10, x: 10, y: 10)
        .shadow(color: Color.white.opacity(0.1), radius: 5, x: -5, y: -5)
        .padding(.horizontal, 18)
        .animation(.spring())
    }
}

struct DataBaseView_Previews: PreviewProvider {
    
    static let env = APP_SETTING()
    
    static var previews: some View {
        DataBaseView()
            .environmentObject(env)
    }
}

