//
//  PaypalPaymentViewController - WKWebView.swift
//  CarShare
//
//  Created by nicholas on 3/26/23.
//

import UIKit
import WebKit

extension PaypalPaymentViewController: WKUIDelegate, WKNavigationDelegate {
    internal
    func setupWebView() {
        
        // Create web view configs
        let config = WKWebViewConfiguration()
        
        // Create web view
        let webView = WKWebView(frame: CGRect.zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        // Add web view to main view
        view.addSubview(webView)
        
        // Add constraints to web view
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        webView.configuration.userContentController.add(self, name: "carshare")
        
        
        let _progressView: UIProgressView = UIProgressView(progressViewStyle: .default)
//        _progressView.trackTintColor = UIColor(named: "second-button-color")
        _progressView.progressTintColor = UIColor(named: "progress-bar-color")
        _progressView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(_progressView)
        
        NSLayoutConstraint.activate([
            _progressView.widthAnchor.constraint(equalTo: webView.widthAnchor, multiplier: 4/5),
            _progressView.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
            _progressView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            _progressView.heightAnchor.constraint(equalToConstant: 3)
        ])
        
        self.progressObservation = webView.observe(\.estimatedProgress, options: [.new], changeHandler: { [weak self] webView, changes in
            if let progress = changes.newValue {
                self?.update(progress: Float(progress))
            }
        })
        
        
        self.progressView = _progressView
        
        // Update global web view in PaymentViewController
        self.webView = webView
    }
    
    func update(progress : Float) {
        print("PaymentDetail: -> Progress: \(progress)")
        DispatchQueue.main.async {
            if progress == 1 {
                UIView.animate(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
                    self.progressView?.setProgress(1, animated: true)
                }) { (finished) in
                    UIView.animate(withDuration: 0.2, animations: {
                        self.progressView?.alpha = 0
                    }, completion: {(finished) in
                        self.progressView?.isHidden = true
                        self.progressView?.progress = 0
                    })
                }
            } else {
                self.progressView?.alpha = 1
                self.progressView?.isHidden = false
                if progress < 0.1 {
                    self.progressView?.setProgress(0.1, animated: true)
                    self.progressView?.setProgress(progress, animated: true)
                }
            }
        }
    }

    
    // MARK: - WKWebView Delegates
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("PaymentDetail: \(#function) -> \(webView)")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("PaymentDetail: \(#function) -> \(webView)")
    }
 
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("PaymentDetail: \(#function) -> \(webView)")
        webView.evaluateJavaScript("navigator.userAgent", completionHandler: { result, error in
            
            if let userAgent = result as? String {
                print(userAgent)
            }
        })
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("PaymentDetail: \(#function) -> \(webView) error: \(error)")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("PaymentDetail: \(#function) -> \(webView) error: \(error)")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("PaymentDetail: \(#function) -> \(webView)")
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
        print("PaymentDetail: \(#function) -> \(webView)")
    }
    
    @available(iOS 13.0, *)
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        print("PaymentDetail: \(#function) -> \(webView)")
        let pagePreference = WKWebpagePreferences()
        pagePreference.allowsContentJavaScript = true
        pagePreference.preferredContentMode = .recommended
        if (navigationAction.navigationType == .other) {
            print("WebView Debug: \(navigationAction.request.url)")
            if let redirectedURL = navigationAction.request.url,
                redirectedURL.host == "devlab.link",
               let componment = URLComponents(url: redirectedURL, resolvingAgainstBaseURL: true),
               let token = componment.queryItems?.first(where: {$0.name == "token" }),
               let payerID = componment.queryItems?.first(where: {$0.name == "PayerID" }) {
                var userInfo = PaymentInfo()
                userInfo["token"] = token
                userInfo["PayerID"] = payerID
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1),
                                              execute: { [weak self] in
                    self?.paymentCompletionHandler?(.success, userInfo)
                })
                
                decisionHandler(.allow, pagePreference)
                return
            }
        }
        decisionHandler(.allow, pagePreference)
    }
    
}


extension PaypalPaymentViewController: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("PaymentDetail: \(message.name) ********* \(message.body)")
        if message.name == "carshare" {
            if let body = message.body as? NSDictionary {
            }
        }
    }
}
