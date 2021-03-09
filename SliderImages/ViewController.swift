//
//  ViewController.swift
//  SliderImages
//
//  Created by 刘Sir on 2021/3/9.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var containerView: UIView!
    
    private var leftContainerView: UIView!
    private var rightContainerView: UIView!
    
    private var leftImageView: UIImageView!
    private var rightImageView: UIImageView!
    private var originLeftRect: CGRect!
    private var originRightRect: CGRect!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupContainerViews()
        leftContainerView.clipsToBounds = true
        rightContainerView.clipsToBounds = true
        setupImages()
        let leftPan = UIPanGestureRecognizer(target: self, action: #selector(moveImageView(_:)))
        leftPan.maximumNumberOfTouches = 1
        leftContainerView.addGestureRecognizer(leftPan)
        
        let rightPan = UIPanGestureRecognizer(target: self, action: #selector(moveImageView(_:)))
        rightPan.maximumNumberOfTouches = 1
        rightContainerView.addGestureRecognizer(rightPan)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resetFrame()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    private func setupContainerViews() {
        leftContainerView = UIView()
        rightContainerView = UIView()
        containerView.addSubview(leftContainerView)
        containerView.addSubview(rightContainerView)
    }
    // MARK: 设置图片
    private func setupImages() {
        guard let originImage = UIImage(named: "demo_png") else {
            return
        }
        // 获取image尺寸
        let leftImageView = UIImageView(frame: CGRect.zero)
        self.leftImageView = leftImageView
        leftImageView.contentMode = .scaleAspectFill
        let rightImageView = UIImageView(frame: CGRect.zero)
        self.rightImageView = rightImageView
        rightImageView.contentMode = .scaleAspectFill
        leftContainerView.addSubview(leftImageView)
        rightContainerView.addSubview(rightImageView)
        // set images
        leftImageView.image = originImage
        // 图片镜像
        let rightImage = originImage.withHorizontallyFlippedOrientation()
        rightImageView.image = rightImage
    }
    // MARK: 设置frame
    private func resetFrame() {
        guard let originImage = UIImage(named: "demo_png") else {
            return
        }
        let size = originImage.size
        let width = containerView.frame.size.width/2
        let height = containerView.frame.size.height
        let imageWidth = size.width * height/size.height
        // set frame
        leftImageView.frame = CGRect(x: width - imageWidth, y: 0, width: imageWidth, height: height)
        originLeftRect = leftImageView.frame
        rightImageView.frame = CGRect(x: 0, y: 0, width: imageWidth, height: height)
        originRightRect = rightImageView.frame
        
        leftContainerView.frame = CGRect(x: 0, y: 0, width:width, height: height)
        rightContainerView.frame = CGRect(x: width, y: 0, width: width, height: height)
    }
    // MARK: 滑动手势监听
    @objc private func moveImageView(_ pan: UIPanGestureRecognizer) {
        if pan.state == .changed {
            let changedPointX = pan.translation(in: leftContainerView).x
            var movedLeftX: CGFloat = 0
            var movedRightX: CGFloat = 0
            let absMoved = CGFloat(fabs(Double(changedPointX)))
            // 处理边界以及异常条件
            if leftImageView.frame.origin.x <= 0,
               leftImageView.frame.origin.x >= (leftContainerView.frame.size.width - leftImageView.frame.width),
               absMoved >= 0 ,
               absMoved <= leftContainerView.frame.size.width {
                // 滑动左边
                if pan.view == leftContainerView {
                    movedLeftX = originLeftRect.origin.x + changedPointX
                    movedRightX = originRightRect.origin.x - changedPointX
                    if movedLeftX <= 0 ,
                       movedLeftX >= (leftContainerView.frame.size.width - leftImageView.frame.width)  {
                        leftImageView.frame = CGRect(x: movedLeftX, y: 0, width: originLeftRect.size.width, height: originLeftRect.size.height)
                        rightImageView.frame = CGRect(x: movedRightX, y: 0, width: originRightRect.size.width, height: originRightRect.size.height)
                    }
                } else {
                    movedLeftX = originLeftRect.origin.x - changedPointX
                    movedRightX = originRightRect.origin.x + changedPointX
                    if movedLeftX <= 0 ,
                       movedLeftX >= (leftContainerView.frame.size.width - leftImageView.frame.width)  {
                        leftImageView.frame = CGRect(x: movedLeftX, y: 0, width: originLeftRect.size.width, height: originLeftRect.size.height)
                        rightImageView.frame = CGRect(x: movedRightX, y: 0, width: originRightRect.size.width, height: originRightRect.size.height)
                    }
                }
            }
        } else if pan.state == .ended {
            originLeftRect = leftImageView.frame
            originRightRect = rightImageView.frame
        }
    }
    // MARK: 点击保存按钮
    @IBAction func clickSave(_ sender: Any) {
        let image = containerView.asImage()
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSavedSuccess(_:error:contextInfo:)), nil)
    }
    // MARK: 保存成功
    @objc func imageSavedSuccess(_ image: UIImage, error: Error, contextInfo: Any) {
        let alertController = UIAlertController(title: "保存成功", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "关闭", style: .cancel) { (_) in
            
        }
        alertController.addAction(cancelAction)
        show(alertController, sender: nil)
    }
    
}

