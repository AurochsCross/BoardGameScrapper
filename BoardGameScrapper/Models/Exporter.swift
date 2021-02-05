//
//  Exporter.swift
//  BoardGameScrapper
//
//  Created by Petras Malinauskas on 2021-01-27.
//

import Foundation
import AppKit

class Exporter {
    func export(products: [ScrappedProduct]) {
        var textToExport = "Product name; Original value; Current value;\n"
        
        products.forEach { product in
            var line = "\"\(product.name)\";\(product.originalPrice ?? product.price);\(product.price);\n"
            line = line.replacingOccurrences(of: "'", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: ".", with: ",")
            
            textToExport += line
        }
        
        DispatchQueue.main.async {
            let savePanel = NSSavePanel()
            savePanel.canCreateDirectories = true
            savePanel.showsTagField = false
            savePanel.nameFieldStringValue = "result.csv"
            savePanel.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.modalPanelWindow)))
            savePanel.begin { (result) in
                if result == NSApplication.ModalResponse.OK {
                    let filename = savePanel.url
                    do {
                        try textToExport.write(to: filename!, atomically: true, encoding: String.Encoding.utf8)
                    } catch {
                        print("failed to write file (bad permissions, bad filename etc.")
                    }
                } else {
                    
                }
            }
        }
    }

}
