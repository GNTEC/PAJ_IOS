//
//  ManuaisListaViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 07/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation
import MessageUI
import CoreTelephony

class ManuaisListaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var tableview: UITableView!
    var listaManuais: [Manual]?
    var selecionado: Manual?

    static let  TAG_SELECAO_TABELA  = 100
    static let  TAG_SELECAO_CENTRAL = 101
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = button
        
        let api  = PinturaAJatoApi()
        
        let parametros : [String:AnyObject] = [
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
            ]

        api.buscarManuaisETreinamentos(self.navigationController!.view, parametros:parametros, sucesso: { (objeto:[Manual]?, falha:Bool) -> Bool in
            
            if !falha {
                self.listaManuais = objeto
                self.tableview.reloadData()
            }
            
            return true
        })
    }
    
    @IBAction func onCentralAtendimento(_ sender: AnyObject) {
        
        let alertView = UIAlertView(title: "O que deseja fazer?", message: nil, delegate: self, cancelButtonTitle: "Cancelar")
        
        alertView.tag = ManuaisListaViewController.TAG_SELECAO_CENTRAL
        alertView.addButton(withTitle: "Enviar email")
        alertView.addButton(withTitle: "Ligar para a Central")
        
        alertView.show()
    }
    
    @IBAction func onPerguntasRespostas(_ sender: AnyObject) {
    }
    
    func prossegueEnviarEmailCentral() {
        
        if !MFMailComposeViewController.canSendMail() {
            AvisoProcessamento.mensagemErroGenerico("Não é possível enviar emails deste dipositivo. Verifique se existe uma conta configurada.")
            return
        }
        
        let emailTitle = "SUPORTE APLICATIVO"
        let messageBody = "Minha dúvida:"
        let toRecipents = ["suporte.app@pinturaajato.com"]
        let mc = MFMailComposeViewController()

        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        self.present(mc, animated: true, completion: { _ in })

    }
    
    func efetuaLigacao() {
        
        let telefone = "tel://+551126799697"
        let url = URL.init(string: telefone)
        
        if UIApplication.shared.canOpenURL(url!) {
            
            let mobileNetworkCode = CTTelephonyNetworkInfo().subscriberCellularProvider?.mobileNetworkCode
            
            let isInvalidNetworkCode = mobileNetworkCode == nil
                || mobileNetworkCode?.characters.count == 0
                || mobileNetworkCode == "65535"
            
            let resultado = isInvalidNetworkCode || UIApplication.shared.openURL(url!)
            
            if resultado == false {
                AvisoProcessamento.mensagemErroGenerico("Não foi possível efetuar a ligação. Ligue para nossa central de atendimento no número: (11) 2679-9697")
            }
        }
        else {
            AvisoProcessamento.mensagemErroGenerico("Ligue para nossa central de atendimento no número: (11) 2679-9697")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
    }
    // MARK: - UITableView Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if listaManuais == nil {
            return 0
        }
        
        return listaManuais!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier: String
        var cell: CelulaManualListaTableViewCell?
        
        cellIdentifier = "SimpleTableCell"
        
        cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CelulaManualListaTableViewCell)
        
        let dados:Manual = listaManuais![indexPath.item]
        cell!.descricao.text = dados.descricao
        
        var cor: UIColor?//, corFundo: UIColor?
        var nome_icone:String?
        
        if (dados.id_tipo_manual == 1) {
            cor = self.corAzulClaro()
            nome_icone = "book"
        }
        else if (dados.id_tipo_manual == 2) {
            cor = self.corLaranja()
            nome_icone = "briefcase"
        }
        else if (dados.id_tipo_manual == 3) {
            cor = self.corCinzaBullet()
            nome_icone = "facetime-video"
        }
        
        if indexPath.item % 2 == 0 {
            //corFundo = self.corZebradoPar()
            cell!.backgroundColor = self.corZebradoPar()
        }
        else {
            //corFundo = self.corZebradoImpar()
            cell!.backgroundColor = self.corZebradoImpar()
        }
        cell!.imageView!.image = self.iconeLista(nome_icone, cor: cor, corFundo: UIColor.clear)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selecionado = listaManuais![indexPath.row]
        
        let alertView = UIAlertView(title: "O que deseja fazer?", message: nil, delegate: self, cancelButtonTitle: "Cancelar")
        
        alertView.tag = ManuaisListaViewController.TAG_SELECAO_TABELA
        alertView.addButton(withTitle: "Assistir/Ler")
        
        if selecionado?.id_tipo_manual != 3 {
            alertView.addButton(withTitle: "Enviar para o email de cadastro")
        }
        
        alertView.show()
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if alertView.tag ==  ManuaisListaViewController.TAG_SELECAO_TABELA {
            if buttonIndex == 1 {
                //Code for download button
                self.performSegue(withIdentifier: "ListaManuaisParaVideo", sender: self)
            }
            if buttonIndex == 2 {
                //Code for download button
                self.performSegue(withIdentifier: "ListaManuaisParaEnvioEmail", sender: self)
            }
        }
        else if alertView.tag == ManuaisListaViewController.TAG_SELECAO_CENTRAL {
            
            if buttonIndex == 1 {
                prossegueEnviarEmailCentral()
            }
            else if buttonIndex == 2 {
                efetuaLigacao()
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ListaManuaisParaVideo" {
            
            let contexto = ContextoManuaisExibir()
            
            let api = PinturaAJatoApi()
            
            contexto.url = api.obtemUrlManual(selecionado?.url)
            
            let viewController = segue.destination as! ManualExibirConteudoViewController
            
            viewController.defineContexto(contexto)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case MFMailComposeResult.cancelled:
            break
        case MFMailComposeResult.saved:
            break
        case MFMailComposeResult.sent:
            break
        case MFMailComposeResult.failed:
            break
        default:
            break
        }
        
        // Close the Mail Interface
        self.dismiss(animated: true, completion: { _ in })
    }
}
