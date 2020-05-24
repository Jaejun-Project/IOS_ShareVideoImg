//
//  LoginViewController.swift
//  Finalp
//
//  Created by JaeJun Min on 26/04/2018.
//  Copyright © 2018 JaeJun Min. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
class LoginViewController: UIViewController {
    var medias = [Media]()
    var ref : DatabaseReference!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func signIn(_ sender: Any) {
       Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, error) in
        if(error != nil){
            Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!) { (user, error) in
                if(error != nil){
                    let alret = UIAlertController(title: "Error", message: error.debugDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alret.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alret, animated: true, completion: nil)
                }else{
                    print("yes")
                }
            }
            
        }else{
            let alert = UIAlertController(title: "Alert", message: "You've registered for app! \n Now you can login", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title:"Confrim", style:UIAlertActionStyle.default, handler:nil))
            
            self.present(alert, animated: true, completion: nil)
    
            }
        
    }
}
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      //  let firebaseAuth = Auth.auth()
        try! Auth.auth().signOut()
        Auth.auth().addStateDidChangeListener { (Auth, user) in
            if(Auth.currentUser != nil){
                 self.performSegue(withIdentifier: "Home", sender: nil)
            }
        }
      
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
