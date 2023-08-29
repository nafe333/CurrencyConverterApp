//
//  ConcurrencyViewController.swift
//  ConCurrency
//
//  Created by Nafea Elkassas on 23/08/2023.
//

import UIKit
import DropDown
import SDWebImage
import Alamofire

let manager = APIManager()

class ConcurrencyViewController: UIViewController {
    
    //MARK: - Properties
    let code: [String] = []
    var apiManager = APIManager()
    let convertFromdropdown = DropDown()
    let convertTodropDown = DropDown()
    let compareFromdropDown = DropDown()
    let firstTargetdropDown = DropDown()
    let secondTargetdropDown = DropDown()
    
    //    let codesArr = code
    var dataSourceArray : GetCurrencyConversions = []
    
    let tableViewFlagsArr = [UIImage(named: "egypt"), UIImage(named: "usa"), UIImage(named: "eur")]
    let concurrencyArr = ["EGP", "USD", "EUR"]
    let concurrencyRateArr = ["3.1", "5.5", "8.9"]
    
    //MARK: - Outlets
    // Convert View
    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var favouritesTableView: UITableView!
    @IBOutlet weak var convertView: UIView!
    @IBOutlet weak var compareView: UIView!
    @IBOutlet weak var fromViewDropDown: UIView!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toViewDropDown: UIView!
    @IBOutlet weak var toDropdownLabel: UILabel!
    @IBOutlet weak var convertFromImageView: UIImageView!
    @IBOutlet weak var convertToImageView: UIImageView!
    @IBOutlet weak var convertToDownArrow: UIImageView!
    @IBOutlet weak var convertFromDownArrow: UIImageView!
    @IBOutlet weak var convertToAmountView: UIView!
    @IBOutlet weak var convertToAmountViewLable: UILabel!
    @IBOutlet weak var convertAmountTextField: UITextField!
    @IBOutlet weak var convertCompareSegmentedController: UISegmentedControl!
    
    // Compare View
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var compareFromDropdownView: UIView!
    @IBOutlet weak var compareFromDropdownLabel: UILabel!
    @IBOutlet weak var firstTargetDropdownView: UIView!
    @IBOutlet weak var firstTargetDropdownLabel: UILabel!
    @IBOutlet weak var secondTargetDropdownView: UIView!
    @IBOutlet weak var seconTargetDropdownLabel: UILabel!
    @IBOutlet weak var compareButton: UIButton!
    @IBOutlet weak var fromFlagImageView: UIImageView!
    @IBOutlet weak var firstTargetImageView: UIImageView!
    @IBOutlet weak var secondTargetImageView: UIImageView!
    @IBOutlet weak var compareFromDownArrow: UIImageView!
    @IBOutlet weak var secondTargetDownArrow: UIImageView!
    @IBOutlet weak var firstTargetDownArrow: UIImageView!
    @IBOutlet weak var compareFromButton: UIButton!
    @IBOutlet weak var secondResultView: UIView!
    @IBOutlet weak var firstResultView: UIView!
    @IBOutlet weak var firstResultLabel: UILabel!
    @IBOutlet weak var ssecondResultLabel: UILabel!
    
    
    var selectedFavList: GetCurrencyConversions = []
    var selectedFavRateList: GetLiveExchangeRates = []
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Networking
        apiManager.getCurrencyConversionsData(callback: { [weak self] list in
            self?.dataSourceArray = list ?? []
            self?.selectedFavList = list?.filter({favArr.contains($0.code)}) ?? []
            self?.favouritesTableView.reloadData()
        })
        
        navigationController?.navigationBar.isHidden = true
        compareView.isHidden = true
        setCompareComponentsShape()
        setConvertComponentsShape()
        favouritesTableView.delegate = self
        favouritesTableView.dataSource = self
        favouritesTableView.register(UINib(nibName: "FavouritesTableViewCell", bundle: nil), forCellReuseIdentifier: "FavouriteCellIdentifier")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                apiManager.getLiveExchangeRatesData(from: "EGP", toParameter: favArr) { [weak self] rateList in
                    guard let self = self else { return}
                    DispatchQueue.main.async {
                        self.selectedFavList = self.dataSourceArray.filter({favArr.contains($0.code)}) ?? []
                        self.selectedFavRateList = rateList.filter({favArr.contains($0.to)}) ?? []
                        self.favouritesTableView.reloadData()
                    }
        }
    }
    
    
    //MARK: - Actions
    @IBAction func compareConvertSegmentedController(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        
        switch selectedIndex {
        case 0:
            convertView.isHidden = false
            compareView.isHidden = true
        case 1:
            convertView.isHidden = true
            compareView.isHidden = false
        default:
            break
        }
    }
    
    @IBAction func fromTextLabelTapped(_ sender: UIButton) {
        setconvertFromDropdown()
        convertFromdropdown.show()
        convertTodropDown.hide()
        convertFromDownArrow.image = UIImage(systemName: "chevron.up")
    }
    
    @IBAction func toDropDownTapped(_ sender: UIButton) {
        setConvertToDropdown()
        convertTodropDown.show()
        convertFromdropdown.hide()
        convertToDownArrow.image = UIImage(systemName: "chevron.up")
    }
    
    @IBAction func compareFromDropDownTapped(_ sender: UIButton) {
        setcompareFromDropdown()
        compareFromdropDown.width = 158
        convertTodropDown.hide()
        convertFromdropdown.hide()
        compareFromdropDown.show()
        compareFromDownArrow.image = UIImage(systemName: "chevron.up")
    }
    
    
    @IBAction func firstTargetDropDownTapped(_ sender: UIButton) {
        setCompareFirstTarget()
        firstTargetdropDown.width = 158
        compareFromdropDown.hide()
        firstTargetdropDown.show()
        secondTargetdropDown.hide()
        firstTargetDownArrow.image = UIImage(systemName: "chevron.up")
    }
    
    @IBAction func secondTargetDropDownTapped(_ sender: UIButton) {
        setCompareSecondTarget()
        secondTargetdropDown.width = 158
        compareFromdropDown.hide()
        firstTargetdropDown.hide()
        secondTargetdropDown.show()
        secondTargetDownArrow.image = UIImage(systemName: "chevron.up")
    }
    
    
    @IBAction func addToFavouritesButtonTapped(_ sender: UIButton) {
        let favouritesVC = FavouriteTableViewController(nibName: "FavouriteTableViewController", bundle: nil)
        favouritesVC.modalPresentationStyle = .fullScreen
        present(favouritesVC, animated: true, completion: nil)
    }
    
    @IBAction func convertButtonTapped(_ sender: UIButton) {
        let url = "http://ec2-3-144-40-233.us-east-2.compute.amazonaws.com:8000/api/currency-conversions/convert?from=\(self.fromLabel.text!)&to=\(self.toDropdownLabel.text!)&amount=\(convertAmountTextField.text!)"
        let parameters: Parameters = ["from": [self.fromLabel.text!], "to": [self.toDropdownLabel.text!], "amount": [convertAmountTextField.text!]]
        
        apiManager.getConvertCurrencyData(url: url, parameters: parameters) { convertedValue in
            if let convertedValue = convertedValue {
                DispatchQueue.main.async {
                    self.convertToAmountViewLable.text = convertedValue
                }
            }
        }
    }
    
    
    @IBAction func compareButtonTapped(_ sender: UIButton) {
        let url = "http://ec2-3-144-40-233.us-east-2.compute.amazonaws.com:8000/api/currency-conversions/compare?from=\(self.compareFromDropdownLabel.text!)&to=\(firstTargetDropdownLabel.text!),\(seconTargetDropdownLabel.text!)&amount=\(amountTextField.text!)"
        let parameters: Parameters = ["from": [self.compareFromDropdownLabel.text!], "to": [firstTargetDropdownLabel.text!, seconTargetDropdownLabel.text!], "amount": [amountTextField.text!]]
        
        apiManager.getCompareCurrenciesData(url: url, parameters: parameters) { firstValue, secondValue in
            if let firstValue = firstValue, let secondValue = secondValue {
                DispatchQueue.main.async {
                    // Use the values as needed, e.g., set label text
                    self.firstResultLabel.text = firstValue
                    self.ssecondResultLabel.text = secondValue
                }
            } else {
                // Handle the case where something went wrong
            }
        }
        
    }
    
    //MARK: - Private Functions
    
    // related to convert view
    //    private func setconvertFromDropdown() {
    //
    //        setDropDownPerformance(dropdown: convertFromdropdown, dropdownView: fromViewDropDown)
    //        convertFromdropdown.selectionAction = { [unowned self] (index: Int, item: String) in
    //            self.fromLabel.text = dataSourceArray[index].code
    //
    //            let flagURLString = self.dataSourceArray[index].flagURL
    //            if let flagURL = URL(string: flagURLString) {
    //                self.convertFromImageView.sd_setImage(with: flagURL, completed: nil)
    //            }
    //
    //            self.convertFromDownArrow.image = UIImage(systemName: "chevron.down")
    //
    //
    //        }
    //        fetchCurrencyInfo(from: self.fromLabel.text ?? "")
    //    }
    private func setconvertFromDropdown() {
        setDropDownPerformance(dropdown: convertFromdropdown, dropdownView: fromViewDropDown)
        convertFromdropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.fromLabel.text = dataSourceArray[index].code
            
            let flagURLString = self.dataSourceArray[index].flagURL
            if let flagURL = URL(string: flagURLString) {
                self.convertFromImageView.sd_setImage(with: flagURL, completed: nil)
            }
            
            self.convertFromDownArrow.image = UIImage(systemName: "chevron.down")
            
            // Move the fetchCurrencyInfo call here, after setting fromLabel.text
            fetchCurrencyInfo(from: self.fromLabel.text ?? "")
        }
    }
    
    
    func fetchCurrencyInfo(from currency: String) {
        apiManager.getLiveExchangeRatesData(from: currency, toParameter: favArr) { [weak self] rateList in
            guard let self = self else { return}
            DispatchQueue.main.async {
                self.selectedFavList = self.dataSourceArray.filter({favArr.contains($0.code)}) ?? []
                self.selectedFavRateList = rateList.filter({favArr.contains($0.to)}) ?? []
                self.favouritesTableView.reloadData()
            }
           
        }
    }
   
    
    private func setConvertToDropdown() {
        setDropDownPerformance(dropdown: convertTodropDown, dropdownView: toViewDropDown)
        convertTodropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.toDropdownLabel.text = dataSourceArray[index].code
            
            let flagURLString = self.dataSourceArray[index].flagURL
            if let flagURL = URL(string: flagURLString) {
                self.convertToImageView.sd_setImage(with: flagURL, completed: nil)
            }
            
            self.convertToDownArrow.image = UIImage(systemName: "chevron.down")
        }
    }
    
    // related to compare view
    
    private func setcompareFromDropdown() {
        setDropDownPerformance(dropdown: compareFromdropDown, dropdownView: compareFromDropdownView)
        compareFromdropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.compareFromDropdownLabel.text = dataSourceArray[index].code
            
            let flagURLString = self.dataSourceArray[index].flagURL
            if let flagURL = URL(string: flagURLString) {
                self.fromFlagImageView.sd_setImage(with: flagURL, completed: nil)
            }
            
            self.compareFromDownArrow.image = UIImage(systemName: "chevron.down")
        }
    }
    private func setCompareFirstTarget() {
        setDropDownPerformance(dropdown: firstTargetdropDown, dropdownView: firstTargetDropdownView)
        firstTargetdropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.firstTargetDropdownLabel.text = dataSourceArray[index].code
            
            let flagURLString = self.dataSourceArray[index].flagURL
            if let flagURL = URL(string: flagURLString) {
                self.firstTargetImageView.sd_setImage(with: flagURL, completed: nil)
            }
            
            self.firstTargetDownArrow.image = UIImage(systemName: "chevron.down")
        }
    }
    
    private func setCompareSecondTarget() {
        setDropDownPerformance(dropdown: secondTargetdropDown, dropdownView: secondTargetDropdownView)
        secondTargetdropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.seconTargetDropdownLabel.text = dataSourceArray[index].code
            
            let flagURLString = self.dataSourceArray[index].flagURL
            if let flagURL = URL(string: flagURLString) {
                self.secondTargetImageView.sd_setImage(with: flagURL, completed: nil)
            }
            
            self.secondTargetDownArrow.image = UIImage(systemName: "chevron.down")
        }
    }
    
    private func setDropDownPerformance(dropdown: DropDown, dropdownView: UIView){
        dropdown.anchorView = dropdownView
        dropdown.bottomOffset = CGPoint(x: 0, y:(dropdown.anchorView?.plainView.bounds.height)!)
        dropdown.direction = .bottom
        dropdown.dataSource = dataSourceArray.map({$0.code})
        dropdown.cellNib = (UINib(nibName:"FlagCell" , bundle: nil))
        dropdown.width = 186
        dropdown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? FlagCell else { return }
            cell.optionLabel.text = self.dataSourceArray[index].code
            let flagURLString = self.dataSourceArray[index].flagURL
            if let flagURL = URL(string: flagURLString) {
                cell.flagImageView.sd_setImage(with: flagURL, completed: nil)
            }
        }
    }
}

//MARK: - Table View Methods
extension ConcurrencyViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectedFavList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favouritesTableView.dequeueReusableCell(withIdentifier: "FavouriteCellIdentifier") as! FavouritesTableViewCell
        let rowIndex = indexPath.row

        cell.flagImageView.sd_setImage(with: URL.init(string: selectedFavList[rowIndex].flagURL)!)
        cell.concurrencyCodeLabel.text = selectedFavList[rowIndex].code
        cell.currencyRateLabel.text = selectedFavRateList[rowIndex].rate.description
        cell.checkMarkImageView.isHidden = true
        return cell
    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = favouritesTableView.dequeueReusableCell(withIdentifier: "FavouriteCellIdentifier") as! FavouritesTableViewCell
//        let rowIndex = indexPath.row
//
//        // Make sure selectedFavRateList is populated correctly
//        cell.flagImageView.image = tableViewFlagsArr[rowIndex]
//        cell.concurrencyCodeLabel.text = concurrencyArr[rowIndex]
//            cell.currencyRateLabel.text = concurrencyRateArr[rowIndex]
//            cell.checkMarkImageView.isHidden = true
//
//
//        return cell
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = favouritesTableView.dequeueReusableCell(withIdentifier: "FavouriteCellIdentifier", for: indexPath) as! FavouritesTableViewCell
//        let rowIndex = indexPath.row
//
//        // Make sure the arrays have data and the index is within bounds
//        if rowIndex < selectedFavList.count && rowIndex < selectedFavRateList.count {
//            // Populate the cell using the arrays
//            let selectedFavListItem = selectedFavList[rowIndex]
//            let selectedFavRateListItem = selectedFavRateList[rowIndex]
//
//            cell.flagImageView.sd_setImage(with: URL(string: selectedFavListItem.flagURL))
//            cell.concurrencyCodeLabel.text = selectedFavListItem.code
//            cell.currencyRateLabel.text = selectedFavRateListItem.rate.description
//            cell.checkMarkImageView.isHidden = true
//        }
//
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

//MARK: - Shape Settings
extension ConcurrencyViewController {
    private func setCompareComponentsShape(){
        amountTextField.layer.cornerRadius = 15
        amountTextField.layer.borderColor = .init(gray: .leastNormalMagnitude, alpha: 0.1)
        amountTextField.layer.borderWidth = 1
        amountTextField.clipsToBounds = true
        compareButton.layer.cornerRadius = 20
        compareFromDropdownView.layer.cornerRadius = 20
        firstTargetDropdownView.layer.cornerRadius = 20
        secondTargetDropdownView.layer.cornerRadius = 20
        compareFromDropdownView.layer.borderColor = .init(gray: .leastNormalMagnitude, alpha: 0.1)
        compareFromDropdownView.layer.borderWidth = 1
        firstTargetDropdownView.layer.borderColor = .init(gray: .leastNormalMagnitude, alpha: 0.1)
        firstTargetDropdownView.layer.borderWidth = 1
        secondTargetDropdownView.layer.borderColor = .init(gray: .leastNormalMagnitude, alpha: 0.1)
        secondTargetDropdownView.layer.borderWidth = 1
        compareFromdropDown.bottomOffset = CGPoint(x: 0, y: compareFromdropDown.anchorView?.plainView.bounds.height ?? 0)
        compareFromdropDown.direction = .bottom
        firstTargetdropDown.bottomOffset = CGPoint(x: 0, y: firstTargetdropDown.anchorView?.plainView.bounds.height ?? 0)
        firstTargetdropDown.direction = .bottom
        secondTargetdropDown.bottomOffset = CGPoint(x: 0, y: secondTargetdropDown.anchorView?.plainView.bounds.height ?? 0)
        secondTargetdropDown.direction = .bottom
    }
    
    private func setConvertComponentsShape(){
        convertAmountTextField.layer.cornerRadius = 15
        convertAmountTextField.layer.borderColor = .init(gray: .leastNormalMagnitude, alpha: 0.1)
        convertAmountTextField.layer.borderWidth = 1
        convertAmountTextField.clipsToBounds = true
        convertButton.layer.cornerRadius = 20
        convertToAmountView.layer.cornerRadius = 20
        convertToAmountView.layer.borderColor = .init(gray: .leastNormalMagnitude, alpha: 0.1)
        convertToAmountView.layer.borderWidth = 1
        fromViewDropDown.layer.cornerRadius = 20
        toViewDropDown.layer.cornerRadius = 20
        fromViewDropDown.layer.borderWidth = 1
        fromViewDropDown.layer.borderColor = .init(gray: .leastNormalMagnitude, alpha: 0.1)
        toViewDropDown.layer.borderColor = .init(gray: .leastNormalMagnitude, alpha: 0.1)
        toViewDropDown.layer.borderWidth = 1
        convertFromdropdown.bottomOffset =  CGPoint(x: 0, y:(convertFromdropdown.anchorView?.plainView.bounds.height) ?? 0)
        convertFromdropdown.direction = .bottom
        convertTodropDown.bottomOffset = CGPoint(x: 0, y:(convertTodropDown.anchorView?.plainView.bounds.height) ?? 0)
        convertTodropDown.direction = .bottom
    }
}
