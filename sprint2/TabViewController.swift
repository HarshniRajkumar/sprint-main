//
//  TabViewController.swift
//  sprint2
//
//  Created by Capgemini-DA088 on 9/21/22.
//
import Foundation
import Alamofire
import UIKit
//initializing index
 var myIdex = 0
    

class TabViewController: UIViewController {
    //outlets given
    @IBOutlet weak var userTable: UITableView!
    var categoryArray = [String]()
    //calling the func on viewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
        getJSONData()
    }
    //func to get the json data using alamofire:
    func getJSONData() {
        let urlFile = "https://dummyjson.com/products/categories"
    //Alamofire is used as an api calling agent a online api using link is called
        Alamofire.request(urlFile).responseJSON{ (response) in
    //writing the switch case for the usertable display
            switch response.result
            {
            case .success(_):
            let jsondata = response.result.value as! [String]?
            self.categoryArray = jsondata!
            self.userTable.reloadData()
     //writing case failure to know whether the data gets parsed or not:
            case .failure(let error):
            print("Error Occured \(error.localizedDescription)")
                }
            }
        }
}
    
     //an extension for the viewcontroller is set so that tableView func can be written
     extension TabViewController : UITableViewDelegate, UITableViewDataSource {
      //func to return cell height
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)->CGFloat{
            return 90.0
        }
         //func to return the array
        func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int)-> Int {
            return categoryArray.count
        }
         //func to call and identify the cell
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         //cell is called and displayed using identifier
            let cell = userTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //cell returning
            cell.textLabel?.text = categoryArray[indexPath.row]
            return cell
        }
         //func to move to next vc
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
            if let vc = storyboard?.instantiateViewController(withIdentifier:"AddtocartVC") as? AddtocarttblViewController{self.navigationController?.pushViewController(vc, animated: true)
                myIdex = indexPath.row
                userTable.deselectRow(at: indexPath, animated: true)
        }
    }
    }
