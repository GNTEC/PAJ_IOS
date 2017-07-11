//
//  OrcamentoEscolhaViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 10/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class OrcamentoEscolhaViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var botao_novo_cliente: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var listaOrcamentos: [OrcamentoDetalhe]?
    
    override func viewWillAppear(_ animated: Bool) {
        
        let api = PinturaAJatoApi()
        
        let parametros: [String:AnyObject] = [
            "id_franquia" : String(format: "%d", PinturaAJatoApi.obtemFranqueado()!.id_franquia) as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject,
            "tipo_solicitacao" : "0" as AnyObject
        ]
        
        api.buscarOrcamentosCompletosPorFranquia(self.navigationController!.view, parametros:parametros, sucesso: { (objeto:[OrcamentoDetalhe]?, resultado:Bool) -> Bool in
           
                self.listaOrcamentos = objeto
                self.tableView.reloadData()
                return true
            })
    }
    
    override func viewDidLoad() {
        
        let texto_icone = String.fontAwesomeIconString(forEnum: FAIcon.FAIconUserPlus)
        
        let atributo_awesome : [String:AnyObject] = [NSFontAttributeName: UIFont(awesomeFontOfSize:24.0)!, NSForegroundColorAttributeName: UIColor.white]
        
        let atributo_texto : [String:AnyObject] = [NSForegroundColorAttributeName: UIColor.white, NSBaselineOffsetAttributeName: NSNumber(value: 3.5 as Double)]
        
        let textoIcone = NSMutableAttributedString(string: texto_icone!, attributes: atributo_awesome)
        let textoNovoCliente = NSAttributedString(string: "   Novo cliente", attributes: atributo_texto)
        
        textoIcone.append(textoNovoCliente)

        botao_novo_cliente.setAttributedTitle(textoIcone, for: UIControlState())
        botao_novo_cliente.titleLabel!.textAlignment = NSTextAlignment.center
        //botao_novo_cliente.con
        
    }
    
    var id_cliente: Int?
    
    func prossegueParaConfirmacao(_ id_cliente: Int) {
        
        self.id_cliente = id_cliente
        
        performSegue(withIdentifier: "SegueOrcamentoEscolhaParaConfirmacao", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueOrcamentoEscolhaParaConfirmacao" {
            
            let vc = segue.destination as! OrcamentoConfirmacaoViewController
            
            let contexto = ContextoOrcamento()
            
            contexto.id_cliente = self.id_cliente!;
            
            vc.defineContexto(contexto)
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if listaOrcamentos == nil {
            return 0
        }
        
        return listaOrcamentos!.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dados = listaOrcamentos![indexPath.item]
        
        // Selecionou o orçamento, busca na base para termos o completo e restaurar o objeto
        let api = PinturaAJatoApi()
        
        let parametros:[String: AnyObject] = [
            "id_orcamento" : String(format:"%d", dados.id) as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
        ]
        
        api.buscarOrcamentoPorId(self.navigationController!.view, parametros:parametros, sucesso: { (objeto:OrcamentoConsultaSaida?, resultado:Bool) -> Bool in
            
            do {
                
                try Orcamento.recriaOrcamentoGerado(objeto!.orcamento!, notificaOrcamentoMudou: nil, parcial: false)
            
                let orcamento = Orcamento.obtemOrcamento()
            
                orcamento!.numero_parcelas = objeto?.orcamento?.numero_parcelas
                orcamento!.forma_de_pagamento = objeto?.orcamento?.forma_de_pagamento
                orcamento!.meio_de_pagamento = objeto?.orcamento?.meio_de_pagamento
                orcamento!.dias_servico = objeto?.orcamento?.dias_servico
                
                self.prossegueParaConfirmacao((objeto?.orcamento?.id_cliente)!)
            }
            catch {
                
                Registro.registraErro("Falha durante recriaOrcamentoGerado")
                
                AvisoProcessamento.mensagemErroGenerico("Houve um problema ao processar este item. Tente novamente mais tarde.")
            }
            
            return true
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CelulaOrcamentoEscolhaTableViewCell", for: indexPath) as! CelulaOrcamentoEscolhaTableViewCell

        let dados = listaOrcamentos![indexPath.item]
        
        cell.label_data.text = dados.dataExibicao
        cell.label_pedido.text = String(format:"#%06d", dados.id)
        cell.label_valor.text = dados.valor
        
        cell.backgroundColor = indexPath.item % 2 == 0 ? corZebradoPar() : corZebradoImpar()
        
        return cell
    }
}
