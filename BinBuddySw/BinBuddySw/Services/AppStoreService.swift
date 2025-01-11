//
//  AppStoreService.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 11/01/25.
//

import Foundation

import Foundation

struct AppInfo: Decodable {
    let title: String?
    let link: String?
    let logos: [Logo]?
}

struct Logo: Decodable {
    let size: String?
    let link: String?
}

class AppStoreService {
    func fetchApps(keyword: String, completion: @escaping ([AppInfo]?) -> Void) {
        let apiKey = "d88f0aad7c06e72826d79566a12e6847a7e86f9aae5b781ab60a53ad621a2561"
            let urlString = "https://serpapi.com/search.json?engine=apple_app_store&term=\(keyword)&country=us&lang=en-us&api_key=\(apiKey)"
            
            guard let url = URL(string: urlString) else {
                print("URL inválida")
                completion(nil)
                return
            }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error al realizar la solicitud: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                guard let data = data else {
                    print("Datos no disponibles")
                    completion(nil)
                    return
                }
                
            do {
                        // 1. Convierte los datos en un diccionario JSON.
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            
                            // 2. Accede directamente al campo "organic_results".
                            if let organicResultsData = jsonObject["organic_results"] as? [[String: Any]] {
                                
                                // 3. Convierte el contenido de "organic_results" nuevamente en datos JSON.
                                let organicResultsJSONData = try JSONSerialization.data(withJSONObject: organicResultsData, options: [])
                                
                                // 4. Decodifica "organic_results" como un array de AppInfo.
                                let decoder = JSONDecoder()
                                decoder.keyDecodingStrategy = .convertFromSnakeCase
                                let organicResults = try decoder.decode([AppInfo].self, from: organicResultsJSONData)
                                
                                // 5. Envía los resultados al completion handler.
                                completion(organicResults)
                                return
                            } else {
                                print("No se encontró la clave 'organic_results' o no tiene el formato esperado.")
                            }
                        } else {
                            print("El JSON no es un diccionario válido.")
                        }
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Clave no encontrada: \(key.stringValue) en \(context.codingPath)")
                    } catch let DecodingError.typeMismatch(type, context) {
                        print("Tipo no coincide: \(type) en \(context.codingPath)")
                    } catch {
                        print("Error al analizar JSON: \(error.localizedDescription)")
                    }
                    
                    // Si algo falla, retorna nil.
                    completion(nil)

            }.resume()
    }

}



