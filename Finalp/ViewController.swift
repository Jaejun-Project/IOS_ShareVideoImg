//
//  ViewController.swift
//  Finalp
//
//  Created by JaeJun Min on 26/04/2018.
//  Copyright © 2018 JaeJun Min. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

   
    @IBOutlet weak var collectionView: UICollectionView!
    var ref: DatabaseReference!
    var medias = [Media]()
    override func viewDidLoad() {
        super.viewDidLoad()
    self.navigationItem.title = "Playlist"
        fetchMedia()

        // Do any additional setup after loading the view, typically from a nib.
    }
    func fetchMedia() {
        ref = Database.database().reference()
        ref.child("media").observe(DataEventType.value) { (snapshot) in
            self.medias.removeAll()
            for child in snapshot.children.allObjects as![DataSnapshot]{
                let obj = child.value as? [String: Any]
                
                let content = obj?["content"]
                let imageUrl = obj?["imageUrl"]
                let title = obj?["title"]
                let type = obj?["type"]
                let uid = obj?["uid"]
                let userID = obj?["userID"]
                let videoUrl = obj?["videoUrl"]
                let media = Media(uid: uid as! String?, userID: userID as! String?, type: type as! String?, title: title as! String?, content: content as! String?, videoUrl: videoUrl as! String?, imageUrl: imageUrl as! String?)
                
                self.medias.append(media)
            }
            self.collectionView.reloadData()
        }
    }
    
 override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.medias.count
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath) as! MainCollectionViewCell
      
        let media = self.medias[indexPath.row]
      //  cell.imageCell.image = UIImage(named: self.medias[indexPath.row].imageUrl!)
        cell.lbCell.text = "Title: " + media.title!
        cell.lbCotent.text = media.content
        cell.lbType.text = "Type: " + media.type!;
        if let imageUrl = media.imageUrl{
            let url = URL(string: imageUrl)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil{
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    cell.imageCell.image = UIImage(data: data!)
                }
          
            }).resume()
        }
     //   cell.backgroundColor = UIColor.blue
        return cell;
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width, height: 250)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main" , bundle: nil)
        let desVC = mainStoryBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
          let media = self.medias[indexPath.row]
        if(media.videoUrl != nil){
            desVC.videoUrl = media.videoUrl!
            
        }
       desVC.imageUrl  = media.imageUrl!
      //  print("label :", cell.lbCell)
        print("type: ", media.type!)
        desVC.type = media.type!
        desVC.name = media.title!
        desVC.content = media.content!
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    

}


