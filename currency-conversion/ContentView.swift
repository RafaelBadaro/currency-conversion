//
//  ContentView.swift
//  currency-conversion
//
//  Created by Rafael Badaró on 16/04/24.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @State private var coin1: String = ""
    @State private var coin2: String = ""
    @State private var isCoin1FieldFocused = false
    @State private var isCoin2FieldFocused = false
    
    @State private var conversionRate: Double = 185.44
    
    var body: some View {
        VStack {
            VStack{
                Button(action: {
                    getCurrentRate()
                }) {
                    Text("Atualizar taxa de conversao")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }.padding()
                
                Text("Taxa de conversao: R$ 1  = \(String(format:"%.2f", conversionRate)) CLP")
            }.padding()
            
            
            VStack{
                HStack{
                    Text("R$")
                    TextField("Enter BRL", text: $coin1, onEditingChanged: setFocusCoin1)
                        .padding()
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: coin1) { newValue in
                            if isCoin1FieldFocused {
                                if let value = Double(newValue.replacingOccurrences(of: ",", with: ".")) {
                                    coin2 = format(
                                        value: String(format: "%.2f", value * conversionRate)
                                    )
                                    
                                } else {
                                    coin2 = ""
                                }
                            }
                        }
                }
            }
            
            VStack{
                HStack{
                    Text("CLP")
                    TextField("Enter CLP", text: $coin2, onEditingChanged: setFocusCoin2)
                        .padding()
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: coin2) { newValue in
                            
                            if isCoin2FieldFocused {
                                if let value = Double(newValue.replacingOccurrences(of: ",", with: ".")) {
                                    coin1 = format(
                                        value: String(format:"%.2f",value/conversionRate)
                                        
                                    )
                                } else {
                                    coin1 = ""
                                }
                            }
                        }
                }
                
            }
            
        }
        .padding()
        
    }
    
    func format(value: String) -> String {
        let numberFormatted = Decimal(string: value)?.formatted()
        return "\(String(describing: numberFormatted!))"
    }
    
    func setFocusCoin1(focused: Bool) {
        isCoin1FieldFocused = focused
    }
    
    func setFocusCoin2(focused: Bool) {
        isCoin2FieldFocused = focused
    }
    
    func getCurrentRate(){
        let url = URL(string: "https://v6.exchangerate-api.com/v6/API_KEY/pair/BRL/CLP")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if error != nil {
                print("Deu erro na requisicao")
                
            }
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let pairConversion = try decoder.decode(PairConversionModel.self, from: data)
                
                if let rate = pairConversion.conversionRate {
                    conversionRate = rate
                    coin1 = ""
                    coin2 = ""
                }
            } catch let err {
                print("Erro no parse: ", err)
            }
        }
        
        task.resume()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
