//
//  CategoryEditController.swift
//  WeThereProject
//
//  Created by 김주영 on 2021/06/20.
//

import UIKit
import FirebaseFirestore

class CategoryEditController: UITableViewController {

    let db: Firestore = Firestore.firestore()
    var category = [String](){
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadCategory()
    }
    
    func loadCategory(){
        let docRef = db.collection("category").document("category")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.category = (document.get("items") as? [String])!
              //  self.tableView.reloadData()
                print("reload goTdhdh")
            } else {
                print("Document does not exist")
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return category.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)

        cell.textLabel?.text = self.category[(indexPath as NSIndexPath).row]

        return cell
    }
    
    @IBAction func addCategory(_ sender: UIButton){
        let addAlert = UIAlertController(title: "카테고리 추가", message: "새로운 카테고리를 입력하세요.", preferredStyle: .alert)
        addAlert.addTextField()
        let alertOk = UIAlertAction(title: "추가", style: .default) { (alertOk) in
            self.uploadCategory((addAlert.textFields?[0].text)!, add: true)
            self.loadCategory()
            self.tableView.reloadData()
        }
        let alertCancle = UIAlertAction(title: "취소", style: .default) { (alertCancel) in
        
        }
        addAlert.addAction(alertCancle)
        addAlert.addAction(alertOk)
        self.present(addAlert, animated: true, completion: nil)
    }
    
    func uploadCategory(_ item: String, add: Bool){
        
        let categoryRef = db.collection("category").document("category")
        
        if add{
            categoryRef.updateData([
                    "items": FieldValue.arrayUnion([item])
                ])
        }else{
            categoryRef.updateData([
                "items": FieldValue.arrayRemove([item])
            ])
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let removeItem = category[(indexPath as NSIndexPath).row] as String
            uploadCategory(removeItem, add: false)
            
            if let index = category.firstIndex(of: removeItem) {
                category.remove(at: index)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
