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
    
//    let urlBase = "https://www.pinturaajato.com/api/"
//    let urlBaseManuais = "https://www.pinturaajato.com/uploads/manual/"
//    let urlBaseFotosUsuarios = "https://www.pinturaajato.com/uploads/usuario/"
//    let urlBaseFotosPedidos =  "https://www.pinturaajato.com/uploads/foto/"
//    let urlBaseFotosProdutos = "https://www.pinturaajato.com/uploads/produto/"
    
    //paj.azurewebsites.net
    //paj.azurewebsites.net/api
    
    let urlBase = "https://paj.azurewebsites.net/api/"
    let urlBaseManuais = "https://paj.azurewebsites.net/uploads/manual/"
    let urlBaseFotosUsuarios = "https://paj.azurewebsites.net/uploads/usuario/"
    let urlBaseFotosPedidos =  "https://paj.azurewebsites.net/uploads/foto/"
    let urlBaseFotosProdutos = "https://paj.azurewebsites.net/uploads/produto/"
    
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
        
    
        Alamofire.request(URL(string: urlBase + "lembrarSenha")!, method: .post, parameters: parametros, encoding: JSONEncoding.default, headers: nil).responseObject { (resposta: DataResponse<BaseSaida>) in
            
            self.escondeProcessando(view)
            
            switch(resposta.result) {
            case .success(_):
                if let saida = resposta.result.value {
                    if saida.resultado?.erro == false {
                        sucesso(saida.resultado)
                    } else {
                        AvisoProcessamento.mensagemErroGenerico(saida.resultado?.mensagem)
                    }
                }
                return
                
            case .failure(_):
                print(resposta.result.error as? NSError)
                
                self.trataErroGenerico(resposta.result.error as NSError?)
                return

            }
        }
    }
    
//        Alamofire.request(.POST, URL(string: urlBase + "lembrarSenha", parameters: parametros)
//            .responseString(completionHandler: { (resposta:Response<String, NSError>) in
//                print(resposta.request?.url?.absoluteString)
//                print(resposta)
//            })
//            .responseObject { (resposta: Response<BaseSaida, NSError>)  in
//                
//                self.escondeProcessando(view)
//                
//                if resposta.result.error != nil {
//                    
//                    self.trataErroGenerico(resposta.result.error as? NSError)
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
        Alamofire.request(URL(string: urlBase + "validarUsuario")!, method: .post, parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<LoginSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }

                let login: LoginSaida? = resposta.result.value
     
                if login?.resultado?.erro == false {
                    
                    sucesso(login?.franqueado, login?.sessao, (login?.resultado?.erro)!)
                }
                else {
                    AvisoProcessamento.mensagemErroGenerico(login?.resultado?.mensagem)
                }
                
        }
    }
    
    func buscarOrcamentosCompletosPorFranquia(_ view: UIView, parametros: [String : AnyObject], sucesso: @escaping (_ objeto:[OrcamentoDetalhe]?, _ resultado:Bool) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "buscarOrcamentosCompletosPorFranquia")!, method: .post, parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<HistoricoSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let login: HistoricoSaida? = resposta.result.value
                
                if login?.resultado?.erro == false {
                    
                    sucesso(login?.orcamento, (login?.resultado?.erro)!)
                }
                
                
        }
    }
    
    func buscarAgendaPorFranquia(_ view:UIView, parametros: [String: AnyObject], sucesso: @escaping (_ objeto:[ItemHistoricoCalendario]?, _ resultado:Bool) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "buscarAgendaPorFranquia")!, method: .post, parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<BuscaAgendaOrcamentoSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let saida: BuscaAgendaOrcamentoSaida? = resposta.result.value
                
                if saida?.resultado?.erro == false {
                    
                    sucesso(saida?.agenda, (saida?.resultado?.erro)!)
                }
                
                
        }
    }
    
    func avaliacao(_ view:UIView, tipo: String, parametros: [String:AnyObject], sucesso: @escaping (_ objeto:Avaliacao?, _ tipo: String, _ resultado:Bool) -> Bool ) {
        
        exibeProcessando(view)
        Alamofire.request(URL(string: urlBase + "avaliacao/" + tipo)!, method: .post, parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<ConsultaAvaliacaoSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }

                let saida: ConsultaAvaliacaoSaida? = resposta.result.value
                
                if saida?.resultado?.erro == false {
                    
                    sucesso(saida?.avaliacao, tipo, (saida?.resultado?.erro)!)
                }
                
                
        }
    }
    
    func incluirAgendaBloqueio(_ view: UIView, parametros: [String:AnyObject], sucesso: @escaping (_ objeto:Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "incluirAgendaBloqueio")!, method: .post, parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<BaseSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let saida: BaseSaida? = resposta.result.value
                
                sucesso(saida?.resultado)
        }
    }
    
    func financeiro(_ view:UIView, tipo: String, parametros: [String:AnyObject], sucesso: @escaping (_ objeto:[Recebimento]?, _ tipo: String, _ resultado:Bool) -> Bool ) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "financeiro/" + tipo)!, method: .post, parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<ConsultaRecebimentosSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
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
                    
                    sucesso(itens, tipo, (saida?.resultado?.erro)!)
                }
                
                
        }
    }
    
    func financeiroDetalhe(_ view:UIView, tipo: String, parametros: [String:AnyObject], sucesso: @escaping (_ objeto:[RecebimentoDetalhe]?, _ tipo: String, _ resultado:Bool) -> Bool ) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "financeiro/" + tipo + "/detalhe")!, method: .post, parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<ConsultaRecebimentoDetalheSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
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
                    
                    sucesso(itens, tipo, (saida?.resultado?.erro)!)
                }
                
                
        }
    }
    
    func trocarSenhaApp(_ view: UIView, parametros: [String:AnyObject], sucesso: @escaping (_ objeto:Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "trocarSenhaApp")!, method: .post, parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<BaseSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let saida: BaseSaida? = resposta.result.value
                
                sucesso(saida?.resultado)
        }
    }
    
    func buscarManuaisETreinamentos(_ view: UIView, parametros: [String:AnyObject]?, sucesso: @escaping (_ objeto:[Manual]?, _ falha:Bool) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "buscarManuaisETreinamentos")!, method: .post,  parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<ConsultaManuaisTreinamentosSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let saida: ConsultaManuaisTreinamentosSaida? = resposta.result.value
                
                sucesso(saida?.manual, (saida?.resultado!.erro)!)
        }
    }
    
    func buscarCartoesPorFranquia(_ view: UIView, parametros: [String:AnyObject]?, sucesso: @escaping (_ objeto:[Cartao]?, _ falha:Bool) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "buscarCartoesPorFranquia")!, method: .post,  parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<ConsultaCartoesSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let saida: ConsultaCartoesSaida? = resposta.result.value
                
                sucesso(saida?.cartoes, (saida?.resultado!.erro)!)
        }
    }
    
    func incluirCartao(_ view: UIView, parametros: [String:AnyObject], sucesso: @escaping (_ objeto:Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "incluirCartao")!, method: .post, parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<BaseSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let saida: BaseSaida? = resposta.result.value
                
                sucesso(saida?.resultado)
        }
    }
    
    func buscarProdutos(_ view: UIView, parametros: [String:AnyObject]?, sucesso: @escaping (_ objeto:[Produto]?, _ falha:Bool) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "buscarProdutos")!, method: .post, parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<ConsultaProdutosSaida>)  in
                
                self.escondeProcessando(view)

                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }

                
                let saida: ConsultaProdutosSaida? = resposta.result.value
                
                sucesso(saida?.produtos, (saida?.resultado!.erro)!)
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
        
        
        do {
            let url = try URLRequest(url: "\(urlBase)inserirFoto", method: .post)
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(id_franquia.data(using: String.Encoding.utf8)!, withName: "id_franquia")
                multipartFormData.append(id_sessao.data(using: String.Encoding.utf8)!, withName: "id_sessao")
                multipartFormData.append(id_sequencia.data(using: String.Encoding.utf8)!, withName: "id_sequencia")
                multipartFormData.append(formato.data(using: String.Encoding.utf8)!, withName: "formato")
                multipartFormData.append(id_orcamento.data(using: String.Encoding.utf8)!, withName: "id_orcamento")
                multipartFormData.append(antes_depois.data(using: String.Encoding.utf8)!, withName: "antes_depois")
                multipartFormData.append(UIImageJPEGRepresentation(foto_pequena!, 1.0)!, withName: "fotop", fileName: "fotop.jpg", mimeType: "image/jpeg")
                multipartFormData.append(UIImageJPEGRepresentation(foto_grande!, 1.0)!, withName: "fotog", fileName: "fotog.jpg", mimeType: "image/jpeg")
            }, with: url) { (encodingResult) in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseString { response in
                        self.escondeProcessando(view)
                        debugPrint(response)
                        sucesso(true, response.result.value)
                    }
                case .failure(let encodingError):
                    self.escondeProcessando(view)
                    debugPrint(encodingError)
                    sucesso(false, nil/*encodingError*/)
                }
            }
        } catch {
            
        }
    }
    
    func inserirFotoUsuario(_ view:UIView, parametros: [String:AnyObject]?, foto:UIImage?, sucesso: @escaping (_ resultado:Bool, _ mensagem: String?) -> Bool) {
        
        exibeProcessando(view)
        
        let id_franquia = parametros?["id_franquia"] as! String,
            id_sessao = parametros?["id_sessao"] as! String,
            id_usuario = parametros?["id_usuario"] as! String,
            formato = parametros?["formato"] as! String
        
        do {
            let url = try URLRequest(url: URL(string: urlBase + "inserirFotoUsuario")!, method: .post)
            Alamofire.upload(multipartFormData: { multipartFormData in
                    multipartFormData.append(id_franquia.data(using: String.Encoding.utf8)!, withName: "id_franquia")
                    multipartFormData.append(id_sessao.data(using: String.Encoding.utf8)!, withName: "id_sessao")
                    multipartFormData.append(id_usuario.data(using: String.Encoding.utf8)!, withName: "id_usuario")
                    multipartFormData.append(formato.data(using: String.Encoding.utf8)!, withName: "formato")
                    multipartFormData.append(UIImageJPEGRepresentation(foto!, 1.0)!, withName: "foto", fileName: "foto.jpg", mimeType: "image/jpeg")
            }, with: url) { encodingResult in

                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseString { response in
                            self.escondeProcessando(view)
                            debugPrint(response)
                            sucesso(true, response.result.value)
                        }
                    case .failure(let encodingError):
                        self.escondeProcessando(view)
                        debugPrint(encodingError)
                        sucesso(false, nil/*encodingError*/)
                    }
                }
        } catch {
            
        }
    }

    func buscarOrcamentoPorId(_ view: UIView, parametros: [String:AnyObject]?, sucesso: @escaping (_ objeto:OrcamentoConsultaSaida?, _ falha:Bool) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "buscarOrcamentoPorId")!, method: .post, parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<OrcamentoConsultaSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let saida: OrcamentoConsultaSaida? = resposta.result.value
                
                sucesso(saida, (saida?.resultado!.erro)!)
        }
    }
    
    func pagamento(_ view: UIView, tipo: String,  parametros: [String:AnyObject], sucesso: @escaping (_ objeto:Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "pagamento/" + tipo)!, method: .post, parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<BaseSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let saida: BaseSaida? = resposta.result.value
                
                sucesso(saida?.resultado)
        }
    }
    
    func email(_ view: UIView, tipo: String,  parametros: [String:AnyObject], sucesso: @escaping (_ objeto:Cliente?, _ resultado:Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "email/" + tipo)!, method: .post, parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<EmailOrcamentoSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let saida: EmailOrcamentoSaida? = resposta.result.value
                
                sucesso(saida?.cliente, saida?.resultado)
        }
    }
    
    func editarOrcamentoApp(_ view: UIView, parametros: [String: AnyObject], sucesso: @escaping (_ objeto: OrcamentoGerado?, _ resultado: Bool) -> Bool) {
        
        exibeProcessando(view)
        Alamofire.request(URL(string: urlBase + "editarOrcamentoApp")!, method: .post, parameters: parametros, encoding: JSONEncoding.default, headers: nil)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<OrcamentoConsultaSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as NSError?)
                    
                    return
                }
                
                let saida: OrcamentoConsultaSaida? = resposta.result.value
                
                sucesso(saida?.orcamento, (saida?.resultado!.erro)!)
        }
    }
    
    func incluirOrcamento(_ view: UIView, parametros: [String: AnyObject], sucesso: @escaping (_ objeto: OrcamentoGerado?, _ resultado: Bool) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "incluirOrcamento")!, method: .post, parameters: parametros, encoding: JSONEncoding.default)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString as Any)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<OrcamentoConsultaSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let saida: OrcamentoConsultaSaida? = resposta.result.value
                
                sucesso(saida?.orcamento, (saida?.resultado!.erro)!)
        }
    }

    func orcamentoCalculoApp(_ view: UIView, parametros: [String:AnyObject], sucesso: @escaping (_ objeto:OrcamentoGerado?, _ resultado: Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "orcamento/calculoApp")!, method: .post, parameters: parametros, encoding: JSONEncoding.default)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<OrcamentoConsultaSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let saida: OrcamentoConsultaSaida? = resposta.result.value
                
                sucesso(saida?.orcamento, saida?.resultado)
        }
    }
    
    func orcamento(_ view: UIView, tipo: String,  parametros: [String:AnyObject], sucesso: @escaping (_ objeto:Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "orcamento/" + tipo)!, method: .post, parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<BaseSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let saida: BaseSaida? = resposta.result.value
                
                sucesso(saida?.resultado)
        }
    }
    
    func buscarClienteCadastroCompletoPorId(_ view: UIView, parametros: [String:AnyObject], sucesso: @escaping (_ objeto: Cliente?, _ resultado: Bool) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "buscarClienteCadastroCompletoPorId")!, method: .post, parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<ClienteCadastroCompletoSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let saida: ClienteCadastroCompletoSaida? = resposta.result.value
                
                sucesso(saida?.cliente, (saida?.resultado!.erro)!)
        }
    }

    func editarClienteCadastroCompletoPorId(_ view: UIView, parametros: [String:AnyObject], sucesso: @escaping (_ objeto:Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "editarClienteCadastroCompletoPorId")!, method: .post, parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<BaseSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let saida: BaseSaida? = resposta.result.value
                
                sucesso(saida?.resultado)
        }
    }

    func buscarPedido(_ view: UIView, parametros: [String:AnyObject], sucesso: @escaping (_ objeto:PedidoConsultaSaida?, _ resultado: Bool) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "buscarPedido")!, method: .post, parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<PedidoConsultaSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let saida: PedidoConsultaSaida? = resposta.result.value
                
                sucesso(saida, (saida?.resultado!.erro)!)
        }
    }
    
    func buscarPedidoPorId(_ view: UIView, parametros: [String:AnyObject], sucesso: @escaping (_ objeto:CartaoPagamentoSaida?, _ resultado: Bool) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "buscarPedidoPorId")!, method: .post, parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<CartaoPagamentoSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let saida: CartaoPagamentoSaida? = resposta.result.value
                
                sucesso(saida, (saida?.resultado!.erro)!)
        }
    }
    
    func incluirAgendaOrcamento(_ view: UIView, parametros: [String:AnyObject], sucesso: @escaping (_ objeto:Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "incluirAgendaOrcamento")!, method: .post, parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<BaseSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let saida: BaseSaida? = resposta.result.value
                
                sucesso(saida?.resultado)
        }
    }
    
    func getNet(_ view: UIView, tipo: String,  parametros: [String:AnyObject], sucesso: @escaping (_ objeto: PedidoGetNet?, _ resultado:Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "getNet/" + tipo)!, method: .post, parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<GetNetPagamentoSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let saida: GetNetPagamentoSaida? = resposta.result.value
                
                sucesso(saida?.pedido, saida?.resultado)
        }
    }
    
    func incluirCheckList(_ view: UIView, parametros: [String: AnyObject], sucesso: @escaping (_ resultado: Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "incluirCheckList")!, method: .post, parameters: parametros, encoding: JSONEncoding.default)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<BaseSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let saida: BaseSaida? = resposta.result.value
                
                sucesso(saida?.resultado)
        }
    }

    func incluirCliente(_ view: UIView, parametros: [String:AnyObject], sucesso: @escaping (_ objeto:Cliente?, _ resultado: Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "incluirCliente")!, method: .post, parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<ClienteIncluirSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let saida: ClienteIncluirSaida? = resposta.result.value
                
                sucesso(saida?.cliente, (saida?.resultado)!)
        }
    }

    func buscarClientePor(_ view: UIView, tipo: String,  parametros: [String:AnyObject], sucesso: @escaping (_ objeto:Cliente?, _ resultado:Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "buscarClientePor" + tipo)!, method: .post, parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<ClienteBuscarSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let saida: ClienteBuscarSaida? = resposta.result.value
                
                sucesso(saida?.cliente, saida?.resultado)
        }
    }
    
    func consultarDatasDisponiveis(_ view: UIView,  parametros: [String:AnyObject], sucesso: @escaping (_ objeto:[String]?, _ resultado:Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "consultarDatasDisponiveis")!, method: .post, parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<DatasDisponiveisSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let saida: DatasDisponiveisSaida? = resposta.result.value
                
                sucesso(saida?.datas, saida?.resultado)
        }
    }
    
    func ponto(_ view: UIView, tipo: String,  parametros: [String:AnyObject], sucesso: @escaping (_ resultado:Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "ponto/" + tipo)!, method: .post, parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<BaseSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let saida: BaseSaida? = resposta.result.value
                
                sucesso(saida?.resultado)
        }
    }
    
    func buscarClientesPorFranquia(_ view: UIView, parametros: [String:AnyObject], sucesso: @escaping (_ objeto:ClientesBuscarSaida?, _ resultado: Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "buscarClientesPorFranquia")!, method: .post, parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<ClientesBuscarSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let saida: ClientesBuscarSaida? = resposta.result.value
                
                sucesso(saida, saida?.resultado)
        }
    }

    func excluirCartao(_ view: UIView, parametros: [String:AnyObject], sucesso: @escaping (_ resultado:Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "excluirCartao")!, method: .post, parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<BaseSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let saida: BaseSaida? = resposta.result.value
                
                sucesso(saida?.resultado)
        }
    }
    
    func loja(_ view: UIView, tipo: String, parametros: [String: AnyObject], sucesso: @escaping (_ objeto: CalculoPedido?, _ resultado: Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "loja/" + tipo)!, method: .post, parameters: parametros, encoding: JSONEncoding.default)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<LojaCalculoPedidoSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let saida: LojaCalculoPedidoSaida? = resposta.result.value
                
                sucesso(saida?.calculo, saida?.resultado)
        }
    }

    func lojaBuscarPorFranquia(_ view: UIView, parametros: [String: AnyObject], sucesso: @escaping (_ objeto: [PedidoLoja]?, _ resultado: Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "loja/buscarPorFranquia")!, method: .post, parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<LojaListaPedidosSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let saida: LojaListaPedidosSaida? = resposta.result.value
                
                sucesso(saida?.pedidos, saida?.resultado)
        }
    }
    
    func lojaEfetivar(_ view: UIView, parametros: [String:AnyObject], sucesso: @escaping (_ objeto:PedidoLoja?, _ resultado: Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "loja/efetivar")!, method: .post, parameters: parametros, encoding: JSONEncoding.default)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                print(resposta)
            })
            .responseObject { (resposta: DataResponse<LojaEfetivaPedidoSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let saida: LojaEfetivaPedidoSaida? = resposta.result.value
                
                sucesso(saida?.pedido, saida?.resultado)
        }
    }
    
    func lojaBuscarDetalhe(_ view: UIView, parametros: [String: AnyObject], sucesso: @escaping (_ objeto: LojaDetalhePedidoSaida?, _ resultado: Resultado?) -> Bool) {
        
        exibeProcessando(view)
        
        Alamofire.request(URL(string: urlBase + "loja/buscarDetalhe")!, method: .post, parameters: parametros)
            .responseString(completionHandler: { (resposta:DataResponse<String>) in
                print(resposta.request?.url?.absoluteString)
                })
            .responseObject { (resposta: DataResponse<LojaDetalhePedidoSaida>)  in
                
                self.escondeProcessando(view)
                
                if resposta.result.error != nil {
                    
                    self.trataErroGenerico(resposta.result.error as? NSError)
                    
                    return
                }
                
                let saida: LojaDetalhePedidoSaida? = resposta.result.value
                
                sucesso(saida, saida?.resultado)
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
