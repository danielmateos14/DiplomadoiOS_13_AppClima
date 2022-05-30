//
//  ViewController.swift
//  13AppClima
//
//  Created by djdenielb on 23/05/22.
//

import UIKit
//importar libreria de corelocation
import CoreLocation

class ViewController: UIViewController {
    
//    MARK: ************************ Instancia de clases ***********************************
//    Instancia de Clima manager
    var climaManager = ClimaManager()
//    Instancia del location
    let locationManager = CLLocationManager()

    
//    MARK: ************************* Outlets ***********************************
    @IBOutlet weak var labelTemp: UILabel!
    @IBOutlet weak var ivIcono: UIImageView!
    @IBOutlet weak var labelCiudad: UILabel!
    @IBOutlet weak var labelMin: UILabel!
    @IBOutlet weak var labelMax: UILabel!
    @IBOutlet weak var labelDescripcion: UILabel!
    @IBOutlet weak var labelSensacion: UILabel!
    @IBOutlet weak var ivWallpaper: UIImageView!
    @IBOutlet weak var tfBuscar: UITextField!
    
//    MARK: ************************* ViewDidLoad ***********************************
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        protocolo de location
        locationManager.delegate = self
        
//        Solicitamos permisos al usuario
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
//    LLamada a funcion que recibe la ciudad
        climaManager.delegate = self
        
    }// viewDID
    
//    MARK: ************************* Actions ****************************************
//Boton buscar mandar llamar a la funcion que recibe ese texto
    @IBAction func btnBuscar(_ sender: UIButton) {
////        Si el text edit esta vacio entonces no hace nada
//        if ((tfBuscar.text?.isEmpty) == nil){
//            print("Debug **** tf vacio")
//        }
//        else{
//            let ciudadString = tfBuscar.text?.replacingOccurrences(of: " ", with: "+")
//            //        Dubug
//            //        print(ciudadString)
//            climaManager.recibeNombreCiudad(cualCiudad: ciudadString ?? "0")
//        }
    }
    @IBAction func btnLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
} //View Controller

//    MARK: ************************* protocolo VC **************************************
extension ViewController: ClimaProtocol {
//    Funcion que actualiza la ui y recibe el objeto lleno que viene del manager
    func actualizarUI(recibeClima: ClimaModelo) {
//        Creamos un dispatch para manejar los hilos asyncronos
        DispatchQueue.main.async {
//            Sustitucion de los outlets por los datos del objeto
            self.labelCiudad.text = recibeClima.modeloName
            self.labelTemp.text = "\(Int(recibeClima.modeloTemp)) °C"
            self.labelMin.text = "Temperatura Minima: \(Int(recibeClima.modeloMin)) °C"
            self.labelMax.text = "Temperatura Maxima: \(Int(recibeClima.modeloMax)) °C"
            self.labelDescripcion.text = "Descripcion: \(recibeClima.modeloDescription)"
            self.labelSensacion.text = "Sensacion Termica: \(Int(recibeClima.modeloSensacion)) °C"
            
//              Icono Clima desde la propiedad computada, la propiedad computada ya
//              le genere una url con el icono que vendra, ahora esa url la
//              convertimos en data para que la muestre y la asginamos al ImageView
            DispatchQueue.main.async {
                if let imageField = URL(string: recibeClima.iconoClima){
                    if let dataImage = try? Data(contentsOf: imageField){
                        self.ivIcono.image = UIImage(data: dataImage)
                    }
                }
            } //Cierra dispatch icono
            
//              El wallpaper igual es una propiedad computada, pero esta en ves de
//              traer una imagen de una url, son imagenes que yo agrege al proyecto
//              entonces solo es poner el nombre de la propiedad computada, por que
//              la variable ya sabe que imagen poner dependiendo el rango de la
//              propiedad computada
            self.ivWallpaper.image = UIImage(named: recibeClima.wallpaperClima)
            
            
        } //Cierra dispatch llenado de la UI
    }
    
//    Si hubo error en el nombre de la ciudad o al no escribir nada, en el nombre
//    de la ciudad imprimira que no encontro la ciudad
    func huboError(cualError: Error) {
        if cualError.localizedDescription == "The data couldn’t be read because it is missing." {
            DispatchQueue.main.async {
                self.labelCiudad.text = "Ciudad no encontrada"
            }
        }
    }
} // Protocolo

//    MARK: ************************* Core location ************************************
extension ViewController: CLLocationManagerDelegate{
//    Creamos una funcion con parametros por defecto de core locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        Variable segura que tendra la primera posicion del array CLLocation
//        que esta en los parametros de arriba, dentro del if tenemos la un metodo
//        que detiene la ubicacion y entonces guarda dentro de latitud y longitud
//        las coordenadas
        if let ubicacion = locations.first{
            locationManager.stopUpdatingLocation()
            let latitud = ubicacion.coordinate.latitude
            let longitud = ubicacion.coordinate.longitude
            
            print("Latitud ***** \(latitud)")
            print("Longitud ***** \(longitud)")
//            Con las coordenadas ya sacadas se las enviamos a la funcion del
//            manager que nececesita las coordenadas para crear la url
            climaManager.recibeLocalizacion(longitud: longitud, latitud: latitud)
    }
    }
    
//    Si hay un error al obtener la ubicacion imprime en consola
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error al obtener la ubicacion \(error.localizedDescription)")
        
        
    }
    
}

