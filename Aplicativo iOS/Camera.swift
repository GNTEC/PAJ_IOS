//
//  Camera.swift
//  Pintura a Jato
//
//  Created by daniel on 08/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import MobileCoreServices

class Camera : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //var dados_imagem : NSData?
    var funcao_sucesso: ((_ imagem:UIImage?) -> Void)?
    var controller: UIViewController?
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //let mediaType = (info[UIImagePickerControllerMediaType] as! String)
        var originalImage: UIImage!
        //var editedImage: UIImage!
        //var imageToSave: UIImage!
        
        // Handle a still image capture
            //editedImage = ((info[UIImagePickerControllerEditedImage] as! String) as! UIImage)
            originalImage = (info[UIImagePickerControllerOriginalImage] as! UIImage)
            //if editedImage != nil {
              //  imageToSave = editedImage!
            //}
            //else {
              //  imageToSave = originalImage!
            //}
            // Save the new image (original or edited) to the Camera Roll
            //UIImageWriteToSavedPhotosAlbum(imageToSave!, nil, nil, nil)
        
        //dados_imagem = UIImageJPEGRepresentation(originalImage, 1.0)
        
        var parentViewController: UIViewController?
        
        if picker.presentingViewController != nil {
            parentViewController = picker.presentingViewController
        }
        else {
            parentViewController = picker.parent
        }

        parentViewController?.dismiss(animated: true, completion:{ () -> Void in
            self.funcao_sucesso!(originalImage)
            })

    }
    
    static func selecionaFotoGaleria(_ controller: UIViewController?, sucesso: @escaping (_ imagem: UIImage?) -> Void) -> Camera? {
        
        if (UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) == false) || (controller == nil) {
            return nil
        }
        
        let camera = Camera()
        camera.funcao_sucesso = sucesso
        
        let mediaUI = UIImagePickerController()
        mediaUI.sourceType = .savedPhotosAlbum
        
        // Displays saved pictures and movies, if both are available, from the
        // Camera Roll album.
        mediaUI.mediaTypes = [kUTTypeImage as String]
        // Hides the controls for moving & scaling pictures, or for
        // trimming movies. To instead show the controls, use YES.
        mediaUI.allowsEditing = false
        mediaUI.delegate = camera
        
        controller!.present(mediaUI, animated: true, completion:nil)
        
        return camera

    }
    
    static func disparaCapturaFoto(_ controller: UIViewController?, sucesso: @escaping (_ imagem: UIImage?) -> Void) -> Camera? {
        
        if (UIImagePickerController.isSourceTypeAvailable(.camera) == false) {
            return nil
        }
        
        let camera = Camera()
        camera.funcao_sucesso = sucesso
        
        let cameraUI = UIImagePickerController()
        cameraUI.sourceType = .camera
        
        // Displays a control that allows the user to choose picture or
        // movie capture, if both are available:
        cameraUI.mediaTypes = [kUTTypeImage as String]
        
        // Hides the controls for moving & scaling pictures, or for
        // trimming movies. To instead show the controls, use YES.
        cameraUI.allowsEditing = false
        cameraUI.delegate = camera
        
        controller!.present(cameraUI, animated: true, completion:nil)
        
        return camera

    }
}
