//
//  LogsView.swift
//  Blocky Stats
//
//  Created by Yoxt on 05/09/2022.
//

import SwiftUI


class LogsModel: ObservableObject {
    @Published var logs = LogsObject(Logs: [], LastTimestamp: "")
    @objc func fetch_logs(first: Bool) {
        var requestUrl = ""
        if (first) {
            requestUrl = "https://\(UserDefaults.standard.string(forKey: "endpoint")!)/v1/logs/recent"
        } else {
            requestUrl = "https://\(UserDefaults.standard.string(forKey: "endpoint")!)/v1/logs/recent?last=\(logs.LastTimestamp)"
        }
        guard let url = URL(string: requestUrl) else {
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: url) {data, response, error in
                
        if let data = data {
            do {
                let decoder = JSONDecoder()
                let logs = try decoder.decode(LogsObject.self, from: data)
                DispatchQueue.main.async {
                    // add extra items if timestamp is not empty
                    if (first) {
                        self.logs = logs;
                    }
                    else {
                        self.logs.Logs.append(contentsOf: logs.Logs)
                        self.logs.LastTimestamp = logs.LastTimestamp
                    }
                }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
}


struct LogsView: View {
    @StateObject var logsModel = LogsModel()
    
    var body: some View {
        VStack(spacing: 25) {
            // branding & settings icon
            HStack(alignment: .bottom) {
                Text("Blocky").bold().font(.system(size: 40)).padding().padding(.leading, 20).foregroundColor(.white);
                Spacer()
            }.frame(maxWidth: .infinity ,maxHeight: 70, alignment: .topLeading).padding(.top, 50)
            HStack {
                Text("Latest Logs").font(.system(size: 15)).fontWeight(Font.Weight.semibold).foregroundColor(.white).opacity(0.6).padding(.leading, 50)
                Spacer()
            }
            ScrollView {
                // Latest Logs
                
                ForEach(logsModel.logs.Logs, id: \.self.Id) { log in
                    Log(clientName: log.ClientName, status: log.ResponseType, domain: log.Question, duration: log.Duration)
                }
                Button {
                    logsModel.fetch_logs(first: false)
                } label: {
                    Text("Load More").bold()
                }.padding(.top, 15).padding(.bottom, 20)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("gray")).edgesIgnoringSafeArea(.top).onAppear {
            logsModel.fetch_logs(first: true)
        }
    }
}


struct Log: View {
    let clientName: String
    let status: String
    let domain: String
    let duration: Int
    var body: some View {
        VStack(alignment: .leading) {
            // domain element
            HStack {
                Text(domain).font(.system(size: 13)).padding(.leading, 12).padding(.top, 10).padding(.bottom, 1).padding(.trailing, 12)
                Spacer()
            }
            HStack {
                Text(clientName).font(.system(size: 15)).fontWeight(Font.Weight.semibold).opacity(0.7).foregroundColor(Color(.white))
                Spacer()
                // check if status is resolved
                if (status == "RESOLVED") {
                    Text("Resolved").font(.system(size: 15)).fontWeight(Font.Weight.semibold).foregroundColor(Color("green"))
                    // Text("Resolved in \(duration)ms").font(.system(size: 15)).fontWeight(Font.Weight.semibold).foregroundColor(Color("green"))
                }
                // check if status is resolved
                if (status == "BLOCKED") {
                    Text("Blocked").font(.system(size: 15)).fontWeight(Font.Weight.semibold).foregroundColor(Color("red"))
                    //Text("Blocked in \(duration)ms").font(.system(size: 15)).fontWeight(Font.Weight.semibold).foregroundColor(Color("red"))
                }
                if (status == "CACHED") {
                    Text("Cached").font(.system(size: 15)).fontWeight(Font.Weight.semibold).foregroundColor(Color("blue"))
                    //Text("Cached in \(duration)ms").font(.system(size: 15)).fontWeight(Font.Weight.semibold).foregroundColor(Color("blue"))
                }
            }.padding(.leading,  12).padding(.bottom, 10).padding(.trailing, 12)
        }.frame(maxWidth: .infinity, maxHeight: 80).background(Color("lightgray")).padding(.leading, 10).padding(.trailing, 10).cornerRadius(15)
    }
}

struct LogsObject: Codable {
    var Logs: [RequestLog]
    var LastTimestamp: String

    enum CodingKeys: String, CodingKey {
        case Logs
        case LastTimestamp
    }
}

struct RequestLog: Codable, Hashable {
    let ClientName: String
    let ResponseType: String
    let Question: String
    let Duration: Int
    let Id: String

    enum CodingKeys: String, CodingKey {
        case ClientName
        case ResponseType
        case Question
        case Duration
        case Id
    }
}

struct LogsView_Previews: PreviewProvider {
    static var previews: some View {
        LogsView()
    }
}


