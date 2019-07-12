//
//  ViewController.swift
//  DB2LimitedTest
//
//  Created by md760 on 7/10/19.
//  Copyright © 2019 md760. All rights reserved.
//

import UIKit
import SVProgressHUD

final class ExchangeRateViewController: UIViewController {
    
    @IBOutlet weak var pbTableView: UITableView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var secondDateButton: UIButton!
    @IBOutlet weak var nbuTableView: UITableView!
    @IBOutlet weak var angleView: UIView!
    @IBOutlet weak var underPickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    private let cellId = "pbCell"
    private let secondCellId = "nbuCell"
    private let baseUrlString = "https://api.privatbank.ua/p24api/exchange_rates?json&date="
    //MARK: Default current date
    private var selectDate = Date().getDateStringFromDate(nil)
    private var showed = false
    private var currencyExchangeArray = [PrivatBankModel]()
    private var nbuCurrencyExchangeArray = [NBUExchangeRateModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setButtonTitle()
        fetchRequest()
    }
    
    private func fetchRequest() {
        
        SVProgressHUD.show()
        Singleton.shared.fetchRequest(urlString: baseUrlString + selectDate) { [weak self] (data, error) in
            guard let data = data else { return }
            self?.currencyExchangeArray = data.0
            self?.nbuCurrencyExchangeArray = data.1
            self?.pbTableView.reloadData()
            self?.nbuTableView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
    private func setupView() {
        angleView.transform = CGAffineTransform(rotationAngle: .pi / 4)
        underPickerView.layer.cornerRadius = 15
        datePicker.datePickerMode = UIDatePicker.Mode.date
        
        dateButton.layer.cornerRadius = 5
        dateButton.clipsToBounds = true
        dateButton.layer.borderWidth = 1
        
        secondDateButton.layer.cornerRadius = 5
        secondDateButton.clipsToBounds = true
        secondDateButton.layer.borderWidth = 1
        
        
        pbTableView.register(UINib(nibName: "PBCell", bundle: nil), forCellReuseIdentifier: cellId)
        nbuTableView.register(UINib(nibName: "NBUCell", bundle: nil), forCellReuseIdentifier: secondCellId)
        
        datePicker.maximumDate = Date()
        
        
    }
    
    private func setButtonTitle() {
        let selectedDate = datePicker.date.getDateStringFromDate(nil)
        self.selectDate = selectedDate
        let textRange = NSMakeRange(0, selectedDate.count)
        let attributedText = NSMutableAttributedString(string: selectedDate)
        
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: textRange)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1), range: textRange)
        dateButton.setAttributedTitle(NSAttributedString(attributedString: attributedText), for: .normal)
        secondDateButton.setAttributedTitle(NSAttributedString(attributedString: attributedText), for: .normal)
    }
    
    @IBAction func selectDate(_ sender: UIButton) {
        
        if showed == false {
            underPickerView.isHidden = false
            angleView.isHidden = false
            datePicker.isHidden = false
            showed = true
        } else {
            underPickerView.isHidden = true
            angleView.isHidden = true
            datePicker.isHidden = true
            showed = false
            fetchRequest() //MARK: reload data
        }
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        
        datePicker.datePickerMode = UIDatePicker.Mode.date
        setButtonTitle()
        
    }
    
}

extension ExchangeRateViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == pbTableView {
            return pbTableView.frame.height / 3
        }
        if tableView == nbuTableView {
            return nbuTableView.frame.height / 6
        }
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView {
        case pbTableView:
            let modelPB = currencyExchangeArray[indexPath.row]
            
            for (index, modelNB) in nbuCurrencyExchangeArray.enumerated() {
                if modelPB.currency == modelNB.currency {
                    let indexPath = IndexPath(item: index, section: 0)
                    nbuTableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
                }
            }
        case nbuTableView:
            let modelNB = nbuCurrencyExchangeArray[indexPath.row]
            
            for (index, modelPB) in currencyExchangeArray.enumerated() {
                if modelNB.currency == modelPB.currency {
                    let indexPath = IndexPath(item: index, section: 0)
                    pbTableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
                }
            }
        default:
            break
        }
    }
}

extension ExchangeRateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == pbTableView {
            return currencyExchangeArray.count
        }
        if tableView == nbuTableView {
            return nbuCurrencyExchangeArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == pbTableView {
            let cell = pbTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PBCell
            cell.model = currencyExchangeArray[indexPath.row]
            return cell
        }
        if tableView == nbuTableView {
            let cell = nbuTableView.dequeueReusableCell(withIdentifier: secondCellId, for: indexPath) as! NBUCell
            cell.backgroundColor = indexPath.row % 2 == 0 ? #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.model = nbuCurrencyExchangeArray[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    
}


