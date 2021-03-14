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
    var originImage: UIImage!
    var originRightImage: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupContainerViews()
        leftContainerView.clipsToBounds = true
        rightContainerView.clipsToBounds = true
        setupImages()
        addGestures()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resetFrame()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    private func addGestures() {
        // pan
        let leftPan = UIPanGestureRecognizer(target: self, action: #selector(moveImageView(_:)))
        leftPan.maximumNumberOfTouches = 1
        leftContainerView.addGestureRecognizer(leftPan)
        // pinch
        let leftPinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchImageView(_:)))
        leftContainerView.addGestureRecognizer(leftPinch)
        // pan
        let rightPan = UIPanGestureRecognizer(target: self, action: #selector(moveImageView(_:)))
        rightPan.maximumNumberOfTouches = 1
        rightContainerView.addGestureRecognizer(rightPan)
        // pinch
        let rightPinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchImageView(_:)))
        rightContainerView.addGestureRecognizer(rightPinch)
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
        self.originImage = originImage
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
        self.originRightImage = rightImage
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
            var changedPointX: CGFloat = 0
            var changedPointY: CGFloat = 0
            var movedLeftX: CGFloat = 0
            var movedRightX: CGFloat = 0
            var movedY: CGFloat = 0
            changedPointY = pan.translation(in: leftContainerView).y

            // 处理边界以及异常条件
            movedY = originLeftRect.minY + changedPointY
            let movedMaxY = originLeftRect.maxY + changedPointY
            if movedMaxY < leftContainerView.frame.height {
                movedY = movedY + leftContainerView.frame.height - movedMaxY
            }
            if movedY > 0 {
                movedY = 0
            }
            if pan.view == leftContainerView {
                changedPointX = pan.translation(in: leftContainerView).x
                movedLeftX = originLeftRect.origin.x + changedPointX
                if movedLeftX > 0 {
                    movedLeftX = 0
                }
                
                movedLeftX = originLeftRect.origin.x + changedPointX
                movedRightX = originRightRect.origin.x - changedPointX
                if movedLeftX <= 0 ,
                   movedLeftX >= (leftContainerView.frame.size.width - leftImageView.frame.width)  {
                    leftImageView.frame = CGRect(x: movedLeftX, y: movedY, width: originLeftRect.size.width, height: originLeftRect.size.height)
                    rightImageView.frame = CGRect(x: movedRightX, y: movedY, width: originRightRect.size.width, height: originRightRect.size.height)
                }
            } else {
                changedPointX = pan.translation(in: rightContainerView).x
                movedLeftX = originRightRect.origin.x + changedPointX
                if movedLeftX > 0 {
                    movedLeftX = 0
                }
                movedLeftX = originLeftRect.origin.x - changedPointX
                movedRightX = originRightRect.origin.x + changedPointX
                if movedLeftX <= 0 ,
                   movedLeftX >= (leftContainerView.frame.size.width - leftImageView.frame.width)  {
                    leftImageView.frame = CGRect(x: movedLeftX, y: movedY, width: originLeftRect.size.width, height: originLeftRect.size.height)
                    rightImageView.frame = CGRect(x: movedRightX, y: movedY, width: originRightRect.size.width, height: originRightRect.size.height)
                }
            }
            
        } else if pan.state == .ended {
            originLeftRect = leftImageView.frame
            originRightRect = rightImageView.frame
        }
    }
    // 缩放手势
    @objc private func pinchImageView(_ pinch: UIPinchGestureRecognizer) {
        let scale = CGFloat(Double(pinch.scale).roundToDecimal(3))
        var width = leftImageView.frame.size.width * scale
        if width/2 <= leftContainerView.frame.width {
            width = leftContainerView.frame.width*2
        }
        let height = width
        var left_x = (leftImageView.frame.minX - (width - leftImageView.frame.width)/2)
        var left_y = leftImageView.frame.minY - (height - leftImageView.frame.height)/2
        if left_x > 0 {
            // 靠左
            left_x = 0
        } else if leftImageView.frame.maxX < leftContainerView.frame.maxX {
            // 靠右
            left_x = left_x - leftImageView.frame.maxX + leftContainerView.frame.maxX
        }
        if left_y > 0 {
            // 靠上
            left_y = 0
        } else if left_y < leftContainerView.frame.maxY - height  {
            // 靠下
            left_y = leftContainerView.frame.height - height
        }
        if left_y > 0 {
            left_y = 0
        }
        var right_x = rightImageView.frame.minX - (width - rightImageView.frame.width)/2
        var right_y = rightImageView.frame.minY - (height - rightImageView.frame.height)/2
        if right_x > 0 {
            // 靠左
            right_x = 0
        } else if rightImageView.frame.maxX < rightContainerView.frame.maxX/2 {
            // 靠右
            right_x = right_x - rightImageView.frame.maxX + rightContainerView.frame.maxX/2
        }
        if right_y > 0 {
            // 靠上
            right_y = 0
        } else if right_y < rightContainerView.frame.maxY - height {
            // 靠下
            right_y = rightContainerView.frame.height - height
        }
        leftImageView.frame = CGRect(x: left_x, y: left_y, width: width, height: height)
        rightImageView.frame = CGRect(x: right_x, y: right_y, width: width, height: height)
        
        pinch.scale = 1
        if pinch.state == .ended {
            originLeftRect = leftImageView.frame
            originRightRect = rightImageView.frame
        }
    }
    
    // MARK: 点击保存按钮
    @IBAction func clickSave(_ sender: Any) {
        let scale: CGFloat = originLeftRect.height/originImage!.size.height
        // 获取左边图片容器当前展示区域在图片上的frame
        var leftRect = CGRect(x: abs(originLeftRect.minX), y: abs(originLeftRect.minY), width: leftContainerView.frame.width, height: leftContainerView.frame.height)
        // 获取右边图片容器当前展示区域在图片上的frame
        var rightRect = CGRect(x: abs(originRightRect.minX), y: abs(originRightRect.minY), width: rightContainerView.frame.width, height: rightContainerView.frame.height)
        // 需要裁剪的区域
        leftRect = CGRect(x: leftRect.minX/scale, y: leftRect.minY/scale, width: leftRect.width/scale, height: leftRect.height/scale)
        rightRect = CGRect(x: rightRect.minX/scale, y: rightRect.minY/scale, width: rightRect.width/scale, height: rightRect.height/scale)
        // 裁剪图片
        let leftImage = originImage.getImageFromRect(leftRect)
        let rightImage = originRightImage.getImageFromRect(rightRect)
        // 左右两张图片合成 原始图片
        let totalImage = UIImage.combine(leftImage, rightImage: rightImage)
        // 按需要分成三种像素尺寸图片
        let alertController = UIAlertController(title: "请选择保存像素", message: nil, preferredStyle: .alert)
        // 2048
        let action2048 = UIAlertAction(title: "2048px", style: .default) { (_) in
            guard let image = UIImage.resizeImage(totalImage, targetSize: CGSize(width: 2048, height: 2048)) else {
                self.saveFailure()
                return
            }
            self.saveImage(image)
            
        }
        // 1280
        let action1280 = UIAlertAction(title: "1280px", style: .default) { (_) in
            guard let image = UIImage.resizeImage(totalImage, targetSize: CGSize(width: 1280, height: 1280)) else {
                self.saveFailure()
                return
            }
            self.saveImage(image)
        }
        // 960
        let action960 = UIAlertAction(title: "960px", style: .default) { (_) in
            guard let image = UIImage.resizeImage(totalImage, targetSize: CGSize(width: 960, height: 960)) else {
                self.saveFailure()
                return
            }
            self.saveImage(image)
        }
        let cancelAction = UIAlertAction(title: "关闭", style: .cancel) { (_) in
            
        }
        alertController.addAction(action2048)
        alertController.addAction(action1280)
        alertController.addAction(action960)
        alertController.addAction(cancelAction)
        show(alertController, sender: nil)

    }
    private func saveImage(_ image: UIImage) {
        // 保存图片
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
    private func saveFailure() {
        let alertController = UIAlertController(title: "生成图片失败，请重试", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "关闭", style: .cancel) { (_) in
            
        }
        alertController.addAction(cancelAction)
        show(alertController, sender: nil)
    }
}

