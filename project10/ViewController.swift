//
//  ViewController.swift
//  project10
//
//  Created by Waterflow Technology on 10/04/2025.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //UIImagePickerControllerDelegate tells us, user either selected a picture or cancelled the picker.
    //It has two methods and both are optional.
    //We care about is imagePickerController(_, didFinishPickingMediaWithInfo:),
    //which returns when the user selected an image and it's being returned to you.
    
    //This method needs to do several things:
    
    // - Extract the image from the dictionary that is passed as a parameter.
    // - Generate a unique filename for it.
    // - Convert it to a JPEG, then write that JPEG to disk.
    // - Dismiss the view controller.
    
    //dictionary parameter will contain one of two keys:
    // .editedImage (the image that was edited) or .originalImage.
    
    //here dictionary will always have .editedImage (the edited version), because we have set allowsEditing = true.
    
    //All apps that are installed have a directory called Documents where you can save private information for the app, and it's also automatically synchronized with iCloud
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
      
    }
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else{return};
        let imageName = UUID().uuidString;
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName);
        
        if let jpegData = image.jpegData(compressionQuality: 0.8){
            try? jpegData.write(to: imagePath);
        }
        dismiss(animated: true) //dismiss the topmost view controller i.e. Image picker for this case.
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            //This line crashes the app with an exception
            fatalError("Unable to dequeue Person cell")
        }
        return cell
        
    }
}

