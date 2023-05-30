//
//  cameraView.swift
//  specDemo
//
//  Created by Yiyum on 2023/2/8.
//

import SwiftUI

//UIKit 桥接
struct UIBridge: UIViewControllerRepresentable {
    
    //这个UIViewControllerType你要接哪个就是哪个，在这里就是viewController
    typealias UIViewControllerType = cameraSub
    @EnvironmentObject var settings: APP_SETTING
    
    //必须实现的方法，当swiftUI要显示view时，会调用这个方法。返回值就是当前需要显示的类
    func makeUIViewController(context: UIViewControllerRepresentableContext<UIBridge>) -> UIBridge.UIViewControllerType {
        let viewController = cameraSub()
                // 传递模型对象到 UIViewController
        viewController.settings = settings
        return viewController
    }
    //更新UIViewController时会调用此方法
    func updateUIViewController(_ uiViewController: cameraSub, context: UIViewControllerRepresentableContext<UIBridge>) {
    }
}

struct cameraSubView: View {

    let settings = APP_SETTING()
    var body: some View {
        UIBridge()
            .environmentObject(settings)
    }
}

struct cameraSubView_Previews: PreviewProvider {
    static var previews: some View {
        cameraSubView()
    }
}
