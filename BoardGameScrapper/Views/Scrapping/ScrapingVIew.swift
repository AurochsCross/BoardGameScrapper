//
//  ScrapingVIew.swift
//  BoardGameScrapper
//
//  Created by Petras Malinauskas on 2021-02-04.
//

import SwiftUI

struct ScrapingView: View {
    @StateObject var scrapeManager: ScrappingManager
    
    @State var isScrapping = false
    @State var status = "None"
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Settings")
                        .font(.title)
                    HStack {
                        Text("Chunk size")
                        TextField("Chunk size", text: $scrapeManager.chunk)
                            .frame(maxWidth: 100)
                    }
                    HStack {
                        Toggle("Limit", isOn: $scrapeManager.limitEnabled)
                        if scrapeManager.limitEnabled {
                            TextField("Limit", text: $scrapeManager.limit)
                                .frame(maxWidth: 100)
                        }
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Sources")
                        .font(.title)
                    
                    Toggle("stalozaidimai.eu", isOn: $scrapeManager.shouldScrapeStaloZaidimaiEu)
                    Toggle("rikis.eu", isOn: $scrapeManager.shouldScrapeRikis)
                }
            }
            
            HStack {
                Button(action: scrapeManager.scrape) {
                    Text(!isScrapping ? "Start scrapping" : "Stop scrapping")
                }
                Button(action: scrapeManager.clearDatabase) {
                    Text("Clear database")
                }
            }
            
            Divider()
                .frame(width: 300)
            
            VStack(alignment: .leading) {
                Text("Results")
                    .font(.title)
                
                Text("Status: \(scrapeManager.scrapingState.stateString)")
                Text("Scrapped: \(scrapeManager.productsScraped)")
            }
        }
        .padding()
        .frame(minWidth: 300)
    }
}

struct ScrapingView_Previews: PreviewProvider {
    static var previews: some View {
        ScrapingView(scrapeManager: ScrappingManager())
    }
}
