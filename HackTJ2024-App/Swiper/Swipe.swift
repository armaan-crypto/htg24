//
//  Swipe.swift
//  HackTJ2024
//
//  Created by Armaan Ahmed on 2/24/24.
//

import SwiftUI
import AlertToast

struct Swipe: View {
    
    @State var stocks: [Stock] = []
    @State var loading = false
    var body: some View {
        VStack{
            ZStack{
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                    }
                    Spacer()
                }
                .background(K.colors.grayGreen)
                ForEach(stocks.reversed(), id: \.self) { stock in
                    SwipeTest(stock: stock)
                }
            }
            Spacer()
        }
        .background(K.colors.grayGreen)
        .task {
            await fillStocks()
        }
        .toast(isPresenting: $loading) {
            AlertToast(displayMode: .alert, type: .loading)
        }
        
    }
    
    func fillStocks() async {
        do {
            loading = true
            var s = [Stock(name: "Apple", symbol: "AAPL", description: "", risk: 0.0), Stock(name: "Amphenol", symbol: "APH", description: "", risk: 0.0), Stock(name: "HP", symbol: "HPQ", description: "", risk: 0.0), Stock(name: "IBM", symbol: "IBM", description: "", risk: 0.0), Stock(name: "Ansys", symbol: "ANSS", description: "", risk: 0.0), Stock(name: "Applied Materials", symbol: "AMAT", description: "", risk: 0.0), Stock(name: "Lam", symbol: "LRCX", description: "", risk: 0.0),
                     Stock(name:"Mastercard", symbol:  "MA", description: "", risk:   0.0),
                     Stock(name: "NetApp", symbol: "NTAP", description: "", risk: 0.0),
                     Stock(name:"PTC", symbol:"PTC", description: "", risk: 0.0),
                     Stock(name: "Qualcomm", symbol: "QCOM", description: "", risk: 0.0),
                     Stock(name: "Salesforce", symbol: "CRM", description: "", risk: 0.0),
                     Stock(name: "Teradyne", symbol: "TER", description: "", risk: 0.0)]
            
            for si in 0...(s.count - 1) {
                var stock = s[si]
                let urlString = "https://htg24.vercel.app/api/describe?symbol=" + (stock.symbol.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")
                let url = URL(string: urlString)!
                let (data, response) = try await URLSession.shared.data(from: url)
                print(String(data: data, encoding: .utf8))
                let res = try JSONDecoder().decode(DataResponse.self, from: data)
                stock.description = res.description.replacingOccurrences(of: "*", with: "")
                stock.risk = res.risk
                loading = false
                withAnimation {
                    stocks.append(stock)
                }
            }
        } catch { print(error) }
    }
    
}

#Preview {
    Swipe()
}

struct Stock: Hashable, Codable, Comparable {
    static func < (lhs: Stock, rhs: Stock) -> Bool {
        return lhs.symbol < rhs.symbol
    }
    
    let name: String
    let symbol: String
    var description: String
    var risk: Double
    
}

struct DataResponse: Codable {
    let description: String
    let risk: Double
}
