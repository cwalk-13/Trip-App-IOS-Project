//
//  TripTableViewCell.swift
//  Pa7
//  This class creates the custom table view cell.
//  CPSC 315-01, Fall 2020
//  No sources to cite
//  Created by Walker, Charles Milton on 11/5/20.
//  Copyright © 2020 Walker, Charles Milton. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {
    let dateFormatter = DateFormatter()
    @IBOutlet var destLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var tripImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func update(with trip: Trip) {
        dateFormatter.dateFormat = "MM/dd/yyyy"
        destLabel.text = trip.destinationName
//        dateLabel.text = dateFormatter.string(from: trip.startDate) + " - " + dateFormatter.string(from: trip.endDate)
        if let startDate = trip.startDate as Date? {
            if let endDate = trip.endDate as Date? {
                dateLabel.text = "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
            }
        }

//        let imageFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(trip.imageFileName ?? "")
//
//        do {
//            tripImageView.image = UIImage(contentsOfFile: try String(contentsOf: imageFile))
//        }
//        catch {
//            print("Error \(error)")
//        }

        let imageFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(trip.imageFileName ?? "")
        

        tripImageView.image = UIImage(contentsOfFile: imageFile.path)
    }
}
