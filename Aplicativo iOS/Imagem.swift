//
//  Imagem.swift
//  Pintura a Jato
//
//  Created by daniel on 08/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import UIKit

class Imagem {
    
    //static var imagensPendentes = [NSData]()
    
    static func carregaImagemUrlAssincrona(_ url: String, sucesso: @escaping (_ imagem: UIImage?) -> Void, falha: @escaping (_ url: String?) -> Void) {
        
        let urlImagem = URL(string: url)
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high).async(execute: {() -> Void in
            
            let imageData = try? Foundation.Data(contentsOf: urlImagem!)
            
            //imagensPendentes.append(imageData!)
            
            DispatchQueue.main.async(execute: {() -> Void in
                
                if imageData == nil {
                    sucesso(nil)
                    return
                }
                
                let image = UIImage(data: imageData!)
                
                if image != nil {
                
                    sucesso(image)
                }
                else {
                    falha(url)
                }
                
                /*let indice = imagensPendentes.indexOf(imageData!)
                
                if indice != nil {
                    imagensPendentes.removeAtIndex(indice!)
                }*/
                
            })
        })

    }
    
    static func ajustaTamanhoImagem(_ image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        //UIGraphicsBeginImageContext(newSize);
        // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
        // Pass 1.0 to force exact pixel size.
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
