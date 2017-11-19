//
//  MemeViewController.swift
//  smile
//
//  Created by Nabeel Ahmad Khan on 11/18/17.
//  Copyright © 2017 Defcon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class MemeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var postsTableView: UITableView!
    var posts = NSMutableArray()
    
    override func viewDidLoad() {
        print("view did load appear")
        super.viewDidLoad()
        self.postsTableView.delegate = self
        self.postsTableView.dataSource = self
        
        self.title = "Memes"
        //self.navigationController?.navigationBar.titleTextAttributes = UIFont(name: "ChalkboardSE-Bold", size: 25)!
        
        self.postsTableView.estimatedRowHeight = 429
        
        loadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func loadData(){
        let ref = Database.database().reference().root
        //let uid = Auth.auth().currentUser?.uid
        print("in load data")
        ref.child("memePosts").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            print("in ref child")
            if let value = snapshot.value as? [String: AnyObject]{
                print(" value is \(value)")
                for post in value{
                    self.posts.add(post.value)
                    print("value of posts is \(self.posts)")
                }
                self.postsTableView.reloadData()
            }
            
            
            print("value is")
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        print("3 table view called")
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("2 table view called count \(self.posts.count)")
        return self.posts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("table view loading data in lables 1")
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell", for: indexPath) as! PostTableViewCell
        
        // Configure the cell...
        print("table view loading data in lables")
        let post = self.posts[indexPath.row] as! [String: AnyObject]
        cell.cellLabel.text = post["title"] as? String
        //print("posts title is \(cell.cellLabel.text)")
        cell.cellDescription.text = post["description"] as? String
        let imageURL = post["url"] as? String
        let url = URL(string: imageURL!)
        let data = try? Data(contentsOf: url!)
        let image = UIImage(data: data!)
        cell.cellImage.image = image
        
        cell.cellLabel.alpha = 0
        cell.cellDescription.alpha = 0
        cell.cellImage.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            cell.cellLabel.alpha = 1
            cell.cellDescription.alpha = 1
            cell.cellImage.alpha = 1
        })
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
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
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
