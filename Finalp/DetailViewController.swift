//
//  DetailViewController.swift
//  Finalp
//
//  Created by JaeJun Min on 26/04/2018.
//  Copyright © 2018 JaeJun Min. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class DetailViewController: UIViewController {

    @IBOutlet weak var imgImage: UIImageView!
   
    
    @IBOutlet weak var playButton: UIButton!
  // var image = UIImage()
    var name = ""
    var type = ""
    var content = ""
    var videoUrl : String?
    var imageUrl: String?
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = name;
        self.playButton.isHidden = true
        self.playButton.isEnabled = false
        if let imageUrl = self.imageUrl{
            let url = URL(string: imageUrl)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil{
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                   self.imgImage.image = UIImage(data: data!)
                    if(self.videoUrl != nil){
                        self.playButton.isHidden = false
                        self.playButton.isEnabled = true
                    }
                }
            }).resume()
        }
        
        titleLabel.text = name
        contentLabel.text = content
      //  imgImage.image=image
     //   lbLabel.text! = name        // Do any additional setup after loading the view.
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playVideo(_ sender: UIButton) {
        let url = NSURL(string: self.videoUrl!)!
        playVideo(url:url)
        }
        private func playVideo(url: NSURL) {
            let playerController = AVPlayerViewController()
            
            let player = AVPlayer(url: url as URL)
            
            playerController.player = player
            
            self.present(playerController, animated: true) {
                player.play()
            }
        }
       
        


    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
