//
//  Modelo.swift
//  Lector Noticias
//
//  Created by Dev1 on 11/12/2018.
//  Copyright © 2018 Dev1. All rights reserved.
//

import Foundation
import CoreData

struct RootJSON: Codable {
   let id: Int32
   let date: String
   let jetpack_feactured_media_url: URL?
   struct Title: Codable {
      let rendered: String
   }
   struct Content: Codable {
      let rendered: String
   }
   struct Authors: Codable {
      let id: Int16
      let name: String
      struct Avatar_urls: Codable {
         let avatar_urls: URL?
      }
   }
   struct Categories: Codable {
      let id: Int16
      let name: String
      // let link: String - ¿Lo necesito?
   }
   
}
var cargaDatos: [RootJSON] = []
var autores: [Authors] = []

//var persistentContainer:NSPersistentContainer = {
//   let container = NSPersistentContainer(name: "Comics")
//   container.loadPersistentStores { (storeDescripcion, error) in
//      if let error = error as NSError? {
//         fatalError("Error inicialización la base de datos")
//      }
//   }
//   return container
//}()
//
//var context:NSManagedObjectContext {
//   return persistentContainer.viewContext
//}
//
//func saveContext() {
//   if context.hasChanges {
//      do {
//         try context.save()
//      } catch {
//         print("Error en la grabación de la base de datos \(error)")
//      }
//   }
//}
//
//struct RootJSON:Codable {
//   let etag:String
//   struct Data:Codable {
//      let count:Int
//      struct Results:Codable {
//         let id:Int
//         let title:String
//         let issueNumber:Int
//         let variantDescription:String
//         let description:String?
//         struct Prices:Codable {
//            let type:String
//            let price:Double
//         }
//         let prices:[Prices]
//         struct Thumbnail:Codable {
//            let path:URL
//            let imageExtension:String
//            enum CodingKeys:String, CodingKey {
//               case path
//               case imageExtension = "extension"
//            }
//            var fullPath:URL? {
//               var pathComponents = URLComponents(url: path, resolvingAgainstBaseURL: false)
//               pathComponents?.scheme = "https"
//               return pathComponents?.url?.appendingPathComponent("portrait_incredible").appendingPathExtension(imageExtension)
//            }
//         }
//         let thumbnail:Thumbnail
//         struct Creators:Codable {
//            let items:[Items]
//            struct Items:Codable {
//               let name:String
//               let role:String?
//            }
//         }
//         let creators:Creators
//         let characters:Creators
//      }
//      let results:[Results]
//   }
//   let data:Data
//}
//
//var datosCarga:RootJSON?
//var etag:String?
//
//struct comicsCarga {
//   let id:Int32
//   let desc:String
//   let title:String
//   let imagenURL:URL?
//   let price:Double
//   let issueNumber:Int16
//}
//
//func cargar(datos:Data) {
//   let decoder = JSONDecoder()
//   do {
//      let carga = try decoder.decode(RootJSON.self, from: datos)
//      UserDefaults.standard.set(carga.etag, forKey: "etag")
//      etag = carga.etag
//
//      for dato in carga.data.results {
//         let cargaTemp = comicsCarga(id: Int32(dato.id), desc: dato.description ?? "No hay descripción", title: dato.title, imagenURL: dato.thumbnail.fullPath, price: dato.prices.first?.price ?? 0, issueNumber: Int16(dato.issueNumber))
//         var personajes:[Personajes] = []
//         for heroe in dato.characters.items {
//            if let existeHeroe = checkPersonaje(name: heroe.name) {
//               personajes.append(existeHeroe)
//            } else {
//               let newPersonaje = Personajes(context: context)
//               newPersonaje.nombre = heroe.name
//               personajes.append(newPersonaje)
//            }
//         }
//         var autores:[Autores] = []
//         for autor in dato.creators.items {
//            if let existeAutor = checkCreador(name: autor.name, role: autor.role ?? "None") {
//               autores.append(existeAutor)
//            } else {
//               let newAutor = Autores(context: context)
//               newAutor.autor = autor.name
//               newAutor.role = autor.role ?? "Ninguno"
//               autores.append(newAutor)
//            }
//         }
//         let consulta:NSFetchRequest<Comics> = Comics.fetchRequest()
//         consulta.predicate = NSPredicate(format: "id = %d", dato.id)
//         do {
//            let comic = try context.fetch(consulta)
//            if let comicFetched = comic.first {
//               comicFetched.desc = cargaTemp.desc
//               comicFetched.issueNumber = cargaTemp.issueNumber
//               comicFetched.imagenURL = cargaTemp.imagenURL
//               comicFetched.price = cargaTemp.price
//               comicFetched.title = cargaTemp.title
//               comicFetched.personajes = NSOrderedSet(array: personajes)
//               comicFetched.autores = NSOrderedSet(array: autores)
//            } else {
//               let newComic = Comics(context: context)
//               newComic.id = cargaTemp.id
//               newComic.desc = cargaTemp.desc
//               newComic.issueNumber = cargaTemp.issueNumber
//               newComic.imagenURL = cargaTemp.imagenURL
//               newComic.price = cargaTemp.price
//               newComic.title = cargaTemp.title
//               newComic.addToPersonajes(NSOrderedSet(array: personajes))
//               newComic.addToAutores(NSOrderedSet(array: autores))
//            }
//         } catch {
//            print("Error en la consulta del comic en el id \(dato.id) - \(error)")
//         }
//      }
//      saveContext()
//      print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
//
//      NotificationCenter.default.post(name: NSNotification.Name("OKCARGA"), object: nil)
//   } catch {
//      print("Fallo en la serialización \(error)")
//   }
//}
//
//func checkPersonaje(name:String) -> Personajes? {
//   let consulta:NSFetchRequest<Personajes> = Personajes.fetchRequest()
//   consulta.predicate = NSPredicate(format: "nombre ==[c] %@", name)
//   do {
//      let character = try context.fetch(consulta)
//      if let valor = character.first {
//         return valor
//      } else {
//         return nil
//      }
//   } catch {
//      print("Fallo en la consulta de personajes \(error)")
//   }
//   return nil
//}
//
//func checkCreador(name:String, role:String) -> Autores? {
//   let consulta:NSFetchRequest<Autores> = Autores.fetchRequest()
//   consulta.predicate = NSPredicate(format: "autor ==[c] %@ AND role ==[c] %@", name, role)
//   do {
//      let creador = try context.fetch(consulta)
//      if let valor = creador.first {
//         return valor
//      } else {
//         return nil
//      }
//   } catch {
//      print("Fallo en la consulta de autores \(error)")
//   }
//   return nil
//}
//
//func recuperaURL(url:URL, callback:@escaping (UIImage) -> Void) {
//   let conexion = URLSession.shared
//   conexion.dataTask(with: url) { (data, response, error) in
//      guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
//         if let error = error {
//            print("Error en la conexión de red \(error.localizedDescription)")
//         }
//         return
//      }
//      if response.statusCode == 200 {
//         if let imagen = UIImage(data: data) {
//            callback(imagen)
//         }
//      }
//      }.resume()
//}

// para poner, lo tiene puesto Julio.
// var datos: [Posts] = []
// var autores: [Authors] = []

// let url = URL(String: "https://applecoding.com/wp-json/wp/v2/posts")!
//recupera(url: url) { data in
//    let decoder = JSONDecoder()
//    decoder.dateDecodingStrategy = . formatted(DateFormatter.iso8601Full)
// do {
// datos = try decoder.
