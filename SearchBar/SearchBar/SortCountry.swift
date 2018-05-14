//
//  SortCountry.swift
//  SearchBar
//
//  Created by huobanbengkui on 2018/5/14.
//  Copyright © 2018年 huobanbengkui. All rights reserved.
//

import UIKit
private let letterArray = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
extension String{
    /*
     *获取汉字拼音的首字母, 返回的字母是大写形式, 例如: @"俺妹", 返回 @"A".
     *如果字符串开头不是汉字, 而是字母, 则直接返回该字母, 例如: @"b彩票", 返回 @"B".
     *如果字符串开头不是汉字和字母, 则直接返回 @"#", 例如: @"&哈哈", 返回 @"#".
     *字符串开头有特殊字符(空格,换行)不影响判定, 例如@"       a啦啦啦", 返回 @"A".
     */
    //判断
    func getFirstLetter() -> String? {
        let stringRef = NSMutableString(string: self) as CFMutableString;
        //转换为带音标的拼音
        CFStringTransform(stringRef, nil, kCFStringTransformToLatin, false);
        //去掉音标
        CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false);
        let string = String(stringRef);
        //去掉空格 并且首字母转换为大写
        let result = string.replacingOccurrences(of: " ", with: "").capitalized;
        let index = result.index(result.startIndex, offsetBy: 1);
        return String(result.prefix(upTo: index));
    }
}

extension Array{
    /*
     *将一个字符串数组按照拼音首字母规则进行重组排序, 返回重组后的数组.
     *格式和规则为:
     
     [
     @{
     @"firstLetter": @"A",
     @"content": @[@"啊", @"阿狸"]
     }
     ,
     @{
     @"firstLetter": @"B",
     @"content": @[@"部落", @"帮派"]
     }
     ,
     ...
     ]
     *只会出现有对应元素的字母字典, 例如: 如果没有对应 @"C"的字符串出现, 则数组内也不会出现 @"C"的字典.
     *数组内字典的顺序按照26个字母的顺序排序
     *@"#"对应的字典永远出现在数组最后一位
     */
    func arrayWithPinYinFirstLetterFormat() -> [(key: String, value: [String])] {
        var resultDic = Dictionary<String, [String]>();
        for str in self {
            let firstLetter = (str as! String).getFirstLetter();
            if letterArray.contains(firstLetter!){
                if resultDic[firstLetter!] != nil && (resultDic[firstLetter!]! as AnyObject).count > 0{
                    var array = resultDic[firstLetter!]! ;
                    array.append(str as! String);
                    resultDic.updateValue(array, forKey: firstLetter!);
                }else{
                    var array = Array();
                    array.append(str);
                    resultDic.updateValue(array as! [String], forKey: firstLetter!)
                }
            }else{
                if resultDic["#"] != nil && (resultDic["#"]! as AnyObject).count > 0{
                    var array = resultDic["#"]! ;
                    array.append(str as! String);
                    resultDic.updateValue(array, forKey: "#");
                }else{
                    var array = Array();
                    array.append(str);
                    resultDic.updateValue(array as! [String], forKey: "#")
                }
            }
        }
        for (key, value) in resultDic{
            let result = value.sorted(by: { (t1, t2) -> Bool in
                return t1 > t2;
            })
            resultDic.updateValue(result, forKey: key);
        }
        
        let result = resultDic.sorted { (str1, str2) -> Bool in
            return str1.0 < str2.0;
        }
        return result;
    }
}

