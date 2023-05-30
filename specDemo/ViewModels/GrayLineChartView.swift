//
//  RGBLineChartView.swift
//  specDemo
//
//  Created by Yiyum on 2023/2/9.
//

import SwiftUI
import Charts

struct GrayLineChartView: UIViewRepresentable {
    
    let entries: [ChartDataEntry]
    
    func makeUIView(context: Context) -> Charts.LineChartView {
        return LineChartView()
    }
    
    func updateUIView(_ uiView: Charts.LineChartView, context: Context) {
        let dataSet = LineChartDataSet(entries: entries)
        uiView.data = LineChartData(dataSet: dataSet)
    }

}

struct GrayLineChartView_Previews: PreviewProvider {
    static var previews: some View {
        RGBLineChartView(entries: RGBPoints.dataEntries(points: RGBPoints.allPoints))
    }
}
