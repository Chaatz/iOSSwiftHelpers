//
//  WKWebViewExtension.swift
//  chaatz
//
//  Created by Mingloan Chan on 3/11/17.
//  Copyright © 2017 Chaatz. All rights reserved.
//

import WebKit

extension WKWebView {
    
    func setScrollEnabled(_ enabled: Bool) {
        scrollView.isScrollEnabled = enabled
        scrollView.panGestureRecognizer.isEnabled = enabled
        scrollView.bounces = enabled
        
        for subview in subviews {
            if let subview = subview as? UIScrollView {
                subview.isScrollEnabled = enabled
                subview.bounces = enabled
                subview.panGestureRecognizer.isEnabled = enabled
            }
            
            for subScrollView in subview.subviews {
                if type(of: subScrollView) == NSClassFromString("WKContentView")! {
                    for gesture in subScrollView.gestureRecognizers! {
                        subScrollView.removeGestureRecognizer(gesture)
                    }
                }
            }
        }
    }
    
    func loadURL(_ url: URL) {
        if #available(iOS 9.0, *) {
            // iOS9. One year later things are OK.
            loadFileURL(url, allowingReadAccessTo: url)
        }
        else {
            // iOS8. Things can be workaround-ed
            //   Brave people can do just this
            //   fileURL = try! pathForBuggyWKWebView8(fileURL)
            //   webView.loadRequest(NSURLRequest(URL: fileURL))
            do {
                let filePath = try fileURLForBuggyWKWebView8(url)
                load(URLRequest(url: filePath))
            }
            catch let error as NSError {
                debug_print("Error: " + error.debugDescription)
            }
        }
    }
    
    func fileURLForBuggyWKWebView8(_ fileURL: URL) throws -> URL {
        // Some safety checks
        var error:NSError? = nil;
        if (!fileURL.isFileURL || !(fileURL as NSURL).checkResourceIsReachableAndReturnError(&error)) {
            throw error ?? NSError(
                domain: "BuggyWKWebViewDomain",
                code: 1001,
                userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("URL must be a file URL.", comment:"")])
        }
        
        // Create "/temp/www" directory
        let fm = FileManager.default
        let tmpDirURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("www")
        try! fm.createDirectory(at: tmpDirURL, withIntermediateDirectories: true, attributes: nil)
        
        // Now copy given file to the temp directory
        let dstURL = tmpDirURL.appendingPathComponent(fileURL.lastPathComponent)
        let _ = try? fm.removeItem(at: dstURL)
        try! fm.copyItem(at: fileURL, to: dstURL)
        
        // Files in "/temp/www" load flawlesly :)
        return dstURL
    }
    
}
