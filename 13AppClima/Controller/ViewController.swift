//
//  ViewController.swift
//  13AppClima
//
//  Created by djdenielb on 23/05/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
//    Instancia de Clima manager
    var climaManager = ClimaManager()
    
//    Instancia del location
    let locationManager = CLLocationManager()

//    Variables graficas
    @IBOutlet weak var labelTemp: UILabel!
    @IBOutlet weak var ivIcono: UIImageView!
    
    @IBOutlet weak var labelCiudad: UILabel!
    @IBOutlet weak var labelMin: UILabel!
    @IBOutlet weak var labelMax: UILabel!
    @IBOutlet weak var labelDescripcion: UILabel!
    
    @IBOutlet weak var labelSensacion: UILabel!
    
    @IBOutlet weak var ivWallpaper: UIImageView!
    @IBOutlet weak var tfBuscar: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        protocolo de location
        locationManager.delegate = self
        
//        Solicitamos permisos al usuario
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
//    LLamada a funcion que recibe la ciudad
        climaManager.delegate = self
//
    }
    
//Boton buscar mandar llamar a la funcion que recibe ese texto
    @IBAction func btnBuscar(_ sender: UIButton) {
        if tfBuscar.text == ""{
            
        }
        else{
        let ciudadString = tfBuscar.text?.replacingOccurrences(of: " ", with: "+")
//        Dubug
//        print(ciudadString)
        climaManager.recibeNombreCiudad(cualCiudad: ciudadString ?? "0")
        }
    }
    @IBAction func btnLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
} //View Controller


//Extension del protocolo
extension ViewController: ClimaProtocol {
    func actualizarUI(recibeClima: ClimaModelo) {
        DispatchQueue.main.async {
            self.labelCiudad.text = recibeClima.modeloName
            self.labelTemp.text = "\(Int(recibeClima.modeloTemp)) °C"
            self.labelMin.text = "Temperatura Minima: \(Int(recibeClima.modeloMin)) °C"
            self.labelMax.text = "Temperatura Maxima: \(Int(recibeClima.modeloMax)) °C"
            self.labelDescripcion.text = "Descripcion: \(recibeClima.modeloDescription)"
            self.labelSensacion.text = "Sensacion Termica: \(Int(recibeClima.modeloSensacion)) °C"
            
//            Icono Clima desde la propiedad computada
            DispatchQueue.main.async {
                if let imageField = URL(string: recibeClima.iconoClima){
                    if let dataImage = try? Data(contentsOf: imageField){
                        self.ivIcono.image = UIImage(data: dataImage)
                    }
                }
            } //Cierra dispatch icono
            
//            Wallpaper
            self.ivWallpaper.image = UIImage(named: recibeClima.wallpaperClima)
            
            
        } //Cierra dispatch llenado de la UI
    }
    
    func huboError(cualError: Error) {
        if cualError.localizedDescription == "The data couldn’t be read because it is missing." {
            DispatchQueue.main.async {
                self.labelCiudad.text = "Ciudad no encontrada"
            }
        }
    }
} // Protocolo

//Extesion del core location

extension ViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let ubicacion = locations.first{
            locationManager.stopUpdatingLocation()
            let latitud = ubicacion.coordinate.latitude
            let longitud = ubicacion.coordinate.longitude
            
            print("Latitud ***** \(latitud)")
            print("Longitud ***** \(longitud)")
            climaManager.recibeLocalizacion(longitud: longitud, latitud: latitud)
    }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error al obtener la ubicacion \(error.localizedDescription)")
        
    }
    
}

