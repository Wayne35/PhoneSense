//
//  FlagsParas.swift
//  specDemo
//
//  Created by Yiyum on 2023/2/10.
//

import Foundation
import SwiftUI

let mainFilePath: String = util.createFolder(folderName: "")

//一般组件所占最大屏款
let MAX_WIDTH: CGFloat = 360

//当前选择的样品类型
var TYPE_SELECTED: String = "啤酒"

//保存的图表图片
var CHART_IMAGE: UIImage = UIImage(systemName: "heart.fill")!

//当前要分类的光谱数据
var SPEC_DATA_CLASSIFY: [Double] = []

//用于保存四组数组，元素为RGBPoints，仅用于显示在Chart
var R_DATA: [RGBPoints] = []
var G_DATA: [RGBPoints] = []
var B_DATA: [RGBPoints] = []
var GRAY_DATA: [RGBPoints] = []
var SPEC_DATA: [RGBPoints] = []

//用于保存四组数组，仅用于显示在Chart
var R_Array: [Double] = []
var G_Array: [Double] = []
var B_Array: [Double] = []
var Gray_Array: [Double] = []
var Spec_Array: [Double] = []
var Spec_Array_temp: [Double] = []
var RGB_DATA: [[Double]] = [R_Array, G_Array, B_Array, Gray_Array]

//用于存放真酒和待检酒的光谱
var truth_Array: [Double] = []
var unknown_Array: [Double] = []

var COMBINE_DATA = [
    (type: "red", data: R_DATA),
    (type: "green", data: G_DATA),
    (type: "blue", data: B_DATA)
]

var GRAY_PLOT_DATA = [
    (type: "gray", data: GRAY_DATA)
]

var SPEC_PLOT_DATA = [
    (type: "spec", data: SPEC_DATA)
]

//用于存取数据库中啤酒的种类
var NumToBearType: [Int: String] = [:]

//用于读取所有的模型
var trainedModelName: [String] = []

//用于读取

var colorEnum: [Color] = [
    Color.red,
    Color.orange,
    Color.yellow,
    Color.green,
    Color.cyan,
    Color.blue,
    Color.purple
]
