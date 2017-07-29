//
//  AddExerciseViewController.swift
//  Weight Lifting
//
//  Created by Jordan Jacobson on 11/7/17.
//  Copyright © 2017 Awesome Inc. All rights reserved.
//

import UIKit
import CoreData

class AddExerciseViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var repNumText: UITextField!
    @IBOutlet weak var setNumText: UITextField!
    
    @IBOutlet weak var chooseImage: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    var chosenExercise = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Exercise"
        imageView.image = UIImage(named: "placeholderForAddExercise")
        repNumText.keyboardType = UIKeyboardType.numberPad
        setNumText.keyboardType = UIKeyboardType.numberPad
        
        chooseImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddExerciseViewController.selectImage))
        chooseImage.addGestureRecognizer(gestureRecognizer)
        
        if (chosenExercise != "") {
            let context = DatabaseController.getContext()
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
            fetchRequest.predicate = NSPredicate(format: "name = %@", self.chosenExercise)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let name = result.value(forKey: "name") as? String {
                            nameText.text = name
                        }
                        
                        if let repNum = result.value(forKey: "repNum") as? String {
                            repNumText.text = repNum
                        }
                        
                        if let setNum = result.value(forKey: "setNum") as? String {
                            setNumText.text = setNum
                        }
                        
                        if let imageData = result.value(forKey: "image") as? Data {
                            let image = UIImage(data: imageData)
                            self.imageView.image = image
                        }
                    }
                }
            } catch {
                print("error")
            }
            
        } else {
            nameText.text = ""
            repNumText.text = ""
            setNumText.text = ""
            imageView.image = UIImage(named: "placeholderForAddExercise.png")
        }
    }
    
    func photoLibrary() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    func camera() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func selectImage() {
        
        //let picker = UIImagePickerController()
        //picker.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo library or Camera", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { (UIAlertAction) in
            self.camera()
        }
        
        let library = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default) { (UIAlertAction) in
            self.photoLibrary()
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        actionSheet.addAction(library)
        actionSheet.addAction(camera)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
        
        
    }
    
    
    func saveData() {
        let newExercise : Exercise = NSEntityDescription.insertNewObject(forEntityName: String(describing: Exercise.self), into: DatabaseController.getContext()) as! Exercise
        newExercise.name = self.nameText.text
        newExercise.repNum = self.repNumText.text
        newExercise.setNum = self.setNumText.text
        newExercise.image = UIImageJPEGRepresentation(self.imageView.image!, 1)! as NSData
        DatabaseController.saveContext()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newExerciseCreated"), object: nil)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        
        
        
        if (self.chosenExercise == "") {
            
            if (nameText.text != "") {
                
                
                do {
                    
                    // Check whether an exercise of the same name has been entered
                    let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "name = %@", nameText.text!)
                    fetchRequest.returnsObjectsAsFaults = false
                    let context = DatabaseController.getContext()
                    let results = try context.fetch(fetchRequest)
                    
                    if results.count == 0 {
                        
                        // Check if number of sets has been entered
                        if (setNumText.text == "" || repNumText.text == "") {
                            
                            var warningMessage : String = ""
                            if ((setNumText.text! == "") && (repNumText.text! == "")) {
                                warningMessage = "You have not entered an amount of sets or reps"
                            } else if (!(setNumText.text! == "") && (repNumText.text == "")) {
                                warningMessage = "You have not entered an amount of reps"
                            } else if ((setNumText.text! == "") && !(repNumText.text == "")) {
                                warningMessage = "You have not entered an amount of sets"
                            }
                            
                            let alert = UIAlertController(title: "Warning", message: warningMessage, preferredStyle: UIAlertControllerStyle.alert)
                            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
                            
                            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                                
                                self.saveData()
                              
                            })
                            
                            alert.addAction(cancel)
                            alert.addAction(ok)
                            self.present(alert, animated: true, completion: nil)
                            
                        } else {
                            saveData()
                        }
                        
                    } else {
                        let alert = UIAlertController(title: "Error", message: "You already have an exercise with the same name", preferredStyle: UIAlertControllerStyle.alert)
                        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                } catch {
                    print("error")
                }
                
                
                
                
            } else {
                let alert = UIAlertController(title: "Error", message: "Please enter an exercise name", preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)            }
            
        } else {
            
            let fetchRequest:NSFetchRequest<Exercise> = Exercise.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name = %@", self.chosenExercise)
            fetchRequest.returnsObjectsAsFaults = false
            
            
            do {
                let context = DatabaseController.getContext()
                
                let results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    for result in results as [NSManagedObject] {
                        result.setValue(nameText.text, forKey: "name")
                        result.setValue(repNumText.text, forKey: "repNum")
                        result.setValue(setNumText.text, forKey: "setNum")
                        result.setValue(UIImageJPEGRepresentation(imageView.image!,1), forKey: "image")
                        
                    }
                }
                try context.save()
                
            } catch {
                print("error")
            }
            
            
            
        }
        
        
        
        
    }
    
}










