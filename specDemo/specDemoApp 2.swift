//
//  specDemoApp.swift
//  specDemo
//
//  Created by Yiyum on 2023/2/8.
//

import SwiftUI

@main
struct specDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.colorScheme, .light)
        }
    }
    
    init() {
        util.createFolder(folderName: "深度学习模型")
        util.findModelName()
        // 要保存的工程文件路径
//        let projectFilePath = Bundle.main.path(forResource: "Beer_svm_model.mlmodel", ofType: nil)!
//        //let projectFilePath = "Beer_svm_model"
//
//        // 要保存的文件名
//        let fileName = "深度学习模型"
//
//        // 获取Document目录路径
//        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//            // 目标文件路径
//            let fileURL = documentDirectory.appendingPathComponent(fileName)
//
//            do {
//                // 将工程文件复制到目标文件路径中
//                try FileManager.default.copyItem(atPath: projectFilePath, toPath: fileURL.path)
//            } catch {
//                print("Error: \(error.localizedDescription)")
//            }
//        }

    }
}
