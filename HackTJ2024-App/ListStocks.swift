//
//  ListStocks.swift
//  HackTJ2024
//
//  Created by Armaan Ahmed on 2/25/24.
//

import SwiftUI

struct ListStocks: View {
    
    @State var stocks: [Stock] = []
    
    var body: some View {
        List {
            ForEach(stocks, id: \.self) { stock in
                Text(stock.name + " (" + stock.symbol + ")")
            }
        }
        .background(K.colors.grayGreen)
        .scrollContentBackground(.hidden)
        .onAppear(perform: {
            stocks = []
            fillStocks()
        })
    }
    
    func fillStocks() {
        let s = JSON().value([Stock].self, "stocks.json") ?? []
        for si in s {
            withAnimation {
                stocks.append(si)
            }
        }
    }
}

#Preview {
    ListStocks()
}
