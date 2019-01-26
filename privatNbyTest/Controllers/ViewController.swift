//
//  ViewController.swift
//  privatNbyTest
//
//  Created by Yermakov Anton on 1/23/19.
//  Copyright © 2019 Yermakov Anton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var privateTableView: UITableView!
    @IBOutlet weak var nbyTableView: UITableView!
    
    let dispatchGroup = DispatchGroup()
    let apiManager = APIManager()
    var privatData = [Privat]()
    var nbyData = [NBY]()
    
    private enum SourceHeader: String{
        case pb = "PrivateHeader"
        case nby = "NbyHeader"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
        fetchPrivat()
        fetchNby()
        reloadData()
    }

    private func setUpTableView(){
        let privateHeaderNib = UINib.init(nibName: SourceHeader.pb.rawValue, bundle: Bundle.main)
        privateTableView.register(privateHeaderNib, forHeaderFooterViewReuseIdentifier: SourceHeader.pb.rawValue)
        let nbyHeaderNib = UINib.init(nibName: SourceHeader.nby.rawValue, bundle: Bundle.main)
        nbyTableView.register(nbyHeaderNib, forHeaderFooterViewReuseIdentifier: SourceHeader.nby.rawValue)
    }
    
    private func fetchPrivat(){
        dispatchGroup.enter()
        apiManager.genericFetch(urlString: Endpoint.privatBank.rawValue) { [unowned self] (privatResponse: [Privat]?, error: APIError?) in
            
            if let error = error{
                switch error{
                case .invalidData: self.onFetchFailed(with: "Invalid privatbank data")
                case .jsonParsingFailure: self.onFetchFailed(with: "JSON privatbank parsing failure")
                case .requestFailed: self.onFetchFailed(with: "Request privatbank failed")
                }
            }
            if let privatData = privatResponse{
                self.privatData = privatData
            }
            self.dispatchGroup.leave()
        }
    }
    
    private func fetchNby(){
        dispatchGroup.enter()
        apiManager.genericFetch(urlString: Endpoint.nby.rawValue) { [unowned self] (nbyResponse: [NBY]?, error: APIError?) in
            if let error = error{
                switch error{
                case .invalidData: self.onFetchFailed(with: "Invalid NBY data")
                case .jsonParsingFailure: self.onFetchFailed(with: "JSON NBY parsing failure")
                case .requestFailed: self.onFetchFailed(with: "Request NBY failed")
                }
            }
            if let nbyData = nbyResponse{
                self.nbyData = nbyData
            }
            self.dispatchGroup.leave()
        }
    }
    
    private func reloadData(){
        dispatchGroup.notify(queue: .main) {
            self.privateTableView.reloadData()
            self.nbyTableView.reloadData()
        }
    }
    
} // class

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == privateTableView{
            return privatData.count
        }else{
            return nbyData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == privateTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "privateCell", for: indexPath) as! PrivateTableViewCell
            let privat = privatData[indexPath.row]
            cell.setUpCell(with: privat)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NBYCell", for: indexPath) as! NBYTableViewCell
            let nby = nbyData[indexPath.row]
            cell.setUpCell(with: nby)
            if indexPath.row % 2 == 0{cell.backgroundColor = #colorLiteral(red: 0.8948069141, green: 1, blue: 0.9024681547, alpha: 1)}else{cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)}
            return cell
         }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == privateTableView{
            let headerView = privateTableView.dequeueReusableHeaderFooterView(withIdentifier: SourceHeader.pb.rawValue) as! PrivateHeader
            return headerView
        }else{
            let headerView = nbyTableView.dequeueReusableHeaderFooterView(withIdentifier: SourceHeader.nby.rawValue) as! NbyHeader
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == privateTableView{
            return 80
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == privateTableView{
            var currency = privatData[indexPath.row].ccy
            if currency == "RUR" {currency = "RUB"}
            if let findInNBY = nbyData.first(where: {$0.cc == currency}) {
                guard let indexOf = nbyData.index(where: {$0.cc == findInNBY.cc }) else { return }
                let indexPath = NSIndexPath(item: indexOf, section: 0)
                nbyTableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.middle, animated: true)
                nbyTableView.selectRow(at: indexPath as IndexPath, animated: true, scrollPosition: UITableView.ScrollPosition.middle)
            }
        } else {
            var currency = nbyData[indexPath.row].cc
            if currency == "RUB" {currency = "RUR"}
            if let findInPrivat = privatData.first(where: {$0.ccy == currency}) {
                guard let indexOf = privatData.index(where: {$0.ccy == findInPrivat.ccy }) else { return }
                let indexPath = NSIndexPath(item: indexOf, section: 0)
                privateTableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.middle, animated: true)
                privateTableView.selectRow(at: indexPath as IndexPath, animated: true, scrollPosition: UITableView.ScrollPosition.middle)
            }
        }
    }
}

extension ViewController: AlertDisplayer{
    private func onFetchFailed(with reason: String) {
        let title = "Warning"
        let action = UIAlertAction(title: "OK", style: .default)
        displayAlert(with: title , message: reason, actions: [action])
    }
}
