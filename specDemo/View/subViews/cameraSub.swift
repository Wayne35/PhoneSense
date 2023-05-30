//
//  cameraSubView.swift
//  specDemo
//
//  Created by Yiyum on 2023/2/25.
//

import UIKit
import AVFoundation
import Charts
import CSV
import SwiftDate
import SwiftUI

class cameraSub: UIViewController{
   
    @ObservedObject var settings = APP_SETTING()
    //定义最后坐标的起始位置和范围
    var start:Int = 0
    var len:Int = 800
    var outputOfSpec:[Double]! = []
    //判断有没有放样品
    var stage1: Bool = true
    var stage2: Bool = false
    static var initComplete: Bool = false
    static var Sample: Bool = false
    var investigateStage: Int = 0
    //缓存区和缓存区长度
    var isDenoiseEnable: Bool = true
    var len_buffer: Int = 15
    var gray_buffer: [[Double]]! = [[]]
    var basic_buffer: [[Double]]! = [[]]
    //初始化位置需要用到两个数组
    var init1:[Double]! = []
    var init2:[Double]! = []
    var init1_buffer:[[Double]]! = [[]]
    var init2_buffer:[[Double]]! = [[]]
    //定义数据数组
    var gray: [Double]! = []
    var basic_gray: [Double]! = []

    let WIDTH = 1080
    let HEIGHT = 1920
    // 音视频采集会话
    let captureSession = AVCaptureSession()
    // 当前正在使用的设备
    var currentDevice: AVCaptureDevice?
    // 静止图像输出端
    var stillImageOutput: AVCaptureStillImageOutput?
    // 相机预览图层
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    //当前是否是鉴别真假模式
    static var isInvestigateMode: Bool = false

    @IBOutlet weak var warn: UITextView!
        //定义计时器
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        //print(settings?.UI_switch)
         //获取设备，创建UI
        CreateUI()
        initRange()
//        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { Timer in
//
//        })
        NotificationCenter.default.addObserver(self, selector: #selector(pushYes), name: Notification.Name("ButtonPushed"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
        cameraSub.isInvestigateMode = false
        zoomReset()
        TorchOff()
    }
    
    func processImage() {
        // 获得音视频采集设备的连接
           let videoConnection = stillImageOutput?.connection(with: AVMediaType.video)
           // 输出端以异步方式采集静态图像
           stillImageOutput?.captureStillImageAsynchronously(from: videoConnection!, completionHandler: { (imageDataSampleBuffer, error) -> Void in
                // 获得采样缓冲区中的数据
               if imageDataSampleBuffer != nil{
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer!)

             // 将数据转换成UIImage
               if let stillImage = UIImage(data: imageData!){
                   self.fillArray(averageNum: 20, interval: 10, image: stillImage)
                    }
               }
          })
    }

    func fillArray(averageNum: Int, interval: Int,image:UIImage){
        gray.removeAll()
        //basic_gray.removeAll()
        //init1.removeAll()
       // init2.removeAll()
        var r_collect = [Double]()
        var row_max = [Int]()
        //获取图片data
        let provider = image.cgImage!.dataProvider
        let providerData = provider!.data
        let data = CFDataGetBytePtr(providerData)
        //获取所有行的数据
        for i in 0..<HEIGHT/interval{
            var sum:Double = 0
            for j in 0..<WIDTH/interval{
                let x = interval*j
                let y = Int(interval*i) < HEIGHT-1 ? Int(interval*i) : HEIGHT-1
                sum += CGFloat(data![((HEIGHT * x) + y) * 4])/1.0
            }
            r_collect.append(sum)
        }
        //获取最亮的几行
            if averageNum<HEIGHT/interval{
                for _ in 0..<averageNum{
                    var max = 0
                    var index = 0
                    for j in 0..<(HEIGHT/interval-averageNum){
                        if r_collect[j]>Double(max){
                            max = Int(r_collect[j])
                            index = j
                        }
                    }
                    row_max.append(index)
                    r_collect[index] = 0
                }
            }else{
                return
            }
        //将最亮的几行均值化处理
         for i in 0..<WIDTH{
             var r:Double = 0
             var g:Double = 0
             var b:Double = 0
             for j in 0..<averageNum{
                 let x = WIDTH-i-1
                 let y = interval*row_max[j] < HEIGHT-1 ? interval*row_max[j] : HEIGHT-1
                 r += CGFloat(data![((HEIGHT * x) + y) * 4])/1.0
                 g += CGFloat(data![((HEIGHT * x) + y) * 4 + 1])/1.0
                 b += CGFloat(data![((HEIGHT * x) + y) * 4 + 2])/1.0
             }
             var sum:Double = 0
             sum += r*30
             sum += g*59
             sum += b*11 + 50
             sum = sum/Double((100*averageNum))
             if(!cameraSub.initComplete && stage1){
                 init1.append(sum)
             }else if(!cameraSub.initComplete && stage2){
                 init2.append(sum)
             }else if(cameraSub.Sample && cameraSub.initComplete){
                 gray.append(sum)
             }else if(!cameraSub.Sample && cameraSub.initComplete){
                 basic_gray.append(sum)
             }
         }
        if(!cameraSub.initComplete && stage1){
            init1_buffer.append(init1)
            init1_buffer.removeFirst()
        }else if(!cameraSub.initComplete && stage2){
            init2_buffer.append(init2)
            init2_buffer.removeFirst()
        }else if(cameraSub.Sample && cameraSub.initComplete){
            gray_buffer.append(gray)
            gray_buffer.removeFirst()
        }else if(!cameraSub.Sample && cameraSub.initComplete){
            basic_buffer.append(basic_gray)
            basic_buffer.removeFirst()
        }
    }
    func initRange(){
        //@EnvironmentObject var settings: APP_SETTING
        NotificationCenter.default.addObserver(self, selector: #selector(drawSpec), name: Notification.Name("initiated"), object: nil)
        var cnt:Int = 0
            timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true, block: { Timer in
                self.processImage()
                cnt += 1
                //print("focusDistance: \(self.currentDevice?.lensPosition)")
                //self.settings.progress = Float(cnt*100/(10*self.len_buffer))
                NotificationCenter.default.post(name: NSNotification.Progress, object: nil)
                if(cnt>self.len_buffer*2){
                    self.timer?.invalidate()
                    NotificationCenter.default.post(name: NSNotification.buttonEnable, object: nil)
                    NotificationCenter.default.post(name: Notification.Name("initiated"), object: nil)
                    NotificationCenter.default.removeObserver(self, name: Notification.Name("initiated"), object: nil)
                    cameraSub.initComplete = true
                }else if(cnt>self.len_buffer){
                    self.stage1 = false
                    self.stage2 = true
                }
            })
        }
    func findRange(spec:[Double],len:Int)->Int{
        var start:Int = 0
        var min: Double = 100000
        if(spec.count<=len){
            return 0
        }

        for i in 0..<spec.count-len{
            if(abs(spec[i] - spec[i + len]) < min) {
                start = i
                min = abs(spec[i] - spec[i + len])
            }
        }
        return start
    }
    //MARK: - 获取设备,创建自定义视图
    func CreateUI(){
        //创建缓存区
        for _ in 1...len_buffer{
            var row = [Double]()
            for _ in 1...WIDTH{
                row.append(0)
            }
            gray_buffer.append(row)
            basic_buffer.append(row)
            init1_buffer.append(row)
            init2_buffer.append(row)
        }
         // 将音视频采集会话的预设设置为高分辨率照片--选择照片分辨率
        self.captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        // 获取设备
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back){
            self.currentDevice = device
        }else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back){
            self.currentDevice = device
        }else{
            fatalError("missing camera")
        }
        try?  currentDevice?.lockForConfiguration()
        currentDevice?.setExposureModeCustom(duration: CMTimeMake(value: 1, timescale: 50), iso: 40, completionHandler: nil)
          do {
                // 当前设备输入端
             let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
              self.stillImageOutput = AVCaptureStillImageOutput()
            // 输出图像格式设置
              self.stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecType.jpeg]
              
            self.captureSession.addInput(captureDeviceInput)
            self.captureSession.addOutput(self.stillImageOutput!)
             
            }catch {
             print(error)
              return
            }
           // 创建预览图层
         self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
         self.view.layer.addSublayer(cameraPreviewLayer!)
        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        self.cameraPreviewLayer?.frame = CGRect(x: 20, y: 50, width: 350, height: 250)
        
        self.cameraPreviewLayer?.masksToBounds = true;
        self.cameraPreviewLayer?.cornerRadius = 30;
        
         //启动音视频采集的会话
        self.captureSession.startRunning()
        //打开闪光灯
        TorchOn()
        //放大
        zoom(zoomFactor: 5.0)
    }
    
    @objc func drawSpec(){
        var spec = [Double]()
        if(!cameraSub.initComplete){
            var temp = [Double]()
        for i in 0..<WIDTH{
            var init1_sum:Double =  0
            var init2_sum:Double = 0
              for k in 0..<len_buffer{
                  init1_sum += init1_buffer[k][i]/Double(len_buffer)
                  init2_sum += init2_buffer[k][i]/Double(len_buffer)
              }
             spec.append(init1_sum/init2_sum)
            temp.append(init2_sum)
        }
            start = findRange(spec: temp, len: Int(self.len))
            //print(start)
            
        }else{
            let documentPath = util.createFolder(folderName: "光谱数据")
            let dir = documentPath+"/"+"\(Date().hour + 8 > 24 ? Date().hour - 16 : Date().hour + 8)"+"\(Date().minute)"+"\(Date().second).csv"
            let stream = OutputStream(toFileAtPath: dir, append: false)!
            let csv = try! CSVWriter(stream: stream)
            var temp: [Double] = []
            for i in start..<start + len{
                var sum: Double = 0
                var basic_sum: Double = 0
                for k in 0..<len_buffer{
                sum += gray_buffer[k][i]/Double(len_buffer)
                basic_sum += basic_buffer[k][i]/Double(len_buffer)
                }
                Spec_Array.append(sum/basic_sum)
                //temp.append(sum)
                //print("\(i): \(temp[i-start])")
            }
            
            Spec_Array = util.smooth(window: 5, array: Spec_Array)
            Spec_Array_temp = Spec_Array
            for i in 0..<Int(len){
                var index = Int(480+((140*i)/len))
                SPEC_DATA.append(RGBPoints(index: i, value: Spec_Array[i]))
                try! csv.write(row: ["\(index)nm","\(Spec_Array[i])"])
            }
            SPEC_PLOT_DATA = [
                (type: "spec", data: SPEC_DATA)
            ]
            if(cameraSub.isInvestigateMode) {
                if(investigateStage == 1) {
                    truth_Array.removeAll()
                    truth_Array = Spec_Array
                } else if(investigateStage == 2) {
                    unknown_Array.removeAll()
                    unknown_Array = Spec_Array
                    cameraSub.isInvestigateMode = false
                    NotificationCenter.default.post(name: NSNotification.truthAndUnknownEnable, object: nil)
                }
            }
            NotificationCenter.default.post(name: NSNotification.drawSpec, object: nil)
            //NotificationCenter.default.removeObserver(self, name: Notification.Name("processed"), object: nil)
            NotificationCenter.default.post(name: NSNotification.buttonEnable, object: nil)
            SPEC_DATA.removeAll()
            Spec_Array.removeAll()
            csv.stream.close()
        }
      }
    @objc func pushYes() {
        var cnt:Int = 0
        if(!cameraSub.Sample){
            timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true, block: { Timer in
                self.processImage()
                cnt += 1
                //print("focusDistance: \(self.currentDevice?.lensPosition)")
                //self.settings.progress = Float(100*cnt/(2*self.len_buffer))
                NotificationCenter.default.post(name: NSNotification.Progress, object: nil)
                if(cnt>self.len_buffer*2){
                    NotificationCenter.default.post(name: NSNotification.buttonEnable, object: nil)
                    cameraSub.Sample = true
                    cnt = 0
                    self.timer?.invalidate()
                    //self.textview.text = "请在放置样品后再按“确认”，过程中轻拿轻放。"
                }
            })
        }else if(cameraSub.Sample){
            NotificationCenter.default.addObserver(self, selector: #selector(drawSpec), name: Notification.Name("processed"), object: nil)
            timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true, block: { Timer in
                self.processImage()
                cnt += 1
                //print("focusDistance: \(self.currentDevice?.lensPosition)")
                NotificationCenter.default.post(name: NSNotification.Progress, object: nil)
                //self.settings.progress = Float(100/(2*self.len_buffer))
                
                if(cnt>self.len_buffer*2){
                    self.investigateStage += 1

                    NotificationCenter.default.post(name: NSNotification.buttonEnable, object: nil)
                    self.timer?.invalidate()
                    NotificationCenter.default.post(name: Notification.Name("processed"), object: nil)
                    NotificationCenter.default.removeObserver(self, name: Notification.Name("processed"), object: nil)
                }
            })
        }
    }
}

extension cameraSub: UITextFieldDelegate,AVCapturePhotoCaptureDelegate{
    //MARK: - 缩放方法
    @objc func zoom(zoomFactor: Float) {
        do {
        try currentDevice?.lockForConfiguration()
            currentDevice?.ramp(toVideoZoomFactor: min(10.0,CGFloat(zoomFactor)), withRate: 123.0)
            currentDevice?.unlockForConfiguration()
            }
        catch {
            print(error)
        }
    }
    
    func zoomReset() {
        do {
            try currentDevice?.lockForConfiguration()
            currentDevice?.ramp(toVideoZoomFactor: 1.0, withRate: 123.0)
            currentDevice?.unlockForConfiguration()
        }
        catch {
            print(error)
        }
    }
    
    //MARK: - 开启闪光灯
    func TorchOn(){
       try? currentDevice?.lockForConfiguration()
        if ((currentDevice?.isTorchAvailable) != nil) {
            currentDevice?.torchMode = .on
        }
        currentDevice?.unlockForConfiguration()
    }
    //MARK: - 关闭闪光灯
    func TorchOff(){
      try?  currentDevice?.lockForConfiguration()
        if ((currentDevice?.isTorchAvailable) != nil) {
            currentDevice?.torchMode = .off
        }
        currentDevice?.unlockForConfiguration()
    }
}
extension NSNotification {
    static let Progress = Notification.Name.init("progress")
    static let drawSpec = Notification.Name.init("drawSpec")
    static let buttonEnable = Notification.Name.init("buttonEnable")
    static let truthAndUnknownEnable = Notification.Name.init("TAUEanble")
    static let saveChartViewAsImage = Notification.Name.init("saveChart")
}

