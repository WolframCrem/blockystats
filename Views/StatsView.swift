//
//  StatsView.swift
//  Blocky Stats
//
//  Created by Yoxt on 05/09/2022.
//

import SwiftUI


class ViewModel: ObservableObject {
    @Published var stopLoop:Bool = false
    @Published var stats: Stats = Stats(Total: 0, Blocked: 0, TopClients: [Gafam(Name: "Loading...", Count: 0)], Gafam: [Gafam(Name: "Loading...", Count: 0)])
    @objc func fetch_stats() {
        // check if userdefaults is nil
        if let endpoint = UserDefaults.standard.array(forKey: "endpoint") {
            guard let url = URL(string: "https://\(endpoint)/v1/stats") else {
                return
            }
            let task = URLSession.shared.dataTask(with: url) {data, response, error in
                    
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let stats = try decoder.decode(Stats.self, from: data)
                    DispatchQueue.main.async {
                        self.stats = stats;
                    }
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        } else {
            stopLoop = true;
        }
    }
}

struct StatsView: View {
    @StateObject var viewModel = ViewModel()

    
    var body: some View {
        VStack(spacing: 25) {
            // branding & settings icon
            HStack(alignment: .bottom) {
                Text("Blocky").bold().font(.system(size: 40)).padding().padding(.leading, 20).foregroundColor(.white);
                Spacer()
            }.frame(maxWidth: .infinity ,maxHeight: 70, alignment: .topLeading).padding(.top, 50)
            // scrollview with all the elements
            ScrollView {
                // total requests box
                VStack(alignment: .leading) {
                    Text("Total Requested").font(.system(size: 15)).fontWeight(Font.Weight.semibold).foregroundColor(.white).opacity(0.6).padding(.leading, 5)
                    HStack {
                        Text(String(viewModel.stats.Total)).bold().font(.system(size: 32)).foregroundColor(Color("green")).padding()
                    }.frame(maxWidth: .infinity, maxHeight: 70).background(Color("lightgray")).cornerRadius(10)
                }.frame(maxWidth: .infinity ,maxHeight: 200, alignment: .topLeading).padding(.leading, 45).padding(.trailing, 45).padding(.bottom, 20)
                
                // total blocked requests box
                VStack(alignment: .leading) {
                    Text("Total Blocked").font(.system(size: 15)).fontWeight(Font.Weight.semibold).foregroundColor(.white).opacity(0.6).padding(.leading, 5)
                    HStack {
                        Text(String(viewModel.stats.Blocked)).bold().font(.system(size: 32)).foregroundColor(Color("red")).padding()
                    }.frame(maxWidth: .infinity, maxHeight: 70).background(Color("lightgray")).cornerRadius(10)
                }.frame(maxWidth: .infinity ,maxHeight: 200, alignment: .topLeading).padding(.leading, 45).padding(.trailing, 45).padding(.bottom, 20)
                
                //top clients box
                VStack(alignment: .leading) {
                    Text("Top Clients").font(.system(size: 15)).fontWeight(Font.Weight.semibold).foregroundColor(.white).opacity(0.6).padding(.leading, 5)
                    HStack {
                        ScrollView {
                            // create all clients
                            
                        
                            ForEach(viewModel.stats.TopClients, id: \.self) { client in
                                ClientName(name: client.Name, count: client.Count, divider: true)
                            }
                            //TODO: add loading indicator when data hasn't loaded yet
                            
                        }/*.scrollIndicators(.hidden)*/.padding(.top, 13).padding(.bottom, 13)
                    }.frame(maxWidth: .infinity, maxHeight: 150).background(Color("lightgray")).cornerRadius(10)
                }.frame(maxWidth: .infinity ,maxHeight: 200, alignment: .topLeading).padding(.leading, 45).padding(.trailing, 45).padding(.bottom, 20)
                
                //Gafam
                VStack(alignment: .leading) {
                    Text("Gafam").font(.system(size: 15)).fontWeight(Font.Weight.semibold).foregroundColor(.white).opacity(0.6).padding(.leading, 5)
                    VStack {
                        
                        ForEach(Array(zip(viewModel.stats.Gafam.indices, viewModel.stats.Gafam)), id: \.0) { index, client in
                          // Add Code here
                            // first element
                            if (viewModel.stats.Gafam[0] == client) {
                                ClientName(name: client.Name, count: client.Count, divider: true).padding(.top, 13)
                            }
                            else {
                                ClientName(name: client.Name, count: client.Count, divider: true)
                            }
                        }
                    }.frame(maxWidth: .infinity, maxHeight: 300).background(Color("lightgray")).cornerRadius(10)
                }.frame(maxWidth: .infinity ,maxHeight: 200, alignment: .topLeading).padding(.leading, 45).padding(.trailing, 45).padding(.bottom, 140)
                Spacer()
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("gray")).edgesIgnoringSafeArea(.top)
        .onAppear{
            // send first request
            viewModel.fetch_stats()
            // start timet to refresh every 10 seconds
            //TODO: make it configurable
            if (viewModel.stopLoop != true) {
                Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { _ in
                    viewModel.fetch_stats()
                })
            }
        }.alert(isPresented: $viewModel.stopLoop, content: {
            Alert(title: Text("Error"), message: Text("endpoint has not been set"), dismissButton: .default(Text("OK")) )
        })
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}

struct ClientName: View {
    let name: String
    let count: Int64
    let divider: Bool
    var body: some View {
            VStack {
                HStack {
                    Text(name).font(.system(size: 22)).fontWeight(Font.Weight.semibold)
                    Spacer()
                    Text(String(count)).font(.system(size: 16)).fontWeight(Font.Weight.semibold).opacity(0.65)
                }.padding(.leading, 13).padding(.trailing, 13)
                if divider {
                    Divider().background(.white)
                }
            }
        }
}

struct Stats: Codable {
    let Total, Blocked: Int
    let TopClients, Gafam: [Gafam]

    enum CodingKeys: String, CodingKey {
        case Total
        case Blocked
        case TopClients
        case Gafam
    }
}

struct Gafam: Codable, Hashable {
    let Name: String
    let Count: Int64

    enum CodingKeys: String, CodingKey {
        case Name
        case Count
    }
}
