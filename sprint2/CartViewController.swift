//
//  CartViewController.swift
//  sprint2
//
//  Created by Capgemini-DA088 on 9/26/22.
//

import UIKit
import CoreData
import Alamofire

class CartViewCell: UITableViewCell{
    //outlets connected from cell
    @IBOutlet weak var pdtTitleC: UILabel!
    @IBOutlet weak var pdtIn: UIImageView!
    @IBOutlet weak var cartIM: UIImageView!
    @IBOutlet weak var ctDesc: UILabel!
}
class CartViewController: UIViewController {
    //table view connected
    @IBOutlet weak var cartTblview: UITableView!
    var productAddedToCart = [DetailsCart]()
    let addCartContext = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
    //required func are called in the viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        cartTblview.dataSource = self
        cartTblview.delegate = self
        fetchProducts()

    }
    //func that happens after clicking cart image
    @objc func clickOnCart(_ sender: UITapGestureRecognizer)
    {
        //the navigation to next vc is imaprted:
        let mapVc = storyboard?.instantiateViewController(withIdentifier: "Mapvc") as! MapViewController
        self.navigationController?.pushViewController(mapVc, animated: true)
    }
    
    //func to fetch the products and display:
    func fetchProducts(){
        do{
            self.productAddedToCart = try addCartContext.fetch(DetailsCart.fetchRequest())
            //to check the data and fetch accordingly
            DispatchQueue.main.async {
                self.cartTblview.reloadData()
            }
        }
        catch(let error){
            print(error.localizedDescription)
        }
    }
}

     //extension for cart vc is imparted for the tableView
     extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView:UITableView, numberOfRowsInSection section : Int)-> Int {
        return productAddedToCart.count
    }
    //tableview func written to display height of a row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)-> CGFloat {
        return 150.0
    }
    //func to collect data and move to next vc:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartViewCell") as! CartViewCell
        let tapGestureRecogniser = UITapGestureRecognizer(target: "self", action: #selector(clickOnCart(_:)))
        let product = productAddedToCart[indexPath.row]
        cell.pdtTitleC.text = product.productTitle
        cell.ctDesc.text = product.productDescriptionLabel
        cell.pdtIn.loadFromUrl(urlAddress: product.productThumbnail!)
        cell.cartIM.addGestureRecognizer(tapGestureRecogniser)
        return cell
    }
   
}
