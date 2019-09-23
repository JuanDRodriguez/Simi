//
//  SearchBarViewController.swift
//  Supervisores
//
//  Created by Oscar Montaño Ayala on 1/20/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

protocol SearchingProtocol: class {
    func typingSearch(text: String)
}
class SearchBarViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    weak var delegate: SearchingProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.delegate?.typingSearch(text: searchText)
    }
}
