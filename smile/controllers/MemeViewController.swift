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
    var newHeight = CGFloat(266)
    var buttonLiked = false
    var rowIndex:IndexPath = IndexPath()
    var totalcount = 0
    var liked:[Bool] = []
    var imagekeys:[String] = []
    var userLiked:[String] = []
    
    var userLikedFetched:[String] = []
   
    
    @IBAction func imagesLikeButtonTapped(_ sender: Any) {
        print("like button tapped")
        //likeButton.image = UIImage(cgImage: #imageLiteral(resourceName: "heart-colored") as! CGImage)
        buttonLiked = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        userLikedFetched = []
        let user = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().root
        postsTableView.rowHeight = UITableViewAutomaticDimension;
        postsTableView.estimatedRowHeight = 420
        ref.child("users").child(user!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let images:[String] = (value?["imagesLiked"] as? [String]) ?? [""]
            
            print("IMAGES LIKED OUTUPUT  OUTPUT IS \(images)")
            self.userLikedFetched = images
            print("value is \(images)")
            
            
            self.title = "Memes"
            self.postsTableView.estimatedRowHeight = 429
            
            self.loadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    override func viewDidLoad() {
        print("view did load appear")
        super.viewDidLoad()
        self.postsTableView.delegate = self
        self.postsTableView.dataSource = self
        
        
        
        
        
        
        //self.navigationController?.navigationBar.titleTextAttributes = UIFont(name: "ChalkboardSE-Bold", size: 25)!
        
        
        
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
                    print("KEYS ARE \(post.key)")
                    self.imagekeys.append(post.key)
                    print("value of posts is \(self.posts)")
                    self.liked.append(false)
                    
                }
                for i in self.userLikedFetched{
                    if self.imagekeys.contains(i){
                        let position = self.imagekeys.index(of: i)
                        self.liked[position!] = true
                        self.userLiked.append(i)
                    }
                }
                
                print("LIKED ARRAY ARRAY ARRAY ARRAY ARRAY ARRAY ARRAY  IS \(self.liked)")
                print("LIKED ARRAY ARRAY ARRAY ARRAY ARRAY ARRAY ARRAY  userLiked \(self.userLiked)")
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
        totalcount = self.posts.count
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
        let like = post["like"] as? Bool
        //print(" LIKED VALUE IS \(like)")
        
        
        
        //cell.cellImage.image = image
        
        // For changing the dimensions of the UIImageView 414*266
        let aspect = image!.size.width / image!.size.height
        print("the width, heigth and aspect of image is \(image!.size.width) \(image!.size.height) \(aspect)")
        
        //let constraint = NSLayoutConstraint(item: cell.cellImage, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: cell.cellImage, attribute: NSLayoutAttribute.height, multiplier: aspect, constant: 0.0)
        //constraint.priority = UILayoutPriority(rawValue: 999)
        
        //let aspectConstraint = constraint
        newHeight = postsTableView.frame.width / aspect
        print("The new heigth is equal to \(newHeight)")
        
        
        cell.cellImage.frame = CGRect(x: 0, y: 59, width: 414, height: newHeight)
        cell.cellImage.image = image
        //postsTableView.RowHeight = UITableViewAutomaticDimension
        //postsTableView.estimatedRowHeight = 140+newHeight
        
        print("The new heigth of the row is \(140 + newHeight)")
        
        cell.cellLabel.alpha = 0
        cell.cellDescription.alpha = 0
        cell.cellImage.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            cell.cellLabel.alpha = 1
            cell.cellDescription.alpha = 1
            cell.cellImage.alpha = 1
        })
        
        print("INDEX PATH IS IS IS IS IS IS IS IS IS \(indexPath)")
        
        if (liked[indexPath[1]] == true){
            cell.likeButton.image = #imageLiteral(resourceName: "heart-colored")
            print("in Button liked if")
            buttonLiked = false
        }
        else{
            //cell.likeButton.image = UIImage(cgImage: #imageLiteral(resourceName: "heart") as! CGImage)
            cell.likeButton.image = #imageLiteral(resourceName: "heart")
            print("in Button liked else")
            
        }
        
        // Adding tapgesture recogniser on the heart button
        //rowIndex = postsTableView.indexPath(for: cell)!
        //rowIndex = indexPath
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(likeButtonClicked(recogniser:)))
        cell.likeButton.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    
    @objc func likeButtonClicked(recogniser: UITapGestureRecognizer){
        print(" button clicked ")
        let tapLocation = recogniser.location(in: self.postsTableView)
        let indexPath = self.postsTableView.indexPathForRow(at: tapLocation)
        print("the index path is \(indexPath)")
        rowIndex = indexPath!
        liked[rowIndex[1]] = true
        print("THE VALUE OF ROWINDEX IS \(rowIndex[1])")
        self.postsTableView.reloadRows(at: [indexPath!], with: UITableViewRowAnimation.none)
        buttonLiked = true
        userLiked.append(imagekeys[rowIndex[1]])
        print("THE KEYS TO BE ADDED ARE \(userLiked)")
        var user = Auth.auth().currentUser?.uid
        var ref = Database.database().reference().root
        
        ref.child("users").child((user)!).child("imagesLiked").setValue(userLiked)
        
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
