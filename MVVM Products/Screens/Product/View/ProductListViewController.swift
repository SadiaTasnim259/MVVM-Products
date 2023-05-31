//
//  ProductListViewController.swift
//  MVVM Products
//
//  Created by Sadia on 30/5/23.
//

import UIKit

class ProductListViewController: UIViewController {
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    @IBOutlet weak var productTableView: UITableView!
    var productViewModel = ProductViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
//        loader.style = .large
//        loader.hidesWhenStopped = true
//        loader.startAnimating()
        
        configuration()
        
        productTableView.delegate = self
        productTableView.dataSource = self
    }
    
}

extension ProductListViewController{
    
    func configuration(){
        productTableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        initViewModel()
        observeEvent()
    }
    func initViewModel(){
        productViewModel.fetchProducts()
    }
    
    //Data binding - communication  
    func observeEvent(){
        productViewModel.eventHandler = { [weak self] event in
            guard let self else {
                return
            }
            switch event {
            case .loading:
                print("product Loading..")
            case .stoploading:
                print("product stopLoading..")
            case .dataloaded:
                print("data loaded..")
                DispatchQueue.main.async {
                    self.loader.stopAnimating()
                    self.productTableView.reloadData()
                }
                //print(self.productViewModel.products)
            case .error(let error):
                print(error)
            }
        }
    }
}

extension ProductListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productViewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"ProductCell") as? ProductCell else{
            return UITableViewCell()
        }
        let product = productViewModel.products[indexPath.row]
        cell.product = product
        return cell
    }
}

extension ProductListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // Row select effect
    }
}
