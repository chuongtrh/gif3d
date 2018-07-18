//
//  EditorFrameView.swift
//  gif3d
//
//  Created by Sam on 7/10/18.
//  Copyright © 2018 chuongtran. All rights reserved.
//

import UIKit

protocol EditorFrameViewDelegate: class {
    func editorFrameChange(editorFrameView:EditorFrameView)
}

class EditorFrameView: UIView {

    @IBOutlet weak var ivThumbnail:UIImageView!
    @IBOutlet weak var editorView:EditorView!

    public weak var delegate:EditorFrameViewDelegate?

    var editor:Editor!
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        editorView.delegate = self
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setupEditor(editor:Editor) {
        self.editor = editor
        ivThumbnail.image = editor.image
        
        editorView.resetDrawing()
        editorView.setupEditor(editor: editor)
        editorView.commit()
    }
    
    func buildFrame() -> UIImage {
        if let image = ivThumbnail.createImage(), let overlay = editorView.getEditedFrame(){
            return image.overlayWith(image: overlay, posX: 0, posY: 0)
        }
        return UIImage()
    }
}

extension EditorFrameView: EditorViewDelegate{
    func drawPath(editorView: EditorView, from: CGPoint, to: CGPoint, radius: CGFloat) {
        let path = Path(fromPoint: from, toPoint: to)
        editor.tools?.append(Tool(path: path, radius: radius))
        
        if let delegate = self.delegate{
            delegate.editorFrameChange(editorFrameView: self)
        }
    }
}
