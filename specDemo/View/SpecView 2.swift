//
//  SpecView.swift
//  specDemo
//
//  Created by Yiyum on 2023/2/11.
//

import SwiftUI
import Charts
import Foundation

struct SpecView: View {

    @EnvironmentObject var settings: APP_SETTING
    @State var refresh: Bool = true
    @State var showSelectSample: Bool = false
    @State var turnColor: Bool = false
    
    var body: some View {
        
        var chartView = ChartSpecView()
        
        ZStack {
            Color(Color.RGBColorSpace.sRGB, red: 24/256, green: 27/256, blue: 29/256, opacity: 1)
                .ignoresSafeArea()
                
            
            VStack(spacing: 20) {
                cameraSubView()
                    .onDisappear{
                        cameraSub.initComplete = false
                        cameraSub.Sample = false
                        settings.progress = 0
                        SPEC_PLOT_DATA.removeAll()
                    }
                    
                chartView
                                    
                ZStack {
                    ProgressView(value: settings.progress, total: 100)
                        .progressViewStyle(GradientProgressStyle())
                        .blur(radius: 1)
                        .padding(.horizontal, 5)
                    buttonView()
                        .onTapGesture {
                            if(showSelectSample) {
                                showSelectSample = false
                            } else if(settings.progress >= 99) {
                                settings.progress = 0
                                NotificationCenter.default.post(name: Notification.Name("ButtonPushed"), object: nil)
                            }
                        }
                }
                
                if(!cameraSub.isInvestigateMode) {
                    saveButtonView(turnColor: $turnColor, showSelectSample: $showSelectSample)
                }
            }
            
            if(showSelectSample) {
                findBearView(showSelectSample: $showSelectSample)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.saveChartViewAsImage)) {_ in
            let renderer = ImageRenderer(content: chartView)
             
            if let image = renderer.uiImage {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                CHART_IMAGE = image
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Progress)) {_ in
            if(!cameraSub.initComplete) {
                settings.progress += 100/31
            } else if (!cameraSub.Sample) {
                settings.progress += 100/31
            } else {
                turnColor = false
                settings.progress += 100/31
                if !(settings.progress < 100) {
                    turnColor = true
                }
            }
        }
        .onTapGesture {
            showSelectSample = false
        }
    }
}

struct GradientProgressStyle: ProgressViewStyle {
   
    var cornerRadius: CGFloat = 5
    var height: CGFloat = 100
    var animation: Animation = .linear
    
    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0
        var gradient =
        LinearGradient(
            gradient: Gradient(colors: stride(from: 0.6, to: 0.6*(1-Double(fractionCompleted)), by: -0.01).map {
                    Color(hue: $0, saturation: 1, brightness: 1)
                }),
                startPoint: .leading,
                endPoint: .trailing
            )
        return VStack {
            ZStack(alignment: .topLeading) {
                GeometryReader { geo in
                    Rectangle()
                        .fill(gradient)
                        .frame(maxWidth: geo.size.width * CGFloat(fractionCompleted))
                        //.animation(animation)
                }
            }
            .frame(height: height)
            .cornerRadius(cornerRadius)
        }
    }
}

//
//struct SpecView_Previews: PreviewProvider {
//
//    static let env = APP_SETTING()
//
//    static var previews: some View {
//        SpecView()
//            .environmentObject(env)
//    }
//}

struct buttonView: View {

    @EnvironmentObject var settings: APP_SETTING
    @State var textInfo: Int = 0
    
    var body: some View {
        VStack {
            switch(textInfo) {
            case 0:
                    VStack {
                        Text("初始化中...")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        Text("Initializing".uppercased())
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                    }
            case 1:
                    VStack {
                        Text("请在确定没放置样品的情况下继续")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        Text("ensure no sample inside and continue".uppercased())
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                    }
            case 2:
                    VStack {
                        if(cameraSub.isInvestigateMode) {
                            Text("请放置真实样本后再按继续，轻拿轻放。")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                            Text("ensure samples inside and continue".uppercased())
                                .font(.system(size: 12, weight: .regular, design: .rounded))
                        } else {
                            Text("请在放置样品后再按继续，过程中轻拿轻放。")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                            Text("ensure samples inside and continue".uppercased())
                                .font(.system(size: 12, weight: .regular, design: .rounded))
                        }
                    }
            case 3:
                    VStack {
                        if(cameraSub.isInvestigateMode) {
                            Text("请放置待测样品后再按继续，轻拿轻放。")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                            Text("ensure samples inside and continue".uppercased())
                                .font(.system(size: 12, weight: .regular, design: .rounded))
                        } else {
                            Text("可以更换样品后继续，过程中轻拿轻放。")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                            Text("change sample and continue".uppercased())
                                .font(.system(size: 12, weight: .regular, design: .rounded))
                        }
                    }
            default:
                    VStack {
                        if(cameraSub.isInvestigateMode) {
                            Text("请放置待测样品后再按继续，轻拿轻放。")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                            Text("ensure samples inside and continue".uppercased())
                                .font(.system(size: 12, weight: .regular, design: .rounded))
                        } else {
                            Text("可以更换样品后继续，过程中轻拿轻放。")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                            Text("change sample and continue".uppercased())
                                .font(.system(size: 12, weight: .regular, design: .rounded))
                        }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .shadow(color: .secondary.opacity(0.3), radius: 20, x: 10, y: 20)
        .foregroundStyle(LinearGradient(colors: [.black, .indigo], startPoint: .top, endPoint: .bottom))
        //.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding(.horizontal, 18)
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.buttonEnable)) { _ in
            textInfo += 1
        }
    }
}

struct ChartSpecView: View {

    let chartData = SPEC_PLOT_DATA
    
    var body: some View {
        
       var max_temp = findMax(array: SPEC_PLOT_DATA.flatMap({ $0.data}))
       var min_temp = findMin(array: SPEC_PLOT_DATA.flatMap({ $0.data}))
        
        VStack {
            Chart {
                ForEach(chartData, id: \.type){ combs in
                    ForEach(combs.data) {
                        LineMark(
                            x: .value("nm", $0.index),
                            y: .value("", $0.value)
                        )
                    }
                    .foregroundStyle(by: .value("", combs.type))
                }
            }
            .chartForegroundStyleScale(["spec": .blue])
            .chartPlotStyle { plotArea in
                plotArea
                    .background(.white.opacity(0.2))
            }
        }
        .chartXScale(domain: 0...800)
        .chartYScale(domain: 0.9*min_temp...1.1*max_temp)
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .frame(width: 350, height: 200)
        //.padding()
//        .onReceive(NotificationCenter.default.publisher(for: NSNotification.drawSpec)) { _ in
////            max = findMax(array: SPEC_PLOT_DATA.flatMap({ $0.data}))
////            min = findMin(array: SPEC_PLOT_DATA.flatMap({ $0.data}))
//        }
    }
    
    func findMax(array: [RGBPoints]) -> Double {
        return array.max(by: { $0.value < $1.value })?.value ?? 0
    }
    
    func findMin(array: [RGBPoints]) -> Double {
        return array.min(by: { $0.value < $1.value })?.value ?? 0
    }
}

struct saveButtonView: View {
    
    @Binding var turnColor: Bool
    @Binding var showSelectSample: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "atom")
                .renderingMode(.template)
                .resizable()
                .frame(width: 50, height: 50)
            VStack {
                Text("保存数据")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                Text("SaveData".uppercased())
                    .font(.system(size: 12, weight: .regular, design: .rounded))
            }
        }
        .frame(width: 250, height: 60)
        .shadow(color: .secondary.opacity(0.8), radius: 20, x: 10, y: 20)
        .foregroundStyle(LinearGradient(colors: [turnColor ? .green: .black, turnColor ? .green: .gray], startPoint: .top, endPoint: .bottom))
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .onTapGesture {
            showSelectSample = true
        }
        .disabled(!turnColor)
    }
}
