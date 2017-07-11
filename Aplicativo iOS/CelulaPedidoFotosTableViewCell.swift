//
//  CelulaPedidoFotosTableViewCell.swift
//  Pintura a Jato
//
//  Created by daniel on 17/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import UIKit

enum EstadosProcessamentoImagem {
    case semImagem
    case carregandoImagem
    case comImagem
    case erroCarregandoImagem
}

typealias conclusaoFotoObtida = (_ imagem:UIImage?, _ antes: Bool, _ sequencia: Int) -> Void
typealias conclusaoExibirDetalhe = (_ antes:Bool, _ url: String?, _ imagem: UIImage?) -> Void

class CelulaPedidoFotosTableViewCell: UITableViewCell {
    @IBOutlet weak var imagem_antes: UIImageView!
    @IBOutlet weak var imagem_depois: UIImageView!
    @IBOutlet weak var activity_antes: UIActivityIndicatorView!
    @IBOutlet weak var botao_adicionar_antes: UIButton!
    @IBOutlet weak var activity_depois: UIActivityIndicatorView!
    @IBOutlet weak var botao_adicionar_depois: UIButton!
    @IBOutlet weak var label_erro_antes: UILabel!
    @IBOutlet weak var label_erro_depois: UILabel!
    
    var itemFoto : ItemAntesDepois?
    var permiteNovaFoto = false
    var viewController: UIViewController?
    var camera: Camera?
    var conclusaoFoto: conclusaoFotoObtida?
    var conclusaoExibir: conclusaoExibirDetalhe?
    //var sequencia: Int = 1
    
    func definePermiteNovaFoto(_ permite: Bool) {
        self.permiteNovaFoto = permite
        
        if !permite {
            botao_adicionar_depois.isHidden = true
            botao_adicionar_antes.isHidden = true
        }
    }
    
    func defineItemFoto(_ itemFoto: ItemAntesDepois?) {
        self.itemFoto = itemFoto
        
        if itemFoto?.urlAntesPequena != nil {
            
            defineEstadoImagem(.carregandoImagem, antes: true)
            
            Imagem.carregaImagemUrlAssincrona(itemFoto!.urlAntesPequena!, sucesso: { (imagem) in
                
                if imagem == nil {
                    self.defineEstadoImagem(.erroCarregandoImagem, antes: true)
                    return
                }
                self.imagem_antes.image = imagem
                
                self.defineEstadoImagem(.comImagem, antes: true)
                }, falha: { (url) in })
        }
        
        
        if itemFoto?.urlDepoisPequena != nil {
            
            defineEstadoImagem(.carregandoImagem, antes: false)
            
            Imagem.carregaImagemUrlAssincrona(itemFoto!.urlDepoisPequena!, sucesso: { (imagem) in
                
                if imagem == nil {
                    self.defineEstadoImagem(.erroCarregandoImagem, antes: false)
                    return
                }
                self.imagem_depois.image = imagem
                
                self.defineEstadoImagem(.comImagem, antes: false)
            }, falha: { (url) in })
        }
    }
    
    
    @IBAction func onAdicionarAntes(_ sender: AnyObject) {
        
        if !permiteNovaFoto {
            return
        }
        
        let destino : (UIImage?) -> Void = { (imagem: UIImage?) in
            
            if imagem == nil {
                return
            }

            self.defineImagem(imagem, antes:true)
            self.itemFoto?.imagemGrandeAntes = imagem
            
            self.conclusaoFoto?(imagem, true, self.itemFoto!.sequencia);
        }
        
        #if DEBUG
            camera = Camera.selecionaFotoGaleria(viewController, sucesso: destino)
        #else
            camera = Camera.disparaCapturaFoto(viewController, sucesso: destino)
        #endif
    }

    @IBAction func onAdicionarDepois(_ sender: AnyObject) {
        
        if !permiteNovaFoto {
            return
        }
        
        let destino : (UIImage?) -> Void = { (imagem: UIImage?) in
            
            if imagem == nil {
                return
            }
            
            self.defineImagem(imagem, antes:false)
            self.itemFoto?.imagemGrandeDepois = imagem
            
            self.conclusaoFoto?(imagem, false, self.itemFoto!.sequencia)
        }
        
        #if DEBUG
            camera = Camera.selecionaFotoGaleria(viewController, sucesso: destino)
        #else
            camera = Camera.disparaCapturaFoto(viewController, sucesso: destino)
        #endif
    }
    
    func defineImagem(_ imagem: UIImage?, antes: Bool) {
        
        if(antes && imagem != nil) {
            //fotoAntes = bitmap;
            imagem_antes.image = (imagem);
        }
    
        if(!antes && imagem != nil) {
            //fotoDepois = bitmap;
            imagem_depois.image = (imagem);
        }
    
        defineEstadoImagem(imagem == nil ? EstadosProcessamentoImagem.semImagem : EstadosProcessamentoImagem.comImagem, antes: antes);
    }
    
    func defineEstadoImagem(_ estado: EstadosProcessamentoImagem, antes: Bool) {
        
        let imagem : UIImageView! = antes ? imagem_antes : imagem_depois
        let botao : UIButton! = antes ? botao_adicionar_antes : botao_adicionar_depois
        let activity : UIActivityIndicatorView!  = antes ? activity_antes : activity_depois
        let label_erro : UILabel! = antes ? label_erro_antes : label_erro_depois
        
        if(estado == EstadosProcessamentoImagem.semImagem) {
            imagem.isHidden = true
            botao.isHidden = false
            activity.isHidden = true
            activity.stopAnimating()
            label_erro.isHidden = true
        }
        else if(estado == EstadosProcessamentoImagem.carregandoImagem) {
            imagem.isHidden = true
            botao.isHidden = true
            activity.isHidden = false
            activity.startAnimating()
            label_erro.isHidden = true
        }
        else if(estado == EstadosProcessamentoImagem.comImagem) {
            imagem.isHidden = false
            botao.isHidden = true
            activity.isHidden = true
            activity.stopAnimating()
            label_erro.isHidden = true
            
            imagem.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: antes ? #selector(handleTapAntes) : #selector(handleTapDepois))
            imagem.addGestureRecognizer(gesture)
        }
        else if(estado == EstadosProcessamentoImagem.erroCarregandoImagem) {
            imagem.isHidden = true
            botao.isHidden = true
            activity.isHidden = true
            activity.stopAnimating()
            label_erro.isHidden = false
        }
    }
    
    func handleTapAntes(_ sender: UITapGestureRecognizer) {
        
        if sender.state == .ended {
            self.conclusaoExibir?(true, itemFoto?.urlAntesGrande, itemFoto?.imagemGrandeAntes)
        }
    }
    
    func handleTapDepois(_ sender: UITapGestureRecognizer) {
    
        if sender.state == .ended {
            self.conclusaoExibir?(false, itemFoto?.urlDepoisGrande, itemFoto?.imagemGrandeDepois)
        }
    }
}
