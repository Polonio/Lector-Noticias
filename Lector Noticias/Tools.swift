//
//  Tools.swift
//  Lector Noticias
//
//  Created by Dev1 on 11/12/2018.
//  Copyright © 2018 Dev1. All rights reserved.
//

import Foundation

let inicioURL = URL(string: "https://applecoding.com/wp-json/wp/v2")!


func conectarRSS(valorDato: String) {
   let queryPost = URLQueryItem (name: "p", value: "posts")
//   let queryCategorias = URLQueryItem (name: "cat", value: "categories")
//   let queryAutores = URLQueryItem (name: "author", value: "users")

   // Switch case: ??????
   
   var url = URLComponents()
   url.scheme = inicioURL.scheme
   url.host = inicioURL.host
   url.path = inicioURL.path
   url.queryItems = [queryPost]
   
   let session = URLSession.shared
   var request = URLRequest(url: url.url!.appendingPathComponent(valorDato))
   request.httpMethod = "GET"
   request.addValue("*/*", forHTTPHeaderField: "Accept")
   session.dataTask(with: request) { (data, response, error) in
      guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
         if let error = error {
            print("Error en la comunicación \(error)")
         }
         return
      }
      if response.statusCode == 200 {
//         print(String(data: data, encoding: .utf8)!)
         cargar(datos: data)
      } else {
         print(response.statusCode)
      }
   }.resume()
}

// OBTENER FECHA DE PUBLICACIÓN
//func getDateTime() -> String {
//   let fecha = Date()
//   let formatter = DateFormatter()
//   formatter.dateFormat = "ddMMyyyyhhmmss"
//   return formatter.string(from: fecha)
//}
