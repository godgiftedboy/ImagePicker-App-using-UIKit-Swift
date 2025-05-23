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
    
    var people = [Person]();
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
      
    }
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        //Try using picker.sourceType = .camera when creating your image picker, which will tell it to create a new image by taking a photo. This is only available on devices (not on the simulator) so you might want to check the return value of UIImagePickerController.isSourceTypeAvailable() before trying to use it!
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else{return};
        let imageName = UUID().uuidString;
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName);
        
        if let jpegData = image.jpegData(compressionQuality: 0.8){
            try? jpegData.write(to: imagePath);
        }
        
        let person = Person(name: "Unknwon", image: imageName)
        people.append(person);
        collectionView.reloadData();
        dismiss(animated: true) //dismiss the topmost view controller i.e. Image picker for this case.
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            //This line crashes the app with an exception
            fatalError("Unable to dequeue Person cell")
        }
        
        let person = people[indexPath.item]
        //item in collection as it is grid (collectionView)
        //It was row in tableView.

        cell.name.text = person.name //UILabel has reusable Identifier as name in our custom PersonCell class.

        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        
        //reusable Identifier as imageView
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        //adding some styles
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        let ac = UIAlertController(title: "Select action", message: nil, preferredStyle: .alert);
        ac.addAction(UIAlertAction(title: "Delete", style: .default){
            [weak self] action in
            self?.people.remove(at: indexPath.item)
            self?.collectionView.reloadData()
        })
        ac.addAction(UIAlertAction(title: "Rename", style: .default){
            [weak self] action in
            let acr = UIAlertController(title: "Rename Person", message: nil, preferredStyle: .alert);
            acr.addTextField()
            acr.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            acr.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak acr] action in
                   guard let newName = acr?.textFields?[0].text else { return }
                   person.name = newName
                
                   self?.collectionView.reloadData()
               })
            self?.present(acr, animated: true);
        })
        present(ac, animated: true);
        
        
        
    }
  
}

