//
//  Modelo.swift
//  Lector Noticias
//
//  Created by Dev1 on 11/12/2018.
//  Copyright © 2018 Dev1. All rights reserved.
//

import Foundation
import CoreData
import UIKit

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
    let date: String?
    let link: URL?
    struct Rendered: Codable {
        let rendered: String
    }
    let author: Int16
    let jetpack_featured_media_url: URL?
    let title: Rendered
    struct Content: Codable {
        let rendered: String
    }
    struct Excerpt: Codable {
        let rendered: String
    }
    let content: Rendered
    let excerpt: Rendered
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
var author: [RootAuthorsJSON] = []

struct RootCategoriesJSON: Codable {
    let id: Int16
    let name: String
}
var categories: [RootCategoriesJSON] = []

struct rssCarga {
    let id: Int16
    let titulo: String?
    let contenido: String
    let date: String
    let imagenURL: URL?
    let autor: Int16
}

func cargar(datos:Data) {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
    do {
        let posts = try decoder.decode([RootPostsJSON].self, from: datos)
        
        for datos in posts {
            let cargaTemp = rssCarga(id: Int16(datos.id), titulo: datos.title.rendered, contenido: datos.excerpt.rendered, date: datos.date ?? "No se recogen datos", imagenURL: datos.jetpack_featured_media_url, autor: datos.author)
            //         let cargaTemp = rssCarga (id: Int16(datos.id), titulo: datos.title.rendered, contenido: datos.content.rendered, date: datos.date ?? "No se recogen datos")
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
                    rssFetched.imagenURL = cargaTemp.imagenURL
                    rssFetched.autor = cargaTemp.autor
                } else {
                    let newRSS = Posts(context: context)
                    newRSS.id = cargaTemp.id
                    newRSS.titulo = cargaTemp.titulo
                    newRSS.contenido = cargaTemp.contenido
                    newRSS.date = cargaTemp.date
                    newRSS.imagenURL = cargaTemp.imagenURL
                    newRSS.autor = cargaTemp.autor
                    //               newComic.addToPersonajes(NSOrderedSet(array: personajes))
                    //               newComic.addToAutores(NSOrderedSet(array: autores))
                }
            } catch {
                print("Error en la consulta del RSS en el id \(datos.id) - \(error)")
            }
        }
        saveContext()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
        
        NotificationCenter.default.post(name: NSNotification.Name("CARGA_OK"), object: nil)
    } catch {
        print("Fallo en la serialización \(error)")
    }
}

var persistentContainer:NSPersistentContainer = {
    let container = NSPersistentContainer(name: "DDBB")
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

func recuperaImagenURL(url:URL, callback:@escaping (UIImage) -> Void) {
    let conexion = URLSession.shared
    conexion.dataTask(with: url) { (data, response, error) in
        guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
            if let error = error {
                print("Error en la conexión de red \(error.localizedDescription)")
            }
            return
        }
        if response.statusCode == 200 {
            if let imagen = UIImage(data: data) {
                callback(imagen)
            }
        }
        }.resume()
}
