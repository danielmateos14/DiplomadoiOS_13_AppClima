//
//  ClimaModelo.swift
//  13AppClima
//
//  Created by djdenielb on 28/05/22.
//

import Foundation

// Modelamos los datos para poder crear el objeto con los datos decodificados
// Con un nombre personalizado cada dato del json

struct ClimaModelo{
    let modeloName: String
    let modeloId: Int
    let modeloSensacion: Double
    let modeloDescription: String
    let modeloTemp: Double
    let modeloMin: Double
    let modeloMax: Double
    
//    Propiedad computada, esta sirve para que en base a un rango dentro de una vriable
//    tome el valor de ese rango, por ejemplo aqui, el icono cambia dependiendo
//    de un rango de numeros entonces la variable va a tomar ese valor dependiendo
//    de ese rango como un if o como switch
    var iconoClima: String{
        switch modeloId{
        case 200...232:
            return "http://openweathermap.org/img/wn/11d@2x.png"
        case 300...321:
            return "http://openweathermap.org/img/wn/09d@2x.png"
        case 500...504:
            return "http://openweathermap.org/img/wn/10d@2x.png"
        case 511:
            return "http://openweathermap.org/img/wn/13d@2x.png"
        case 520...531:
            return "http://openweathermap.org/img/wn/09d@2x.png"
        case 600...622:
            return "http://openweathermap.org/img/wn/13d@2x.png"
        case 701...781:
            return "http://openweathermap.org/img/wn/50d@2x.png"
        case 800:
            return "http://openweathermap.org/img/wn/01d@2x.png"
        case 801:
            return "http://openweathermap.org/img/wn/02d@2x.png"
        case 802:
            return "http://openweathermap.org/img/wn/03d@2x.png"
        case 803...804:
            return "http://openweathermap.org/img/wn/04d@2x.png"
        default:
            return ""
        }
    }
    
//    Propiedad computada para cambiar el fondo dependiendo del rango
    var wallpaperClima: String{
        switch modeloId{
        case 200...232:
            return "tormenta_electrica"
        case 300...321:
            return "lluvia_intensa"
        case 500...504:
            return "lluvia_ligera"
        case 511:
            return "Nevando"
        case 520...531:
            return "lluvia_ligera"
        case 600...622:
            return "Nevando"
        case 701...781:
            return "nublado"
        case 800:
            return "cielo_soleado"
        case 801:
            return "cielo_soleado"
        case 802:
            return "nublado"
        case 803...804:
            return "nublado"
        default:
            return ""
        }
    }
}
