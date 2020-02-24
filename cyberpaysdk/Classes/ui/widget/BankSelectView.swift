//
//  BankSelectView.swift
//  CyberpaySdk
//
//  Created by David Ehigiator on 21/02/2020.
//  Copyright © 2020 cyberspace. All rights reserved.
//

import Foundation
import UIKit
internal class BankSelectView : UIViewController, UISearchBarDelegate {
    
    var tableView =  UITableView()
    var safeArea: UILayoutGuide!
    var searchBar = UISearchBar()
    
    let cancelButtonItem : UIBarButtonItem =  {
        let item = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        return item
    }()
    let navigationBar: UINavigationBar =  {
        let bar = UINavigationBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    var primaryStackView :  UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var bankList: [BankResponse] = []
    
    override func viewWillAppear(_ animated: Bool) {
        
        if navigationController != nil {
            navigationBar.isHidden = true
        } else {
            navigationBar.isHidden = false
            navigationBar.pushItem(navigationItem, animated: false)
        }
        
        super.viewWillAppear(animated)
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        setupNavigationItem()
        setupTableView()
        
    }
    
    private var uiController : UIViewController?
    private var onCompleted : ((BankResponse) -> Void)?
    private var onCancel : (() -> Void)?
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init() {
        self.init()
    }
    
    init(rootController: UIViewController,banksResponse: [BankResponse],  onFinished: @escaping (BankResponse)->(), onCancelled: @escaping ()->()) {
        
        
        onCompleted = onFinished
        onCancel = onCancelled
        uiController = rootController
        bankList = banksResponse
        
        super.init(nibName: nil, bundle: nil)
        
        
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
        self.onCancel!()
    }
    
    func setupNavigationItem() {
        self.navigationItem.leftBarButtonItem = cancelButtonItem
    }
    
    
    func setupTableView() {
        primaryStackView.addArrangedSubview(navigationBar)
        primaryStackView.addArrangedSubview(tableView)
        self.view.addSubview(primaryStackView)
        NSLayoutConstraint.activate(primaryStackView.superviewHuggingConstraints(useMargins: false))
        //        navigationBar.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        
        searchBar.frame = CGRect(x: 0, y: 0, width: 200, height: 70)
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBar.placeholder = " Search Banks..."
        searchBar.sizeToFit()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.tableHeaderView = searchBar
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        tableView.reloadData()
        
    }
    
}

extension BankSelectView: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bankList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = bankList[indexPath.row].bankName
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        cell.textLabel?.textColor = UIColor.init(hexString: Constants.primaryColor)
        
        if (bankList[indexPath.row].processingType == "External") {
            if #available(iOS 13.0, *) {
                let redirectIconConfig = UIImage.SymbolConfiguration(scale: .default)
                
                let redirectIcon = UIImage(systemName: "arrow.up.right", withConfiguration: redirectIconConfig)
                
                cell.accessoryView = UIImageView(image: redirectIcon)
                
            } else {
                // Fallback on earlier versions
                cell.detailTextLabel?.text = "You'll be redirected to your bank"
            }
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //          println("You selected cell #\(indexPath.row)!")
        let bank = bankList[indexPath.row]
        
        dismiss(animated: true) {
            self.onCompleted!(bank)
        }
        
        
    }
}
