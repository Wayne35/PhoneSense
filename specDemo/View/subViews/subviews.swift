//
//  subviews.swift
//  specDemo
//
//  Created by Yiyum on 2023/4/10.
//

import Foundation
import SwiftUI
import CSV
// MARK: -背景视图

struct backgroudView: View {
    
    let WIDTH = UIScreen.main.bounds.width
    @State var size: Int
    
    var body: some View {
        ZStack {
            //全局渐变色背景
            LinearGradient(colors: [Color.white.opacity(0.3), Color.purple.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        
                        Circle()
                            .frame(width: 300)
                            .foregroundStyle(Color.blue.opacity(0.3))
                            .blur(radius: 10)
                            .offset(x: -330, y: -150)
                            
                        
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .frame(width: 500, height: 500)
                            .foregroundStyle(LinearGradient(colors: [Color.mint.opacity(0.5), Color.mint.opacity(0.5)], startPoint: .top, endPoint: .leading))
                            .offset(x: 300, y: 200)
                            .blur(radius: 5)
                            .rotationEffect(.degrees(30))
                            
                        
                        Circle()
                            .frame(width: 250)
                            .foregroundStyle(Color.pink.opacity(0.6))
                            .blur(radius: 8)
                            .offset(x: 0, y: -200)
                            
        }
        //初始偏移
        .frame(width: size == 1 ? UIScreen.main.bounds.width : 2*UIScreen.main.bounds.width)
    }
}

// MARK: -垂直的拖动条
struct VerticalSliderView: View {
    
    @State var maxHeight: CGFloat = 240
    @Binding var sliderProgress: CGFloat
    @State var sliderHeight: CGFloat = 120
    @State var lastDragValue: CGFloat = 120
    //rgb的峰值
    @Binding var r_max: Double
    @Binding var g_max: Double
    @Binding var b_max: Double
    
    @EnvironmentObject var settings: APP_SETTING
        
        var body: some View {
                VStack {
                    ZStack(alignment: .bottom) {
                        Rectangle()
                            .fill(Color.black).opacity(0.1)
                        Rectangle()
                            .fill(Color.white).opacity(0.6)
                            .frame(height: sliderHeight < 0 ? 0 : sliderHeight)
                    }
                    .frame(width:55, height: maxHeight)
                    .foregroundStyle(LinearGradient(colors: [.blue, .indigo], startPoint: .top, endPoint: .bottom))
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .cornerRadius(15)
                    .gesture(DragGesture(minimumDistance: 0).onChanged({ value in
                        
                        let translation = value.translation
                        sliderHeight = -translation.height + lastDragValue
                        
                        if sliderHeight > maxHeight {
                            sliderHeight = maxHeight
                        } else if sliderHeight < 0 {
                            sliderHeight = 0
                        }
                        // %表示
                        sliderProgress = sliderHeight / maxHeight
                        
                    }).onEnded({ value in
                        //更新结束后更新数据
                        util.getPoints(position: Int((1-sliderProgress)*1920))
                        util.LoadToRgbdata(data: RGB_DATA)
                        //拖动结束后更新峰值
                        r_max = RGB_DATA[0].max() ?? 0
                        g_max = RGB_DATA[1].max() ?? 0
                        b_max = RGB_DATA[2].max() ?? 0
                        //拖动结束后刷新Chart
                        settings.REFRESHCHART.toggle()
                        lastDragValue = sliderHeight
                    }))
                    .overlay(alignment: .bottom, content: {
                        Text("\(Int(sliderProgress * 100))")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(.bottom, 20)
                            .offset(y: sliderHeight > maxHeight - 100 ? -(maxHeight - 100) :  -sliderHeight)
                    })
            }
        }
}

// MARK: -按下显示峰值的视图

struct showPeakView: View {
    
    //rgb的峰值
    @GestureState var longPress: Bool
    @Binding var r_max: Double
    @Binding var g_max: Double
    @Binding var b_max: Double
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.red)
                    .frame(width: 80, height: 50)
                    .overlay {
                        Text("\(Int(r_max))")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                }
                if longPress {
                    Text("R通道的最大强度值出现在波长为处\(RGB_DATA[0].firstIndex(of: r_max) ?? 0)nm，强度为\(Int(r_max))")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                }
            }
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.green)
                    .frame(width: 80, height: 50)
                    .overlay {
                        Text("\(Int(g_max))")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                }
                if longPress {
                    Text("G通道的最大强度值出现在波长为处\(RGB_DATA[1].firstIndex(of: r_max) ?? 0)nm，强度为\(Int(r_max))")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                }
            }
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue)
                    .frame(width: 80, height: 50)
                    .overlay {
                        Text("\(Int(b_max))")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                }
                if longPress {
                    Text("B通道的最大强度值出现在波长为处\(RGB_DATA[2].firstIndex(of: r_max) ?? 0)nm，强度为\(Int(r_max))")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                }
            }
        }
        .frame(width: longPress ? 300 : 100)
        .frame(height: 240)
        .padding(.horizontal, longPress ? 10 : 0)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .offset(x: longPress ? 15 : 130)
        .animation(.spring())
        .gesture(LongPressGesture(
            minimumDuration: 10.0, maximumDistance: 500.0)
            .updating($longPress) { currentState, gestureState, transaction in
                            gestureState = currentState
            }
        )
    }
}

// MARK: -过渡视图。。。

struct Message: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var image: String
    
}

// 定义数组，存放数据
var Messages = [
    Message(name: "啤酒", image: "bearDetc"),
    Message(name: "白酒", image: "WineDetc"),
    Message(name: "红酒", image: "RedWineDetc"),
    Message(name: "饮料", image: "drinkDetc"),
]

struct findBearView: View {
    
    @State var showResultView = false
    @State var showAlert: Bool = false
    @Binding var showSelectSample: Bool
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    ForEach(Messages, id: \.self) { msg in
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.gray.opacity(0.5))
                            .frame(width: 250, height: 80)
                            .animation(.spring())
                            .overlay {
                                HStack(spacing: 20) {
                                    Image(msg.image)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .background(
                                            Circle()
                                                .fill(Color.white)
                                                .frame(width: 60, height: 60)
                                                .shadow(radius: 2, x: 2, y: 2)
                                        )
                                    Text(msg.name)
                                        .font(.system(size: 28, weight: .medium, design: .rounded))
                                    Spacer()
                                }
                                .padding()
                                .onTapGesture {
                                    TYPE_SELECTED = msg.name
                                    showAlert.toggle()
                                }
                                .alert(isPresented: $showAlert){
                                    Alert(title: Text("请确认"), message: Text("确定保存至\(TYPE_SELECTED)吗？"), primaryButton: Alert.Button.default(Text("确认"), action: {
                                        NotificationCenter.default.post(name: NSNotification.saveChartViewAsImage, object: nil)
                                        
                                        var croppedImage = CHART_IMAGE.imageAtRect(rect: CGRect(x: 25, y: 0, width: 350, height: 160))
                                        //print(CHART_IMAGE.accessibilityFrame)
                                        
                                        
                                        let specFile = specFile(
                                            name: util.nameStringForSpecfile(),
                                            value: Spec_Array_temp,
                                            date: util.dateString(),
                                            time: util.timeString(),
                                            imageData: croppedImage.pngData()!)
                                        
                                        util.saveSpecDataToFolder(
                                            folderName: TYPE_SELECTED,
                                            specFile: specFile)
                                        
                                        showSelectSample = false
                                         }),
                                          secondaryButton: Alert.Button.cancel(Text("取消"))
                                     )
                                }
                            }
                    }
                }
                .padding()
            }
            .frame(width: 300, height: 500)
            .cornerRadius(20)
            .foregroundStyle(LinearGradient(colors: [.black, .blue],startPoint: .top, endPoint: .bottom))
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                        
            if(showResultView) {
                resultView(showResultView: $showResultView)
            }
        }
    }
}

struct resultView: View {
    
    @Binding var showResultView: Bool
    @State var showResult: Bool = false
    
    var body: some View {
        ZStack {
            if(!showResult) {
                ProgressView()
            } else {
                VStack(spacing: 20) {
                                            
                }
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .frame(width: 250)
                .frame(height: 240)
                .cornerRadius(20)
                .padding(.horizontal, 10)
                .foregroundStyle(LinearGradient(colors: [.blue, .indigo],startPoint: .top, endPoint: .bottom))
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .onTapGesture {
                    showResultView = false
                }
            }
        }
        .onAppear {
            //showResult = true
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                showResult = true
                //print("\(showResult)")
            })
        }
    }
}

// MARK: -显示详细信息的视图

struct investigateResultView: View {
    
    @Binding var EuclideanDistance: Double
    @Binding var CosineSimilarity: Double
    @Binding var PearsonSimilarity: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("鉴定结果：")
                .font(.system(size: 28, weight: .bold, design: .monospaced))
            Spacer()
            Text("相似度：\(util.afterDecimal(value: 100 * PearsonSimilarity, places: 3))%")
                .font(.system(size: 40, weight: .bold, design: .monospaced))
            Text("基于皮尔逊相关系数")
                .font(.system(size: 15, weight: .bold, design: .monospaced))
            Spacer()
        }
        .foregroundColor(.black)
        .padding()
    }
}

// MARK: -信息提示视图

struct bannerView: View {
    @State private var isShow: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("鉴定结果：")
                .font(.system(size: 28, weight: .bold, design: .monospaced))
            Spacer()
            Text("相似度：100%")
                .font(.system(size: 40, weight: .bold, design: .monospaced))
            
            Text("基于皮尔逊相关系数")
                .font(.system(size: 15, weight: .bold, design: .monospaced))
            Spacer()
        }
        .frame(height: 300)
        .foregroundColor(.black)
        .padding()
    }
}

struct bannerView_Previews: PreviewProvider {
    
    static var previews: some View {
        bannerView()
    }
}

extension View {
    func bannerVisible(with isShow: Binding<Bool>,
                       title: String = "顶部banner提示语") -> some View {
        self.navigationBarTitleDisplayMode(.inline)
            .modifier(Banner(isShow: isShow,title: title)
            )
    }
}

struct Banner: ViewModifier {
    
    @Binding var isShow: Bool
    let title: String

    @State private var offset: CGFloat = -100
    @State private var opacity: CGFloat = 0

    func body(content: Content) -> some View {
        let asyncHide = DispatchWorkItem() { hide() }

        ZStack {
            content
            if isShow {
                VStack {
                    bannerView
                    Spacer()
                }
                .padding()
                .onTapGesture {
                    asyncHide.cancel()
                    hide()
                }
                .onAppear {
                    show()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: asyncHide)
                }
                .offset(y: offset)
            }
        }
    }

    private var bannerView: some View {
        Text(title)
        .font(.system(size: 24, weight: .bold, design: .rounded))
        .opacity(opacity)
        .padding(12)
        .foregroundStyle(LinearGradient(colors: [.blue, .indigo], startPoint: .top, endPoint: .bottom))
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        .cornerRadius(8)
    }

    private func show() {
        withAnimation(.easeInOut(duration: 0.3)) {
            offset = 0
            withAnimation(.easeInOut(duration: 0.45)) {
                opacity = 0.75
            }
        }
    }

    private func hide() {
        withAnimation(.easeInOut(duration: 0.3)) {
            offset = -100
            withAnimation(.easeInOut(duration: 0.2)) {
                opacity = 0
                self.isShow = false
            }
        }
    }
}

extension UIImage {
    // 截取部分图片
    func imageAtRect(rect: CGRect) -> UIImage{
            var rect = rect
            rect.origin.x *= self.scale
            rect.origin.y *= self.scale
            rect.size.width *= self.scale
            rect.size.height *= self.scale
            let imageRef = self.cgImage!.cropping(to: rect)
            let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
            return image
    }

}
