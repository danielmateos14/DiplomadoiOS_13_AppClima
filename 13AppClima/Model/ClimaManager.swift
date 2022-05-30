//
//  ClimaManager.swift
//  13AppClima
//
//  Created by djdenielb on 28/05/22.
//

import Foundation
import UIKit
// Importamos la libreria de core location, primero debemos de habilitar los permisos
// en inf en la configuracion del proyecto
import CoreLocation

// Protocolo del manager para actualizar la ui y que ponga un error
protocol ClimaProtocol{

    func actualizarUI(recibeClima: ClimaModelo)
    
    func huboError(cualError: Error)
}

// struct del manager
struct ClimaManager{
    
//    Delegado del protocolo
    var delegate: ClimaProtocol?
        
//  Funcion que recibe nombre ciudad, esta misma genera la url concatenada
//  Y esta misma funcion llama a la funcion que decodficia la url
    func recibeNombreCiudad(cualCiudad: String){
        let urlString = "http://api.openweathermap.org/data/2.5/weather?&APPID=7e19186558ea9fae06d5445efed291e3&units=metric&lang=es&q=\(cualCiudad)"
        funcionUrlSessions(recibeString: urlString)
} //Cierra recibe ubicacion
    
    
//  Funcion que recibe ubicacion, esta misma genera la url concatenada
//  Y esta misma funcion llama a la funcion que decodficia la url
    func recibeLocalizacion(longitud: CLLocationDegrees, latitud: CLLocationDegrees){
        let urlString = "http://api.openweathermap.org/data/2.5/weather?&APPID=7e19186558ea9fae06d5445efed291e3&units=metric&lang=es&lat=\(latitud)&lon=\(longitud)"
        
        funcionUrlSessions(recibeString: urlString)
    }
    
    
//    Funcion para urlSessions, recibe un string
    func funcionUrlSessions(recibeString: String){
//        Crea objeto url a partir de una url string
        if let variableTipoUrl = URL(string: recibeString){
//            Instancia de urlsessions
            let variableUrlSessions = URLSession(configuration: .default)
//             Asigna una tarea a la sesion, la tarea es a la variable session trae
//             dentro la variabletipoURL y de parametros tiene un data, respouesta
//             y error, luego viene un closure
            let tarea = variableUrlSessions.dataTask(with: variableTipoUrl) { data, respuesta, error in
//                Dentro del closure es para ver si hay error o no, si hay error
//                entonces le mandas el error al delegado para que lo lleve a otra
//                pantalla
                if error != nil{
                    print("Debug *** Saber que Error de tarea:  \(error?.localizedDescription ?? "")")
                    delegate?.huboError(cualError: error!)
                    return
                }
                
//                Si no hay error, crea una variable segura del tipo data
                if let datosSeguros = data {
//                    Crea una variable segura que sera igual a la funcion que
//                    decodifica el json y esta a su ves recibe variable tipo data
                    if let climaDecodificado = decodificarJson(recibeDatosSeguros: datosSeguros){
//                        Envia la informacion al delegado para que le lleve a la
//                        siguiente pantalla y asi ves recibe el objeto lleno
                        delegate?.actualizarUI(recibeClima: climaDecodificado)
                        
                    } //Clima decodificado
                } //Datos seguros
            } //Tarea
            
//            Iniciamos la tarea del url session, que esta en segundo plano
            tarea.resume()
            
        } //Variable tipo url
    } //Funcion url sessions
    
    
//    Funcion decodifcar json, recibe un data y retorna un objeto del modelo personzalido
    func decodificarJson(recibeDatosSeguros: Data) -> ClimaModelo? {
//        Intancia de jsondecoder
        let deco = JSONDecoder()
        
//        Hacemos un do para intentar decodificar, dentro de los parametros se debe
//        poner el tipo de dato del modelo original no del perzonalizado y el
//        segundo parametro es un data
        do{
            let dataDecodificada = try deco.decode(ClimaData.self, from: recibeDatosSeguros)
            
            print("Debug *** \(dataDecodificada.name ?? "")")
            
//            Ya decodificado, vamos a llenar el objeto, primero creamos una variable
//            por cada dato del modelo que vamos a guardar
            let nombre = dataDecodificada.name
            let id = dataDecodificada.weather[0].id
            let sensacion = dataDecodificada.main.feels_like
            let descripcion = dataDecodificada.weather[0].description
            let temperatura = dataDecodificada.main.temp
            let min = dataDecodificada.main.temp_min
            let max = dataDecodificada.main.temp_max
            
//            Despues, vamos a crear una instancia del modelo personalizado y este
//            nos va a pedir datos por defecto, esos datos seran variables de arriba
            let objetoClima = ClimaModelo(modeloName: nombre ?? "", modeloId: id ?? 0, modeloSensacion: sensacion ?? 0, modeloDescription: descripcion ?? "", modeloTemp: temperatura ?? 0, modeloMin: min ?? 0, modeloMax: max ?? 0)
            
            print("Degub **** \(objetoClima)")
            
//            Retornamos el objeto clima
            return objetoClima
//            Este catch es por si hay un error al momeno de decodificar json, por si
//            no esta bien el modelo o algo
        } catch{
            print("Debug No obtienes localidad **** \(error.localizedDescription)")
            delegate?.huboError(cualError: error)
            
//            Retornamos nil para que se detenga la funcion decodificar json
            return nil
        }
        
    }//Cierra decodificar json
    
} //cierra clima manager

