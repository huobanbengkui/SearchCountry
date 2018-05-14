//
//  SelectCountryVC.swift
//  SearchBar
//
//  Created by huobanbengkui on 2018/5/7.
//  Copyright © 2018年 huobanbengkui. All rights reserved.
//

import UIKit
private let WIDTH = UIScreen.main.bounds.width;
private let HEIGHT = UIScreen.main.bounds.height;

class SelectCountryVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private var tableView: UITableView!;
    private var searchController: UISearchController!;
    var resultCountry:((String) -> Void)?;
    /**
     *  数据数组
     */
    var dataArray: [(key: String, value: [String])]!;
    /**
     *  是否添加索引框
     */
    var isSectionIndex: Bool?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        
        let button = UIButton(type: .custom);
        button.setTitle("返回", for: .normal);
        button.setTitleColor(UIColor.white, for: .normal);
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0);
        button.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44);
        button.addTarget(self, action: #selector(clickBackButton), for: .touchUpInside);
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button);
        
        let searchView = UIView();
        self.view.addSubview(searchView);
        let searchResultVC = SearchResultVC();
        searchResultVC.dataArray = dataArray;
        searchResultVC.searchResult = { [weak self](str) in
            if let strongSelf = self {
                if strongSelf.resultCountry != nil {
                    strongSelf.resultCountry!(str);
                }
                strongSelf.searchController.isActive = false;
                strongSelf.clickBackButton();
            }
        };
        searchController = UISearchController.init(searchResultsController: searchResultVC);
        //设置更新代理
        searchController.searchResultsUpdater = searchResultVC;
        searchController.searchBar.delegate = searchResultVC;
        //搜索时，背景变暗色
        searchController.dimsBackgroundDuringPresentation = true;
        //是否自动隐藏导航
//        searchController.hidesNavigationBarDuringPresentation = false;
        searchController.searchBar.placeholder = "搜索";
        searchView.addSubview(searchController.searchBar);
        let height = UIApplication.shared.statusBarFrame.size.height + 44.0;
        searchView.frame = CGRect.init(x: 0, y: height, width: WIDTH, height: searchController.searchBar.bounds.size.height);
        
        tableView = UITableView();
        self.view.addSubview(tableView);
        tableView.delegate = self;
        tableView.dataSource = self;
        var tabbarHeight: CGFloat = 0.0
        if WIDTH >= 375.0 && HEIGHT >= 812.0 {
            tabbarHeight = 34.0;
        }
        tableView.frame = CGRect.init(x: 0, y: searchView.frame.maxY, width: WIDTH, height: HEIGHT - tabbarHeight - searchView.frame.maxY);
        
        //设置搜索导航栏
        tableView.sectionIndexBackgroundColor = UIColor.clear;
        tableView.sectionIndexColor = UIColor.black;
        
        // Do any additional setup after loading the view.
    }
   
    //MAKR:--UITableViewDelegate, UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dic = dataArray[section];
        return dic.value.count;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0;
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataArray[section].key;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "SelectCountryVC";
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier);
        if cell == nil{
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: identifier);
        }
        cell?.textLabel?.text = dataArray[indexPath.section].value[indexPath.row];
        return cell!;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if resultCountry != nil {
            resultCountry!(dataArray[indexPath.section].value[indexPath.row]);
        }
        clickBackButton();
    }
    //索引标题
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if isSectionIndex != nil && isSectionIndex!{
            var array = Array<String>();
            array.append(UITableViewIndexSearch);
            for (key, _) in dataArray {
                array.append(key);
            }
            return array;
        }else{
            return nil;
        }
    }
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if title == UITableViewIndexSearch{
            searchController.searchBar.becomeFirstResponder();
            return NSNotFound;
        }else{
            //添加了搜索标识-1
            let result = UILocalizedIndexedCollation.current().section(forSectionIndexTitle: index - 1);
            return result;
        }
    }
    
    @objc private func clickBackButton(){
        self.dismiss(animated: true, completion: nil);

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
