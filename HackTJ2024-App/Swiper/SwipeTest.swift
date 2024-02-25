//
//  SwipeTest.swift
//  HackTJ2024
//
//  Created by Armaan Ahmed on 2/24/24.
//

import SwiftUI

struct SwipeTest: View {
    
    @State var stock: Stock
    @State var offset = CGSize.zero
    @State var color: Color = .black
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Card(stock: stock, color: $color)
                    Spacer()
                }
                Spacer()
            }
        }
        .offset(x: offset.width, y: offset.height * 0.4)
        .rotationEffect(.degrees(Double(offset.width / 40)))
        .gesture(
            DragGesture()
                .onChanged({ gesture in
                    offset = gesture.translation
                    withAnimation {
                        changeColor(width: offset.width)
                    }
                })
                .onEnded({ _ in
                    swipeCard(width: offset.width)
                    changeColor(width: offset.width)
                })
        )
//        .background(K.colors.grayGreen)
    }
    func swipeCard(width: CGFloat) {
        switch width {
        case -500...(-150):
            print("\(stock.name) removed")
            offset = CGSize(width: -500, height: 0)
        case 150...500:
            var current = JSON().value([Stock].self, "stocks.json") ?? []
            if !current.contains(stock) {
                current.append(stock)
            }
            do {
                try JSON().save(current, fileName: "stocks.json")
            } catch {
                print(error)
                return
            }
            print("\(stock.name) added")
            offset = CGSize(width: 500, height: 0)
        default:
            offset = .zero
        }
    }
    
    func changeColor(width: CGFloat) {
        switch width {
        case -500...(-130):
            color = .red
        case 130...500:
            color = .green
        default:
            color = .black
        }
    }
}

struct Card: View {
    
    var width = CGFloat(360)
    var height = CGFloat(600)
    
    @State var stock: Stock
    @Binding var color: Color
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: width, height: height)
                .cornerRadius(30)
                .foregroundColor(color)
                .shadow(radius: 10)
            VStack(spacing: 15) {
                HStack {
                    Text("\(stock.name) (\(stock.symbol))")
                        .padding([.top, .leading, .trailing], 30)
                        .padding([.bottom], 5)
                        .font(.system(size: 32, weight: .heavy))
                        .foregroundColor(.white)
                }
                ChartView(symbol: stock.symbol)
                Text("Safety score: " + String(stock.risk) + "%")
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundColor(.white)
                    .padding([.leading, .trailing])
                Text(stock.description)
                    .font(.system(size: 15, weight: .heavy))
                    .foregroundColor(.white)
                    .padding([.leading, .trailing])
                Spacer()
            }
            .frame(width: width, height: height)
        }
    }
}

#Preview {
    SwipeTest(stock: Stock(name: "Apple", symbol: "AAPL", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Nulla at volutpat diam ut venenatis tellus. Lacinia at quis risus sed vulputate odio ut enim blandit.", risk: 12.2))
}
