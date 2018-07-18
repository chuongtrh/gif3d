//
//  EditorVC.swift
//  gif3d
//
//  Created by Sam on 7/10/18.
//  Copyright © 2018 chuongtran. All rights reserved.
//

import UIKit

class EditorVC: UIViewController {

    @IBOutlet weak var editorFrameView:EditorFrameView!
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var colorCollectionView:UICollectionView!
    @IBOutlet weak var ivBackground:UIImageView!
    @IBOutlet weak var btnTool: UIButton!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var toolView: UIView!
    @IBOutlet weak var radiusView: UIView!


    @IBOutlet weak var toolViewHeightConstraint: NSLayoutConstraint!
    
    var images:[UIImage]!
    
    private var currentIndexpath:IndexPath!
    private var selectBackgroundFrameColor = UIColor.black
    
    private var activeEditor:Editor! {
        didSet {
            self.editorFrameView.setupEditor(editor: self.activeEditor)
        }
    }
    
    private var colors = [Color.red.base,
                          Color.pink.base,
                          Color.purple.base,
                          Color.deepPurple.base,
                          Color.indigo.base,
                          Color.blue.base,
                          Color.lightBlue.base,
                          Color.cyan.base,
                          Color.teal.base,
                          Color.green.base,
                          Color.lightGreen.base,
                          Color.lime.base,
                          Color.yellow.base,
                          Color.amber.base,
                          Color.orange.base,
                          Color.deepOrange.base,
                          Color.brown.base,
                          Color.grey.base,
                          Color.blueGrey.base,
                          Color.black,
                          Color.white]
 
    var isShowTool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        images.removeAll()
        EditorManager.shared.cleanData()
    }
    
    //MARK: - Helper
    func setup() {
        editorFrameView.delegate = self
        
        ivBackground.image = images.first
        editorFrameView.ivThumbnail.backgroundColor = selectBackgroundFrameColor
        
        EditorManager.shared.setupEditor(images: images)
        activeEditor = EditorManager.shared.editors.first

        collectionView.backgroundColor = UIColor.clear
        colorCollectionView.backgroundColor = UIColor.clear

        toolView.backgroundColor = UIColor.clear
        toolView.isUserInteractionEnabled = false
        toolView.alpha = 0
        //Change radius
        editorFrameView.editorView.radius = 16
        updateRadiusView(radius: 16)
        
        
        if currentIndexpath == nil {
            currentIndexpath = IndexPath(row: 0, section: 0)
        }
    }
    func buildFinalFrameSuccess(images:[UIImage]){
        
        
        if currentIndexpath != nil {
            activeEditor = EditorManager.shared.editors[currentIndexpath.row]
        }
        
        self.performSegue(withIdentifier: "ShowPreviewVCIdentifier", sender: images)
    }
    func buildFinalFrame() {
        var images:[UIImage] = []
        
        print("buildFinalFrame")
        showHUDWith(text: "processing...")
        let nCount = EditorManager.shared.editors.count
        let queue = DispatchQueue(label: "com.chuongtran.gif3d.queue.1")
        queue.sync {
            EditorManager.shared.editors.forEach { (editor) in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // 2
                    self.activeEditor = editor
                    images.append(self.editorFrameView.buildFrame())

                    if(images.count == nCount) {
                        self.dismissHUD()
                        self.buildFinalFrameSuccess(images: images)
                    }
                }
            }
        }
        
    }
    
    func updateRadiusView(radius:CGFloat) {
        radiusView.frame = CGRect(x: radiusView.center.x - radius/2, y: radiusView.center.y - radius/2, width: radius, height: radius)
        radiusView.layer.cornerRadius = radiusView.width/2
    }
    //MARK: - OnAction
    @IBAction func onBack(){
        ivBackground.image = nil
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onNext(){
            buildFinalFrame()
    }
    
    @IBAction func onShowTool(){
        isShowTool = !isShowTool
        
        UIView.animate(withDuration: 0.3, animations: {
            self.toolViewHeightConstraint.constant = self.isShowTool == true ? -150: 10
            self.collectionView.alpha = self.isShowTool == true ? 0 : 1
            self.toolView.alpha = self.isShowTool == true ? 1 : 0
            self.view.layoutIfNeeded()
        }) { (complete) in
            self.collectionView.isUserInteractionEnabled = self.isShowTool == true ? false : true
            self.toolView.isUserInteractionEnabled = self.isShowTool == true ? true : false
            self.btnTool.setImage(UIImage(named: self.isShowTool == true ? "arrowDown" : "arrowUp"), for: .normal)
        }
    }
    
    @IBAction func radiusOnValueChanged(_ sender: Any) {
        let radius = CGFloat(Int(radiusSlider.value))
        editorFrameView.editorView.radius = radius
        updateRadiusView(radius: radius)
        
    }
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPreviewVCIdentifier" {
            if let vc:PreviewVC = segue.destination as? PreviewVC {
                vc.images = sender as? [UIImage]
                vc.bgImage = self.ivBackground.image
            }
        }
    }

}

extension EditorVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return images.count
        }
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell:FrameItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: FrameItemCell.identifier(), for: indexPath) as! FrameItemCell
            let editor:Editor = EditorManager.shared.editors[indexPath.row]
            
            cell.updateUI(image: images[indexPath.row], isEdited: editor.isEdited(), color: selectBackgroundFrameColor, index: indexPath.row, isActive:indexPath.row == currentIndexpath.row)
            
            return cell
        }else {
            let cell:ColorItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorItemCell.identifier(), for: indexPath) as! ColorItemCell
            cell.backgroundColor = colors[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            if currentIndexpath != indexPath {
                currentIndexpath = indexPath
                activeEditor = EditorManager.shared.editors[indexPath.row]
                self.collectionView.reloadData()

            }
        }else{
            selectBackgroundFrameColor = colors[indexPath.row]
            editorFrameView.ivThumbnail.backgroundColor = selectBackgroundFrameColor
            self.collectionView.reloadData()
        }
    }
   
}

extension EditorVC: EditorFrameViewDelegate {
    func editorFrameChange(editorFrameView: EditorFrameView) {
        if activeEditor.tools?.count == 1 {
            self.collectionView.reloadData()
        }
    }
}
