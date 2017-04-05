//
//  PinturaAJatoApi.swift
//  Pintura a Jato
//
//  Created by daniel on 28/08/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class PinturaAJatoApi {
    
    init() {
        
    }
    
    static var franqueado: Franqueado?
    static var sessao: Sessao?
    
    static func defineSessao(_ sessao: Sessao?) {
        self.sessao = sessao
    }
    
    static func defineFranqueado(_ franqueado: Franqueado?) {
        
        if(franqueado != nil) {
            
            Crashlytics.sharedInstance().setUserEmail(franqueado?.email);
            Crashlytics.sharedInstance().setUserName(franqueado?.nome);
            Crashlytics.sharedInstance().setUserIdentifier(String.init(format:"%d", (franqueado?.id)!));
        }
        
        self.franqueado = franqueado
    }
    
    static func obtemFranqueado() -> Franqueado? {
        return self.franqueado
    }
    
    static func obtemIdSessao() -> String {
        
        if self.sessao?.id == nil {
            return ""
        }
        
        return self.sessao!.id!
    }
    
    let urlBase = "https://www.pinturaajato.com/api/"
    let urlBaseManuais = "https://www.pinturaajato.com/uploads/manual/"
    let urlBaseFotosUsuarios = "https://www.pinturaajato.com/uploads/usuario/"
    let urlBaseFotosPedidos =  "https://www.pinturaajato.com/uploads/foto/"
    let urlBaseFotosProdutos = "https://www.pinturaajato.com/uploads/produto/"
    let mensagem = "Processando"
    
    func exibeProcessando(_ view: UIView) {

        DispatchQueue.main.async { 
            let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.labelText = self.mensagem
            loadingNotification.show(true)
            loadingNotification.dimBackground = true
        }
        
    }
    
    func escondeProcessando(_ view: UIView) {
        DispatchQueue.main.async {
            MBProgressHUD.hideAllHUDs(for: view, animated: true)
        }
    }
    
    func lembrarSenha(_ view: UIView, parametros: [String : AnyObject], sucesso: @escaping (_ resultado:Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
    
        Alamofire.request(urlBase + "lembrarSenha", method: .post, parameters: parametros, encoding: JSONEncoding.default, headers: nil).responseJSON { (resposta:DataResponse<Any>) in
            
            self.escondeProcessando(view)
            
            switch(resposta.result.error.result) {
            case .success(_):
                
                if let data = resposta.result.error.result.value{
                    print(resposta.result.error.result.value)
                    
                    
                    let saida = resposta.result.value
                    
                    if (saida? as AnyObject).resultado != nil && saida?.resultado?.erro == false {
                        
                        sucesso(resultado: saida?.resultado)
                    }
                    else {
                        AvisoProcessamento.mensagemErroGenerico(saida?.resultado?.mensagem)
                    }
                    
                }
                return
                
            case .failure(_):
                print(resposta.result.error.result.error)
                
                self.trataErroGenerico(resposta.result.error)
                return
                
            }
        }
        
//        Alamofire.request(.POST, urlBase + "lembrarSenha", parameters: parametros)
//            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
//                print(resposta.request?.URLString)
//                print(resposta)
//            })
//            .responseObject { (resposta: Response<BaseSaida, NSError>)  in
//                
//                self.escondeProcessando(view)
//                
//                if resposta.result.error != nil {
//                    
//                    self.trataErroGenerico(resposta.result.error)
//                    
//                    return
//                }
//                
//                let saida = resposta.result.value
//                
//                if saida?.resultado != nil && saida?.resultado?.erro == false {
//                    
//                    sucesso(resultado: saida?.resultado)
//                }
//                else {
//                    AvisoProcessamento.mensagemErroGenerico(saida?.resultado?.mensagem)
//                }
//                
//        }
//    }
    
    func validarUsuario(_ view: UIView, parametros: [String : AnyObject], sucesso: @escaping (_ objeto:Franqueado?, _ sessao: Sessao?, _ resultado:Bool) -> Bool) {
       
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "validarUsuario", parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(resposta)
            })
            .responseObject { (resposta: Response<LoginSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }

                let login: LoginSaida? = resposta.result.value
     
                if login?.resultado?.erro == false {
                    
                    sucesso(objeto: login?.franqueado, sessao: login?.sessao, resultado: (login?.resultado?.erro)!)
                }
                else {
                    AvisoProcessamento.mensagemErroGenerico(login?.resultado?.mensagem)
                }
                
        }
    }
    
    func buscarOrcamentosCompletosPorFranquia(_ view: UIView, parametros: [String : AnyObject], sucesso: @escaping (_ objeto:[OrcamentoDetalhe]?, _ resultado:Bool) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "buscarOrcamentosCompletosPorFranquia", parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(resposta)
            })
            .responseObject { (resposta: Response<HistoricoSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let login: HistoricoSaida? = resposta.result.value
                
                if login?.resultado?.erro == false {
                    
                    sucesso(objeto: login?.orcamento, resultado: (login?.resultado?.erro)!)
                }
                
                
        }
    }
    
    func buscarAgendaPorFranquia(_ view:UIView, parametros: [String: AnyObject], sucesso: @escaping (_ objeto:[ItemHistoricoCalendario]?, _ resultado:Bool) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "buscarAgendaPorFranquia", parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(resposta)
            })
            .responseObject { (resposta: Response<BuscaAgendaOrcamentoSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: BuscaAgendaOrcamentoSaida? = resposta.result.value
                
                if saida?.resultado?.erro == false {
                    
                    sucesso(objeto: saida?.agenda, resultado: (saida?.resultado?.erro)!)
                }
                
                
        }
    }
    
    func avaliacao(_ view:UIView, tipo: String, parametros: [String:AnyObject], sucesso: @escaping (_ objeto:Avaliacao?, _ tipo: String, _ resultado:Bool) -> Bool ) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "avaliacao/" + tipo , parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(resposta)
            })
            .responseObject { (resposta: Response<ConsultaAvaliacaoSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }

                let saida: ConsultaAvaliacaoSaida? = resposta.result.value
                
                if saida?.resultado?.erro == false {
                    
                    sucesso(objeto: saida?.avaliacao, tipo:tipo, resultado: (saida?.resultado?.erro)!)
                }
                
                
        }
    }
    
    func incluirAgendaBloqueio(_ view: UIView, parametros: [String:AnyObject], sucesso: @escaping (_ objeto:Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "incluirAgendaBloqueio" , parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(resposta)
            })
            .responseObject { (resposta: Response<BaseSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: BaseSaida? = resposta.result.value
                
                sucesso(objeto: saida?.resultado)
        }
    }
    
    func financeiro(_ view:UIView, tipo: String, parametros: [String:AnyObject], sucesso: @escaping (_ objeto:[Recebimento]?, _ tipo: String, _ resultado:Bool) -> Bool ) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "financeiro/" + tipo , parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(resposta)
            })
            .responseObject { (resposta: Response<ConsultaRecebimentosSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: ConsultaRecebimentosSaida? = resposta.result.value
                
                if saida?.resultado?.erro == false {
                    
                    var itens: [Recebimento]?
                    
                    if tipo == "recebido" {
                        itens = saida?.recebido
                    }
                    else if tipo == "receber" {
                        itens = saida?.receber
                    }
                    if tipo == "cancelado" {
                        itens = saida?.cancelado
                    }
                    
                    sucesso(objeto: itens, tipo:tipo, resultado: (saida?.resultado?.erro)!)
                }
                
                
        }
    }
    
    func financeiroDetalhe(_ view:UIView, tipo: String, parametros: [String:AnyObject], sucesso: @escaping (_ objeto:[RecebimentoDetalhe]?, _ tipo: String, _ resultado:Bool) -> Bool ) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "financeiro/" + tipo + "/detalhe" , parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(resposta)
            })
            .responseObject { (resposta: Response<ConsultaRecebimentoDetalheSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }

                let saida: ConsultaRecebimentoDetalheSaida? = resposta.result.value
                
                if saida?.resultado?.erro == false {
                    
                    var itens: [RecebimentoDetalhe]?
                    
                    if tipo == "recebido" {
                        itens = saida?.recebido
                    }
                    else if tipo == "receber" {
                        itens = saida?.receber
                    }
                    if tipo == "cancelado" {
                        itens = saida?.cancelado
                    }
                    
                    sucesso(objeto: itens, tipo:tipo, resultado: (saida?.resultado?.erro)!)
                }
                
                
        }
    }
    
    func trocarSenhaApp(_ view: UIView, parametros: [String:AnyObject], sucesso: @escaping (_ objeto:Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "trocarSenhaApp" , parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(resposta)
            })
            .responseObject { (resposta: Response<BaseSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: BaseSaida? = resposta.result.value
                
                sucesso(objeto: saida?.resultado)
        }
    }
    
    func buscarManuaisETreinamentos(_ view: UIView, parametros: [String:AnyObject]?, sucesso: @escaping (_ objeto:[Manual]?, _ falha:Bool) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "buscarManuaisETreinamentos" , parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(resposta)
            })
            .responseObject { (resposta: Response<ConsultaManuaisTreinamentosSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: ConsultaManuaisTreinamentosSaida? = resposta.result.value
                
                sucesso(objeto: saida?.manual, falha: (saida?.resultado!.erro)!)
        }
    }
    
    func buscarCartoesPorFranquia(_ view: UIView, parametros: [String:AnyObject]?, sucesso: @escaping (_ objeto:[Cartao]?, _ falha:Bool) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "buscarCartoesPorFranquia" , parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(resposta)
            })
            .responseObject { (resposta: Response<ConsultaCartoesSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: ConsultaCartoesSaida? = resposta.result.value
                
                sucesso(objeto: saida?.cartoes, falha: (saida?.resultado!.erro)!)
        }
    }
    
    func incluirCartao(_ view: UIView, parametros: [String:AnyObject], sucesso: @escaping (_ objeto:Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "incluirCartao" , parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(resposta)
            })
            .responseObject { (resposta: Response<BaseSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: BaseSaida? = resposta.result.value
                
                sucesso(objeto: saida?.resultado)
        }
    }
    
    func buscarProdutos(_ view: UIView, parametros: [String:AnyObject]?, sucesso: @escaping (_ objeto:[Produto]?, _ falha:Bool) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "buscarProdutos" , parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(resposta)
            })
            .responseObject { (resposta: Response<ConsultaProdutosSaida, NSError>)  in
                
                self.escondeProcessando(view)

                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }

                
                let saida: ConsultaProdutosSaida? = resposta.result.value
                
                sucesso(objeto: saida?.produtos, falha: (saida?.resultado!.erro)!)
        }
    }
    
    func inserirFoto(_ view:UIView, parametros: [String:AnyObject]?, foto_pequena:UIImage?, foto_grande: UIImage?, sucesso: @escaping (_ resultado:Bool, _ mensagem: String?) -> Bool) {
        
        exibeProcessando(view)
        
        let id_franquia = parametros?["id_franquia"] as! String,
            id_sessao = parametros?["id_sessao"] as! String,
            id_sequencia = parametros?["id_sequencia"] as! String,
            id_orcamento = parametros?["id_orcamento"] as! String,
            formato = parametros?["formato"] as! String,
            antes_depois = parametros?["antes_depois"] as! String
        
        Alamofire.upload(.POST,
                         urlBase + "inserirFoto" ,
                         multipartFormData: { multipartFormData in
                            multipartFormData.appendBodyPart(data: id_franquia.dataUsingEncoding(NSUTF8StringEncoding)!, name: "id_franquia")
                            multipartFormData.appendBodyPart(data: id_sessao.dataUsingEncoding(NSUTF8StringEncoding)!, name: "id_sessao")
                            multipartFormData.appendBodyPart(data: id_sequencia.dataUsingEncoding(NSUTF8StringEncoding)!, name: "id_sequencia")
                            multipartFormData.appendBodyPart(data: formato.dataUsingEncoding(NSUTF8StringEncoding)!, name: "formato")
                            multipartFormData.appendBodyPart(data: id_orcamento.dataUsingEncoding(NSUTF8StringEncoding)!, name: "id_orcamento")
                            multipartFormData.appendBodyPart(data: antes_depois.dataUsingEncoding(NSUTF8StringEncoding)!, name: "antes_depois")
                            multipartFormData.appendBodyPart(data: UIImageJPEGRepresentation(foto_pequena!, 1.0)!, name: "fotop", fileName: "fotop.jpg", mimeType: "image/jpeg")
                            multipartFormData.appendBodyPart(data: UIImageJPEGRepresentation(foto_grande!, 1.0)!, name: "fotog", fileName: "fotog.jpg", mimeType: "image/jpeg")
            },
                         encodingCompletion: { encodingResult in
                            
                            
                            switch encodingResult {
                            case .Success(let upload, _, _):
                                upload.responseString { response in
                                    self.escondeProcessando(view)
                                    debugPrint(response)
                                    sucesso(resultado: true, mensagem: response.result.value)
                                }
                            case .Failure(let encodingError):
                                self.escondeProcessando(view)
                                debugPrint(encodingError)
                                sucesso(resultado: false, mensagem: nil/*encodingError*/)
                            }
            }
        )
    }
    
    func inserirFotoUsuario(_ view:UIView, parametros: [String:AnyObject]?, foto:UIImage?, sucesso: @escaping (_ resultado:Bool, _ mensagem: String?) -> Bool) {
        
        exibeProcessando(view)
        
        let id_franquia = parametros?["id_franquia"] as! String,
            id_sessao = parametros?["id_sessao"] as! String,
            id_usuario = parametros?["id_usuario"] as! String,
            formato = parametros?["formato"] as! String
        
        Alamofire.upload(.POST,
            urlBase + "inserirFotoUsuario" ,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: id_franquia.dataUsingEncoding(NSUTF8StringEncoding)!, name: "id_franquia")
                multipartFormData.appendBodyPart(data: id_sessao.dataUsingEncoding(NSUTF8StringEncoding)!, name: "id_sessao")
                multipartFormData.appendBodyPart(data: id_usuario.dataUsingEncoding(NSUTF8StringEncoding)!, name: "id_usuario")
                multipartFormData.appendBodyPart(data: formato.dataUsingEncoding(NSUTF8StringEncoding)!, name: "formato")
                multipartFormData.appendBodyPart(data: UIImageJPEGRepresentation(foto!, 1.0)!, name: "foto", fileName: "foto.jpg", mimeType: "image/jpeg")
            },
            encodingCompletion: { encodingResult in
                
                
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseString { response in
                        self.escondeProcessando(view)
                        debugPrint(response)
                        sucesso(resultado: true, mensagem: response.result.value)
                    }
                case .Failure(let encodingError):
                    self.escondeProcessando(view)
                    debugPrint(encodingError)
                    sucesso(resultado: false, mensagem: nil/*encodingError*/)
                }
            }
        )
    }

    func buscarOrcamentoPorId(_ view: UIView, parametros: [String:AnyObject]?, sucesso: @escaping (_ objeto:OrcamentoConsultaSaida?, _ falha:Bool) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "buscarOrcamentoPorId" , parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(resposta)
            })
            .responseObject { (resposta: Response<OrcamentoConsultaSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: OrcamentoConsultaSaida? = resposta.result.value
                
                sucesso(objeto: saida, falha: (saida?.resultado!.erro)!)
        }
    }
    
    func pagamento(_ view: UIView, tipo: String,  parametros: [String:AnyObject], sucesso: @escaping (_ objeto:Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "pagamento/" + tipo , parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(resposta)
            })
            .responseObject { (resposta: Response<BaseSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: BaseSaida? = resposta.result.value
                
                sucesso(objeto: saida?.resultado)
        }
    }
    
    func email(_ view: UIView, tipo: String,  parametros: [String:AnyObject], sucesso: @escaping (_ objeto:Cliente?, _ resultado:Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "email/" + tipo , parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(resposta)
            })
            .responseObject { (resposta: Response<EmailOrcamentoSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: EmailOrcamentoSaida? = resposta.result.value
                
                sucesso(objeto: saida?.cliente, resultado:  saida?.resultado)
        }
    }
    
    func editarOrcamentoApp(_ view: UIView, parametros: [String: AnyObject], sucesso: @escaping (_ objeto: OrcamentoGerado?, _ resultado: Bool) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "editarOrcamentoApp", parameters: parametros, encoding: .JSON)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(resposta)
            })
            .responseObject { (resposta: Response<OrcamentoConsultaSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: OrcamentoConsultaSaida? = resposta.result.value
                
                sucesso(objeto:saida?.orcamento, resultado: (saida?.resultado!.erro)!)
        }
    }

    
    func incluirOrcamento(_ view: UIView, parametros: [String: AnyObject], sucesso: @escaping (_ objeto: OrcamentoGerado?, _ resultado: Bool) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "incluirOrcamento", parameters: parametros, encoding: .JSON)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(NSString.init(data:resposta.request!.HTTPBody!, encoding:NSUTF8StringEncoding))
                print(resposta)
            })
            .responseObject { (resposta: Response<OrcamentoConsultaSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: OrcamentoConsultaSaida? = resposta.result.value
                
                sucesso(objeto:saida?.orcamento, resultado: (saida?.resultado!.erro)!)
        }
    }

    func orcamentoCalculoApp(_ view: UIView, parametros: [String:AnyObject], sucesso: @escaping (_ objeto:OrcamentoGerado?, _ resultado: Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "orcamento/calculoApp", parameters: parametros, encoding: .JSON)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(NSString.init(data:resposta.request!.HTTPBody!, encoding:NSUTF8StringEncoding))                
                print(resposta)
            })
            .responseObject { (resposta: Response<OrcamentoConsultaSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: OrcamentoConsultaSaida? = resposta.result.value
                
                sucesso(objeto:saida?.orcamento, resultado: saida?.resultado)
        }
    }
    
    func orcamento(_ view: UIView, tipo: String,  parametros: [String:AnyObject], sucesso: @escaping (_ objeto:Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "orcamento/" + tipo , parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(resposta)
            })
            .responseObject { (resposta: Response<BaseSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: BaseSaida? = resposta.result.value
                
                sucesso(objeto: saida?.resultado)
        }
    }
    
    func buscarClienteCadastroCompletoPorId(_ view: UIView, parametros: [String:AnyObject], sucesso: @escaping (_ objeto: Cliente?, _ resultado: Bool) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "buscarClienteCadastroCompletoPorId", parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(NSString.init(data:resposta.request!.HTTPBody!, encoding:NSUTF8StringEncoding))
                print(resposta)
            })
            .responseObject { (resposta: Response<ClienteCadastroCompletoSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: ClienteCadastroCompletoSaida? = resposta.result.value
                
                sucesso(objeto:saida?.cliente, resultado: (saida?.resultado!.erro)!)
        }
    }

    func editarClienteCadastroCompletoPorId(_ view: UIView, parametros: [String:AnyObject], sucesso: @escaping (_ objeto:Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "editarClienteCadastroCompletoPorId" , parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(resposta)
            })
            .responseObject { (resposta: Response<BaseSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: BaseSaida? = resposta.result.value
                
                sucesso(objeto: saida?.resultado)
        }
    }

    func buscarPedido(_ view: UIView, parametros: [String:AnyObject], sucesso: @escaping (_ objeto:PedidoConsultaSaida?, _ resultado: Bool) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "buscarPedido" , parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(resposta)
            })
            .responseObject { (resposta: Response<PedidoConsultaSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: PedidoConsultaSaida? = resposta.result.value
                
                sucesso(objeto:saida, resultado: (saida?.resultado!.erro)!)
        }
    }
    
    func buscarPedidoPorId(_ view: UIView, parametros: [String:AnyObject], sucesso: @escaping (_ objeto:CartaoPagamentoSaida?, _ resultado: Bool) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "buscarPedidoPorId" , parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(resposta)
            })
            .responseObject { (resposta: Response<CartaoPagamentoSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: CartaoPagamentoSaida? = resposta.result.value
                
                sucesso(objeto:saida, resultado: (saida?.resultado!.erro)!)
        }
    }
    
    func incluirAgendaOrcamento(_ view: UIView, parametros: [String:AnyObject], sucesso: @escaping (_ objeto:Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "incluirAgendaOrcamento" , parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(resposta)
            })
            .responseObject { (resposta: Response<BaseSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: BaseSaida? = resposta.result.value
                
                sucesso(objeto: saida?.resultado)
        }
    }
    
    func getNet(_ view: UIView, tipo: String,  parametros: [String:AnyObject], sucesso: @escaping (_ objeto: PedidoGetNet?, _ resultado:Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "getNet/" + tipo , parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(NSString.init(data:resposta.request!.HTTPBody!, encoding:NSUTF8StringEncoding))
                print(resposta)
            })
            .responseObject { (resposta: Response<GetNetPagamentoSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: GetNetPagamentoSaida? = resposta.result.value
                
                sucesso(objeto: saida?.pedido, resultado: saida?.resultado)
        }
    }
    
    func incluirCheckList(_ view: UIView, parametros: [String: AnyObject], sucesso: @escaping (_ resultado: Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "incluirCheckList", parameters: parametros, encoding: .JSON)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(NSString.init(data:resposta.request!.HTTPBody!, encoding:NSUTF8StringEncoding))
                print(resposta)
            })
            .responseObject { (resposta: Response<BaseSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: BaseSaida? = resposta.result.value
                
                sucesso(resultado:saida?.resultado)
        }
    }

    func incluirCliente(_ view: UIView, parametros: [String:AnyObject], sucesso: @escaping (_ objeto:Cliente?, _ resultado: Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "incluirCliente" , parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(resposta)
            })
            .responseObject { (resposta: Response<ClienteIncluirSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: ClienteIncluirSaida? = resposta.result.value
                
                sucesso(objeto:saida?.cliente, resultado: (saida?.resultado)!)
        }
    }

    func buscarClientePor(_ view: UIView, tipo: String,  parametros: [String:AnyObject], sucesso: @escaping (_ objeto:Cliente?, _ resultado:Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "buscarClientePor" + tipo , parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(resposta)
            })
            .responseObject { (resposta: Response<ClienteBuscarSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: ClienteBuscarSaida? = resposta.result.value
                
                sucesso(objeto: saida?.cliente, resultado:  saida?.resultado)
        }
    }
    
    func consultarDatasDisponiveis(_ view: UIView,  parametros: [String:AnyObject], sucesso: @escaping (_ objeto:[String]?, _ resultado:Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "consultarDatasDisponiveis" , parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(resposta)
            })
            .responseObject { (resposta: Response<DatasDisponiveisSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: DatasDisponiveisSaida? = resposta.result.value
                
                sucesso(objeto: saida?.datas, resultado:  saida?.resultado)
        }
    }
    
    func ponto(_ view: UIView, tipo: String,  parametros: [String:AnyObject], sucesso: @escaping (_ resultado:Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "ponto/" + tipo , parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(resposta)
            })
            .responseObject { (resposta: Response<BaseSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: BaseSaida? = resposta.result.value
                
                sucesso(resultado:  saida?.resultado)
        }
    }
    
    func buscarClientesPorFranquia(_ view: UIView, parametros: [String:AnyObject], sucesso: @escaping (_ objeto:ClientesBuscarSaida?, _ resultado: Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "buscarClientesPorFranquia" , parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(NSString.init(data:resposta.request!.HTTPBody!, encoding:NSUTF8StringEncoding))
                print(resposta)
            })
            .responseObject { (resposta: Response<ClientesBuscarSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: ClientesBuscarSaida? = resposta.result.value
                
                sucesso(objeto: saida, resultado:  saida?.resultado)
        }
    }

    func excluirCartao(_ view: UIView, parametros: [String:AnyObject], sucesso: @escaping (_ resultado:Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "excluirCartao" , parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(resposta)
            })
            .responseObject { (resposta: Response<BaseSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: BaseSaida? = resposta.result.value
                
                sucesso(resultado:  saida?.resultado)
        }
    }
    
    func loja(_ view: UIView, tipo: String, parametros: [String: AnyObject], sucesso: @escaping (_ objeto: CalculoPedido?, _ resultado: Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "loja/" + tipo, parameters: parametros, encoding: .JSON)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(resposta)
            })
            .responseObject { (resposta: Response<LojaCalculoPedidoSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: LojaCalculoPedidoSaida? = resposta.result.value
                
                sucesso(objeto:saida?.calculo, resultado: saida?.resultado)
        }
    }

    func lojaBuscarPorFranquia(_ view: UIView, parametros: [String: AnyObject], sucesso: @escaping (_ objeto: [PedidoLoja]?, _ resultado: Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "loja/buscarPorFranquia" , parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(NSString.init(data:resposta.request!.HTTPBody!, encoding:NSUTF8StringEncoding))
                print(resposta)
            })
            .responseObject { (resposta: Response<LojaListaPedidosSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: LojaListaPedidosSaida? = resposta.result.value
                
                sucesso(objeto:saida?.pedidos, resultado: saida?.resultado)
        }
    }
    
    func lojaEfetivar(_ view: UIView, parametros: [String:AnyObject], sucesso: @escaping (_ objeto:PedidoLoja?, _ resultado: Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "loja/efetivar", parameters: parametros, encoding: .JSON)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(NSString.init(data:resposta.request!.HTTPBody!, encoding:NSUTF8StringEncoding))
                print(resposta)
            })
            .responseObject { (resposta: Response<LojaEfetivaPedidoSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: LojaEfetivaPedidoSaida? = resposta.result.value
                
                sucesso(objeto:saida?.pedido, resultado: saida?.resultado)
        }
    }
    
    func lojaBuscarDetalhe(_ view: UIView, parametros: [String: AnyObject], sucesso: @escaping (_ objeto: LojaDetalhePedidoSaida?, _ resultado: Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(.POST, urlBase + "loja/buscarDetalhe" , parameters: parametros)
            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
                print(resposta.request?.URLString)
                print(NSString.init(data:resposta.request!.HTTPBody!, encoding:NSUTF8StringEncoding))
                print(resposta)
            })
            .responseObject { (resposta: Response<LojaDetalhePedidoSaida, NSError>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error)
                    
                    return
                }
                
                let saida: LojaDetalhePedidoSaida? = resposta.result.value
                
                sucesso(objeto:saida, resultado: saida?.resultado)
        }
    }
    
    func trataErroGenerico(_ erro: NSError?) {
        
        AvisoProcessamento.mensagemErroGenerico(erro.debugDescription)
    }

    
    func obtemUrlManual(_ arquivo: String?) -> String? {
        
        return urlBaseManuais + arquivo!
    }
    
    func obtemUrlFotoUsuario(_ arquivo: String) -> String {
        return urlBaseFotosUsuarios + arquivo
    }
    
    func obtemUrlFotoPedido(_ arquivo: String) -> String {
        return urlBaseFotosPedidos + arquivo
    }

    func obtemUrlFotoProduto(_ arquivo: String) -> String {
        return urlBaseFotosProdutos + arquivo
    }
    
}
