//
//  StopWatchView.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 25.04.23.
//

import SwiftUI
import Charts

struct StopWatchView: View {
    @EnvironmentObject var stopWatchManager: StopWatchManager
    
    @State var selectedDetent: PresentationDetent = .large
    @State var isShowListSheet = false
    
    @State var devideSizeWidth: CGFloat = 0
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Spacer()
                ring()
                    .frame(width: (proxy.size.width/2))
                Spacer()
                HStack {
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 60)
                        
                        Button(stopWatchManager.isRunning ? "Stop" : "Start"){
                            if stopWatchManager.isRunning {
                                stopWatchManager.stop()
                            } else {
                                stopWatchManager.start()
                            }
                        }
                    }
                }
                
                Spacer()
                
                TimerChartScrolling(devideSizeWidth)
                    .frame(maxWidth: .infinity, maxHeight: 200)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // EditButton()
                }
                ToolbarItem {
                    Button(action: { isShowListSheet.toggle() }) {
                        Label("", systemImage: "list.star")
                    }
                }
            }
            .sheet(isPresented: $isShowListSheet) {
                ListSheetContent()
                    .presentationDetents([.large], selection: $selectedDetent)
                    .presentationDragIndicator(.visible)
            }
            .fullSizeCenter()
            .onAppear{
                devideSizeWidth = proxy.size.width
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
    
    
    @ViewBuilder
    func ring() -> some View {
        let angleGradient = AngularGradient(colors: [.white.opacity(0.5), .blue.opacity(0.5)], center: .center, startAngle: .degrees(-90), endAngle: .degrees(360))
        
        ZStack {
            
            if stopWatchManager.isRunning {
                
                Text(stopWatchManager.fetchStartTime()!, style: .timer)
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
            } else {
                Text("0:00")
                    .font(.system(size: 50))
            }
            
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 5))
                .foregroundStyle(.white)
                .overlay {
                    // Foreground ring
                    Circle()
                        .trim(from: 0, to: 0.5 )
                        .stroke(angleGradient, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                }
                .rotationEffect(.degrees(-90))
        }
        .padding(.bottom, 20)
        
        HStack{
            Spacer()
            VStack(alignment: .center){
                Text(stopWatchManager.totalProtheseTimeYesterday)
                    .font(.system(size: 20))
                    .multilineTextAlignment(.center)
                Text("Gester")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 200)
            Spacer()
            VStack(alignment: .center){
                Text(stopWatchManager.totalProtheseTimeToday)
                    .font(.system(size: 20))
                    .multilineTextAlignment(.center)
                Text("Heute")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 200)
            Spacer()
        }
        .padding(.bottom, 20)
    }
    
    @ViewBuilder
    func ListSheetContent() -> some View {
        List {
            HStack{
                Spacer()
                VStack(alignment: .center){
                    Text(stopWatchManager.totalProtheseTimeYesterday)
                        .font(.system(size: 35))
                    Text("Gester")
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack(alignment: .center){
                    Text(stopWatchManager.totalProtheseTimeToday)
                        .font(.system(size: 35))
                    Text("Heute")
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .listRowBackground(Color.white.opacity(0.01))
            
            HStack{
                Text("Aufgezeichnete Zeit")
                Spacer()
                Text("Datum")
            }
            .listRowBackground(Color.white.opacity(0.2))
            
            
            ForEach(stopWatchManager.timesArray, id: \.timestamp) { time in
                HStack {
                    Text(stopWatchManager.convertSecondsToHrMinuteSec(seconds: Int(time.duration) ))
                    Spacer()
                    Text("\(time.timestamp!.formatted(.dateTime.hour().minute())) Uhr -")
                    Text("\(time.timestamp!.formatted(.dateTime.day().month()))")
                    
                }
                .listRowBackground(Color.white.opacity(0.05))
            }
            .onDelete(perform: stopWatchManager.deleteItems)
            
        }
        .refreshable {
            do {
                stopWatchManager.refetchTimesData()
            }
        }
        .background{
            AppConfig().backgroundGradient
        }
        .ignoresSafeArea()
        .scrollContentBackground(.hidden)
        .foregroundColor(.white)
    }
    
    @ViewBuilder
    func TimerChartScrolling(_ devideSizeWidth: CGFloat) -> some View {
        ScrollViewReader { value in
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    Chart() {
                        
                        /*  RuleMark(y: .value("Durchschnitt", stepCounterManager.avgSteps(steps: stopWatchManager.mergedTimesArray) ) )
                         .foregroundStyle(.orange.opacity(0.5))
                         */
                        RuleMark(x: .value("ActiveSteps", stopWatchManager.activeDateCicle ) )
                            .foregroundStyle(stopWatchManager.activeisActive ? .white.opacity(1) : .white.opacity(0.2))
                            .offset(stopWatchManager.dragAmount)
                        
                        ForEach(stopWatchManager.mergedTimesArray, id: \.id) { t in
                            AreaMark(
                                x: .value("Dates", t.date),
                                y: .value("Steps", t.duration)
                            )
                            .interpolationMethod(.catmullRom)
                            .foregroundStyle(
                                .linearGradient(
                                    colors: [
                                        Color(red: 167/255, green: 178/255, blue: 210/255).opacity(0),
                                        Color(red: 167/255, green: 178/255, blue: 210/255).opacity(0.1),
                                        Color(red: 167/255, green: 178/255, blue: 210/255).opacity(0.5)
                                    ],
                                    startPoint: .bottom,
                                    endPoint: .top)
                            )
                            
                            LineMark(
                                x: .value("Dates", t.date),
                                y: .value("Steps", t.duration)
                            )
                            .interpolationMethod(.catmullRom)
                            .symbol {
                                ZStack{
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 10)
                                        .shadow(radius: 2)
                                    
                                    if stopWatchManager.activeDateCicle == t.date {
                                        Circle()
                                            .stroke(Color.white, lineWidth: 2)
                                            .frame(width: 20)
                                            .shadow(radius: 2)
                                    }
                                }
                            }
                            .foregroundStyle(
                                .linearGradient(
                                    colors: [
                                        Color(red: 167/255, green: 178/255, blue: 210/255).opacity(0.5),
                                        Color(red: 167/255, green: 178/255, blue: 210/255)
                                    ],
                                    startPoint: .bottom,
                                    endPoint: .top)
                            )
                            .lineStyle(.init(lineWidth: 5))
                        }
                    }
                    .chartOverlay { proxy in
                        GeometryReader { geometry in
                            ZStack(alignment: .top) {
                                Rectangle().fill(.clear).contentShape(Rectangle())
                                    .onTapGesture { location in updateSelectedStep(at: location, proxy: proxy, geometry: geometry) }
                                    .gesture( DragGesture().onChanged { value in
                                        // find start and end positions of the drag
                                        let start = geometry[proxy.plotAreaFrame].origin.x
                                        let xStart = value.startLocation.x - start
                                        let xCurrent = value.location.x - start
                                        // map those positions to X-axis values in the chart
                                        if let dateCurrent: Date = proxy.value(atX: xCurrent) {
                                            stopWatchManager.activeDateCicle = dateCurrent //(dateStart, dateCurrent)
                                            withAnimation(.easeIn(duration: 0.2)){
                                                stopWatchManager.activeisActive = true
                                            }
                                        }
                                        updateSelectedStep(at: CGPoint(x: value.location.x, y: value.location.y) , proxy: proxy, geometry: geometry)
                                    }.onEnded { value in
                                        withAnimation(.easeOut(duration: 0.2)){
                                            stopWatchManager.activeisActive = false
                                        }
                                        updateSelectedStep(at: value.predictedEndLocation, proxy: proxy, geometry: geometry)
                                    } )
                            }
                        }
                    }
                    .chartYAxis {
                        let sec = stopWatchManager.mergedTimesArray.map { $0.duration }
                        let min = sec.min() ?? 1000
                        let max = sec.max() ?? 20000
                        //let consumptionStride = Array(stride(from: min, through: max, by: (max - min)/3))
                        let test = Array(stride(from: min, to: max, by: 5808))
                        AxisMarks(position: .trailing, values: test) { axis in
                            AxisGridLine(stroke: StrokeStyle(lineWidth: 2,
                                                             lineCap: .butt,
                                                             lineJoin: .bevel,
                                                             miterLimit: 3,
                                                             dash: [5],
                                                             dashPhase: 1))
                        }
                        
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day, count: 1)) { value in
                            AxisGridLine(stroke: StrokeStyle(lineWidth: 0.3))
                            
                            if value.count > 7 {
                                AxisValueLabel(format: .dateTime.day().month())
                            } else {
                                AxisValueLabel(format: .dateTime.weekday())
                            }
                            
                            
                        }
                    }
                    .chartYScale(domain: 0...43200)
                    // .chartXScale(domain: 0...2)
                    .chartYScale(range: .plotDimension(padding: 20))
                    .chartXScale(range: .plotDimension(padding: 30))
                    .frame(maxWidth: .infinity)
                }
                .frame(width: devideSizeWidth)
            }
            .frame(width: devideSizeWidth)
        }
    }
    
    func updateSelectedStep(at location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) {
        let xPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        guard let date: Date = proxy.value(atX: xPosition) else {
            return
        }
        
        stopWatchManager.activeDateCicle = stopWatchManager.mergedTimesArray.sorted(by: {
            abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date))
        }).first?.date ?? Date()
        
    }
}