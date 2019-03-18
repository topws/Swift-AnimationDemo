//
//  ViewController.swift
//  Swift-AnimationDemo
//
//  Created by Avazu on 2019/3/15.
//  Copyright © 2019年 Ken. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var categoryArr: [CategoryModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "动画"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getLocalData()
    }
    
    //MARK: 读取本地数据
    
    private func getLocalData() {
        if let path = Bundle.main.path(forResource: "AnimationList", ofType: "plist") {
            if let arr = NSArray(contentsOfFile: path) {
                for item in arr {
                    if !JSONSerialization.isValidJSONObject(item) {
                        return
                    }
                    guard let data = try? JSONSerialization.data(withJSONObject: item, options: []) else {
                        return
                    }
                    if let model = try? JSONDecoder().decode(CategoryModel.self, from: data) {
                        categoryArr.append(model)
                    }
                }
            }
        }
        tableView.reloadData()
    }
    
    //MARK: tableview

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = categoryArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = categoryArr[indexPath.row]
        let className = "Swift_AnimationDemo." + (model.type ?? "")
        let aClass = NSClassFromString(className) as! UIViewController.Type
        let viewController = aClass.init()
        navigationController?.pushViewController(viewController, animated: true)
    }

}

struct CategoryModel: Codable {
    var title: String?
    var type: String?
}
