//
//  NavigationBootcamp.swift
//  SwiftfulThinkingBootCamp
//
//  Created by HUAHUA on 2022/10/27.
//

import SwiftUI

struct MainView: View {
    
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
                        FirstView(showSpecView: $showSpecView)
                            .onTapGesture {
                                showSpecView = true
                            }
                            .padding(.top, 30)
                        SecondView(showSpecView: $showSpecView)
                            .onTapGesture {
                                showSpecView = true
                            }
                        ThirdView()
                    }
                    .animation(.spring())
                }
            }
        }
        .navigationTitle("phoneSense")
    }
}

struct FirstView: View {

    @Binding var showSpecView: Bool
    
    var body: some View {
        
        HStack() {
            Image("spectrum")
                .resizable()
                .frame(width: 80, height: 50)
                .padding(.leading, 50)
            Spacer()
            VStack() {
                Text("光谱测试")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .opacity(0.8)
                Text("Spectrum".uppercased())
                    .font(.system(size: 12, weight: .regular, design: .rounded))
            }
            .padding(.trailing, 80)
        }
        .sheet(isPresented: $showSpecView){
            SpecView()
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

struct SecondView: View {
    
    @Binding var showSpecView: Bool
    
    var body: some View {
        HStack {
            Image("compare")
                .resizable()
                .frame(width: 60, height: 80)
                .padding(.leading, 50)
            Spacer()
            VStack {
                Text("质量监控")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .opacity(0.8)
                Text("Compare".uppercased())
                    .font(.system(size: 12, weight: .regular, design: .rounded))
            }
            .padding(.trailing, 80)
        }
        .sheet(isPresented: $showSpecView){
            SpecView()
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

struct ThirdView: View {
    
    var body: some View {
        NavigationLink(destination: MLView()) {
            HStack {
                Image("zoomGlass")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .padding(.leading, 50)
                Spacer()
                VStack {
                    Text("智能识别")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .opacity(0.8)
                    Text("DeepLearning".uppercased())
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

struct MainView_Previews: PreviewProvider {
    
    static let env = APP_SETTING()
    
    static var previews: some View {
        MainView()
            .environmentObject(env)
    }
}

struct trueCameraView: View {
    
    @Binding var picture: Image
    
    var body: some View {
        cameraView()
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
            .transition(.asymmetric(
                insertion: .move(edge: .leading),
                removal: .move(edge: .leading)))
            .animation(.easeIn)
        Spacer()
    }
}
