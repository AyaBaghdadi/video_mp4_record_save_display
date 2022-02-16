//
//  ViewController.swift
//
//  Created by Technicalisto.
//

import UIKit
import AVKit
import MobileCoreServices

class ViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    @IBOutlet weak var videoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
//------------------------------------------------------------------------------------------------------------

    @IBAction func recordTapped(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            
             print("Camera Available")

            let videoPicker = UIImagePickerController()
            videoPicker.delegate = self
            videoPicker.sourceType = .camera
            videoPicker.mediaTypes = [kUTTypeMovie as String] // MobileCoreServices
            videoPicker.allowsEditing = false

             self.present(videoPicker, animated: true, completion: nil)
            
         }else{
             
             print("Camera UnAvaialable")
         }
        
    }
    
//------------------------------------------------------------------------------------------------------------
  
    //MARK:- UINavigationControllerDelegate
    
    var myPickedVideo:NSURL! = NSURL()
    
    var VideoToPass:Data!

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Close
        dismiss(animated: true, completion: nil)

        guard
            let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
            mediaType == (kUTTypeMovie as String),
            let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL,
            UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
            
            else {
                return
            }
        
        
        if let pickedVideo:NSURL = (info[UIImagePickerController.InfoKey.mediaURL] as? NSURL) {

            // Get Video URL
            self.myPickedVideo = pickedVideo
            
            do {
                try? VideoToPass = Data(contentsOf: pickedVideo as URL)
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let documentsDirectory = paths[0]
                let tempPath = documentsDirectory.appendingFormat("/vid.mp4")
                let url = URL(fileURLWithPath: tempPath)
                do {
                    try? VideoToPass.write(to: url, options: [])
                }

                // If you want display Video here 1
            }
        }
        // Handle a movie capture
         UISaveVideoAtPathToSavedPhotosAlbum(
             url.path,
             self,
            #selector(video(_:didFinishSavingWithError:contextInfo:)),
             nil)
    }
    
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        
        let title = (error == nil) ? "Success" : "Error"
        let message = (error == nil) ? "Video was saved" : "Video failed to save"

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
        // If you want use Video here 2

    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

//------------------------------------------------------------------------------------------------------------

    @IBAction func displayVideoTapped(_ sender: Any) {
        
        if self.myPickedVideo != nil {
            
        self.DisplayVideoFromData(videoURL: self.myPickedVideo,myView: self.videoView)
            
        }
        
    }
    
    @objc func DisplayVideoFromData(videoURL:NSURL,myView:UIView){
                
        let player = AVPlayer(url: videoURL as URL)

        let playerLayer = AVPlayerLayer(player: player)
        
        playerLayer.videoGravity = .resizeAspectFill //
        playerLayer.needsDisplayOnBoundsChange = true //
        playerLayer.frame = myView.bounds // 1

        myView.layer.masksToBounds = true // 2
        myView.layer.addSublayer(playerLayer)
        
        player.play()
        
    }
    
}




