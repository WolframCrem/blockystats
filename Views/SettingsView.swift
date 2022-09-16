//
//  SettingsView.swift
//  Blocky Stats
//
//  Created by Yoxt on 22/10/2022.
//

import SwiftUI
struct SettingsView: View {
    
    let defaults = UserDefaults.standard
    
    @State private var Url: String = ""
    @State private var ApiKey: String = ""
    @State private var IgnoreSSL: Bool = false
    
    var body: some View {
        VStack(spacing: 25) {
            HStack(alignment: .bottom) {
                Text("Blocky").bold().font(.system(size: 40)).padding().padding(.leading, 20).foregroundColor(.white);
                Spacer()
            }.frame(maxWidth: .infinity ,maxHeight: 70, alignment: .topLeading).padding(.top, 50)
            HStack {
                Text("Settings").font(.system(size: 15)).fontWeight(Font.Weight.semibold).foregroundColor(.white).opacity(0.6).padding(.leading, 50)
                Spacer()
            }
            // text field for the endpoint
            VStack {
                HStack {
                    Text("API Endpoint").font(.system(size: 14))/*.fontWeight(Font.Weight.light)*/.padding(.leading, 55)
                    Spacer()
                }
                TextField("API Endpoint", text: $Url).disableAutocorrection(true).padding(.leading, 50).padding(.trailing, 50).textFieldStyle(.roundedBorder)
            }
            // disable ssl check checkbox
            VStack {
                Toggle("Disable SSL Checks", isOn: $IgnoreSSL).toggleStyle(.switch).font(.subheadline).padding(.trailing, 55).padding(.leading, 55)//.fontWeight(.light)
            }
            // text field for the apikey
            VStack {
                HStack {
                    Text("API Key").font(.system(size: 14))/*.fontWeight(Font.Weight.light)*/.padding(.leading, 55)
                    Spacer()
                }
                TextField("API Key", text: $ApiKey).disableAutocorrection(true).padding(.leading, 50).padding(.trailing, 50).textFieldStyle(.roundedBorder)
            }
            
            Button {
                defaults.set(Url, forKey: "endpoint")
                defaults.set(ApiKey, forKey: "apikey")
                defaults.set(IgnoreSSL, forKey: "SSL")
            } label: {
                Text("Save Changes").bold()
            }.padding(.top, 10).padding(.bottom, 20).buttonStyle(.borderedProminent).foregroundColor(.black)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("gray")).edgesIgnoringSafeArea(.top)
        .onAppear{
            Url = defaults.string(forKey: "endpoint") ?? ""
            ApiKey = defaults.string(forKey: "apikey") ?? ""
            IgnoreSSL = defaults.bool(forKey: "SSL")
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
