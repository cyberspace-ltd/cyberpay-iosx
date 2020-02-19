//
//  Secure3dView.swift
//  CyberpaySdk
//
//  Created by David Ehigiator on 19/02/2020.
//  Copyright © 2020 cyberspace. All rights reserved.
//

import Foundation

import UIKit
import WebKit


/// A protocol for observing the status of the 3DS  transaction being authenticated with a `Secure3DViewController`
public protocol Secure3DControllerDelegate {
    
    /// Called when 3DS  authentication for the transaction is completed.
    ///
    /// - Parameters:
    ///   - secureDsView: The `Secure3DViewController`
    ///   - authenticated: This returns true or false, depending on if the authentication was successful.
    ///   - for transaction: The Transaction that the  `Secure3DViewController` was authenticating.
    func secure3dViewController(_ secureDsView: Secure3DViewController, didComplete authenticated: Bool, for transaction: Transaction)
    
    func secure3dViewController(_ secureDsView: Secure3DViewController, didError error: String, for transaction: Transaction)
    
    func secure3dViewControllerDidCancel(_ secureDsView: Secure3DViewController)
    
}

/// A view controller for performing 3DS authentication.
public class Secure3DViewController: UIViewController {
    
    /// A delegate for being notified of completion or cancellation of the process
    private var delegate: Secure3DControllerDelegate? = nil
    
    lazy var webView =  lazyWebView()
    lazy var activityIndicator = lazyActivityIndicator()
    lazy var activityBarButtonItem = lazyActivityBarButtonItem()
    lazy var cancelButtonItem = lazyCancelBarButtonItem()
    lazy var primaryStackView = lazyStackView()
    lazy var navigationBar = lazyNavigationBar()
    private var isError = false
    private var currentTransaction: Transaction? = nil
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        evaluateNavigationBar()
        activityIndicator.startAnimating()
        super.viewWillAppear(animated)
    }
    
    
    public func initialize(with transaction: Transaction)  {
        currentTransaction = transaction
//        delegate = secure3dDelegate
        guard let url = URL(string: transaction.returnUrl) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        
    }
    
    
    
}


extension Secure3DViewController {
    func evaluateNavigationBar() {
        if navigationController != nil {
            navigationBar.isHidden = true
        } else {
            navigationBar.isHidden = false
            navigationBar.pushItem(navigationItem, animated: false)
        }
    }
    
    func setupNavigationItem() {
        self.navigationItem.leftBarButtonItem = cancelButtonItem
        self.navigationItem.rightBarButtonItem = activityBarButtonItem
    }
    
    func setupView() {
        primaryStackView.addArrangedSubview(navigationBar)
        primaryStackView.addArrangedSubview(webView)
        self.view.addSubview(primaryStackView)
        NSLayoutConstraint.activate(primaryStackView.superviewHuggingConstraints(useMargins: false))
    }
    
    @objc func cancel() {
        delegate?.secure3dViewControllerDidCancel(self)
    }
}


extension Secure3DViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
        LoadingIndicatorView.show()
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        LoadingIndicatorView.hide()
        
    }
    
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let urlString = navigationAction.request.url?.absoluteString ?? ""
        
        
        switch urlString {
        case let str where str.starts(with: "https://payment.staging.cyberpay.ng/notify?ref="):
            delegate?.secure3dViewController(self, didComplete: true, for: currentTransaction!)
            dismiss(animated: true, completion: nil)
            break
        case let str where str.starts(with: "https://payment.cyberpay.ng/url?ref="):
            delegate?.secure3dViewController(self, didComplete: true, for: currentTransaction!)
            dismiss(animated: true, completion: nil)
            
            break
            
        case let str where str.starts(with: "https://payment.cyberpay.ng/url?ref="):
            delegate?.secure3dViewController(self, didComplete: true, for: currentTransaction!)
            dismiss(animated: true, completion: nil)
            
            break
            
        case let str where str.starts(with: "https://payment.cyberpay.ng/pay?reference="):
            delegate?.secure3dViewController(self, didComplete: true, for: currentTransaction!)
            dismiss(animated: true, completion: nil)
            
            break
            
        case let str where str.starts(with: "https://payment.staging.cyberpay.ng/url?ref"):
            delegate?.secure3dViewController(self, didComplete: true, for: currentTransaction!)
            dismiss(animated: true, completion: nil)
            
            break
            
        case let str where str.starts(with: "https://payment.cyberpay.ng/notify?ref="):
            delegate?.secure3dViewController(self, didComplete: true, for: currentTransaction!)
            dismiss(animated: true, completion: nil)
            
            break
            
            
            
        default:
            break
        }
        
        
        
    }
}

extension Secure3DViewController {
    func lazyActivityIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }
    
    func lazyActivityBarButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(customView: activityIndicator)
    }
    
    func lazyWebView() -> WKWebView {
        let wv = WKWebView()
        wv.translatesAutoresizingMaskIntoConstraints = false
        wv.navigationDelegate = self
        return wv
    }
    
    func lazyCancelBarButtonItem() -> UIBarButtonItem {
        let item = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        return item
    }
    
    func lazyStackView() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    func lazyNavigationBar() -> UINavigationBar {
        let bar = UINavigationBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }
}
