//
//  File.swift
//  gif3d
//
//  Created by Sam on 7/9/18.
//  Copyright © 2018 chuongtran. All rights reserved.
//

import Foundation
import UIKit



class DrawingView: UIView {
    
    private var lastPoint: CGPoint?
    fileprivate var drawHandler: ((_ fromPoint: CGPoint, _ toPoint: CGPoint) -> Void)?
    
    // MARK: - override
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        if lastPoint == nil {
            lastPoint = point
        }
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        
        guard let point = touches.first?.location(in: self) else { return }
        defer { lastPoint = point }
        guard let lastPoint = lastPoint else { return }
        
        drawHandler?(lastPoint, point)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard let _ = lastPoint else { return }
        lastPoint = nil
    }
    
}

protocol EditorViewDelegate: class {
    func drawPath(editorView:EditorView, from:CGPoint, to:CGPoint, radius:CGFloat)
}

class EditorView: DrawingView {
    
    open var lineCap: CGLineCap = .round
    open var radius: CGFloat = 20
    public weak var delegate:EditorViewDelegate?
    
    private var tempImageView: UIImageView!
    private var chunkedPath:[Tool] = []
    private var imageCache:UIImage!
    // MARK: - Drawing
 
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
  
    override func layoutSubviews () {
        super.layoutSubviews()
    }
    
    
    // MARK: - Initialization
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupLine()
        
        setupDrawing()

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLine()
        
        setupDrawing()

    }
    
    
    // MARK: - Private methods
    private func setupDrawing(){
        
        self.imageCache = self.createImage()
        tempImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH))
        tempImageView.image = self.imageCache
        self.addSubview(tempImageView)
        self.backgroundColor = UIColor.clear
        
        subviews.forEach { (temp) in
            temp.backgroundColor = UIColor.clear
        }
        
        self.drawHandler = { [weak self] fromPoint, toPoint in
            self?.drawPath(from: fromPoint, to: toPoint)
            if let delegate = self?.delegate{
                delegate.drawPath(editorView: self!, from: fromPoint, to: toPoint, radius: (self?.radius)!)
            }
        }
    }
    
    private func setupLine(){
        
        let screenWidth = SCREEN_WIDTH
        let line1 = UIView()
        line1.frame = CGRect(x: screenWidth/3 - 10, y: 0, width: 20, height: screenWidth)
        line1.backgroundColor = UIColor.white
        self.addSubview(line1)
        
        let line2 = UIView()
        line2.frame = CGRect(x: screenWidth*2/3 - 10, y: 0, width: 20, height: screenWidth)
        line2.backgroundColor = UIColor.white
        self.addSubview(line2)
        
    }
    
    private func drawPath(from fromPoint: CGPoint, to toPoint: CGPoint) {
        let imageSize = CGSize.init(
            width: floor(tempImageView.frame.size.width) ,
            height: floor(tempImageView.frame.size.height))
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        tempImageView.image?.draw(in: .init(origin: .zero, size: imageSize))
        let path = Path(fromPoint: fromPoint, toPoint: toPoint)
        chunkedPath.append(Tool(path: path, radius: radius))
        addStrokePath(context, from: fromPoint, to: toPoint, radius: radius)
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    private func addStrokePath(_ context: CGContext, from fromPoint: CGPoint, to toPoint: CGPoint, radius:CGFloat, lineWidthRatio: CGFloat = 1.0) {
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
        context.setLineCap(lineCap)
        context.setLineWidth(radius * lineWidthRatio)
        context.setStrokeColor(UIColor.clear.cgColor)
        context.setBlendMode(.clear)
        context.strokePath()
    }
    
    //MAKR: - Public methods
    
    func resetDrawing(){
        chunkedPath.removeAll()
        tempImageView.image = self.imageCache

    }
    
    func setupEditor(editor:Editor){
        chunkedPath.removeAll()
        chunkedPath.append(contentsOf: editor.tools!)
    }
    func commit(){
        
        let imageSize = CGSize.init(
            width: floor(tempImageView.frame.size.width) ,
            height: floor(tempImageView.frame.size.height))
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        tempImageView.image?.draw(in: .init(origin: .zero, size: imageSize))
        
        chunkedPath.forEach { (tool) in
            addStrokePath(context, from: tool.path.fromPoint, to: tool.path.toPoint, radius: tool.radius)
        }
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func getEditedFrame()->UIImage?{
        return tempImageView.image
    }
}
