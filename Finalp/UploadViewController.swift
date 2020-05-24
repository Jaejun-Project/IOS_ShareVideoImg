//
//  UploadViewController.swift
//  Finalp
//
//  Created by JaeJun Min on 26/04/2018.
//  Copyright © 2018 JaeJun Min. All rights reserved.
//

import UIKit
import Firebase
class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func goToDetailUpload(_ sender: Any) {
        performSegue(withIdentifier: "uploadDetail", sender: self)
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
