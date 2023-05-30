//
//  MLView.swift
//  specDemo
//
//  Created by Yiyum on 2023/3/31.
//

import CoreML
import SwiftUI

struct MLView: View {
    
    @State private var selection: Int = 1
    @Environment(\.presentationMode) var presentationMode
        
    var body: some View {
        ZStack {
            investigateView()
        }
    }
}

struct investigateView: View {
    
    @State var showInfo: Bool = false
    @State var gotoSpecView: Bool = false
    @State var sampleCheck: Bool = false
    @State var EuclideanDistance: Double = 0
    @State var CosineSimilarity: Double = 0
    @State var PearsonSimilarity: Double = 0
    
    var body: some View {
        ZStack {
            Color(Color.RGBColorSpace.sRGB, red: 24/256, green: 27/256, blue: 29/256, opacity: 1)
                .ignoresSafeArea()
            VStack {
                ScrollView {
                    if(showInfo) {
                        investigateResultView(
                            EuclideanDistance: $EuclideanDistance,
                            CosineSimilarity: $CosineSimilarity,
                            PearsonSimilarity: $PearsonSimilarity)
                    }
                }
                .frame(width: 350, height: showInfo ? 300 : 0)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                .animation(.spring(), value: showInfo)
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(.gray)
                    .opacity(0.3)
                    .frame(width: showInfo ? 350 : 250,
                           height: showInfo ? 120 : 200)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .offset(x: showInfo ? 0 : -50, y: showInfo ? 30 : 70)
                    .overlay {
                        Image("moutai")
                            .resizable()
                            .frame(width: 80, height: 160)
                            .offset(x: -120,y: 30)
                        
                        VStack {
                            Text("真实样品")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(sampleCheck ? .green : .black)
                            Text("GroundTruth")
                                .font(.system(size: 12, weight: .regular, design: .rounded))
                                .foregroundColor(sampleCheck ? .green : .black)
                            if(!showInfo) {
                                Image(systemName: sampleCheck ? "checkmark.square" : "plus.app")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(sampleCheck ? .green : .black)
                            }
                        }
                        .offset(y: showInfo ? 30 : 60)
                        .onTapGesture {
                            gotoSpecView = true
                            cameraSub.isInvestigateMode = true
                        }
                        .sheet(isPresented: $gotoSpecView){
                            SpecView()
                        }
                        
                    }
                    .animation(.spring(), value: showInfo)
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(.gray)
                    .opacity(0.3)
                    .frame(width: showInfo ? 350 : 250,
                           height: showInfo ? 120 : 200)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .offset(x: showInfo ? 0 : 50, y: showInfo ? 60 : 90)
                    .overlay {
                        Image("fake")
                            .resizable()
                            .frame(width: 80, height: 160)
                            .offset(x: 120,y: 50)
                        VStack {
                            Text("待检样品")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(sampleCheck ? .green : .black)
                            Text("UnKnown")
                                .font(.system(size: 12, weight: .regular, design: .rounded))
                                .foregroundColor(sampleCheck ? .green : .black)
                            if(!showInfo) {
                                Image(systemName: sampleCheck ? "checkmark.square" : "plus.app")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(sampleCheck ? .green : .black)
                            }
                        }
                        .offset(y: showInfo ? 60 : 80)
                        .onTapGesture {
                            gotoSpecView = true
                            cameraSub.isInvestigateMode = true
                        }
                        .sheet(isPresented: $gotoSpecView){
                            SpecView()
                        }
                    }
                    .animation(.spring(), value: showInfo)
                Spacer()
            }
            HStack(spacing: 30) {
                Text(showInfo ? "——————":"开始鉴定")
                    .font(.system(size: 28, weight: .light, design: .serif))
                    .foregroundColor(.black)
                    .padding(.vertical, showInfo ? 0 : 20)
                    .padding(.horizontal, showInfo ? 10 : 20)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(radius: 3, x: 2, y: 2)
                    .offset(y: showInfo ? 290 : 270)
                    .animation(.spring(), value: showInfo)
                    .onTapGesture {
                        if(sampleCheck) {
                            EuclideanDistance = util.EuclideanDistance(
                                arr1: truth_Array,
                                arr2: unknown_Array)
                            CosineSimilarity = util.cosineSimilarity(
                                arr1: truth_Array,
                                arr2: unknown_Array)
                            PearsonSimilarity = util.PearsonCorrelationCoefficient(
                                arr1: truth_Array,
                                arr2: unknown_Array)
                            showInfo.toggle()
                        }
                    }
                Image(systemName: "arrow.clockwise.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.black)
                    .padding(.vertical, showInfo ? 0 : 20)
                    .padding(.horizontal, showInfo ? 10 : 20)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(radius: 3, x: 2, y: 2)
                    .offset(y: showInfo ? 290 : 270)
                    .animation(.spring(), value: showInfo)
                    .onTapGesture {
                        showInfo = false
                        sampleCheck = false
                    }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.truthAndUnknownEnable)) {_ in
            gotoSpecView = false
            sampleCheck = true
            //print(truth_Array)
            //print(unknown_Array)
            //print("欧氏距离: \(util.EuclideanDistance(arr1: truth_Array, arr2: unknown_Array))")
            //print("余弦相似度: \(util.cosineSimilarity(arr1: truth_Array, arr2: unknown_Array))")
        }
    }
}

struct MLView_Previews: PreviewProvider {
    
    static let env = APP_SETTING()
    
    static var previews: some View {
        MLView()
            .environmentObject(env)
    }
}

func stupid() {
    for n in 1...800 {
        if(n % 10 == 0) {
            print("_\(n): dataArray[\(n-1)], ")
        } else {
            print("_\(n): dataArray[\(n-1)], ", terminator: "")
        }
    }
}

struct sortView: View {
    
    @State private var pressedIndex: Int?
    @GestureState var longPress: Bool = false
    @State var predictTarget = util.predictBear()!.classLabel
    @State var predictTargetProb = util.predictBear()!.classProbability
    @State var array = Array<String>(repeating: "", count: 10)
    
    @EnvironmentObject var settings: APP_SETTING
    
    var body: some View {
        VStack {
            Text("各类啤酒相似度排序")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .lineLimit(1)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(radius: 5)
                )
                .padding(.top, 20)
            
            ScrollView {
                VStack() {
                    ForEach(0..<settings.beayTypeNum) { i in
                        GeometryReader { geo in
                            HStack() {
                                VStack {
                                    Text(array[i] ?? "")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                    if(pressedIndex == i && longPress) {
                                        HStack(spacing: 0) {
                                            Text(String(util.afterDecimal(value: (100*(predictTargetProb[array[i]] ?? 0)), places: 1)))
                                            Text("%")
                                        }
                                    }
                                }
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.blue)
                                    .frame(width: CGFloat(predictTargetProb[array[i]] ?? 0) * geo.size.width/1.3, height: 50)
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .animation(.spring(), value: longPress)
                            .gesture(
                                LongPressGesture(
                                    minimumDuration: 1, maximumDistance: 10.0)
                                .onChanged { _ in self.pressedIndex = i}
                                    .updating($longPress) {
                                        currentState,
                                        gestureState,
                                        transaction in
                                        gestureState = currentState
                                    }
                            )
                        }
                        .padding()
                        .padding(.bottom, 5)
                    }
                }
                .onAppear{
                    array = util.sortType(len: settings.beayTypeNum)
                }
            }
        }
        .frame(width: 350, height: 400)
        .foregroundStyle(LinearGradient(colors: [.blue, .gray], startPoint: .top, endPoint: .bottom))
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

struct imageView: View {
    
    @State var imageName: String
    @State var type: String
    @Binding var selectedType: String
    @Binding var allFile: [String]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(.purple)
                .frame(width: 100, height: 100)
                .opacity(selectedType == type ? 0.5 : 0)
                .animation(.spring(), value: selectedType)
                .overlay {
                    Image(imageName)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .background(
                            Circle()
                                .fill(Color.white)
                                .frame(width: 80, height: 80)
                                .shadow(radius: 2, x: 2, y: 2)
                        )
                        
                }
                .onTapGesture {
                    selectedType = type
                    allFile = util.allDataInFolderByName(folderName: type)
                }
        }
    }
}

struct dataView: View {
    
    @State var selectedType: String = "啤酒"
    @State var showRank: Bool = false
    @State var allFile: [String] = []
    @State var uuidSelected: String = ""
    
    //显示在info面板的信息
    @State var chartImage: Image = Image(systemName: "heart.fill")
    @State var saveTime: String = ""
    @State var saveDate: String = ""
    
    var body: some View {
        ZStack {
            Color(Color.RGBColorSpace.sRGB, red: 24/256, green: 27/256, blue: 29/256, opacity: 1)
                .ignoresSafeArea()
            VStack {
                ScrollView(.horizontal) {
                    HStack() {
                        imageView(imageName: "bearDetc",type: "啤酒", selectedType: $selectedType, allFile: $allFile)
                        imageView(imageName: "WineDetc",type: "白酒", selectedType: $selectedType, allFile: $allFile)
                        imageView(imageName: "RedWineDetc",type: "红酒", selectedType: $selectedType, allFile: $allFile)
                        imageView(imageName: "drinkDetc",type: "饮料", selectedType: $selectedType, allFile: $allFile)
                    }
                    .padding(.vertical, 20)
                }
                .frame(width: 350,  height: 120)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
                
                ScrollView {
                    VStack {
                        ForEach(allFile, id: \.self) { file in
                            ZStack(alignment: .top) {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.gray.opacity(0.2))
                                    .frame(height: file == uuidSelected ? 150 : 0)
                                    .frame(maxWidth: .infinity)
                                    .offset(y: 25)
                                    .padding(.horizontal)
                                    .padding(.bottom, 5)
                                    .padding(.bottom, uuidSelected == "" ? 0 : 25)
                                    .shadow(radius: 1, x: 1, y: 1)
                                    .animation(.spring(), value: uuidSelected)
                                    .overlay {
                                        HStack(spacing: 30) {
                                            VStack {
                                                Text("创建时间:")
                                                    .font(.system(size: 18, weight: .medium, design: .monospaced))
                                                Text("\(saveDate)")
                                                    .font(.system(size: 18, weight: .medium, design: .monospaced))
                                                Text("\(saveTime)")
                                                    .font(.system(size: 18, weight: .medium, design: .monospaced))
                                            }
                                            
                                            chartImage
                                                .resizable()
                                                .frame(width: 100, height: 100)
                                        }
                                        .offset(y: 25)
                                        .opacity(file == uuidSelected ? 1 : 0)
                                    }
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.white)
                                    .frame(height: 50)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal)
                                    .padding(.bottom, 5)
                                    .shadow(radius: 1, x: 1, y: 1)
                                    .overlay {
                                        HStack {
                                            Text(file)
                                                .font(.system(size: 24, weight: .light, design: .monospaced))
                                                .foregroundColor(file == uuidSelected ? .green : .black)
                                            Spacer()
                                            Image(systemName: "info.circle")
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(file == uuidSelected ? .green : .black)
                                                .onTapGesture {
                                                    let curFile = util.readSpecDataToFolder(folderName: selectedType, name: file)
                                                    if(uuidSelected != curFile.name) {
                                                        
                                                        uuidSelected = curFile.name
                                                    } else {
                                                        
                                                        uuidSelected = ""
                                                    }
                                                    
                                                    //初始化面板
                                                    chartImage = Image(uiImage: UIImage(data: curFile.imageData)!)
                                                    saveDate = curFile.date
                                                    saveTime = curFile.time
                                                }
                                        }
                                        .frame(width: 250)
                                    }
                                    .animation(.spring(), value: uuidSelected)
                            }
                            .onTapGesture {
                                let curFile = util.readSpecDataToFolder(folderName: selectedType, name: file)
                                SPEC_DATA_CLASSIFY.removeAll()
                                SPEC_DATA_CLASSIFY = curFile.value
                                //print(SPEC_DATA_CLASSIFY)
                                showRank.toggle()
                            }
                        }
                    }
                    .padding(.top)
                    .onAppear {
                        allFile = util.allDataInFolderByName(folderName: selectedType)
                        util.getBearNum()
                    }
                }
                .frame(width: 350, height: 500)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
            }
            .onTapGesture {
                showRank = false
            }
            if(showRank) {
                sortView()
            }
        }
    }
}
