//
//  MeteorListViewController.swift
//  Fallen Meteors
//
//  Created by Naveen George Thoppan on 17/07/2021.
//

import UIKit

class MeteorListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private enum AlertType {
        case noMetoerDataAvailable
    }
    
    var viewModel: MeteorListViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            
            setupViewModel(with: viewModel)
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print(viewModel ?? "No View Model Injected")
    }
    
    private func setupViewModel(with viewModel: MeteorListViewModel) {
        // Configure View Model
        viewModel.didFetchMeteorData = { [weak self] (data, error) in
            if error != nil {
                self?.presentAlert(of: .noMetoerDataAvailable)
            } else if let data = data {
                print(data)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            } else {
                self?.presentAlert(of: .noMetoerDataAvailable)
            }
        }
    }
    
    private func presentAlert(of alertType: AlertType) {
        // Helpers
        let title: String
        let message: String

        switch alertType {
        case .noMetoerDataAvailable:
            title = "Unable to Fetch Meteor Data"
            message = "The application is unable to fetch meteor data. Please make sure your device is connected over Wi-Fi or cellular."
        }

        DispatchQueue.main.async {
            // Initialize Alert Controller
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

            // Add Cancel Action
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)

            // Present Alert Controller
            self.present(alertController, animated: true)
        }
      
    }
    
}

extension MeteorListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.meteorList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "meteorCell") {
            cell.textLabel?.text = viewModel?.meteorList[indexPath.row].name
            cell.detailTextLabel?.text = viewModel?.meteorList[indexPath.row].mass
            return cell
        }
        return UITableViewCell()
    }
}
