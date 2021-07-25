//
//  MeteorDetailViewController.swift
//  Fallen Meteors
//
//  Created by Naveen George Thoppan on 23/07/2021.
//

import UIKit
import MapKit

class MeteorDetailViewController: UIViewController {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var massLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var favouriteButton: UIButton!
    
    var viewModel : MeteorDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let meteor = viewModel?.meteor {
            locationLabel.text = meteor.name
            massLabel.text = "\(Int(meteor.mass ??  0.0))"
            classLabel.text = meteor.recclass
            let latitude = CLLocationDegrees(meteor.latitude ?? 0.0)
            let longitude =  CLLocationDegrees(meteor.longitude ?? 0.0)
            let locationCoordinate = CLLocationCoordinate2DMake(latitude, longitude)
            mapView.setCenter(locationCoordinate, animated: false)
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationCoordinate
            annotation.title = meteor.name
            annotation.subtitle = meteor.recclass
            mapView.addAnnotation(annotation)
        }
        favouriteButton.isSelected = viewModel?.checkFavouriteStatus() ?? false
    }
    
    @IBAction func favouriteAction(_ sender: Any) {
        if favouriteButton.isSelected {
            viewModel?.removeFavouriteMeteors()
        } else {
            viewModel?.saveToCoreData()
        }
        favouriteButton.isSelected.toggle()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
