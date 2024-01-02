//
//  LineCard.swift
//  LineChart
//
//  Created by András Samu on 2019. 08. 31..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI

public struct LineChartView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var data:ChartData
    public var title: String
    public var legend: String?
    public var style: ChartStyle
    public var darkModeStyle: ChartStyle
    
    public var formSize:CGSize
    public var dropShadow: Bool
    public var valueSpecifier:String
    
    public var interactive:Bool
    private var intHeader: Bool = true
    
    @State private var touchLocation:CGPoint = .zero
    @State private var showIndicatorDot: Bool = false
    @State private var currentValue: Double = -1.0 {
        didSet{
            if (oldValue != self.currentValue && showIndicatorDot) {
                HapticFeedback.playSelection()
            }
            
        }
    }
    var frame = CGSize(width: UIScreen.main.bounds.size.width, height: 120)
    private var rateValue: Int?
    
    public init(data: [Double],
                title: String,
                legend: String? = nil,
                style: ChartStyle = Styles.lineChartStyleOne,
                form: CGSize?,
                rateValue: Int? = nil,
                dropShadow: Bool? = true,
                valueSpecifier: String? = "%.2f",
                interactive: Bool = false,
                intHeader: Bool? = true) {
        
        self.data = ChartData(points: data)
        self.title = title
        self.legend = legend
        self.style = style
        self.interactive = interactive
        self.darkModeStyle = style.darkModeStyle != nil ? style.darkModeStyle! : Styles.lineViewDarkMode
        self.formSize = form!
        frame = CGSize(width: self.formSize.width, height: self.formSize.height/2)
        self.dropShadow = dropShadow!
        if let value = data.first {
            if value > 2.0 {
                self.valueSpecifier = "%.2f"
            } else if value > 0.01 {
                self.valueSpecifier = "%.6f"
            } else {
                self.valueSpecifier = "%.8f"
            }
        } else {
            self.valueSpecifier = "%.2f"
        }
        self.rateValue = rateValue
        self.intHeader = intHeader ?? false
    }
    
    public var body: some View {
        ZStack(alignment: .center){
            RoundedRectangle(cornerRadius: 20)
                .fill(self.colorScheme == .dark ? self.darkModeStyle.backgroundColor : self.style.backgroundColor)
            VStack(alignment: .leading){
                Text(self.title)
                    .font(.system(size: 18))
                    .bold()
                    .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.textColor : self.style.textColor)
                HStack{
                    Spacer()
                    if self.currentValue == -1 {
                        let points = self.data.onlyPoints()
                        Text(self.intHeader == true ? "\(Int(points.last ?? 0.0))" : "\(points.last ?? 0.0, specifier: "%0.8f")")
                            .font(.system(size: 14, weight: .bold, design: .default))
                            .offset(x: 0, y: 30)
                    } else {
                        Text(self.intHeader == true ? "\(Int(self.currentValue))" : "\(self.currentValue, specifier: "%0.8f")")
                        .font(.system(size: 14, weight: .bold, design: .default))
                        .offset(x: 0, y: 30)
                    }
                    Spacer()
                }
                .padding(.top, -30.0)
                GeometryReader{ geometry in
                    Line(data: self.data,
                         frame: .constant(geometry.frame(in: .local)),
                         touchLocation: self.$touchLocation,
                         showIndicator: self.$showIndicatorDot,
                         minDataValue: .constant(nil),
                         maxDataValue: .constant(nil)
                    )
                    .padding(.bottom, 10.0)
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
            }

        }
        .gesture(DragGesture()
        .onChanged({ value in
            if self.interactive {
                self.touchLocation = value.location
                self.showIndicatorDot = true
                self.getClosestDataPoint(toPoint: value.location, width:self.frame.width, height: self.frame.height)
            }
        })
            .onEnded({ value in
                if self.interactive {
                    self.showIndicatorDot = false
                }
            })
        )
    }
    
    @discardableResult func getClosestDataPoint(toPoint: CGPoint, width:CGFloat, height: CGFloat) -> CGPoint {
        let points = self.data.onlyPoints()
        if points.count == 0 { return .zero }
        let stepWidth: CGFloat = width / CGFloat(points.count-1)
        let stepHeight: CGFloat = height / CGFloat(points.max()! + points.min()!)
        
        let index:Int = Int(round((toPoint.x)/stepWidth))
        if (index >= 0 && index < points.count){
            self.currentValue = points[index]
            return CGPoint(x: CGFloat(index)*stepWidth, y: CGFloat(points[index])*stepHeight)
        }
        return .zero
    }
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LineChartView(data: [8,23,54,32,12,37,7,23,43], title: "Line chart", legend: "Basic", form: CGSize.init(width: 350, height: 300))
                .environment(\.colorScheme, .light)
        }
    }
}
