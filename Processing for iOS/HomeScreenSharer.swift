//
//  HomeScreenSharer.swift
//  Processing for iOS
//
//  Created by Frederik Riedel on 6/10/20.
//  Copyright © 2020 Frederik Riedel. All rights reserved.
//

import Foundation
import Swifter
import UIKit


class HomeScreenSharer: NSObject {
    
    private static let server = HttpServer()
    @objc static func share(sketch: SimpleTextProject) {
        
        server.stop()
        
        let sourceCode = sketch.htmlPage
        let base64 = sourceCode.base64
        
        server["load"] = { request in
            return HttpResponse.ok(.text("<html><script>window.location.href='data:text/html;charset=UTF-8;base64,\(base64)'</script></html>"))
        }
        
        server["manifest.json"] = { request in
            return HttpResponse.ok(.json(
                [
                    "name": "\(sketch.name)",
                    "short_name": "\(sketch.name)",
                    "start_url": "index.html",
                    "display": "fullscreen",
                    "icons": [[
                        "src": "",
                        "sizes": "192x192",
                        "type": "image/png"
                    ]]
                ]
            ))
        }
        
        
        do {
            try server.start(42069)
        } catch {
            print(error)
        }
        
        guard let url = URL(string: "http://localhost:42069/load") else { return }
        UIApplication.shared.open(url)
    }
    
    static func openLocalHostInstructions() {
        
        server.stop()
        
        server["localhostinstruction"] = { request in
            return HttpResponse.ok(.text("""
                                    <html>
                                    <head>
                                    <style>
                                    body {
                                        font-family: -apple-system, system-ui, BlinkMacSystemFont;
                                    }
                                    </style>

                                    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
                                    <meta charset="utf-8">
                                        
                                    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';">

                                    </head>

                                    <body>
                                    
                                    <center><h3>⬆️ Paste into Safari‘s URL Bar. ⬆️</h3></center>
                                    <br/>
                                    <ul>
                                    <li>Processing has already copied the required data/base64 string to your clipboard. </li>
                                    <li>Pasting can take a couple of seconds, the generated string can be quite large. </li>
                                    <li>Once the sketch is loaded, select “Add to Home Screen” from Safari‘s share sheet. </li>
                                    </ul>
                                    </body>
                                    </html>
                                    """))
        }
        
        do {
            try server.start(42069)
        } catch {
            print(error)
        }
        
        guard let url = URL(string: "http://localhost:42069/localhostinstruction") else { return }
        UIApplication.shared.open(url)
    }
    
}


extension String {
    
    
    /**
     Encode a String to Base64
     
     :returns:
     */
    var base64: String {
        let data = self.data(using: .utf8)
        return data!.base64EncodedString()
    }
    
}


extension UIImage {
    @objc func resize(newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    @objc func base64() -> String {
        let imageData = UIImagePNGRepresentation(self)!
        let strBase64:String = imageData.base64EncodedString()
        return strBase64
    }
}
