//
//  ScanViewController.swift
//  DermaCare
//
//  Created by Sneha Kasetty Sudarshan on 4/1/18.
//  Copyright © 2018 Pooja. All rights reserved.
//

import UIKit
import Firebase

class ScanViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    @IBOutlet weak var myImageview: UIImageView!
    
    @IBAction func scanButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker,animated: true,completion: nil)
        }
        
    }
    
    func imagePickerController(_ _picker: UIImagePickerController,didFinishPickingMediaWithInfo info:[String : Any]){
     
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            myImageview.contentMode = .scaleToFill
            myImageview.image = pickedImage

        }
        _picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func importFromGallery(_ sender: Any) {
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        image.allowsEditing = false
        
        self.present(image, animated: true)
        {
            
        }
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinisjPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            myImageview.image = image
        }else{
            print("Error in importing image")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveImage(_ sender: Any) {
        
        let database = Database.database().reference()
        
        let storage = Storage.storage().reference()
        
        let userID: String = (Auth.auth().currentUser?.uid)!
        
        let tempImageRef = storage.child("ImagesUploaded/\(userID)")
        let id = String(format:"%.0f", Date().timeIntervalSince1970*1000)
        
        let image = myImageview.image
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        tempImageRef.child(id).putData(UIImageJPEGRepresentation(image!, 0.8)!, metadata: metaData){ (metadata, error) in
            if error == nil {
            print ("upload successful")
                let alert = UIAlertController(title: "Alert", message: "Saved Successfully", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else {
            print (error?.localizedDescription)
            }
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}