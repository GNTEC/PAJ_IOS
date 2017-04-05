//
//  AgendaCalendarioViewController.swift
//  Pintura a Jato
//
//  Created by daniel on 03/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

// The output below is limited by 4 KB.
// Upgrade your plan to remove this limitation.

//
//  SelecionaDataViewController.m
//  Aplicativo iOS
//
//  Created by daniel on 05/06/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

class AgendaCalendarioViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var painel_eventos: UIView!
    @IBOutlet weak var botao_mais: UIButton!
    @IBOutlet weak var data_hoje: UILabel!
    @IBOutlet weak var text_picker_horarios: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var painel_picker_horarios: UIView!
    @IBOutlet weak var constraint_altura_painel_picker: NSLayoutConstraint!
    @IBOutlet weak var constraint_altura_legenda: NSLayoutConstraint!
    
    var picker_horarios: UIPickerView!
    var botao_avanca_mes: UIBarButtonItem!
    var botao_volta_mes: UIBarButtonItem!

    @IBOutlet weak var tableView: UITableView!
    
    var fonteCalendario: FonteCalendario?
    //var itensCabecalhoCalendario = [AnyObject]()
    var contexto: ContextoAgendaCalendario?
    var dataAtual: Date?
    var dataAtiva: Date?
    var dataFinalServico: Date?
    var horarios_inicio = [ "", "08:00", "08:30", "09:00"]
    var agenda: [ItemHistoricoCalendario]?
    var listaDia: [ItemHistoricoCalendario]?
    
    let reuseIdentifier = "CelulaCalendarioCollectionViewCell"
    
    func defineContexto(_ contexto: ContextoAgendaCalendario) {
        self.contexto = contexto
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = NO;
        // Register cell classes
        //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        // Do any additional setup after loading the view.
        painel_eventos.isHidden = true
        let size: CGSize = CGSize(width: 30, height: 30)

        let icon_color = UIColor.white
        let image = UIImage(icon: (contexto != nil && contexto!.modoSelecaoDataAtualFutura ? "icon-signin" : "icon-plus"), backgroundColor: UIColor.clear, iconColor: icon_color, iconScale: 1.0, andSize: size)
        
        botao_mais.setImage(image, for: UIControlState())
        
        /*let vermelho = UIColor.redColor()
        let cinza = UIColor.grayColor()
        let vermelho_e = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        let cinza_e = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let laranja = self.corLaranja()
        let branco = UIColor.whiteColor()
        let azul = UIColor.blueColor()*/
        
        ///////////////////////////////////////////////////////////////////////////////////////////
        
        if contexto != nil && contexto!.mesSelecionado != nil {
            self.dataAtual = contexto!.mesSelecionado as Date?
        }
        else {
            self.dataAtual = Date()
        }
        
        self.data_hoje.text = Data.dateParaDataExtenso(self.dataAtual!)

        ///////////////////////////////////////////////////////////////////////////////////////////
        
        if contexto != nil && contexto!.modoSelecaoDataAtualFutura {
        
            picker_horarios = UIPickerView(/*frame: CGRectMake(0,200,160,200)*/)
            picker_horarios.delegate = self;
            picker_horarios.dataSource = self
            //picker_horarios.hidden = true
            picker_horarios.showsSelectionIndicator = true
        
            let doneButton = UIBarButtonItem(title: "Fechar", style: .done, target: self, action: #selector(self.concluido_horario(_:)))
            let toolBar = UIToolbar(frame: CGRect(x: 0, y: view.frame.size.height - picker_horarios!.frame.size.height - 50, width: 320, height: 50))
            toolBar.barStyle = .blackOpaque
            let toolbarItems = [doneButton]
            toolBar.items = toolbarItems
            
            //self.view.addSubview(picker_horarios)
            
            self.text_picker_horarios.inputView = picker_horarios
            self.text_picker_horarios.inputAccessoryView = toolBar
            self.text_picker_horarios.text = horarios_inicio[0]
            self.text_picker_horarios.delegate = self

            painel_picker_horarios!.isHidden = false
        }
        else {
            painel_picker_horarios!.isHidden = true
            self.constraint_altura_legenda.constant -= self.constraint_altura_painel_picker.constant
            self.constraint_altura_painel_picker.constant = 0
        }
        
        botao_volta_mes = UIBarButtonItem(title: "<", style: UIBarButtonItemStyle.plain, target: self, action: #selector(onVoltaMes))
        botao_avanca_mes = UIBarButtonItem(title: ">", style: UIBarButtonItemStyle.plain, target: self, action: #selector(onAvancaMes))

        self.navigationItem.rightBarButtonItems = [botao_avanca_mes, botao_volta_mes]
        
        ///////////////////////////////////////////////////////////////////////////////////////////
        
        self.title = Data.dateParaStringMesAno(dataAtual!).uppercased()
        
        fonteCalendario = FonteCalendario(mesReferencia: dataAtual!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

        atualizaCalendario()

    }
    
    func onAvancaMes(_ sender: AnyObject) {
        mudaMes(1)
    }
    
    func onVoltaMes(_ sender: AnyObject) {
        mudaMes(-1)
    }
    
    func concluido_horario(_ sender: AnyObject) {
        
        //pickerFormaPagamento!.hidden = true
        text_picker_horarios.resignFirstResponder()
    }
    
    func atualizaCalendario() {
    
        ///////////////////////////////////////////////////////////////////////////////////////////
        
        let franqueado = PinturaAJatoApi.obtemFranqueado()
        
        ///////////////////////////////////////////////////////////////////////////////////////////
        
        let api = PinturaAJatoApi()
        
        let parametros: [String : AnyObject] = [
            "dataInicial": Data.dateParaStringDD_MM_AAAA(fonteCalendario!.dataInicial) as AnyObject,
            "dataFinal": Data.dateParaStringDD_MM_AAAA(fonteCalendario!.dataFinal) as AnyObject,
            "id_franquia": "\(franqueado!.id_franquia)" as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
        ]
        
        api.buscarAgendaPorFranquia(self.navigationController!.view, parametros: parametros) { (objeto, falha) -> Bool in
            
            if(!falha) {
                
                self.agenda = objeto
            
                self.fonteCalendario!.defineObjetosMarcacao(objeto)
                
                self.defineDataAtiva(self.dataAtual!)
                
                self.collectionView.reloadData()

            }
            
            return true
        }
        
    }
    
    func prosseguePagamento() {
        
        contexto?.horario_inicio = text_picker_horarios.text;
        contexto?.data_inicial = Data.dateParaStringDD_MM_AAAA(dataAtiva)
        contexto?.data_final = Data.dateParaStringDD_MM_AAAA(dataFinalServico)
    
        let storyboard = UIStoryboard(name: "Orcamento", bundle: nil)
        
        var controller : UIViewController
        
        if contexto?.tipoMeioPagamento == TipoMeioPagamento.CartaoCredito {
            controller = storyboard.instantiateViewController( withIdentifier: "OrcamentoPagamentoCartao")
            
            let pcvc = controller as! OrcamentoPagamentoCartaoViewController
            
            pcvc.defineContexto(contexto)
        }
        else {
            controller = storyboard.instantiateViewController( withIdentifier: "OrcamentoFinalizarViewController")

            let fvc = controller as! OrcamentoFinalizarViewController
            
            fvc.defineContexto(contexto)
            
        }

        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func mudaMes(_ diferenca: Int) {
        
        var componentes = DateComponents()
        
        componentes.month = diferenca
        
        dataAtual = (Calendar.current as NSCalendar).date(byAdding: componentes, to: self.dataAtual!, options: NSCalendar.Options(rawValue: 0))
        
        self.title = Data.dateParaStringMesAno(dataAtual!).uppercased()
        
        fonteCalendario = FonteCalendario(mesReferencia: dataAtual!)
        
        atualizaCalendario()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return horarios_inicio.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return horarios_inicio[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.text_picker_horarios.text = horarios_inicio[row];
        //picker_horarios.hidden = true
    }
    
    /*func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        picker_horarios.hidden = false
        return false
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
     #pragma mark - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    // MARK: <UICollectionViewDataSource>

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (fonteCalendario?.contagem())!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CelulaCalendarioCollectionViewCell)
        
        // Configure the cell
        let dados1: AnyObject = fonteCalendario!.obtemDadosItem(indexPath.item) as AnyObject
        let dados: [AnyObject] = dados1 as! [AnyObject]
        
        cell.label_texto.text = dados[0] as? String
        cell.label_texto.textColor = dados[2] as? UIColor
        cell.label_texto.backgroundColor = dados[3] as? UIColor
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        //You may want to create a divider to scale the size by the way..
        let rect = collectionView.frame
        let altura: CGFloat = (rect.size.height - 6) / 6
        // 6 semanas
        let largura: CGFloat = (rect.size.width - 7) / 7
        // 7 dias da semana
        return CGSize(width: largura, height: altura > 40.0 ? 40.0 : altura)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // clique no dia da semana
        if indexPath.item < 7 {
            return
        }
        
        painel_eventos!.isHidden = false
        
        let dataSelecionada = fonteCalendario!.dataPelaPosicao(indexPath.item)
        
        onSelecionouData(dataSelecionada)
    }
    
    @IBAction func onCriarEvento(_ sender: AnyObject) {
        
        if contexto != nil && contexto!.modoSelecaoDataAtualFutura {
            
            if dataAtiva == nil || dataFinalServico == nil {
                AvisoProcessamento.mensagemErroGenerico("Selecione a data do início do serviço")
                return
            }
            
            if text_picker_horarios.text == nil || text_picker_horarios.text!.isEmpty {
                AvisoProcessamento.mensagemErroGenerico("Por favor, escolha o  melhor horário")
                return
            }
            
            prosseguePagamento()
            
        }
        else {
            self.performSegue(withIdentifier: "SegueAgendaParaAdicionarEvento", sender: self)
        }
    }
    
    func onSelecionouData(_ dataSelecionada: Date) {
        
        let disponivel = fonteCalendario!.verificaDiaDisponivel(dataSelecionada)
        
        if contexto != nil && contexto!.modoSelecaoDataAtualFutura {
            
            let agora = Date()
            
            if dataSelecionada.compare(agora) == ComparisonResult.orderedAscending {
                AvisoProcessamento.mensagemErroGenerico("Data não pode ser anterior à data atual")
                return
            }
            
            if !disponivel {
                AvisoProcessamento.mensagemErroGenerico("Data não está disponível")
                return
            }
            
            defineDataAtiva(dataSelecionada)
            
            ////////////////////////////////////////////////////////////////////
            
            let api = PinturaAJatoApi()
            
            let parametros : [String:AnyObject] = [
                "dias" : "\(contexto!.diasServico)" as AnyObject,
                "data_inicial" : Data.dateParaStringDD_MM_AAAA(dataSelecionada) as AnyObject,
                "id_franquia" : "\(PinturaAJatoApi.obtemFranqueado()!.id_franquia)" as AnyObject,
                "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
            ]
            
            api.consultarDatasDisponiveis(self.navigationController!.view, parametros: parametros, sucesso: { (objeto: [String]?, resultado: Resultado?) -> Bool in
            
                var itens = Array<ItemHistoricoCalendario>()
                var sequencia = 0
                
                for data in objeto! {
                    
                    let itemCalendario = ItemHistoricoCalendario()
                    
                    itemCalendario.sequencia = sequencia
                    itemCalendario.setData(Data.dateParaJsonStringComT(Data.dateStringDD_MM_AAAAParaDate(data)!))
                    itemCalendario.periodo_inicial = "00:01"
                    itemCalendario.periodo_final = "23:59"
                    itemCalendario.tipo = sequencia == 0 ? 1 : 3
                    
                    itens.append(itemCalendario)
                    
                    if sequencia == (objeto!.count - 1) {
                        self.dataFinalServico = itemCalendario.data()
                    }
                    
                    sequencia += 1
                }
                
                self.fonteCalendario?.agregaItensMarcacao(itens)
                
                self.collectionView.reloadData()
                
                return true
            })
        }
        else {
            defineDataAtiva(dataSelecionada)
        }
    }
    
    func defineDataAtiva(_ dataAtiva: Date) {
        
        self.dataAtiva = dataAtiva
        
        ///////////////////////////////////////////////////////////////////////
        
        self.data_hoje.text = Data.dateParaDataExtenso(self.dataAtiva!)
        
        ///////////////////////////////////////////////////////////////////////
        
        listaDia = [ItemHistoricoCalendario]()
        
        for itemCalendario:ItemHistoricoCalendario in agenda! {
            
            if itemCalendario.data()!.compare(dataAtiva) == ComparisonResult.orderedSame {
                listaDia?.append(itemCalendario)
            }
        }

        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listaDia == nil {
            return 0
        }
        
        return (listaDia?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = listaDia![indexPath.item]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CelulaDetalheAgendaData", for: indexPath)
        
        var texto: String
        
        if item.tipoDataCalendario() == TipoDataCalendario.diaBloqueadoFranqueado {
            texto = "Bloqueado pelo franqueado"
        }
        else {
            texto = String.init(format: "#%06d - %@ até %@", item.id_orcamento, item.inicio(), item.fim())
        }
        
        cell.textLabel?.text = texto
        
        cell.backgroundColor = indexPath.item % 2 == 0 ? corZebradoPar() : corZebradoImpar()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let itemCalendario = listaDia![indexPath.item]
        
        if itemCalendario.tipoDataCalendario() == TipoDataCalendario.diaBloqueadoFranqueado {
            return
        }
        
        let api = PinturaAJatoApi()
        
        let parametros: [String:AnyObject] = [
            "id_orcamento" :  "\(itemCalendario.id_orcamento)" as AnyObject,
            "id_sessao": PinturaAJatoApi.obtemIdSessao() as AnyObject
        ]
        
        api.buscarOrcamentoPorId(self.navigationController!.view, parametros: parametros) { (objeto, falha) -> Bool in
            
            let status = objeto?.orcamento?.status
            var id : String?
            
            if(status == nil) {
                return false;
            }
            else if(status == ("2")) {
                //intent = new Intent(this, OrcamentoChecklistActivity.class);
                id  = "OrcamentoChecklistViewController"
            }
            else if(status == ("3") || (status == ("4")))  {
                //intent = new Intent(this, PedidoPrincipalActivity.class);
                id = "PedidoPrincipalViewController"
            }
            
            if id != nil {
                
                let storyboard = UIStoryboard(name: "Orcamento", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: id!)
                
                if status == "2" {
                    
                    let vc = controller as! OrcamentoChecklistViewController
                    
                    let contexto = ContextoOrcamento()
                    
                    contexto.id_orcamento = objeto!.orcamento!.id
                    
                    vc.defineContexto(contexto)
                }
                else {
                    
                    let vc = controller as! PedidoPrincipalViewController
                    
                    let contexto = ContextoPedido()
                    
                    contexto.id_orcamento = objeto!.orcamento!.id
                    
                    vc.defineContexto(contexto)
                }

                self.navigationController?.pushViewController(controller, animated: true)
            }
            
            return true
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
