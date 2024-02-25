//
//  PreferencesPicker.swift
//  HackTJ2024
//
//  Created by Armaan Ahmed on 2/24/24.
//

import SwiftUI

struct PreferencesPicker: View {
    
    var industries = ["Industrials", "Health Care", "Information Technology", "Communication Services", "Consumer Staples", "Consumer Discretionary", "Utilities", "Financials", "Materials", "Real Estate", "Energy"]
    @State var selectedIndustry = "Industrials"
    
    var risk = ["Low Risk", "Medium Risk", "High Risk"]
    @State var selectedRisk = "Low Risk"
    
    @State var firstName = ""
    @State var lastName = ""
    @State var email = ""
    
    @State var shouldAdvance = false
    
    var body: some View {
        VStack {
            List {
                Section("User Information") {
                    TextField("First name", text: $firstName)
                    TextField("Last name", text: $lastName)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .onChange(of: email) { value in
                            email = email.lowercased()
                        }
                }
                Section("Preferences") {
                    Picker("Desired Industry", selection: $selectedIndustry) {
                        ForEach(industries, id: \.self) { industry in
                            Text(industry).tag(industry)
                        }
                    }
                    
                    Picker("Risk Index", selection: $selectedIndustry) {
                        ForEach(risk, id: \.self) { value in
                            Text(value).tag(value)
                        }
                    }
                }
            }
            
            NavigationLink(destination: MainTabView().navigationBarBackButtonHidden(), isActive: $shouldAdvance) { EmptyView() }

            Button {
                K.saved.save(firstName, to: K.saved.ids.firstName)
                K.saved.save(lastName, to: K.saved.ids.lastName)
                K.saved.save(email, to: K.saved.ids.email)
                K.saved.save(email, to: K.saved.ids.email)
                K.saved.save(selectedRisk, to: K.saved.ids.risk)
                shouldAdvance = true
            } label: {
                HStack {
                    Spacer()
                    Text("Continue")
                        .foregroundStyle(K.colors.blue)
                        .fontWeight(.heavy)
                    Spacer()
                }
                .padding()
                .cornerRadius(20)
            }
            .background(K.colors.green)
            .cornerRadius(20)
            .padding()
        }
        .background(Color(uiColor: .systemGray6))
        .navigationTitle("Create an Account")
    }
}

#Preview {
    NavigationView {
        PreferencesPicker()
    }
}
