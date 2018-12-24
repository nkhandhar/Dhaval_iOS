//
//  ViewController.swift
//  TestProject
//
//  Created by Saavaj on 24/12/18.
//  Copyright © 2018 Saavaj. All rights reserved.
//

import UIKit
import SKActivityIndicatorView

class ViewController: UIViewController {

    // MARK:- Outlets
    
    @IBOutlet weak var tblSearchList: UITableView!
    
    var refreshControl = UIRefreshControl()
    
    // MARK:-  Array declaration
    
    var arrHitsData:[HitsDataList] = []
    
     // MARK:-  Variable declaration
    
    var currentPage:Int = 1
    var currentSelectedCount:Int = 0
    var isLoadingList : Bool = false
    var maxPage:Int = 0
    
    // MARK:-  ViewController events
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        SKActivityIndicator.show("Loading...")
        self.title = "Selected Hits"
        getHits(page: currentPage)
        
        // MARK:- Add RefreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tblSearchList.refreshControl = refreshControl
        } else {
            tblSearchList.addSubview(refreshControl)
        }
       
    }

    // MARK:-  Refresh table view
    @objc func refresh(sender:AnyObject) {
        
        
        if self.arrHitsData.count > 0 {
            self.arrHitsData.removeAll()
            currentPage = 1
            self.title = "Selected Hits"
            currentSelectedCount = 0
            getHits(page:currentPage)
            refreshControl.endRefreshing()
            
        }else {
            currentPage = 1
            self.title = "Selected Hits"
            currentSelectedCount = 0
            getHits(page:currentPage)
            refreshControl.endRefreshing()
        }
        
    }
    
     // MARK:- Pagination
    
    func loadMoreItemsForList(){
        if isLoadingList == false{
            
        }else {
            currentPage += 1
            if currentPage <= maxPage {
                  getHits(page: currentPage)
            }
          
        }
        
    }
    
    // MARK:- API Calling
    
    func getHits(page:Int){
        
        
        APIManager.shared.searchByDateWith(tag: "story", page: page) { (arrHits, success, errorr,noOfPage) in
            SKActivityIndicator.dismiss()
            if success == true{
                self.arrHitsData.append(contentsOf:arrHits!)
                self.maxPage = noOfPage!
                if self.arrHitsData.count > 0 {
                    self.isLoadingList = false
                    self.tblSearchList.reloadData()
                }else {
                    
                }
                
            }else {
                let alert = UIAlertController(title: "Error", message: errorr, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func switchChangedEvents(index:Int){
        
        arrHitsData[index].isSelectedCell = !arrHitsData[index].isSelectedCell
        let cell = tblSearchList.cellForRow(at: IndexPath(row: index, section: 0)) as! SearchTableViewCell
        if arrHitsData[index].isSelectedCell {
            cell.switchActivate.isOn = true
            cell.backgroundColor = lightGrayColor
            currentSelectedCount += 1
        }
        else {
            cell.switchActivate.isOn = false
            cell.backgroundColor = .white
            currentSelectedCount -= 1
        }
        if currentSelectedCount == 0 {
            self.title = "Selected Hits"
        }
        else {
            self.title = "Selected Hits \(currentSelectedCount)"
        }
    }

}

// MARK:- TableView DataSource & Delegates & ScrollView Delegate
extension ViewController:UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrHitsData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as! SearchTableViewCell
        if self.arrHitsData.count > 0 {
            let objectHits = arrHitsData[indexPath.row]
            // cell.lblCreatedAt.text = objectHits.strCreatedAt
            cell.lblTitle.text = objectHits.strTitle
            let dateString = objectHits.strCreatedAt
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"  // 2018-08-01T07:46:56.000Z
            
            if let dateCreatedAt = dateFormatter.date(from: dateString) {
                
                dateFormatter.dateFormat = "dd, MMM yyyy hh:mm:ss a"
                cell.lblCreatedAt.text = dateFormatter.string(from: dateCreatedAt)
            }
            
            if objectHits.isSelectedCell {
                
                cell.switchActivate.isOn = true
                cell.backgroundColor = lightGrayColor
                
            }
            else {
                cell.switchActivate.isOn = false
                cell.backgroundColor = .white
                
            }
            cell.switchActivate.tag = indexPath.row
            cell.switchActivate.addTarget(self, action: #selector(switchChanged(sender:)), for: .valueChanged)
        }else {
            
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         switchChangedEvents(index: indexPath.row)

    }
    
    // MARK Switch Action
    
    @objc func switchChanged(sender: UISwitch) {
        
        switchChangedEvents(index: sender.tag)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
            self.isLoadingList = true
            self.loadMoreItemsForList()
        }else {
             self.isLoadingList = false
        }
    }
}

