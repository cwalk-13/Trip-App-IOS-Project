//
//  TripDetailViewController.swift
//  Pa7
//  This class is the view controller for displaying the details of the trip. 
//  CPSC 315-01, Fall 2020
//  No sources to cite
//  Created by Walker, Charles Milton on 11/5/20.
//  Copyright © 2020 Walker, Charles Milton. All rights reserved.
//

import UIKit

class TripDetailViewController: UIViewController {
    let dateFormatter = DateFormatter()
    var tripOptional: Trip? = nil
    var totalNumTrips: Int = 0
    var tripIndex: Int = 0
    
    @IBOutlet var tripNumLabel: UILabel!
    @IBOutlet var destLabel: UILabel!
    @IBOutlet var startDateLabel: UILabel!
    @IBOutlet var endDateLabel: UILabel!
    @IBOutlet var tripImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        displayTrip()
    }
//displays the name, dates ,and image of the trip
    func displayTrip() {
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if let trip = tripOptional, let destName = trip.destinationName, let startDate = trip.startDate, let endDate = trip.endDate {
            tripNumLabel.text = "Trip " + String(tripIndex) + " of " + String(totalNumTrips)
            destLabel.text = "Destination: " + destName

            if let startDate = startDate as Date? {
                startDateLabel.text = "Start Date: \(dateFormatter.string(from: startDate))"
            }
            if let endDate = endDate as Date? {
                endDateLabel.text = "End Date: \(dateFormatter.string(from: endDate))"
            }
//            tripImageView.image = UIImage(named: trip.imageFileName ?? "")
            let imageFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(trip.imageFileName ?? "")
            

            tripImageView.image = UIImage(contentsOfFile: imageFile.path)

        }
    }

}
