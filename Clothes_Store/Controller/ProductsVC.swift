//
//  ProductsVC.swift
//  Clothes_Store
//
//  Created by user137691 on 10/8/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class ProductsVC: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource{
    // MARK: - Declare Constants
    let productsURL="http://test100.revival.one/api/setup/GetProductsByCategoryID?"
    var products=[ProductModel]()
    var categoryName:String?{
        didSet{
            navigationItem.title=categoryName
        }
    }
    var categoryID:Int?{
        didSet{
            getProducts(from: productsURL,parameters:["CategoryID":String(categoryID!)])
        }
    }
    //MARK :- Outlet
    @IBOutlet weak var productCollectionView:UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    //MARK : - Alamofire Request Data
    func getProducts(from url:String,parameters:[String:String]){
        Alamofire.request(url,
                          method: .get,
                           parameters:parameters)
        .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print( "Cann't get categories")
                    return
                }
                self.setProductsArray(json: JSON( response.result.value!))
        }
        
    }
    func setProductsArray(json :JSON){
        var productobj:ProductModel
        var jsonListcount:Int=0
        for _ in json["Data"]{
            productobj=ProductModel()
            productobj.productID=Int(json["Data"][jsonListcount]["ProductID"].intValue)
            productobj.productName = String( json["Data"][jsonListcount]["ProductName"].stringValue)
            productobj.productPrice=String( json["Data"][jsonListcount]["ProductPrice"].floatValue)
            productobj.productImageURl = String(json["Data"][jsonListcount]["ImageLocation"].stringValue)
            products.append(productobj)
            jsonListcount+=1
        }
        do_table_refresh()
    }
    func do_table_refresh()
    {
        DispatchQueue.main.async(execute: {
            self.productCollectionView.reloadData()
            return
        })
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.descriptionLabel.text = products[indexPath.row].productName
        cell.priceLabel.text=products[indexPath.row].productPrice
        let url = URL(string: products[indexPath.row].productImageURl)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        cell.productImageView.image = UIImage(data: data!)
        return cell
    }
    


}
