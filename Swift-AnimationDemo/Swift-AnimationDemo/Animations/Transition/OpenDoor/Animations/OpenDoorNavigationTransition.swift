//
//  CustomNavigationTransition.swift
//  BibleGuardian
//
//  Created by Avazu on 2019/2/19.
//  Copyright © 2019年 Avazu Holding. All rights reserved.
//

import UIKit

class OpenDoorNavigationTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    weak var transitionContext: UIViewControllerContextTransitioning? // 强引用会造成页面无法释放
    
    var leftMaskView0 = UIImageView()
    var leftMaskView1 = UIImageView()
    var leftMaskView2 = UIImageView()
    var rightMaskView0 = UIImageView()
    var rightMaskView1 = UIImageView()
    var rightMaskView2 = UIImageView()
    let thirdOffset: CGFloat = 40 // 第三层相对中轴偏移
    
    lazy var leftViewArr = [leftMaskView0, leftMaskView1, leftMaskView2]
    lazy var rightViewArr = [rightMaskView0, rightMaskView1, rightMaskView2]
    
    var maskW = SWScreen_width * 0.7 // 遮盖屏幕宽度
    
    let totalDuration: TimeInterval = 2
    
    override init() {
        super.init()
        setUpViews()
    }
    
    private func setUpViews() {
        
        let img0 = UIImage(contentsOfFile: Bundle.main.path(forResource: "leafLeft0", ofType: "png")!)
        let img1 = UIImage(contentsOfFile: Bundle.main.path(forResource: "leafLeft1", ofType: "png")!)
        let img2 = UIImage(contentsOfFile: Bundle.main.path(forResource: "leafLeft2", ofType: "png")!)
        let img3 = UIImage(contentsOfFile: Bundle.main.path(forResource: "leafRight0", ofType: "png")!)
        let img4 = UIImage(contentsOfFile: Bundle.main.path(forResource: "leafRight1", ofType: "png")!)
        let img5 = UIImage(contentsOfFile: Bundle.main.path(forResource: "leafRight2", ofType: "png")!)
        
        leftMaskView0.image = img0
        leftMaskView1.image = img1
        leftMaskView2.image = img2
        rightMaskView0.image = img3
        rightMaskView1.image = img4
        rightMaskView2.image = img5
        
        leftMaskView0.frame = CGRect(x: -maskW, y: 0, width: maskW, height: SWScreen_height)
        leftMaskView1.frame = CGRect(x: -maskW, y: 0, width: maskW, height: SWScreen_height)
        leftMaskView2.frame = CGRect(x: -maskW, y: 0, width: maskW - thirdOffset, height: SWScreen_height)
        rightMaskView0.frame = CGRect(x: SWScreen_width, y: 0, width: maskW, height: SWScreen_height)
        rightMaskView1.frame = CGRect(x: SWScreen_width, y: 0, width: maskW, height: SWScreen_height)
        rightMaskView2.frame = CGRect(x: SWScreen_width, y: 0, width: maskW + thirdOffset, height: SWScreen_height)
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return totalDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        self.transitionContext = transitionContext
        
        guard let fromController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let fromView = fromController.view else {
            return
        }
        
        // 动画挡住屏幕时添加toView
        perform(#selector(addToView), with: nil, afterDelay: 0.5 * totalDuration)
        
        transitionContext.containerView.insertSubview(leftMaskView0, aboveSubview: fromView)
        transitionContext.containerView.insertSubview(leftMaskView1, aboveSubview: leftMaskView0)
        transitionContext.containerView.insertSubview(leftMaskView2, aboveSubview: leftMaskView1)
        transitionContext.containerView.insertSubview(rightMaskView0, aboveSubview: fromView)
        transitionContext.containerView.insertSubview(rightMaskView1, aboveSubview: rightMaskView0)
        transitionContext.containerView.insertSubview(rightMaskView2, aboveSubview: rightMaskView2)
        
        let interval: TimeInterval = 0.1
        
        // 动画
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            transitionContext.completeTransition(true)
        }
        
        // 左侧往返动画
        for (index, view) in leftViewArr.enumerated() {
            let offset = index == 2 ? Double(thirdOffset) : 0
            let outAnimation = createMoveAnimation(goRight: true, goBack: false, offset: -offset)
            outAnimation.beginTime = CACurrentMediaTime() + interval * Double(index)
            let backAnimation = createMoveAnimation(goRight: true, goBack: true, offset: -offset)
            backAnimation.beginTime = CACurrentMediaTime() + 1.5 - interval * Double(index)
            view.layer.add(outAnimation, forKey: nil)
            view.layer.add(backAnimation, forKey: nil)
        }
        // 右侧往返动画
        for (index, view) in rightViewArr.enumerated() {
            let offset = index == 2 ? Double(thirdOffset) : 0
            let outAnimation = createMoveAnimation(goRight: false, goBack: false, offset: offset)
            outAnimation.beginTime = CACurrentMediaTime() + interval * Double(index)
            let backAnimation = createMoveAnimation(goRight: false, goBack: true, offset: offset)
            backAnimation.beginTime = CACurrentMediaTime() + 1.5 - interval * Double(index)
            view.layer.add(outAnimation, forKey: nil)
            view.layer.add(backAnimation, forKey: nil)
        }
        
        CATransaction.commit()
        
    }
    
    @objc private func addToView() {
        guard let fromController = transitionContext?.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toController = transitionContext?.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromView = fromController.view,
            let toView = toController.view else {
                return
        }
        transitionContext?.containerView.insertSubview(toView, aboveSubview: fromView)
    }
    
    private func createMoveAnimation(goRight: Bool, goBack: Bool, offset: Double) -> CABasicAnimation {
        var start = 0.0
        var end = 0.0
        if goRight {
            if goBack {
                start = Double(maskW) + offset
                end = 0
            } else {
                start = 0
                end = Double(maskW) + offset
            }
        } else {
            if goBack {
                start = Double(-maskW) - offset
                end = 0
            } else {
                start = 0
                end = Double(-maskW) - offset
            }
        }
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = NSNumber(value: start)
        animation.toValue = NSNumber(value: end)
        animation.duration = 0.5
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        return animation
    }
    
}
