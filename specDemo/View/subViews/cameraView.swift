//
//  cameraView.swift
//  specDemo
//
//  Created by Yiyum on 2023/2/8.
//

import SwiftUI

//UIKit 桥接
struct UIBridging: UIViewControllerRepresentable {
    
    //这个UIViewControllerType你要接哪个就是哪个，在这里就是viewController
    typealias UIViewControllerType = camera
    //必须实现的方法，当swiftUI要显示view时，会调用这个方法。返回值就是当前需要显示的类
    func makeUIViewController(context: UIViewControllerRepresentableContext<UIBridging>) -> UIBridging.UIViewControllerType {
        return camera()
    }
    //更新UIViewController时会调用此方法
    func updateUIViewController(_ uiViewController: camera, context: UIViewControllerRepresentableContext<UIBridging>) {
    }
}

struct cameraView: View {
    var body: some View {
        UIBridging()
    }
}

struct cameraView_Previews: PreviewProvider {
    static var previews: some View {
        cameraView()
    }
}
