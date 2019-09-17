//
//  DetailViewController.swift
//  CoreDataEx
//
//  Created by hw on 26/08/2019.
//  Copyright © 2019 hwj. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
   
    @IBOutlet weak var tableView: UITableView!
    var managedObjectContext: NSManagedObjectContext? = nil
    weak var person: Person!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc
    func insertNewObject(_ sender: Any) {
        let context = self.fetchedResultsController.managedObjectContext //1.관리객체 컨텍스트를 불러온다.
        let newContact = ContactInfo(context: context)  //2. 컨텍스트를 통해 Core Data에서 만든 모델(클래스)를 Event 대신 넣어서 생성한다.
        person.addToContacts(newContact) // Master로부터 전달받은 사람에 연락처를 연결한다.
        
        ///이름 하드코딩 않고, alert 창을 통해서 이름을 입력받아보자.
        let alert = UIAlertController(title: "연락처 입력", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            newContact.type = alert.textFields?.first?.text
            newContact.contact = alert.textFields?.last?.text
            // Save the context.
            do {
                try context.save()  //3. 영구 저장소로 보내기 위해 저장을 시도한다.
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        alert.addTextField { (textField) in
            textField.placeholder = "연락처 유형을 입력해주세요"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "연락처 정보를 입력해주세요"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        let event = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withContact: event)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
            
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func configureCell(_ cell: UITableViewCell, withContact contact: ContactInfo) {
        cell.textLabel!.text = contact.contact
        cell.detailTextLabel?.text = contact.type
    }
    
    // MARK: - Fetched results controller
    var _fetchedResultsController: NSFetchedResultsController<ContactInfo>? = nil

    var fetchedResultsController: NSFetchedResultsController<ContactInfo> {  /// 모델객체의 fetchRequest를 핸들하는 컨트롤러
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<ContactInfo> = ContactInfo.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
//        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false) /// 정렬 선택 옵션이 없으면 지워도 무방
        
        fetchRequest.sortDescriptors = [] // fetchRequest.sortDescriptors 값은 빈 배열으로라도 초기화시켜줘야 함
        if let contacts = person?.contacts {
            fetchRequest.predicate = NSPredicate.init(format: "(self IN %@)", person.contacts!)
        }
        // predicate (== filter 역할 )를 사용
        // 해당 person의 연락처에 해당하는 것만 불러와 달라.
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
//        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        // predicate를 쓰기 위해 캐시를 비활성화한다.
         let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self       /// 응답을 받을 딜리게이트로 self(MasterVC)를 선택
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            configureCell(tableView.cellForRow(at: indexPath!)!, withContact: anObject as! ContactInfo)
        case .move:
            configureCell(tableView.cellForRow(at: indexPath!)!, withContact: anObject as! ContactInfo)
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
     // In the simplest, most efficient, case, reload the table view.
     tableView.reloadData()
     }
     */
//    @IBOutlet weak var detailDescriptionLabel: UILabel!
//
//
//    func configureView() {
//        // Update the user interface for the detail item.
//        if let detail = detailItem {
//            if let label = detailDescriptionLabel {
//                label.text = detail.name
//            }
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        configureView()
//    }
//
//    var detailItem: Person? {
//        didSet {
//            // Update the view.
//            configureView()
//        }
//    }


}

