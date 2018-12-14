//
//  Modelo.swift
//  Lector Noticias
//
//  Created by Dev1 on 11/12/2018.
//  Copyright © 2018 Dev1. All rights reserved.
//

import Foundation
import CoreData

var context:NSManagedObjectContext {
   return persistentContainer.viewContext
}

func saveContext() {
   if context.hasChanges {
      do {
         try context.save()
      } catch {
         print("Error en la grabación de la base de datos \(error)")
      }
   }
}

struct RootPostsJSON: Codable {
   let id: Int16
   let date: String? // tipo Date. Lo dejo string para que no pete.
   let link: URL?
   struct Rendered: Codable {
      let rendered: String
   }
   
   let titulo: Rendered
   
   struct Content: Codable {
      let rendered: String
   }
   let contenido: Rendered
}
var posts: [RootPostsJSON] = []

struct RootAuthorsJSON: Codable {
    let id: Int16
    let name: String
    struct Avatar_urls: Codable {
        let avatar_urls: URL?
    }
   let avatar: Avatar_urls
}
var author: [RootPostsJSON] = []

struct RootCategoriesJSON: Codable {
    let id: Int16
    let name: String
    // let link: String - ¿Lo necesito?
}
var categories: [RootCategoriesJSON] = []

struct rssCarga {
   let id: Int16
   let titulo: String
   let contenido: String
   let date: String
}

func cargar(datos:Data) {
   let decoder = JSONDecoder()
   do {
      let carga = try decoder.decode(RootPostsJSON.self, from: datos)
      
      for datos in posts {
         let cargaTemp = rssCarga (id: Int16(datos.id), titulo: datos.titulo.rendered, contenido: datos.contenido.rendered, date: datos.date ?? "No se recogen datos")
//         var postsDDBB:[Posts] = []
//         for post in dato.titulo.rendered {
//            if let existeTitulo =
//         }
         
//         var autores:[Authors] = []
//         for autor in dato.creators.items {
//            if let existeAutor = checkCreador(name: autor.name, role: autor.role ?? "None") {
//               autores.append(existeAutor)
//            } else {
//               let newAutor = Autores(context: context)
//               newAutor.autor = autor.name
//               newAutor.role = autor.role ?? "Ninguno"
//               autores.append(newAutor)
//            }
         
         let consulta: NSFetchRequest<Posts> = Posts.fetchRequest()
         consulta.predicate = NSPredicate (format: "id = %d", cargaTemp.id)
         do {
            let filaRSS = try context.fetch(consulta)
            if let rssFetched = filaRSS.first {
               rssFetched.id = cargaTemp.id
               rssFetched.titulo = cargaTemp.titulo
               rssFetched.contenido = cargaTemp.contenido
               rssFetched.date = cargaTemp.date
            } else {
               let newRSS = Posts(context: context)
               newRSS.id = cargaTemp.id
               newRSS.titulo = cargaTemp.titulo
               newRSS.contenido = cargaTemp.contenido
               newRSS.date = cargaTemp.date
//               newComic.addToPersonajes(NSOrderedSet(array: personajes))
//               newComic.addToAutores(NSOrderedSet(array: autores))
            }
         } catch {
            print("Error en la consulta del comic en el id \(datos.id) - \(error)")
         }
      }
      saveContext()
      print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
      
      NotificationCenter.default.post(name: NSNotification.Name("OKCARGA"), object: nil)
   } catch {
      print("Fallo en la serialización \(error)")
   }
}


var persistentContainer:NSPersistentContainer = {
   let container = NSPersistentContainer(name: "Comics")
   container.loadPersistentStores { (storeDescripcion, error) in
      if let error = error as NSError? {
         fatalError("Error inicialización la base de datos")
      }
   }
   return container
}()

func recuperaURL(url:URL, callback:@escaping (Data) -> Void) {
   let conexion = URLSession.shared
   conexion.dataTask(with: url) { (data, response, error) in
      guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
         if let error = error {
            print("Error en la conexión de red \(error.localizedDescription)")
         }
         return
      }
         if response.statusCode == 200 {
               callback(data)
         } else {
            print ("error de llamada \(response.statusCode)")
         }
      }.resume()
}


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

// para poner, lo tiene puesto Julio.
// var datos: [Posts] = []
// var autores: [Authors] = []

// let url = URL(String: "https://applecoding.com/wp-json/wp/v2/posts")!
//recupera(url: url) { data in
//    let decoder = JSONDecoder()
//    decoder.dateDecodingStrategy = . formatted(DateFormatter.iso8601Full)
// do {
// datos = try decoder.
