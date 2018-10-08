//
//  ViewController.swift
//  Clothes_Store
//
//  Created by user137691 on 10/2/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CategoriesVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    // MARK: - Declare Constants
    let categoriesURL="http://test100.revival.one/api/setup/GetCategories"
    var categories=[CategoryModel]()
    //MARK :- Outlet
    @IBOutlet weak var categoryTableview:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getCategories(from: categoriesURL)
    }

    //MARK : - Alamofire Request Data
    func getCategories(from url:String){
        Alamofire.request(url,
                          method: .get)
            .validate()
            .responseJSON { response in
              guard response.result.isSuccess else {
                    print( "Cann't get categories")
                    return
                }
               self.setCategoriesArray(json: JSON( response.result.value!))
        }
        
    }
    func setCategoriesArray(json :JSON){
        var categoryObj:CategoryModel
        var jsonListcount:Int=0
        for _ in json["Data"]{
            categoryObj=CategoryModel()
            categoryObj.categoryID=Int(json["Data"][jsonListcount]["CategoryID"].intValue)
            categoryObj.categoryTitle = String( json["Data"][jsonListcount]["CategoryTitle"].stringValue)
            categoryObj.categoryImageURl = String(json["Data"][jsonListcount]["ImageLocation"].stringValue)
            categories.append(categoryObj)
            jsonListcount+=1
        }
      do_table_refresh()
    }
    func do_table_refresh()
    {
        DispatchQueue.main.async(execute: {
            self.categoryTableview.reloadData()
            return
        })
    }
    //Mark : - TableViewDelegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)as! CategoryCell
        cell.categoryTitle.text=categories[indexPath.row].categoryTitle
        let url = URL(string: categories[indexPath.row].categoryImageURl)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        cell.categoryImage.image = UIImage(data: data!)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToProducts" ,sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinactionVC=segue.destination as! ProductsVC
        if let indexPath=categoryTableview.indexPathForSelectedRow{
            destinactionVC.categoryID=categories[indexPath.row].categoryID
            destinactionVC.categoryName=categories[indexPath.row].categoryTitle
            let barbtn=UIBarButtonItem()
            barbtn.title=""
            navigationItem.backBarButtonItem=barbtn
        }
            
    
    }
}

