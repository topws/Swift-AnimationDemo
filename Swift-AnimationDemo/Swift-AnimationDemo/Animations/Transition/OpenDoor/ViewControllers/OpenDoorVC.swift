//
//  OpenDoorVC.swift
//  Swift-AnimationDemo
//
//  Created by Avazu on 2019/3/18.
//  Copyright © 2019年 Ken. All rights reserved.
//

import UIKit

class OpenDoorVC: UIViewController, UINavigationControllerDelegate {
    
    let openDoorTransition = OpenDoorNavigationTransition()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "开门"
        
        // 设置代理
        navigationController?.delegate = self
        
        view.backgroundColor = UIColor.white

        let btn = UIButton()
        btn.setTitle("点击开门", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.addTarget(self, action: #selector(open), for: .touchUpInside)
        view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.height.equalTo(44)
            make.width.equalTo(80)
        }
    }
    
    @objc private func open() {
        let subVC = OpenDoorSubVC()
        navigationController?.pushViewController(subVC, animated: true)
    }
    
    // 返回转场
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return openDoorTransition
    }

}
