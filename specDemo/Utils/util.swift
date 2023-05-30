//
//  uitl.swift
//  specDemo
//
//  Created by Yiyum on 2023/2/8.
//

import Foundation
import UIKit
import SwiftUI
import CoreML
import Accelerate
import CSV

class util {
    
    //平滑后重加载数组到rgbpoints
    static func smoothAndLoad(data: [[Double]]){
        //用来保存光滑后的四个数组
        let R_Array = smooth(window: 5, array: data[0])
        let G_Array = smooth(window: 5, array: data[1])
        let B_Array = smooth(window: 5, array: data[2])
        let Gray_Array = smooth(window: 5, array: data[3])
        
        //现对rgbpoints的数据清空
        R_DATA.removeAll()
        G_DATA.removeAll()
        B_DATA.removeAll()
        GRAY_DATA.removeAll()
        for i in 0..<data[0].count{
            R_DATA.append(RGBPoints(index: i, value: R_Array[i]))
            G_DATA.append(RGBPoints(index: i, value: G_Array[i]))
            B_DATA.append(RGBPoints(index: i, value: B_Array[i]))
            GRAY_DATA.append(RGBPoints(index: i, value: Gray_Array[i]))
        }
        COMBINE_DATA = [
            (type: "red", data: R_DATA),
            (type: "green", data: G_DATA),
            (type: "blue", data: B_DATA)
        ]
        GRAY_PLOT_DATA = [
            (type: "gray", data: GRAY_DATA)
        ]
    }
    //加载数组到rgbpoints
    static func LoadToRgbdata(data: [[Double]]){
        //对rgbpoints的数据清空
        R_DATA.removeAll()
        G_DATA.removeAll()
        B_DATA.removeAll()
        GRAY_DATA.removeAll()
        for i in 0..<data[0].count{
            R_DATA.append(RGBPoints(index: i, value: data[0][i]))
            G_DATA.append(RGBPoints(index: i, value: data[1][i]))
            B_DATA.append(RGBPoints(index: i, value: data[2][i]))
            GRAY_DATA.append(RGBPoints(index: i, value: data[3][i]))
        }
        COMBINE_DATA = [
            (type: "red", data: R_DATA),
            (type: "green", data: G_DATA),
            (type: "blue", data: B_DATA)
        ]
        GRAY_PLOT_DATA = [
            (type: "gray", data: GRAY_DATA)
        ]
        
    }
    //获得图片的某一行的像素，并返回一维数组,并且加载到rgbpoints
    static func getPoints(position: Int){
        //需要返回的四组一维数组，分别是r\g\b\gray
        var R_Array: [Double] = []
        var G_Array: [Double] = []
        var B_Array: [Double] = []
        var Gray_Array: [Double] = []
        
        let WIDTH = camera.picture.size.width
        let HEIGHT = camera.picture.size.height
        //获取图片的data
        let provider = camera.picture.cgImage!.dataProvider
        let providerData = provider!.data
        let data = CFDataGetBytePtr(providerData)
        for i in 0..<Int(WIDTH){
            let x = Int(WIDTH)-i-1
            let y = Int(position) < Int(HEIGHT)-1 ? Int(position) : Int(HEIGHT)-1
            let R_value = CGFloat(data![((Int(HEIGHT) * x) + y) * 4])/1.0
            let G_value = CGFloat(data![((Int(HEIGHT) * x) + y) * 4 + 1])/1.0
            let B_value = CGFloat(data![((Int(HEIGHT) * x) + y) * 4 + 2])/1.0
            let gray_value = (R_value*30+G_value*59+B_value*11+50)/100
            R_Array.append(R_value)
            G_Array.append(G_value)
            B_Array.append(B_value)
            Gray_Array.append(gray_value)
        }
        RGB_DATA = [R_Array, G_Array, B_Array, Gray_Array]
    }
    
    //平滑
    static func smooth(window: Int,array: [Double])->[Double]{
        let length = array.count
        if window == 1{
            return array
        }
        var newArray:[Double]! = []
        for i in 0..<window{
            newArray.append(array[i])
        }
        for i in window - 1..<length{
            var sum:Double = 0
            for j in 0..<window{
                sum += array[i - window + 1 + j]/Double(window)
            }
            newArray.append(Double(sum))
        }
        return newArray
    }
    //计算方差
    static func deviationVar(sets:[Double])->Double{
        let len = sets.count
        var aver:Double = 0
        var res:Double = 0
        for i in 0..<len{
           aver += sets[i]/Double(len)
        }
        for i in 0..<len{
           res += pow(aver - sets[i], 2)
        }
        return res
    }
    
    static func afterDecimal(value :Double, places: Int) -> String{
        let divisor = pow(10.0, Double(places))
        return String(round(value * divisor) / divisor)
    }
    
    static func predictBear() -> Beer_svm_modelOutput? {

        do {
            let config = MLModelConfiguration()
            let model = try Beer_svm_model(configuration: config)
            let prediction = try model.prediction(input: MLInput.initMLInput()!)
            print(1)
            return prediction
            
        } catch {
            print("error")
        }
        return nil
    }
    
    static func getBearNum() {
        // 加载模型
        guard let model = try? Beer_svm_model(configuration: MLModelConfiguration()) else {
            fatalError("Failed to load model")
        }

        // 获取模型描述信息
        let modelDescription = model.model.modelDescription

        // 获取模型预测的标签名称
        let labelName = modelDescription.classLabels as! [String]

        for (index, value) in labelName.enumerated() {
            NumToBearType[index] = value
        }

        //print(NumToBearType)
        // 打印标签名称数组
        //print("\(labelName[1]), \(labelName.count)")
    }

    static func sortType(len: Int) -> [String] {
        var dic = Dictionary<String, Double>()
        var ret = [String]()
        //print(NumToBearType)
        var predict = predictBear()
        for i in 0...len-1 {
            dic[NumToBearType[i]!] = predict?.classProbability[NumToBearType[i]!]
        }
        let temp = dic.sorted(by: {$0.1 > $1.1})
        for (key, _) in temp {
            ret.append(key)
        }
        return ret
    }
    
    static func EuclideanDistance(arr1: [Double], arr2: [Double]) -> Double {
        if(arr1.count != arr2.count) { return 0 }
        var sum: Double = 0
        for i in 0..<arr1.count {
            sum += pow(arr1[i] - arr2[i], 2)
        }
        return 1 - pow(sum, 0.5)/Double(arr1.count)
    }
    
    static func cosineSimilarity(arr1: [Double], arr2: [Double]) -> Double {
        if(arr1.count != arr2.count) { return 0 }
        var sum_arr1_square: Double = 0
        var sum_arr2_square: Double = 0
        var sum_arr1_arr2: Double = 0
        for i in 0..<arr1.count {
            sum_arr1_square += arr1[i] * arr1[i]
            sum_arr2_square += arr2[i] * arr2[i]
            sum_arr1_arr2 += arr1[i] * arr2[i]
        }
        return sum_arr1_arr2/(pow(sum_arr1_square, 0.5) * pow(sum_arr2_square, 0.5))
    }
    
    static func PearsonCorrelationCoefficient(arr1: [Double], arr2: [Double]) -> Double {
        if(arr1.count != arr2.count) { return 0 }
        var sum_arr1_square: Double = 0
        var sum_arr2_square: Double = 0
        var sum_arr1_arr2: Double = 0
        var avg_arr1: Double = 0
        var avg_arr2: Double = 0
        for i in 0..<arr1.count {
            avg_arr1 += arr1[i]
            avg_arr2 += arr2[i]
        }
        avg_arr1 = avg_arr1/Double(arr1.count)
        avg_arr2 = avg_arr2/Double(arr2.count)
        for i in 0..<arr1.count {
            sum_arr1_square += pow(arr1[i] - avg_arr1, 2)
            sum_arr2_square += pow(arr2[i] - avg_arr2, 2)
            sum_arr1_arr2 += (arr1[i] - avg_arr1)*(arr2[i] - avg_arr2)
        }
        return sum_arr1_arr2/(pow(sum_arr1_square, 0.5) * pow(sum_arr2_square, 0.5))
    }
    
    static func createFolder(folderName: String) -> String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let fileManager = FileManager.default
        let folderPath = documentPath.appending("/"+folderName) // 新文件夹的路径名
        if !fileManager.fileExists(atPath: folderPath) { // 检查文件夹是否存在
            do {
                try fileManager.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
                // 创建文件夹（如果不存在），包括任何必要的父文件夹。
                // withIntermediateDirectories 参数设置为 true，表示在创建文件夹时，同时创建必要的父文件夹。
                // attributes 参数设置为 nil，表示使用默认属性。
                print("文件夹创建成功")
            } catch {
                print("文件夹创建失败: \(error.localizedDescription)")
            }
        } else {
            print("文件夹已存在")
        }
        return folderPath
    }
    
    static func timeString() -> String {
        let hour_temp: Int = Date().hour + 8 > 24 ? Date().hour - 16 : Date().hour + 8
        let minute_temp: Int = Date().minute
        let second_temp: Int = Date().second
        
        let hour_str: String = hour_temp < 10 ? hour_temp == 0 ? "00" : "0" + String(hour_temp) : String(hour_temp)
        let minute_str: String = minute_temp < 10 ? minute_temp == 0 ? "00" : "0" + String(minute_temp) : String(minute_temp)
        let second_str: String = second_temp < 10 ? second_temp == 0 ? "00" : "0" + String(second_temp) : String(second_temp)
        
        return hour_str.appending(": " + minute_str + ": ").appending(second_str)
    }
    
    static func dateString() -> String {
        let day_temp: Int = Date().day
        let month_temp: Int = Date().month
        let year_temp: Int = Date().year
        
        let day_str: String = day_temp < 10 ? day_temp == 0 ? "00" : "0" + String(day_temp) : String(day_temp)
        let month_str: String = month_temp < 10 ? month_temp == 0 ? "00" : "0" + String(month_temp) : String(month_temp)
        let year_str: String = year_temp < 10 ? year_temp == 0 ? "00" : "0" + String(year_temp) : String(year_temp)
        
        return year_str.appending("年" + month_str + "月").appending(day_str + "日")
    }
    
    static func nameStringForSpecfile() -> String {
        let hour_temp: Int = Date().hour + 8 > 24 ? Date().hour - 16 : Date().hour + 8
        let minute_temp: Int = Date().minute
        let second_temp: Int = Date().second
        
        
        let day_temp: Int = Date().day
        let month_temp: Int = Date().month
        let year_temp: Int = Date().year
        
        let hour_str: String = hour_temp < 10 ? hour_temp == 0 ? "00" : "0" + String(hour_temp) : String(hour_temp)
        let minute_str: String = minute_temp < 10 ? minute_temp == 0 ? "00" : "0" + String(minute_temp) : String(minute_temp)
        let second_str: String = second_temp < 10 ? second_temp == 0 ? "00" : "0" + String(second_temp) : String(second_temp)
        let day_str: String = day_temp < 10 ? day_temp == 0 ? "00" : "0" + String(day_temp) : String(day_temp)
        let month_str: String = month_temp < 10 ? month_temp == 0 ? "00" : "0" + String(month_temp) : String(month_temp)
        let year_str: String = year_temp < 10 ? year_temp == 0 ? "00" : "0" + String(year_temp) : String(year_temp)
        
        return year_str.appending(month_str).appending(day_str).appending(hour_str).appending(minute_str).appending(second_str)
    }
    
    static func saveSpecDataToFolder(folderName: String, specFile: specFile) {
        let documentPath = util.createFolder(folderName: folderName)

        let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(specFile) {
                let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appending(path: folderName).appendingPathComponent(specFile.name)
                try? encoded.write(to: url)
            }
        
//        let dir = documentPath+"/"+"\(Date().hour + 8 > 24 ? Date().hour - 16 : Date().hour + 8)"+"."+"\(Date().minute)"+"."+"\(Date().second).csv"
//        let stream = OutputStream(toFileAtPath: dir, append: false)!
//        let csv = try! CSVWriter(stream: stream)
//        for i in 0..<Spec_Array_temp.count{
//            try! csv.write(row: ["\(index)nm","\(Spec_Array_temp[i])"])
//        }
        //csv.stream.close()
    }
    
    static func readSpecDataToFolder(folderName: String, name: String) -> specFile{
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appending(path: folderName).appendingPathComponent(name)
            if let data = try? Data(contentsOf: url) {
                let decoder = JSONDecoder()
                if let decoded = try? decoder.decode(specFile.self, from: data) {
                    return decoded
                }
            }
        return specFile(name: "", value: [], date: "", time: "", imageData: CHART_IMAGE.pngData()!)
    }
    
    static func allDataInFolderByName(folderName: String) -> [String]{
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let fileManager = FileManager.default
        let folderPath = documentPath.appending("/" + folderName)
        if fileManager.fileExists(atPath: folderPath) {
        do {
        let contents = try fileManager.contentsOfDirectory(atPath: folderPath)
        var arrayNames: [String] = []
        for content in contents {
//        if content.hasSuffix(".csv") { // 仅遍历 .plist 文件
//            let name = content.replacingOccurrences(of: ".csv", with: "")
//            arrayNames.append(name)
//            }
            arrayNames.append(content)
        }
            return arrayNames
        } catch {
            print("无法获取文件夹内容: (error.localizedDescription)")
        }
        } else {
        print("文件夹不存在")
        }
        return []
    }
    
    static func findModelName() {
        let fileManager = FileManager.default
        let folderPath = mainFilePath.appending("深度学习模型") // 新文件夹的路径名
        let items = try! fileManager.contentsOfDirectory(atPath: folderPath)

        for item in items {
            if item.hasSuffix(".csv") {
                trainedModelName.append(item)
            }
        }
        //print(trainedModelName)
        
    }
}
