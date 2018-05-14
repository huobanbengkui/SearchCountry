//
//  ViewController.swift
//  SearchBar
//
//  Created by huobanbengkui on 2018/5/4.
//  Copyright © 2018年 huobanbengkui. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .custom);
        let y = UIApplication.shared.statusBarFrame.size.height + 44.0;
        button.frame = CGRect.init(x: 10, y: y, width: 100, height: 50);
        button.setTitle("展示搜索框", for: .normal);
        button.backgroundColor = UIColor.red;
        self.view.addSubview(button);
        button.addTarget(self, action: #selector(clcikButton), for: .touchUpInside);
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc private func clcikButton(){
        let selectCountryVC = SelectCountryVC();
        let country = ["中国", "美国", "英国", "意大利", "德国", "叙利亚", "利比亚", "阿尔及利亚", "古巴", "埃及", "以色列", "越南", "泰国", "老挝", "加拿大", "巴西", "智力", "不丹", "沙特阿拉伯", "伊拉克", "南非", "蒙古", "韩国"];
        selectCountryVC.dataArray = country.arrayWithPinYinFirstLetterFormat();
        selectCountryVC.isSectionIndex = true;
        let nav = UINavigationController(rootViewController: selectCountryVC);
        self.present(nav, animated: true, completion: nil);
        
        selectCountryVC.resultCountry = { (str) in
            print(str);
        };
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

