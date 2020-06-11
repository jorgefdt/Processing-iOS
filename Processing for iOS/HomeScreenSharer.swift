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
    @objc static func share(sketch: PDESketch) {
        
        server.stop()
        
        let sourceCode = sketch.htmlPage()
        let base64 = sourceCode!.base64
        
        server["load"] = { request in
            return HttpResponse.ok(.text("<HTML><script>window.location.href='data:text/html;charset=UTF-8;base64,\(base64)'</script></HTML>"))
        }
        
        
        
        
        server["manifest.json"] = { request in
            return HttpResponse.ok(.json(
                [
                    "name": "\(sketch.sketchName!)",
                    "short_name": "\(sketch.sketchName!)",
                    "start_url": "index.html",
                    "display": "standalone",
                    "icons": [[
                    "src": "",
                    "sizes": "192x192",
                    "type": "image/png"
                    ]]
                ]
                ))
        }

        
        try? server.start(42096)
        
        guard let url = URL(string: "http://localhost:42096/load") else { return }
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
