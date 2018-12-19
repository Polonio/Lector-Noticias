//
//  TableViewControllerRSS.swift
//  Lector Noticias
//
//  Created by Dev1 on 14/12/2018.
//  Copyright © 2018 Dev1. All rights reserved.
//

import UIKit
import CoreData
import WebKit

class TableViewControllerRSS: UITableViewController {

   var predicate: NSPredicate?
   var sortedResult: [NSSortDescriptor] = []
   
   lazy var postsResult:NSFetchedResultsController<Posts> = {
      let fetchPosts:NSFetchRequest<Posts> = Posts.fetchRequest()
      var orden = [NSSortDescriptor(key: #keyPath(Posts.id), ascending: true)]
      orden.append(contentsOf: sortedResult)
      fetchPosts.sortDescriptors = orden
      fetchPosts.fetchBatchSize = 30
      return NSFetchedResultsController(fetchRequest: fetchPosts, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
   }()
   
   lazy var refresh:UIRefreshControl = {
      let refresh = UIRefreshControl()
      refresh.addTarget(self, action: #selector(self.recargarDatos), for: UIControl.Event.valueChanged)
      refresh.tintColor = .gray
      return refresh
   }()
   
   var refresco = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
      
      conectarRSS(valorDato: "posts")
      refreshControl = refresh
      NotificationCenter.default.addObserver(forName: NSNotification.Name("CARGA_OK"), object: nil, queue: OperationQueue.main) {
         _ in
         self.reloadTableData()
         if self.refresco {
            self.refresco = false
            self.refresh.endRefreshing()
         }
      }
      
      // Pasar datos para mostrar una vez presionemos en la noticia seleccionada de la celda.
      let web = WKWebView(frame: view.frame)
      let contenidoWeb = recargarDatos()
      //web.loadHTMLString(contenidoWeb, baseURL: nil)
      view.addSubview(web)

   }

    // MARK: - Table view data source
   func reloadTableData() {
      do {
         try postsResult.performFetch()
      } catch {
         print("Error en la consulta")
      }
      tableView.reloadData()
   }
   
   @objc func recargarDatos() {
      refresco = true
      conectarRSS(valorDato: "posts")
   }
   
    override func numberOfSections(in tableView: UITableView) -> Int {
        return postsResult.sections?.count ?? 0
    }

   override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
      let action = UIContextualAction(style: .normal, title: title, handler: { (action, view, completionHandler) in
                                                                     completionHandler (true)
      })
      action.image = UIImage(named: "heart")
      action.backgroundColor = .green
      let configuracion = UISwipeActionsConfiguration(actions: [action])
      return configuracion
   }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsResult.sections?.first?.numberOfObjects ?? 0
    }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! TableViewCell
      
         let datosRSS = postsResult.object(at: indexPath)
         cell.tituloRSS.text = datosRSS.titulo
         cell.textoRSS.text = datosRSS.contenido
         cell.fechaRSS.text = datosRSS.date
         cell.autorRSS.text = datosRSS.autores?.name
      //let autorDevulve = URL(string: "")
      
      if let imgURL = datosRSS.imagenURL {
         recuperaImagenURL(url: imgURL) {
            imagen in
            DispatchQueue.main.async {
               if let resize = imagen.resizeImage(newWidth: cell.imagenRSS.bounds.size.width) {
                  if tableView.visibleCells.contains(cell) {
                     cell.imagenRSS.image = resize
                     saveContext()
                  }
                  datosRSS.imagen = resize.pngData()
                  saveContext()
               }
            }
         }
      }
      
      return cell
   }

}
