//
//  FonteCalendario.swift
//  Pintura a Jato
//
//  Created by daniel on 03/09/16.
//  Copyright © 2016 Pintura à Jato. All rights reserved.
//

import Foundation

class FonteCalendario {
    
    let LINHAS = 7
    let COLUNAS = 7
    
    let DOMINGO = 1
    let SEGUNDA = 2
    let TERCA = 3
    let QUARTA = 4
    let QUINTA = 5
    let SEXTA = 6
    let SABADO = 7
    
    var mesReferencia: Date
    var dataInicial: Date
    var dataFinal: Date
    
    var itensMarcacao: [ItemHistoricoCalendario]?
    var itensMarcacaoAgregados: [ItemHistoricoCalendario]?
    
    //var itensCabecalho = [["D", "s", vermelho, branco], ["S", "s", cinza, branco], ["T", "s", cinza, branco], ["Q", "s", cinza, branco], ["Q", "s", cinza, branco], ["S", "s", cinza, branco], ["S", "s", cinza, branco]]
    var itensCabecalho = [ "D", "S", "T", "Q", "Q", "S", "S"]
    
    init(mesReferencia: Date) {
        
        self.mesReferencia = mesReferencia
        
        var flags: NSCalendar.Unit = [.day, .month, .year]
        
        let componentes_mes_refencia = (Calendar.current as NSCalendar).components(flags, from: mesReferencia)
        var componentes = DateComponents()

        componentes.day = 1
        componentes.month = componentes_mes_refencia.month
        componentes.year = componentes_mes_refencia.year
        
        let primeiroDiaMes = Calendar.current.date(from: componentes)
        
        flags = NSCalendar.Unit.weekday
        
        let diaSemana = (Calendar.current as NSCalendar).component(NSCalendar.Unit.weekday, from: primeiroDiaMes!)
        var descontar: Int = 0
        
        switch (diaSemana) {
        case DOMINGO: //Calendar.SUNDAY:
            descontar = -7;
            break;
        case SABADO: //Calendar.SATURDAY:
            descontar = -6;
            break;
        case SEXTA: //Calendar.FRIDAY:
            descontar = -5;
            break;
        case QUINTA: //Calendar.THURSDAY:
            descontar = -4;
            break;
        case QUARTA: //Calendar.WEDNESDAY:
            descontar = -3;
            break;
        case TERCA: //Calendar.TUESDAY:
            descontar = -2;
            break;
        case SEGUNDA: //Calendar.MONDAY:
            descontar = -1;
            break;
        default:
            break;
        }
        
        var componentes_data_inicial = DateComponents()
        
        componentes_data_inicial.day = descontar
        
        self.dataInicial = (Calendar.current as NSCalendar).date(byAdding: componentes_data_inicial, to: primeiroDiaMes!, options: NSCalendar.Options(rawValue: 0))!
        
        var componentes_data_final = DateComponents()
        
        componentes_data_final.day = LINHAS*COLUNAS//self.contagem()
        
        self.dataFinal = (Calendar.current as NSCalendar).date(byAdding: componentes_data_final, to: primeiroDiaMes!, options: NSCalendar.Options(rawValue: 0))!
        
    }
 
    func contagem() -> Int {
        return LINHAS * COLUNAS
    }
    
    func defineObjetosMarcacao(_ itensMarcacao:[ItemHistoricoCalendario]?) {
        self.itensMarcacao = itensMarcacao
    }

    func agregaItensMarcacao(_ itensMarcacaoAgregados:[ItemHistoricoCalendario]?) {
        self.itensMarcacaoAgregados = itensMarcacaoAgregados
    }
    
    func obtemDadosItem(_ indice: Int) -> [AnyObject] {
        
        var texto: String?
        var corTexto: UIColor?
        var corFundo: UIColor?
        let mes_inicial = (Calendar.current as NSCalendar).component(NSCalendar.Unit.month, from: mesReferencia)
                
        corFundo = Cores.corCalendarioFundoCelula()

        if indice < itensCabecalho.count {
            texto = itensCabecalho[indice]
            
            corTexto = (indice == 0) ? Cores.corCalendarioVermelho() : Cores.corCalendarioCinza();
        }
        else {
            
            var componentes_data = DateComponents()
            
            componentes_data.day = indice - COLUNAS
            
            let dataCalculada = (Calendar.current as NSCalendar).date(byAdding: componentes_data, to: dataInicial, options: NSCalendar.Options(rawValue: 0))
            
            let dia = (Calendar.current as NSCalendar).component(NSCalendar.Unit.day, from: dataCalculada!)

            let mes_calculado = (Calendar.current as NSCalendar).component(NSCalendar.Unit.month, from: dataCalculada!)
            let mesDiferente = mes_inicial != mes_calculado
            
            texto = String.init(format: "%d", dia)
            
            let dia_semana = (Calendar.current as NSCalendar).component(NSCalendar.Unit.weekday, from: dataCalculada!)
            
            if dia_semana == DOMINGO {
                corTexto = mesDiferente ? Cores.corCalendarioVermelhoClaro() : Cores.corCalendarioVermelho()
            }
            else {
                corTexto = mesDiferente ? Cores.corCalendarioCinzaClaro() : Cores.corCalendarioCinza()
            }
            
            ///////////////////////////////////////////////////////////////////////////////
            
            let listas = [itensMarcacao, itensMarcacaoAgregados]
            
            for listag in listas {
                
                if listag == nil {
                    continue
                }
                
                let dataAtual = dataCalculada
                
                for itemCalendario:ItemHistoricoCalendario in listag! {
                    
                    if dataAtual!.compare(itemCalendario.data()! as Date) == ComparisonResult.orderedSame {
                        
                        corTexto = Cores.corCalendarioTextoMarcacao()
                        
                        switch itemCalendario.tipoDataCalendario() {
                        case TipoDataCalendario.diaBloqueadoFranqueado:
                            corFundo = Cores.corCalendarioFundoBloqueadoFranqueado()
                            break
                        case TipoDataCalendario.diaContinuacaoFinalizacao:
                            corFundo = Cores.corCalendarioFundoContinuacao()
                            break
                        case TipoDataCalendario.diaInicioTrabalho:
                            corFundo = Cores.corCalendarioFundoInicio()
                            break
                        default:
                            break
                        }
                    }
                }
            }

        }

        return [texto! as AnyObject, 0 as AnyObject, corTexto!, corFundo!]
    }
    
    func dataPelaPosicao(_ posicao: Int) -> Date {
        
        var componente = DateComponents()
        
        componente.day = posicao - COLUNAS
        
        return (Calendar.current as NSCalendar).date(byAdding: componente, to: dataInicial, options: NSCalendar.Options(rawValue: 0))!
        
    }
    
    func verificaDiaDisponivel(_ dataSelecionada: Date) -> Bool {
        
        if itensMarcacao == nil || itensMarcacao?.count == 0 {
            return true
        }
        
        for itemCalendario:ItemHistoricoCalendario in itensMarcacao! {
            
            if dataSelecionada.compare(itemCalendario.data()! as Date) == ComparisonResult.orderedSame {
                return false
            }
            
        }
        
        return true
    }
}
