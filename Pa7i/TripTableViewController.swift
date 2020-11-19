//
//  TripTableViewController.swift
//  Pa7
//  This program runs an app where the user can add trips to a list, all with destination names, start date, end date. The user can also add an image from a photo library or from camera to each trip. The trips are saved to a database and are retrieved when the app is loaded again. 
//  CPSC 315-01, Fall 2020
//  No sources to cite
//  Created by Walker, Charles Milton on 11/5/20.
//  Copyright © 2020 Walker, Charles Milton. All rights reserved.
//

import UIKit
import CoreData

class TripTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let dateFormatter = DateFormatter()
    var trips = [Trip]()
    
    
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print(documentsDirectoryURL)
        loadTrips()

    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return trips.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let trip = trips[row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath) as! TripTableViewCell
        
        cell.update(with: trip)
        
        cell.showsReorderControl = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let trip = trips.remove(at: sourceIndexPath.row)
        trips.insert(trip, at: destinationIndexPath.row)
        
        tableView.reloadData()
    }
    
    // MARK: Lab #20
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            trips.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            context.delete(trips[indexPath.row])
            
            // persist the deletion by saving the context
            saveTrips()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "DetailSegue" {
                if let tripDetailVC = segue.destination as? TripDetailViewController {
                    // we need to get the indexPath for the row the user clicked on
                    // we need to get the trip at the row
                    // pass the trip into detailDetailVC
                    if let indexPath = tableView.indexPathForSelectedRow {
                        let trip = trips[indexPath.row]
                        tripDetailVC.totalNumTrips = trips.count
                        tripDetailVC.tripIndex = indexPath.row + 1
                        tripDetailVC.tripOptional = trip
                    }
                }
            }
            else if identifier == "AddSegue" {
                if let addTriplVC = segue.destination as? AddTripViewController {
                    if let indexPath = tableView.indexPathForSelectedRow {
                        tableView.deselectRow(at: indexPath, animated: true)
                        addTriplVC.tripNum = trips.count + 1
                    }
                }
            }
        }
    }
    
    @IBAction func unwindToTripTableViewController(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            if identifier == "SaveUnwindSegue" {
                if let addTripVC = segue.source as? AddTripViewController {
                    if let trip = addTripVC.tripOptional {
                        // get the currently selected index path
                        if let indexPath = tableView.indexPathForSelectedRow {
                            trips[indexPath.row] = trip
                        }
                        else {
                            // we are undwinding from an AddSegue
                            
                            trips.append(trip)
                        }
                        // force update the table view
                        self.saveTrips()
                        tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
           let newEditingMode = !tableView.isEditing
           tableView.setEditing(newEditingMode, animated: true)
       }
    
    // READ of CRUD
    func loadTrips() {
        // we need to make a "request" to get the Category objects
        // via the persistent container
        let request: NSFetchRequest<Trip> = Trip.fetchRequest()
        // with a sql SELECT statement we usually specify a WHERE clause if we want to filter rows from the table we are selecting from
        // if we want to filter, we need to add a "predicate" to our request... we will do this later for Items
        do {
            trips = try context.fetch(request)
        }
        catch {
            print("Error loading categories \(error)")
        }
        tableView.reloadData()
    }
    
    func saveTrips() {
        // we want to save the context "to disk" (db)
        do {
            try context.save() // like git commit
        }
        catch {
            print("Error saving trips \(error)")
        }
    }
    
}

