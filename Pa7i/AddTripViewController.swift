//
//  AddTripViewController.swift
//  Pa7
//  This class is the view controller for adding a trip. Allows the user to add adestination, start date, and end date, and if all input is valid the trip will be added to the table view
//  CPSC 315-01, Fall 2020
//  No sources to cite
//  Created by Walker, Charles Milton on 11/5/20.
//  Copyright © 2020 Walker, Charles Milton. All rights reserved.
//

import UIKit
import CoreData

class AddTripViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let dateFormatter = DateFormatter()
    var tripOptional: Trip? = nil
    var tripNum: Int = 1
    let alert = UIAlertController(title: "Error", message: "Missing destination", preferredStyle: .alert)
    let startDateAlert = UIAlertController(title: "Error", message: "Invalid start date", preferredStyle: .alert)
    let endDateAlert = UIAlertController(title: "Error", message: "Invalid end date", preferredStyle: .alert)
    let continueAction = UIAlertAction(title: "Continue", style: .cancel, handler: nil)
    let addImageAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    var imageAdded = false
    var allCorrect = true
    var imageFileName = ""
    var image: UIImage? = nil
    
    @IBOutlet var tripNumLabel: UILabel!
    @IBOutlet var destTextField: UITextField!
    @IBOutlet var startTextField: UITextField!
    @IBOutlet var endTextField: UITextField!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var addImageButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tripNumLabel.text = "Add Trip #" + String(tripNum)
        alert.addAction(continueAction)
        startDateAlert.addAction(continueAction)
        endDateAlert.addAction(continueAction)
        addImageAlert.addAction(continueAction)

    }

/*dismisses thew keyboard when the background is tapped */
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        print("background tapped")
        destTextField.resignFirstResponder()
        startTextField.resignFirstResponder()
        endTextField.resignFirstResponder()
    }
/*
 Creates and saves the new trip if all inpiut fields are valid
*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        tripOptional = Trip(context: self.context)
        dateFormatter.dateFormat = "MM/dd/yyyy"
            if let identifier = segue.identifier {
                if identifier == "SaveUnwindSegue" {
                    if let dest = destTextField.text, let startDate = dateFormatter.date(from: startTextField.text ?? "Unknown"), let endDate = dateFormatter.date(from: endTextField.text ?? "Unknown") {
                        if allCorrect {
                            if let trip = tripOptional {
                                trip.destinationName = dest
                                trip.startDate = startDate
                                trip.endDate = endDate
                                trip.imageFileName = nil
                                if imageAdded == true {
                                    writeImage()
                                    trip.imageFileName = imageFileName
                                }
                                saveTrip()
                        }
                    }
                }
            }
        }
    }
/*checks if all input is valid, if not then displays an alert
 */
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        checkDest()
        if allCorrect {
            return true
        }
        return false
    }
    func checkDest(){
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let startDate = dateFormatter.date(from: startTextField.text ?? "Unknown")
        let endDate = dateFormatter.date(from: endTextField.text ?? "Unknown")
        if destTextField.text == "" {
            present(alert,animated: true)
            allCorrect = false
            return
        }
        if startDate == nil {
            present(startDateAlert, animated: true)
            allCorrect = false
            return
        }
        if endDate == nil {
            present(endDateAlert, animated: true)
            allCorrect = false
            return
       }

        allCorrect = true
    }
/*
     When the AddImage button is pressed, an alert is presented which will have a combination of the three actions depending on the device thaqt the user has
     */
    @IBAction func addImageButtonPressed(_ sender: UIButton) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            let libraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { (_) in
                imagePicker.sourceType = .photoLibrary
            })
            addImageAlert.addAction(libraryAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                imagePicker.sourceType = .camera
            })
            addImageAlert.addAction(cameraAction)
        }
        present(imagePicker, animated: true)
        present(addImageAlert, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image

        imagePickerControllerDidCancel(picker)
        imageAdded = true
        imageFileName = "\(UUID().uuidString).jpg"
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
/*
     Writes the image path to disk
     */
    func writeImage() {
        let imagePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(imageFileName)
        if let jpegData = image!.jpegData(compressionQuality: 1) {
            try? jpegData.write(to: imagePath)
        }
        print(imagePath)
    }

    func saveTrip() {
        // we want to save the context "to disk" (db)
        do {
            try context.save() // like git commit
        }
        catch {
            print("Error saving trips \(error)")
        }
    }
    
}
