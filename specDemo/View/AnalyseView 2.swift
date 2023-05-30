//
//  AnalyseView.swift
//  specDemo
//
//  Created by Yiyum on 2023/2/8.
//

import SwiftUI
import UIKit
import Charts

struct AnalyseView: View {
    
    //拉动条的初始位置
    @State var progress: CGFloat = 0.5
    
    @EnvironmentObject var settings: APP_SETTING
    
    var previewdPicture: UIImage = camera.picture
    
    
    var body: some View {
        ZStack() {
            backgroudView(size: 1)
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: 10) {
                UpperView(progress: $progress)
            }
        }
    }
}

struct AnalyseView_Previews: PreviewProvider {
    
    static let env = APP_SETTING()
    
    static var previews: some View {
        AnalyseView()
            .environmentObject(env)
    }
}

struct UpperView: View {
    
    @Binding var progress: CGFloat
    @State var changeChart: Bool = false
    //用来显示rgb
    @State var r_max: Double = RGB_DATA[0].max() ?? 0
    @State var g_max: Double = RGB_DATA[1].max() ?? 0
    @State var b_max: Double = RGB_DATA[2].max() ?? 0
    //长按显示峰值
    @GestureState var longPress: Bool = false
    
    @EnvironmentObject var settings: APP_SETTING
    
    var body: some View {
        VStack(spacing: 30) {
            ZStack {
                HStack(spacing: 10) {
                    Image(uiImage: camera.picture)
                        .resizable()
                        .frame(width: 180, height: 240)
                        .cornerRadius(20)
                    VerticalSliderView(
                        sliderProgress: $progress,
                        r_max: $r_max,
                        g_max: $g_max,
                        b_max: $b_max
                    )
                }
                .offset(x: -60)
                showPeakView(
                    longPress: longPress,
                    r_max: $r_max,
                    g_max: $g_max,
                    b_max: $b_max)
            }
            
            ZStack {
                if settings.REFRESHCHART {
                    ChartView(changeChart: $changeChart)
                } else {
                    ChartView(changeChart: $changeChart)
                }
            }
            .frame(width: MAX_WIDTH)
            .frame(height: 240)
            //.foregroundStyle(LinearGradient(colors: [.white, .gray], startPoint: .leading, endPoint: .trailing))
            .foregroundStyle(LinearGradient(gradient: Gradient(colors: stride(from: 0.6, to: 0, by: -0.01).map {
                Color(hue: $0, saturation: 1, brightness: 1)
            }), startPoint: .leading, endPoint: .trailing))
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
//切换样式的按钮
            HStack(spacing: 10) {
    
                Menu {
                    Button("平滑"){
                        util.smoothAndLoad(data: RGB_DATA)
                        settings.REFRESHCHART.toggle()
                    }
                    Button("切换") {
                        changeChart.toggle()
                    }
                } label: {
                    Capsule(style: .continuous)
                        .frame(width: 200, height: 50)
                        .cornerRadius(20)
                        .overlay {
                            Text("style".uppercased())
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                    }
                
            }
            .frame(width: MAX_WIDTH, height: 100)
            .foregroundStyle(LinearGradient(colors: [.blue, .indigo], startPoint: .top, endPoint: .bottom))
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
    }
}

struct ChartView: View {
    
    @Binding var changeChart: Bool
    
    var body: some View {
        VStack {
            if changeChart{
                Chart {
                    ForEach(COMBINE_DATA, id: \.type){ combs in
                    ForEach(combs.data) {
                        LineMark(
                            x: .value("nm", $0.index),
                            y: .value("", $0.value)
                        )
                        .foregroundStyle(by: .value("", combs.type))
                    }
                }
            }
            .chartForegroundStyleScale(["red": .red, "green": .green, "blue": .blue])
            } else {
                Chart {
                    ForEach(GRAY_PLOT_DATA, id: \.type){ combs in
                    ForEach(combs.data) {
                        LineMark(
                            x: .value("nm", $0.index),
                            y: .value("", $0.value)
                        )
                        .foregroundStyle(by: .value("", combs.type))
                    }
                }
            }
            .chartForegroundStyleScale(["gray": .gray])
            }
        }
        .chartXScale(domain: 0...1080)
        .chartYScale(domain: 0...300)
        .frame(width: 350, height: 200)
        .padding()
    }
}
