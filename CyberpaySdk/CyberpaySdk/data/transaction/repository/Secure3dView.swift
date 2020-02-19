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
import MaterialComponents.MaterialBottomSheet



/// A view controller for performing 3DS authentication.
public class Secure3DViewController: MDCBottomSheetController {
    
    private var uiController : UIViewController?
    private var onCompleted : ((Transaction) -> Void)?
    private var onErrorReturned : ((String) -> Void)?
    
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
        
        self.preferredContentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.dismissOnDraggingDownSheet = false
        self.dismissOnBackgroundTap = false
        
        setupNavigationItem()
        setupView()
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        evaluateNavigationBar()
        activityIndicator.startAnimating()
        super.viewWillAppear(animated)
    }
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(contentViewController: UIViewController, transaction: Transaction, onFinished: @escaping (Transaction)->(), onError: @escaping (_ errorMessage: String)->()) {
        super.init(contentViewController: contentViewController)
        
        onCompleted = onFinished
        onErrorReturned = onError
        uiController = contentViewController
        
        currentTransaction = transaction
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
        onErrorReturned!("User Cancelled the authentication process - 3DSecure Environment")
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
            onCompleted!(currentTransaction!)
            dismiss(animated: true, completion: nil)
            break
        case let str where str.starts(with: "https://payment.cyberpay.ng/url?ref="):
            onCompleted!(currentTransaction!)
            dismiss(animated: true, completion: nil)
            
            break
            
        case let str where str.starts(with: "https://payment.cyberpay.ng/url?ref="):
            onCompleted!(currentTransaction!)
            dismiss(animated: true, completion: nil)
            
            break
            
        case let str where str.starts(with: "https://payment.cyberpay.ng/pay?reference="):
            onCompleted!(currentTransaction!)
            dismiss(animated: true, completion: nil)
            
            break
            
        case let str where str.starts(with: "https://payment.staging.cyberpay.ng/url?ref"):
            onCompleted!(currentTransaction!)
            dismiss(animated: true, completion: nil)
            
            break
            
        case let str where str.starts(with: "https://payment.cyberpay.ng/notify?ref="):
            onCompleted!(currentTransaction!)
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
