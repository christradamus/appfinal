//
//  Utils.swift
//  appfinal
//
//  Created by christian perez  on 06-04-23.
//

import Foundation

class Global {
    static let sharedInstance = Global()
    
    var user: String = ""
    var userPassword: String = ""
    var name: String = ""
    var userNameRegister: String = ""
    var userType: String = ""
    var globalArray = [String]()
    var arrayFinal = [String]()    

    func agregarInteraccion(usuario: String, mensaje: String, fecha: String, tipoLog: String, modulo: String) {
        let directorioPrincipal = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let archivoURL = directorioPrincipal.appendingPathComponent("interacciones.txt")
        let nuevaInteraccion = "Fecha y hora: \(fecha) - Usuario: \(usuario) - Tipo Log: \(tipoLog)\nMódulo: \(modulo) - Mensaje: \(mensaje)\n\n"
        if let archivoHandle = FileHandle(forWritingAtPath: archivoURL.path) {
            archivoHandle.seekToEndOfFile()
            if let nuevaInteraccionData = nuevaInteraccion.data(using: .utf8) {
                archivoHandle.write(nuevaInteraccionData)
                print("Interacción agregada correctamente.")
            } else {
                print("Error al convertir la interacción a datos.")
            }
            archivoHandle.closeFile()
        } else {
            print("Error al abrir el archivo para escritura.")
        }
    }
    
    func getDate() -> String {
        let fechaHoraActual = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let fechaHoraActualString = formatter.string(from: fechaHoraActual)
        return fechaHoraActualString
    }
}
