//
//  PreviewVC.swift
//  gif3d
//
//  Created by Sam on 7/11/18.
//  Copyright © 2018 chuongtran. All rights reserved.
//

import UIKit

class PreviewVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ivBackground:UIImageView!

    var images:[UIImage]!
    var bgImage:UIImage!

    private var fileURL:URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        images.removeAll()
        imageView.image = nil
    }

    //MARK: - Helper
    func setup() {
        ivBackground.image = bgImage
        
        imageView.backgroundColor = UIColor.clear
        fileURL = UIImage.animatedGif(from: images)
        
        print("fileURL:\(fileURL)")
        
        if FileManager.default.fileExists(atPath: (fileURL?.path)!){
            do {
                let data = try Data(contentsOf: fileURL!)
                let image = UIImage.sd_animatedGIF(with: data)
                
                imageView.image = image
                imageView.startAnimating()
            } catch {
                
            }
        }
    }
    //MARK: - OnAction
    @IBAction func onBack(){
        ivBackground.image = nil
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onShare(){
        if let fileURL = self.fileURL {
            let activityVC = UIActivityViewController(
                activityItems: ["#GIF3D", fileURL],
                applicationActivities: nil)
            activityVC.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
                print("Activity: \(activityType) Success: \(completed) Items: \(returnedItems) Error: \(error)")

                if !completed {
                    // User canceled
                    return
                }
                // User completed activity
            }
            present(activityVC, animated: true, completion: nil)
        }
    }
}
