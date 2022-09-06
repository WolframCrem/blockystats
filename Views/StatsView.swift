//
//  StatsView.swift
//  Blocky Stats
//
//  Created by Yoxt on 05/09/2022.
//

import SwiftUI

struct StatsView: View {
    
    
    
    var body: some View {
        VStack(spacing: 25) {
            // branding & settings icon
            HStack(alignment: .bottom) {
                Text("Blocky").bold().font(.system(size: 40)).padding().padding(.leading, 20).foregroundColor(.white);
                Spacer()
                Image(systemName: "gear").resizable()
                    .scaledToFill()
                    .frame(width: 25, height: 25).padding(.top, 10).padding(.trailing, 40).padding(.bottom, 24).foregroundColor(.white).onTapGesture {
                        print("Tapped settings icon")
                    }
            }.frame(maxWidth: .infinity ,maxHeight: 70, alignment: .topLeading).padding(.top, 50)
            ScrollView {
                // total requests box
                VStack(alignment: .leading) {
                    Text("Total Requested").font(.system(size: 15)).fontWeight(Font.Weight.semibold).foregroundColor(.white).opacity(0.6).padding(.leading, 5)
                    HStack {
                        Text("120392").bold().font(.system(size: 32)).foregroundColor(Color("green")).padding()
                    }.frame(maxWidth: .infinity, maxHeight: 70).background(Color("lightgray")).cornerRadius(10)
                }.frame(maxWidth: .infinity ,maxHeight: 200, alignment: .topLeading).padding(.leading, 45).padding(.trailing, 45).padding(.bottom, 20)
                
                // total blocked requests box
                VStack(alignment: .leading) {
                    Text("Total Blocked").font(.system(size: 15)).fontWeight(Font.Weight.semibold).foregroundColor(.white).opacity(0.6).padding(.leading, 5)
                    HStack {
                        Text("2048").bold().font(.system(size: 32)).foregroundColor(Color("red")).padding()
                    }.frame(maxWidth: .infinity, maxHeight: 70).background(Color("lightgray")).cornerRadius(10)
                }.frame(maxWidth: .infinity ,maxHeight: 200, alignment: .topLeading).padding(.leading, 45).padding(.trailing, 45)
                Spacer()
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("gray")).edgesIgnoringSafeArea(.top)
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
