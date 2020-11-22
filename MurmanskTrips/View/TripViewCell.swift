//
//  TripViewCell.swift
//  MurmanskTrips
//
//  Created by Maxim Kuznetsov on 22.11.2020.
//

import UIKit

class TripViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var tripTypeBadge: UIView!
    
    func configure(with trip: Trip) {
        createShadow()
        tripTypeBadge.layer.cornerRadius = 6
        cityLabel.text = trip.city.title
        titleLabel.text = trip.title
        ratingLabel.text = "\(trip.rating)"
        durationLabel.text = trip.duration
        
        guard let imageUrl = trip.images.first else { return }
        TravelAPI.downloadImage(from: imageUrl) { [weak self] image, error in
            DispatchQueue.main.async {
                self?.photoImageView.image = image
            }
        }
    }
    
    private func createShadow() {
        contentView.layer.cornerRadius = 6
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
}
