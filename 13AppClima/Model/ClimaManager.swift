//
//  ClimaManager.swift
//  13AppClima
//
//  Created by djdenielb on 28/05/22.
//

import Foundation
import UIKit
import CoreLocation

protocol ClimaProtocol{
    func actualizarUI(recibeClima: ClimaModelo)
    
    func huboError(cualError: Error)
}

struct ClimaManager{
    
    var delegate: ClimaProtocol?
        
//  Funcion que recibe nombre ciudad o ubicacion
    
    func recibeNombreCiudad(cualCiudad: String){
        let urlString = "http://api.openweathermap.org/data/2.5/weather?&APPID=7e19186558ea9fae06d5445efed291e3&units=metric&lang=es&q=\(cualCiudad)"
        funcionUrlSessions(recibeString: urlString)
} //Cierra recibe ubicacion
    
//    Funcion que recibe localizacion
    func recibeLocalizacion(longitud: CLLocationDegrees, latitud: CLLocationDegrees){
        let urlString = "http://api.openweathermap.org/data/2.5/weather?&APPID=7e19186558ea9fae06d5445efed291e3&units=metric&lang=es&lat=\(latitud)&lon=\(longitud)"
        
        funcionUrlSessions(recibeString: urlString)
    }
    
    
//    Funcion para urlSessions
    func funcionUrlSessions(recibeString: String){
//        Crea objeto url a partir de una url string
        if let variableTipoUrl = URL(string: recibeString){
//            Crea el objeto url sessions
            let variableUrlSessions = URLSession(configuration: .default)
            
//            Asigna una tarea a la sesion
            let tarea = variableUrlSessions.dataTask(with: variableTipoUrl) { data, respuesta, error in
//                Si hay un error
                if error != nil{
                    print("Debug *** Saber que Error de tarea:  \(error?.localizedDescription ?? "")")
                    delegate?.huboError(cualError: error!)
                    return
                }
                
//                Si no hay error, crea una variable segura
                if let datosSeguros = data {
//                    Decodifica el objeto json de la api
                    if let climaDecodificado = decodificarJson(recibeDatosSeguros: datosSeguros){
//                        Envia la informacion al delegado para que le lleve a la
//                        siguiente pantalla
                        delegate?.actualizarUI(recibeClima: climaDecodificado)
                    } //Clima decodificado
                } //Datos seguros
            } //Tarea
            
//            Iniciamos tarea que esta en segundo plano
            tarea.resume()
            
        } //Variable tipo url
    } //Funcion url sessions
    
    
//    Funcion decodifcar json
    func decodificarJson(recibeDatosSeguros: Data) -> ClimaModelo? {
        let deco = JSONDecoder()
        
        do{
            let dataDecodificada = try deco.decode(ClimaData.self, from: recibeDatosSeguros)
            
            print(dataDecodificada.name ?? "")
            
//            Llenamos el objeto
            let nombre = dataDecodificada.name
            let id = dataDecodificada.weather[0].id
            let sensacion = dataDecodificada.main.feels_like
            let descripcion = dataDecodificada.weather[0].description
            let icono = dataDecodificada.weather[0].icon
            let temperatura = dataDecodificada.main.temp
            let min = dataDecodificada.main.temp_min
            let max = dataDecodificada.main.temp_max
            
//            Icono de la api
//            if id ?? 0 >= 200 && id ?? 0 < 232{
//
//            }
            
            let objetoClima = ClimaModelo(modeloName: nombre ?? "", modeloId: id ?? 0, modeloSensacion: sensacion ?? 0, modeloDescription: descripcion ?? "", modeloTemp: temperatura ?? 0, modeloMin: min ?? 0, modeloMax: max ?? 0)
            
            print(objetoClima)
            
            return objetoClima
        } catch{
            print(error.localizedDescription)
            delegate?.huboError(cualError: error)
            
            return nil
        }
        
    }//Cierra decodificar json
    
    
    
} //cierra clima manager

