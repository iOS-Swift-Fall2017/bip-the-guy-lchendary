//
//  ViewController.swift
//  Bip The Guy
//
//  Created by Linda Chen on 9/19/17.
//  Copyright © 2017 Synestha. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: PROPERTIES
    @IBOutlet weak var picture:UIImageView?
    
    var player = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: ACTIONS
    @IBAction func guyTapped(_sender:UITapGestureRecognizer){
        animateImage()
        playSound(soundName: "punch", audioPlayer: &player)
    }
    
    @IBAction func libraryTapped(_sender:UIButton) {
        //Create instance of image picker controller.
        let picker = UIImagePickerController()
        //Set delegate.
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func cameraTapped(_ sender: UIButton) {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            present(picker, animated: true, completion: nil)
        } else {
            showAlert(title: "Camera Not Available", message: "There is no camera available on this device.")
        }
    }
    
    //MARK: FUNCTIONS
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    func animateImage() {
        let bounds = self.picture?.bounds
        let shrink: CGFloat = 60
        
        // shrink our image
        self.picture?.bounds = CGRect(x: self.picture!.bounds.origin.x + shrink, y: self.picture!.bounds.origin.y + shrink, width: self.picture!.bounds.size.width - shrink, height: (self.picture?.bounds.size.height)! - shrink)
        
        // then animate it back out to the original bounds
        // Higher numbers are stronger.
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: [], animations: { self.picture?.bounds = bounds! }, completion: nil)
    }
    
    func playSound(soundName: String, audioPlayer: inout AVAudioPlayer) {
        
        // Is it possible to load in the sound file?
        if let sound = NSDataAsset(name: soundName) {
            // check if sound.data is a usable file
            do {
                try audioPlayer = AVAudioPlayer(data: sound.data)
                audioPlayer.play()
            } catch {
                // if sound.data is not a valid audio file
                print("ERROR: file \(soundName) didn't load.")
            }
        } else {
            // if reading the assets folder didn't work
            print("ERROR: file \(soundName) didn't load.")
        }
        
    }

    
    //What happens when the user selects a photo?
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Create a holder variable for the image.
        var chosenImage = UIImage()
        //Save the image onto the variable.
        if let editedImage = info["UIImagePickerControllerEditedImage"] {
            chosenImage = editedImage as! UIImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] {
            chosenImage = originalImage as! UIImage
        }
        //Update the image view.
        picture?.image = chosenImage
        //Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //What happens when the user hits cancel?
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }


}

