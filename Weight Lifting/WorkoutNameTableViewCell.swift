//
//  WorkoutNameTableViewCell.swift
//  Weight Lifting
//
//  Created by Jordan Jacobson on 12/7/17.
//  Copyright © 2017 Awesome Inc. All rights reserved.
//

import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController!
            }
        }
        return nil
    }
}

class WorkoutNameTableViewCell: UITableViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var workoutNameText: UITextField!
    @IBOutlet weak var chooseImage: UIImageView!
    @IBOutlet weak var workoutImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        chooseImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(WorkoutNameTableViewCell.selectImage))
        chooseImage.addGestureRecognizer(gestureRecognizer)

    }

    
    func photoLibrary() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        parentViewController?.present(picker, animated: true, completion: nil)
    }
    
    func camera() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = true
        parentViewController?.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        workoutImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        parentViewController?.dismiss(animated: true, completion: nil)
    }
    
    func selectImage() {
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
        parentViewController?.present(actionSheet, animated: true, completion: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

}
