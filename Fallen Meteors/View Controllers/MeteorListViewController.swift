//
//  MeteorListViewController.swift
//  Fallen Meteors
//
//  Created by Naveen George Thoppan on 17/07/2021.
//

import UIKit
import MBProgressHUD


class MeteorListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favouriteSwitch: UISwitch!
    
    private enum AlertType {
        case noMetoerDataAvailable
        case noFavouritesAvailable
    }
    let refreshControl = UIRefreshControl()
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
        MBProgressHUD.showAdded(to: self.view, animated: true)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
           refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
           tableView.addSubview(refreshControl)
        print(viewModel ?? "No View Model Injected")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.fetchFavouriteMeteors()
        tableView.reloadData()
    }
    
    private func setupViewModel(with viewModel: MeteorListViewModel) {
        // Configure View Model
        viewModel.didFetchMeteorData = { [weak self] (data, error) in
            if error != nil {
                self?.presentAlert(of: .noMetoerDataAvailable)
            } else if let data = data {
                if data.count > 0 {
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: (self?.view)!, animated: true)
                        if ((self?.refreshControl.isRefreshing) != nil) {
                            self?.refreshControl.endRefreshing()
                        }
                        self?.tableView.reloadData()
                    }
                }
                
            } else {
                self?.presentAlert(of: .noMetoerDataAvailable)
            }
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        if favouriteSwitch.isOn {
            viewModel?.fetchFavouriteMeteors()
        } else {
            viewModel?.refreshData()
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
        case .noFavouritesAvailable:
            title = "No meteors favourited"
            message = ""
        }

        DispatchQueue.main.async {
            // Initialize Alert Controller
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

            // Add Cancel Action
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)

            // Present Alert Controller
            self.present(alertController, animated: true) { [self] in
                if self.favouriteSwitch.isOn {
                    favouriteSwitch.setOn(false, animated: true)
                }
            }
        }
      
    }
    
    @IBAction func sortAction(_ sender: Any) {
        let alert = UIAlertController(title: "Sort", message: "Please select an option to sort the meteors", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Date", style: .default , handler:{ (UIAlertAction)in
                print("User click date button")
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                }
                
                self.viewModel?.sortByDate(isFavourite: self.favouriteSwitch.isOn)
            }))
            
            alert.addAction(UIAlertAction(title: "Size", style: .default , handler:{ (UIAlertAction)in
                print("User click size button")
                MBProgressHUD.showAdded(to: self.view, animated: true)
                self.viewModel?.sortBySize(isFavourite: self.favouriteSwitch.isOn)
            }))

            alert.addAction(UIAlertAction(title: "Location", style: .default , handler:{ (UIAlertAction)in
                MBProgressHUD.showAdded(to: self.view, animated: true)
                self.viewModel?.sortByName(isFavourite: self.favouriteSwitch.isOn)
            }))
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
                print("User click Dismiss button")
            }))

            
            //uncomment for iPad Support
            //alert.popoverPresentationController?.sourceView = self.view

            self.present(alert, animated: true, completion: {
                print("completion block")
            })
    }
    @IBAction func reverseAction(_ sender: Any) {
        viewModel?.reverseList(isFavourite: self.favouriteSwitch.isOn)
    }
    @IBAction func favouritesSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            viewModel?.fetchFavouriteMeteors()
            if viewModel?.favouriteMeteors.count == 0 {
                presentAlert(of: .noFavouritesAvailable)
            }
        } else {
            viewModel?.refreshData()
        }
    }
}

extension MeteorListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favouriteSwitch.isOn {
            return viewModel?.favouriteMeteors.count ?? 0
        }
        return viewModel?.meteorList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 73
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MeteorCell") as? MeteorCell {
            let meteorData = favouriteSwitch.isOn ? viewModel?.favouriteMeteors[indexPath.row] : viewModel?.meteorList?[indexPath.row]
            cell.titleLabel?.text = meteorData?.name
            if let massValue =  meteorData?.mass, massValue >= 0 {
                
                cell.massLabel.text = "\(Int(massValue)) g"
            } else {
                cell.massLabel.text = "Not available"
            }
            if let year = meteorData?.year?.toString() {
                cell.yearLabel?.text = year
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = self.storyboard?.instantiateViewController(identifier: "MeteorDetailViewController") as? MeteorDetailViewController {
            if let detailsViewModel = viewModel?.detailViewModel(indexPath: indexPath, isFavourite: favouriteSwitch.isOn) {
                detailVC.viewModel = detailsViewModel
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return favouriteSwitch.isOn
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            viewModel?.removeFavouriteMeteors(indexPath: indexPath)
            viewModel?.favouriteMeteors.remove(at: indexPath.row)
            if self.favouriteSwitch.isOn {
                if viewModel?.favouriteMeteors.count == 0 {
                    viewModel?.refreshData()
                }
            }
            tableView.reloadData()
        }
    }
}
