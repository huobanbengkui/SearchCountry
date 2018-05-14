//
//  SearchResultVC.swift
//  SearchBar
//
//  Created by huobanbengkui on 2018/5/10.
//  Copyright © 2018年 huobanbengkui. All rights reserved.
//

import UIKit

class SearchResultVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    private let tableView = UITableView();
    private var inputStr:String?;
    var cancelSearch:(() -> Void)?;
    var searchResult:((String) -> Void)?;
    /**
     *  数据数组
     */
    var dataArray: [(key: String, value: [String])]!;
    private var resultArray: Array<String> = Array();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white;
        tableView.frame = CGRect(x: 0, y: -44, width: 320, height: 675);
        tableView.delegate = self;
        tableView.dataSource = self;
        view.addSubview(tableView);
        tableView.tableFooterView = UIView();
        // Do any additional setup after loading the view.
    }
    //MARK:--UISearchResultsUpdating, UISearchBarDelegate
    func updateSearchResults(for searchController: UISearchController) {
        inputStr = searchController.searchBar.text;
        searchController.searchResultsController?.view.isHidden = false;
        if resultArray.count > 0 {
            resultArray.removeAll();
        }
        if inputStr != nil && inputStr!.count > 0 {
            for (_, value) in dataArray {
                let array = NSArray(array: value);
                let predicate = NSPredicate(format: "SELF CONTAINS[cd] %@", inputStr!);
                let result = array.filtered(using: predicate);
                for str in result{
                    resultArray.append(str as! String);
                }
            }
        }
        tableView.reloadData();
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true);
        let tempView = searchBar.subviews.first;
        for subView: UIView in (tempView?.subviews)!{
            if subView.isMember(of: NSClassFromString("UINavigationButton")!){
                let cancelButton: UIButton = subView as! UIButton;
                cancelButton.setTitle("取消", for: .normal);
                break;
            }
        }
        return true;
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true;
    }
    //MARK:--UITableViewDelegate, UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        if inputStr != nil && inputStr!.count > 0 {
            return 1;
        }
        return dataArray.count;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inputStr != nil && inputStr!.count > 0 {
            return resultArray.count;
        }
        let dic = dataArray[section];
        return dic.value.count;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0;
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if inputStr != nil && inputStr!.count > 0 {
            return nil;
        }
        return dataArray[section].key;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "SearchResultVC";
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier);
        if cell == nil{
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: identifier);
        }
        if inputStr != nil && inputStr!.count > 0 {
            cell?.textLabel?.text = resultArray[indexPath.row];
        }else{
            cell?.textLabel?.text = dataArray[indexPath.section].value[indexPath.row];
        }
        return cell!;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var resultStr: String!;
        if inputStr != nil && inputStr!.count > 0 {
            resultStr = resultArray[indexPath.row];
        }else{
            resultStr = dataArray[indexPath.section].value[indexPath.row];
        }
        if searchResult != nil {
            searchResult!(resultStr);
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
