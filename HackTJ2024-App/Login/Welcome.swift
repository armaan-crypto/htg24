//
//  Welcome.swift
//  HackTJ2024
//
//  Created by Armaan Ahmed on 2/24/24.
//

import SwiftUI

struct Welcome: View {
    @State var showView: Bool = false
    @State private var yOffset: CGFloat = UIScreen.main.bounds.height

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Welcome to FIN")
                    .padding([.bottom], 28)
                    .font(.system(size: 32, weight: .heavy))
                    .foregroundColor(.white)
                Spacer()
            }

            DetailView(title: "Market Data", text: "View stock information, interactive graphs, and other financial details associating with public companies.", image: "arrowshape.bounce.forward.fill")
                .offset(y: showView ? 3 : yOffset)

            DetailView(title: "Simplicity", text: "Navigate through stocks with just a swipe of your finger, easily accepting suggestions that catch your interest.", image: "person.fill.checkmark")
                .offset(y: showView ? 3 : yOffset)

            DetailView(title: "Learn", text: "Our app prioritizes the teaching of stocks and patters to teach users how to skillfully manage stocks.", image: "book.fill")
                .offset(y: showView ? 3 : yOffset)

            Spacer()

            NavigationLink {
                PreferencesPicker()
            } label: {
                HStack {
                    Spacer()
                    Text("Continue")
                        .font(.system(size: 18, weight: .heavy))
                        .foregroundColor(K.colors.blue)
                        .fontWeight(.black)
                        .bold()
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(K.colors.blue)
                        .fontWeight(.heavy)
                }
                .padding()
                .cornerRadius(20)
                .background(K.colors.green)
                .cornerRadius(20)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        withAnimation {
                            showView.toggle()
                        }
                    }
                }
            }
        }
        .padding()
        .background(K.colors.blue)
    }
}

fileprivate struct DetailView: View {
    
    @State var title: String
    @State var text: String
    @State var image: String
    
    var body: some View {
        HStack {
            Image(systemName: image)
                .font(.system(size: 50))
                .padding()
                .foregroundStyle(K.colors.green)
            VStack {
                HStack {
                    Text(title)
                        .font(.system(size: 24, weight: .bold))
                    Spacer()
                }
                HStack {
                    Text(text)
                    Spacer()
                }
            }
            .foregroundColor(.white)
        }
        .padding([.top, .bottom], 20)
    }
}

#Preview {
    NavigationView {
        Welcome()
    }
}
