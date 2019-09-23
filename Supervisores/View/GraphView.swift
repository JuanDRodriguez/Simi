//
//  GraphView.swift
//  Supervisores
//
//  Created by Sharepoint on 7/10/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit
import CorePlot
class GraphView: BaseView {
    @IBOutlet weak var hostView: UIView!
    var graphView: CPTGraphHostingView!
    var axisTitleStyle = CPTMutableTextStyle()
    var axisLineStyle = CPTMutableLineStyle()
    var axisTextStyle = CPTMutableTextStyle()
    var axisThickLineStyle = CPTMutableLineStyle()
    var axisGridLineStyle = CPTMutableLineStyle()
    var axisSet : CPTXYAxisSet!
    var items: [IndicatorItem] = []
    var time: [String] = []
    override func awakeFromNib() {
        
    }
    func initPlot() {
        configureHostView()
        configureGraph()
        configurePlot()
        configureAxes()
    }
    func configureGraph() {
        let graph = CPTXYGraph(frame: hostView.frame)
        graph.apply(CPTTheme.init(named: CPTThemeName.plainWhiteTheme))
        graph.paddingLeft = 0.0
        graph.paddingTop = 3.0
        graph.paddingRight = 0.0
        graph.paddingBottom = 3.0
        graph.plotAreaFrame!.borderLineStyle = nil;
        graph.plotAreaFrame!.masksToBorder = false;
        graphView.hostedGraph = graph
        
    }
    func configureHostView() {
        let parentFrame = hostView.frame
       graphView = CPTGraphHostingView.init(frame: parentFrame)
        graphView.allowPinchScaling = false
        hostView.addSubview(graphView)
    }
    func setDsiplay(items: [IndicatorItem], time: [String]){
        self.items = items
        //print("Tamaño array: \(time.count)")
        self.time = time
        initPlot()
    }
}
extension GraphView: CPTPlotDataSource{
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return 3
    }
    
    func configurePlot() {
        let graph = graphView.hostedGraph!
        var plotSpace: CPTXYPlotSpace = graph.defaultPlotSpace as! CPTXYPlotSpace
        plotSpace.allowsUserInteraction = false
        var actualPlot = CPTScatterPlot()
        actualPlot.dataSource = self
        actualPlot.identifier  = "actual" as NSCoding & NSCopying & NSObjectProtocol
        var colorActual : CPTColor = CPTColor.init(componentRed: 237/255.0, green: 63/255.0, blue: 68/255.0, alpha: 1)
        graph.add(actualPlot, to: plotSpace)
        var lastPlot = CPTScatterPlot()
        lastPlot.dataSource = self
        lastPlot.identifier = "last" as NSCoding & NSCopying & NSObjectProtocol
        var lastColor : CPTColor = CPTColor.init(componentRed: 64/255.0, green: 154/255.0, blue: 231/255.0, alpha: 1)
        graph.add(lastPlot, to: plotSpace)
        plotSpace.scale(toFit: [actualPlot,lastPlot])
        var  xRange: CPTMutablePlotRange = plotSpace.xRange.mutableCopy() as! CPTMutablePlotRange
        xRange.locationDecimal = CPTDecimalFromFloat(-0.5)
        xRange.lengthDecimal = CPTDecimalFromInt(3)
        xRange.expand(byFactor: NSNumber(cgFloat: CPTDecimalCGFloatValue(1.0)))
        plotSpace.xRange = xRange
        
        let yRange: CPTMutablePlotRange = plotSpace.xRange.mutableCopy() as! CPTMutablePlotRange
        var location:Int32 =  Int32(truncating: xRange.location)
        var length: Int32 = Int32(truncating: yRange.length)
        length -= location
        location = 3
        yRange.locationDecimal = CPTDecimalFromInt(location)
        yRange.lengthDecimal = CPTDecimalFromInt(length);
        yRange.expand(byFactor: NSNumber(cgFloat: CPTDecimalCGFloatValue(0.8)))
        
        let actualLine: CPTMutableLineStyle = actualPlot.dataLineStyle?.mutableCopy() as! CPTMutableLineStyle
        actualLine.lineWidth=2.0;
        actualLine.lineColor = colorActual
        actualLine.lineCap = CGLineCap.round
        actualLine.lineJoin = CGLineJoin.round
        actualPlot.dataLineStyle = actualLine
        
        let latLine: CPTMutableLineStyle = lastPlot.dataLineStyle?.mutableCopy() as! CPTMutableLineStyle
        latLine.lineWidth=2.0;
        latLine.lineColor = lastColor
        latLine.lineCap = CGLineCap.round
        latLine.lineJoin = CGLineJoin.round
        //actualLine.miterLimit=3.0;
        lastPlot.dataLineStyle = latLine
        var style: CPTMutableTextStyle
        style = CPTMutableTextStyle()
        style.color = CPTColor.black()
        style.fontSize = 9.0
        style.fontName = "Helvetica-Bold"
        let actualyear: String = String(items[5].Anio)
        var x  = NSNumber.init(value: 2.10)
        var y = NSNumber.init(value: self.items[5].Valor)
        var anchorPoint = [x,y]
        
        var actualAnnotation: CPTPlotSpaceAnnotation = CPTPlotSpaceAnnotation.init(plotSpace: plotSpace, anchorPlotPoint: anchorPoint)
        var actualText : CPTTextLayer = CPTTextLayer.init(text: actualyear, style: style)
        actualAnnotation.contentLayer = actualText;
        var lasYear: String = String(self.items[2].Anio)
        x  = NSNumber.init(value: 2.15)
        y = NSNumber.init(value: self.items[2].Valor)
        anchorPoint = [x,y]
        var lastAnnotation: CPTPlotSpaceAnnotation = CPTPlotSpaceAnnotation.init(plotSpace: plotSpace, anchorPlotPoint: anchorPoint)
        var lastText : CPTTextLayer = CPTTextLayer.init(text: lasYear, style: style)
        lastAnnotation.contentLayer = lastText;
        actualPlot.graph?.plotAreaFrame?.addAnnotation(actualAnnotation)
        actualPlot.graph?.plotAreaFrame?.addAnnotation(lastAnnotation)
    }
    
}
extension GraphView: CPTAxisDelegate{
  
    func configureAxes() {
        axisLineStyle = CPTMutableLineStyle()
        axisLineStyle.lineWidth = 1.0
        axisLineStyle.lineColor = CPTColor.init(genericGray: 183/255.0)
        axisTextStyle = CPTMutableTextStyle()
        axisTextStyle.color = CPTColor.init(genericGray: 65/255.0)
        axisTextStyle.fontName = "Helvetica-Bold"
        axisTextStyle.fontSize = 12.0
        axisTextStyle.textAlignment = CPTTextAlignment.center
        axisThickLineStyle = CPTMutableLineStyle()
        axisThickLineStyle.lineWidth = 1.0
        axisThickLineStyle.lineColor = CPTColor.init(genericGray: 183/255.0)
        axisGridLineStyle = CPTMutableLineStyle()
        axisGridLineStyle.lineWidth = 1.0
        axisGridLineStyle.lineColor = CPTColor.init(genericGray: 183/255.0)
        axisSet = (self.graphView.hostedGraph?.axisSet as! CPTXYAxisSet)
        var xAxis: CPTAxis = self.axisSet.xAxis!
        xAxis.labelingPolicy = CPTAxisLabelingPolicy.fixedInterval
        xAxis.titleTextStyle = axisTitleStyle;
        xAxis.axisLineStyle = axisLineStyle;
        xAxis.labelTextStyle = axisTextStyle;
        xAxis.majorTickLineStyle = nil;
        xAxis.majorTickLength = 3.0;
        xAxis.majorIntervalLength = CPTDecimalFromInt(1) as! NSNumber;
        xAxis.minorTickLineStyle = nil;
        xAxis.minorTicksPerInterval=1;
        xAxis.tickDirection = CPTSign.negative
        xAxis.majorGridLineStyle = nil;
        xAxis.minorGridLineStyle = axisGridLineStyle;
        xAxis.delegate=self;
        var yAxis: CPTAxis = axisSet.yAxis!
        yAxis.titleTextStyle = nil
        yAxis.axisLineStyle = nil
        yAxis.labelTextStyle = nil
        yAxis.labelingPolicy = CPTAxisLabelingPolicy.none
        yAxis.majorTickLineStyle = nil
        yAxis.majorTickLength = 1.0
        yAxis.majorGridLineStyle = axisGridLineStyle
        
    }
    func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
        let index: Int = Int((plot.identifier as! String == "actual" ? 3:0)+idx)
        
        switch fieldEnum {
        case 0:
            return idx
            break
        case 1:
            return items[index].Valor
            break
        default:
            return NSDecimalNumber.zero
        }
        
    }
    
    
}
