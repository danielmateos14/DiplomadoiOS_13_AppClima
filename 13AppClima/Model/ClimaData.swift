//
//  ClimaData.swift
//  13AppClima
//
//  Created by djdenielb on 28/05/22.
//

import Foundation

// Struct de clima tal cual viene en el json
struct ClimaData: Codable{
    let weather: [Weather]
    let main: Main
    let name: String?
}


struct Weather: Codable{
    let id: Int?
    let description: String?
    let icon: String?
}


struct Main: Codable{
    let temp: Double?
    let temp_min: Double?
    let temp_max: Double?
    let feels_like: Double?
}
