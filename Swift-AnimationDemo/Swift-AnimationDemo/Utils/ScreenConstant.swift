//
//  ConstantManager.swift
//  SwiftWallet
//
//  Created by Avazu Holding on 2018/3/21.
//  Copyright © 2018年 DotC United Group. All rights reserved.
//

import Foundation
import UIKit
import AdSupport

//屏幕宏
let SWScreen_bounds:CGRect = UIScreen.main.bounds
let SWScreen_width:CGFloat = UIScreen.main.bounds.width
let SWScreen_height:CGFloat = UIScreen.main.bounds.height
let SWStatusBarH:CGFloat = UIApplication.shared.statusBarFrame.size.height
let SWNavBarHeight:CGFloat = 44


//iPhone X
let SafeAreaTopHeight:CGFloat = SWStatusBarH + SWNavBarHeight
let iPhoneXBottomHeight:CGFloat = 34
let iPhoneXScreenHeight:CGFloat = 812.0

//APP info
struct AppInfo {
    let infoDictionary = Bundle.main.infoDictionary
    let appDisplayName: String = Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String
    let bundleID: String = Bundle.main.bundleIdentifier!
    let appVersion: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    let buildVersion: String = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    let uuid = UIDevice.current.identifierForVendor?.uuidString
    let systemName = UIDevice.current.systemName
    let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
}

func getVersionCode(vercode: String) -> String {
    
    //    DCGLogDebug(@"传入的buildVersion为:%@",vercode);
    
    let array = vercode.split(separator: ".")
    
    //    DCGLogDebug(@"分割后的数组为:%@",array);
    
    if (array.count < 2) {
        //        DCGLogDebug(@"build version format error!");
        return "10000";
    }
    
    let firstNumStr = String(array[0])
    let secondNum = Int(array[1]) ?? 0
    let secondNumStr = String.init(format: "%02ld", secondNum)
    var thirdNumStr = "00";
    if (array.count == 3) {
        let thirdNum = Int(array[2]) ?? 0
        thirdNumStr = String.init(format: "%02ld", thirdNum)
    }
    
    
    let intVer = String.init(format: "%@%@%@", firstNumStr, secondNumStr, thirdNumStr)
    
    //    DCGLogDebug(@"第一位为:%@,第二位为:%@,第三位为:%@,拼接后的参数:%@",firstNumStr,secondNumStr,thirdNumStr,intVer);
//    DCGLogDebug(@"拼接后的版本号为:%@",intVer);
    print("拼接后的版本号为:%@",intVer)
    
    return intVer;
    
}
