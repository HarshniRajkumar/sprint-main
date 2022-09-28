//
//  AddtocarttblViewController.swift
//  sprint2
//
//  Created by Capgemini-DA088 on 9/26/22.
//

import UIKit
import Alamofire
import CoreData
//struct to initialize keys and products from api
struct ItemCatlog : Decodable {
    enum CodingKeys: String, CodingKey{
        case product = "products"
    }
    
    let product : [products]
}
//struct to decode the data from api
struct products: Decodable {
    enum CodingKeys: String, CodingKey {
        case productTitle = "title"
        case productDescriptionLabel = "description"
        case productThumbnail = "thumbnail"
    }
    //the respective data are initialized below
    let productTitle: String
    let productDescriptionLabel : String
    let productThumbnail : String
}
//class for tableviewcell
class ProductViewCell : UITableViewCell{
    //outlets for the respective cell is connected
    @IBOutlet weak var titlbl: UILabel!
    @IBOutlet weak var pdtImg: UIImageView!
    @IBOutlet weak var pdtdsc: UILabel!
    @IBOutlet weak var crtvw: UIImageView!
}

class AddtocarttblViewController: UIViewController {
    //outlet for the tableView connected
    @IBOutlet weak var productTableView: UITableView!
    //initializing the requirements in the code
    var productName = String()
    var apiLink = "https://dummyjson.com/products/category/smartphones"
    var differentProducts = [products]()
    //a proper context is created in such a way that it accepts the entity and works properly
    let addCartContext = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //title given
        self.navigationItem.title = "Add To Cart"
        //integrating the products one by one to be fetched on the screen
        apiLink += productName
        //calling the func in viewdidload
        fetchDataFromAlamofire()
        // Do any additional setup after loading the view.
    }
    
    
    //func taken from obj C reference and the func that explains what happens when clicked on cart
    @objc func clickedOnCart(_ sender: UITapGestureRecognizer){
    //func to detect the duplicate entry
     
    if findDuplicateEntry(productTitle: differentProducts[sender.view!.tag].productTitle){
    
    //Entity details are used here
     let addProduct = DetailsCart(context: addCartContext)
    
    //proper names are given and from the entity set up
     addProduct.productTitle = differentProducts[sender.view!.tag].productTitle
     addProduct.productDescriptionLabel=differentProducts[sender.view!.tag].productDescriptionLabel
     addProduct.productThumbnail = differentProducts[sender.view!.tag].productThumbnail
    
    do{
    //the func is being called from that persistent container
    try self.addCartContext.save()
    //alert messages are initiated to depict the messages:
   
    //showAlertt(popUptitle: "Item added to cart",alertMessage: "product selected: \(differentProducts[sender.view!.tag].productTitle)")
    }
    //if error do throw with desc:
     catch (let error){
     print(error.localizedDescription)
    }
    }
    }
    
    
    //func to find the duplicate entry from the user
     func findDuplicateEntry(productTitle: String)-> Bool {
     guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return (0 != 0)}
     let context = appDelegate.persistentContainer.viewContext
    
         
    //the details are fetched from entity
     let request = DetailsCart.fetchRequest()
     request.predicate = NSPredicate(format: "%K == %@", argumentArray: ["productTitle", productTitle])
     var result: [NSManagedObject] = []
     do{
    result = try context.fetch(request)
    if result.count == 1 {
    //showAlert for adding same item
   // showAlertt(popUptitle: "Alert!", alertMessage: "The product has been added already")
    }
    }
       catch (let error) {
    print(error.localizedDescription)
    }
           return result.count == 0
    }
    
       //func to fetch the data from alamofire
       func fetchDataFromAlamofire() {
        //calling the provided link using alamofire:
        Alamofire.request(apiLink, method: .get, encoding: URLEncoding.default, headers:nil).responseJSON { response in
            switch response.result {
            case .success:
                if let jsonData = response.data {
                    do {
                        let urlResponse = try JSONDecoder().decode(ItemCatlog.self, from:jsonData)
                        self.differentProducts.append(contentsOf: urlResponse.product)
                        DispatchQueue.main.async {
                        self.productTableView.dataSource = self
                        self.productTableView.delegate = self
                        self.productTableView.reloadData()
                    }
                }
                catch let error {
                    print(error.localizedDescription)
                }
            }
            break
        case .failure(let error):
            print(error)
        }
        
    }
}
   
}
//extnsn to display data from url i.e images from url:
extension UIImageView {
    func loadFromUrl(urlAddress : String){
        guard let url = URL(string: urlAddress) else {
            return
        }
        //check if the data is present and properly display it one after other
        DispatchQueue.main.async { [weak self] in
        //initializing image view for display
        if let imageData = try? Data(contentsOf: url){
        if let loadedimage = UIImage(data: imageData) {
        self?.image = loadedimage
                }
            }
        }
    }
}
//extended to tableView displaying
extension AddtocarttblViewController: UITableViewDataSource, UITableViewDelegate {
    //cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 290.0
    }
    //returning products
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)->Int{
    return differentProducts.count
}
    //saving the corresponding data and identifying the data
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ProductViewCell", for: indexPath) as! ProductViewCell
    let tapGesture = UITapGestureRecognizer(target: self, action:#selector(clickedOnCart(_:)))
    cell.pdtImg.loadFromUrl(urlAddress: differentProducts[indexPath.row].productThumbnail)
    cell.titlbl.text = differentProducts[indexPath.row].productTitle
    cell.pdtdsc.text = differentProducts[indexPath.row].productDescriptionLabel
    cell.crtvw.tag = indexPath.row
    cell.crtvw.addGestureRecognizer(tapGesture)
    return cell
}
    //navigate to next vc:
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
