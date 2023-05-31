//
//  ProductViewModel.swift
//  MVVM Products
//
//  Created by Sadia on 30/5/23.
//

import Foundation

final class ProductViewModel{
    var products:[Product] = []
    var eventHandler: ((_ event: Event) -> Void)?
    func fetchProducts(){
        self.eventHandler?(.loading)
        APIManager.shared.fetchProduct { response in
            self.eventHandler?(.stoploading)
            switch response{
            case .success(let products):
                self.products = products
                self.eventHandler?(.dataloaded)
            case .failure(let error):
                self.eventHandler?(.error(error))
            }
        }
    }
}

extension ProductViewModel{
    enum Event{
        case loading
        case stoploading
        case dataloaded
        case error(Error?)
    }
}
