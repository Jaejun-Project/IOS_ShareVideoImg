//
//  UploadVideoViewController.swift
//  Finalp
//
//  Created by JaeJun Min on 27/04/2018.
//  Copyright © 2018 JaeJun Min. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import MobileCoreServices
import AVFoundation

class UploadVideoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var subject: UITextField!
    @IBOutlet weak var content: UITextField!
    var ref: DatabaseReference!
    var urlOfVideo : URL! = nil
    var filenameOfVideo : String! = nil
    var imageUrlFromVideo :String?
    var videoPath = String()
    let imagePickerController = UIImagePickerController()
   // let kUTTypeMovie: CFString
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uploadButton.isEnabled = false
        self.subject.isEnabled = false
        self.content.isEnabled = false
        //self.imageView. = "hi"
        self.navigationItem.title = "Upload"
       // self.imageView.description = "hi"
    imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openGallery)))
        imageView.isUserInteractionEnabled = true
        ref=Database.database().reference()
        imagePickerController.delegate = self
        // Do any additional setup after loading the view.
//        if(self.imageView.image != nil && self.subject.text != nil && self.content != nil){
//            self.uploadButton.isEnabled = true;
//          //  upload()
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func uploadButton(_ sender: Any) {
       
       upload()
    }
    
    @objc func openGallery(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL {
            //we selected a video
            handleVideoSelectedForUrl(videoUrl)
        } else {
            //we selected an image
            handleImageSelectedForInfo(info as [String : AnyObject])
        }
    dismiss(animated: true, completion: nil)
        if(self.imageView.image != nil){
            self.subject.isEnabled = true;
        }
    }
    fileprivate func handleImageSelectedForInfo(_ info: [String: AnyObject]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
      self.imageView.image = selectedImageFromPicker
    }
    
    fileprivate func handleVideoSelectedForUrl(_ url: URL) {
        self.filenameOfVideo = Auth.auth().currentUser!.uid + ".mov"
        self.urlOfVideo = url
        let thumnailImage = self.thumbnailImageForFileUrl(url)
        self.imageView.image = thumnailImage

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    fileprivate func thumbnailImageForFileUrl(_ fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
            
        } catch let err {
            print(err)
        }
        
        return nil
    }
    fileprivate func uploadImage(_ imageName :String){
        
        let image = UIImagePNGRepresentation(self.imageView.image!)
        let riversRef = Storage.storage().reference().child("ios_images").child(imageName)
        
        riversRef.putData(image!, metadata: nil) { (metadata, error) in
            if (error != nil){
                // Uh-oh, an error occurred!
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                riversRef.downloadURL(completion: { (url, error) in
                    if (error == nil) {
                        if let downloadUrl = url {
                            // Make you download string
                            let downloadString = downloadUrl.absoluteString
                           self.ref.child("media").childByAutoId().setValue([
                                "uid": Auth.auth().currentUser?.uid,
                                "userID": Auth.auth().currentUser?.email,
                                "type": "Image",
                                "title": self.subject.text!,
                                "content": self.content.text!,
                                "imageUrl": downloadString])
                        }
                        
                        self.dismiss(animated: true, completion: nil)
                        
                    } else {
                        // Do something if error
                    }
                })
                
                
            }
        }
    }
    
    fileprivate func uploadVideo(_ imageName :String, _ filename :String){
        let videoRef = Storage.storage().reference().child("videos").child(filename)
        let imageRef = Storage.storage().reference().child("videos").child(imageName)
        let image = UIImagePNGRepresentation(self.imageView.image!)
      //  var imageDownloadUrl : String
        
        imageRef.putData(image!, metadata: nil) { (metadata, error) in
            if (error != nil){
                // Uh-oh, an error occurred!
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                imageRef.downloadURL(completion: { (url, error) in
                    if (error == nil) {
                        if let downloadUrl = url {
                            // Make you download string
                           self.imageUrlFromVideo = downloadUrl.absoluteString
                        }
                    } else {
                        // Do something if error
                    }
                })
            }
        }
     
      //  imageRef.putData(image!,metadata: nil) {(metadata, error) in}
        
        videoRef.putFile(from: self.urlOfVideo, metadata: nil, completion: { (metadata, error ) in
                        if error != nil{
                            print("Failed upload of video:", error!)
                            return
                        }else{
                            videoRef.downloadURL(completion: { (url , error) in
                                if (error == nil) {
                                    if let downloadUrl = url {
                                        // Make you download string
                                        let downloadString = downloadUrl.absoluteString
                                        self.ref.child("media").childByAutoId().setValue([
                                            "uid": Auth.auth().currentUser?.uid,
                                            "userID": Auth.auth().currentUser?.email,
                                            "type": "Video",
                                            "title": self.subject.text!,
                                            "content": self.content.text!,
                                            "videoUrl": downloadString,
                                            "imageUrl":  self.imageUrlFromVideo])
                                    }
        
                                    self.dismiss(animated: true, completion: nil)
        
                                } else {
                                    // Do something if error
                                    print("upload video error:",error!)
                                }
                            })
                    }
        })
        
    }
    func upload(){
        // var ref: DatabaseReference!
        
     //   ref = Database.database().reference()
       
        //ref = Database.database().reference()
        //Database.database()
        let imageName: String
        if(self.urlOfVideo == nil){
            imageName = Auth.auth().currentUser!.uid + "\(Int(NSDate.timeIntervalSinceReferenceDate * 1000)).jpg"
            print("Videoname : ", imageName)
            uploadImage(imageName)
            
        }
        else{
            
            imageName = Auth.auth().currentUser!.uid + "\(Int(NSDate.timeIntervalSinceReferenceDate * 1000)).jpg"
           // let filename = Auth.auth().currentUser!.uid + ".mov"
            let videoName = self.filenameOfVideo
            uploadVideo(imageName, videoName!)
            print("imagname : ", videoName!)
        }
        
    
        //  let imageName = Auth.auth().currentUser!.uid + "\(Int(NSDate.timeIntervalSinceReferenceDate * 1000)).jpg"
        
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func contentText(_ sender: Any) {
        if  self.content.text != ""
        {
            self.uploadButton.isEnabled = true
        }
        else
        {
            self.uploadButton.isEnabled = false
        }
    }
    @IBAction func subjectText(_ sender: Any) {
        if self.subject.text != ""
        {
            self.content.isEnabled = true;
        }
        else{
            self.content.text = ""
            self.content.isEnabled = false;
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

