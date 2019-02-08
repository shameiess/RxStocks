//
//  DrawerViewController.swift
//  Stocks
//
//  Created by Kevin Nguyen on 1/9/19.
//  Copyright © 2019 Kevin Nguyen. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass
import Charts

class DrawerViewController: UIViewController {
    
    lazy var momentumView: GradientView = {
        let view = GradientView(topColor: UIColor(hex: 0x61A8FF), bottomColor: UIColor(hex: 0x243BD1))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.3, alpha: 1)
        view.cornerRadius = 30
        return view
    }()
    
    lazy var handleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        view.layer.cornerRadius = 3
        return view
    }()
    
    lazy var lineChartView: LineChartView = {
        let view = LineChartView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.delegate = self
        view.xAxis.labelTextColor = .white
        view.xAxis.labelPosition = XAxis.LabelPosition.bottom
        view.xAxis.valueFormatter = MinutesValueFormatter()
        view.rightAxis.labelTextColor = .white
        view.legend.textColor = .white
        view.setScaleEnabled(true)
        view.pinchZoomEnabled = true
        view.highlightPerDragEnabled = true
        view.chartDescription = nil
        return view
    }()
    
    lazy var marker: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .black
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    func setChart(dataPoints: [Double], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        
        for (index, x) in dataPoints.enumerated() {
            let dataEntry = ChartDataEntry(x: x, y: values[index])
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: nil)
        lineChartDataSet.lineWidth = 2
        lineChartDataSet.drawFilledEnabled = true
        lineChartDataSet.highlightColor = UIColor.sky
        lineChartDataSet.highlightLineWidth = 1
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        lineChartDataSet.drawCirclesEnabled = false
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
    }
    
    let panRecognizer = InstantPanGestureRecognizer()
    var animator = UIViewPropertyAnimator()
    var isOpen = false
    var animationProgress: CGFloat = 0
    var closedTransform = CGAffineTransform.identity
    var fullyClosedTransform = CGAffineTransform.identity
    
    var symbol: String = "PHUN"
    var isFullyClosed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)

        setupDrawer()
        
        // Server
//        AlphaVantageAPI().fetchIntraday(symbol: "PHUN", minInterval: 60) { (data, error) in
        AlphaVantageAPI().fetchDaily(symbol: symbol) { (data, error) in
            guard let data = data?.timeSeriesDaily else { return }
            let dateCloseTuple = data.map({ (key: String, value: TimeSeriesDaily) -> (Double, Double) in
                let x = key.toDate(format: "yyyy-MM-dd")?.timeIntervalSince1970
                let y = Double(value.close!)
                return (x!, y!)
            }).sorted(by: { $0.0 < $1.0 })
            let dates = Array(dateCloseTuple.map { $0.0 }.suffix(7))
            let closingValues = Array(dateCloseTuple.map { $0.1 }.suffix(7))
            
            DispatchQueue.main.async {
                self.setChart(dataPoints: dates, values: closingValues)
            }
        }
        
        momentumView.addSubview(lineChartView)
        lineChartView.topAnchor.constraint(equalTo: momentumView.topAnchor, constant: 100).isActive = true
        lineChartView.widthAnchor.constraint(equalTo: momentumView.widthAnchor).isActive = true
        lineChartView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        momentumView.addSubview(marker)
        marker.bottomAnchor.constraint(equalTo: lineChartView.topAnchor, constant: 10).isActive = true
        marker.widthAnchor.constraint(equalTo: lineChartView.widthAnchor, constant: 10).isActive = true
        marker.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}

extension DrawerViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let x = dateFormatter.string(from: Date(timeIntervalSince1970: entry.x))
        marker.text = "\(x) at \(entry.y)"
    }
}

extension DrawerViewController: UIGestureRecognizerDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != momentumView && touch?.view != lineChartView {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}
