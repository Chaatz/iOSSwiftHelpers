//
//  UIWeView+UserAgent.swift
//  chaatz
//
//  Created by Mingloan Chan on 3/11/17.
//  Copyright © 2017 Chaatz. All rights reserved.
//

import UIKit

extension UIWebView {
    
    static func getDeviceUserAgent() -> String? {
        let webView = UIWebView(frame: CGRect.zero)
        return webView.stringByEvaluatingJavaScript(from: "navigator.userAgent")
    }
    
}
