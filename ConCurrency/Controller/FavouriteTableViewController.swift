//
//  FavouriteTableViewController.swift
//  ConCurrency
//
//  Created by Nafea Elkassas on 25/08/2023.
//

import UIKit
public var favArr : [String] = []
class FavouriteTableViewController: UIViewController {
       //MARK: - Properties
    var dataSourceArray : GetCurrencyConversions = []
    var apiManager = APIManager()
    


   //MARK: - Outlets
    @IBOutlet weak var favouritesTableView: UITableView!
    
       //MARK: - LifeCycleMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        favArr = []
        favouritesTableView.register((UINib(nibName: "FavouritesTableViewCell", bundle: nil)), forCellReuseIdentifier: "FavouriteCellIdentifier")
        favouritesTableView.delegate = self
        favouritesTableView.dataSource = self
        apiManager.getCurrencyConversionsData(callback: { [weak self] list in
            self?.dataSourceArray = list ?? []
            self?.favouritesTableView.reloadData()
        })
        
//        concurrencyArr = dataSourceArray.map({$0.code})
//        for flagUrl in dataSourceArray.map({$0.flagURL}) {
//            flagsArr.append((UIImage(named: flagUrl ) ?? UIImage.actions))
//        }

    }

   //MARK: - Actions
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        goBack()
    }
    
       //MARK: - Private Functions
    private func goBack(){
        if let presentingVC = presentingViewController {
                presentingVC.dismiss(animated: true, completion: nil)
            } else {
                let concurrencyVC = ConcurrencyViewController(nibName: "ConcurrencyViewController", bundle: nil)
                navigationController?.pushViewController(concurrencyVC, animated: true)
            }
    }
    


    
}
extension FavouriteTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteCellIdentifier", for: indexPath) as! FavouritesTableViewCell
        let rowData = dataSourceArray[indexPath.row]
        let flagData = URL(string: rowData.flagURL)
        cell.flagImageView.sd_setImage(with: flagData)
        cell.concurrencyCodeLabel.text = rowData.code
        cell.currencyRateLabel.isHidden = true
       
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0// Set the desired height for the cells
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? FavouritesTableViewCell else {
            return
        }
        
        cell.isChecked = !cell.isChecked
        
        // Update the checkmark image based on the isChecked state
        let checkmarkImage = cell.isChecked ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
        
        if cell.isChecked && !favArr.contains(cell.concurrencyCodeLabel.text!){
            // Append the cell's text to the array if it's checked
            favArr.append(cell.concurrencyCodeLabel.text!)
        } else  {
            // Remove the cell's text from the array if it's unchecked
            if let index = favArr.firstIndex(of: cell.concurrencyCodeLabel.text!) {
                favArr.remove(at: index)
            }
        }
        
        cell.checkMarkImageView.image = checkmarkImage
    }
}
