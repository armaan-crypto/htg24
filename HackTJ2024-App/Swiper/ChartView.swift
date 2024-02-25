//
//  ChartView.swift
//  HackTJ2024
//
//  Created by Armaan Ahmed on 2/24/24.
//

import SwiftUI
import Charts

struct ChartView: View {
    
    @State var symbol: String
    @State private var stockData: [StockData] = []
    @State var minimumValue = 0.0
    @State var maximumValue = 0.0

      var body: some View {
          VStack {
              if stockData.count > 0 {
                  Chart(stockData) { data in
                      LineMark(x: .value("timestamp", data.timestamp), y: .value("price", data.price))
                          .interpolationMethod(.linear)
                          .foregroundStyle(K.colors.green)
                  }
                  .chartXAxis {
                      AxisMarks(values: .automatic) {
                          AxisValueLabel()
                              .foregroundStyle(Color.white)// <= change the style of the label
                          
                          AxisGridLine()
                              .foregroundStyle(Color.white)// <= change the style of the line
                      }
                  }
                  .chartYAxis {
                      AxisMarks(values: .automatic) {
                          AxisValueLabel()
                              .foregroundStyle(Color.white)// <= change the style of the label
                          
                          AxisGridLine()
                              .foregroundStyle(Color.white)// <= change the style of the line
                      }
                  }
                  .chartYScale(domain: minimumValue...maximumValue)
                  .frame(width: 320, height: 200)
                  .cornerRadius(30)
              } else {
                  ZStack {
                      Rectangle()
                          .frame(width: 320, height: 200)
                          .foregroundStyle(.white)
                          .cornerRadius(30)
                      ProgressView()
                  }
              }
          }
        .task {
            do {
                let (s, mi, ma) = try await fetchStockData()
                minimumValue = mi
                maximumValue = ma
                withAnimation {
                    stockData = s
                }
            } catch {
                print(error)
            }
        }
      }
    
    func fetchStockData() async throws -> ([StockData], Double, Double) {
        
        let urlString = "https://query1.finance.yahoo.com/v8/finance/chart/\(symbol)?range=1y&interval=1d&indicators=quote"
        
        guard let url = URL(string: urlString) else { return ([], 0, 0) }
        let (data, response) = try await URLSession.shared.data(from: url)
        let chartData = try JSONDecoder().decode(ChartData.self, from: data)
        guard chartData.chart.result.count > 0 else { return ([], 0, 0) }
        let result = chartData.chart.result[0]
        let length = result.timestamp.count
        
        var sd = [StockData]()
        var minimum = 1000000000.0
        var maximum = 0.0
        for i in 0...(length - 1) {
            let p = result.indicators.quote[0].high[i]
            sd.append(StockData(timestamp: Date(timeIntervalSince1970: TimeInterval(result.timestamp[i])), price: p))
            minimum = min(minimum, p)
            maximum = max(maximum, p)
        }
        return (sd, minimum - 5, maximum + 5)
    }
}


#Preview {
    ChartView(symbol: "AAPL")
}

struct StockData: Identifiable {
  let id = UUID()
  let timestamp: Date
  let price: Double
}
