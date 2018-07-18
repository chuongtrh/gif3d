//
//  ViewController.swift
//  gif3d
//
//  Created by Sam on 7/9/18.
//  Copyright © 2018 chuongtran. All rights reserved.
//

import UIKit
import SDWebImage
//import FLAnimatedImage

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let fileURL = Bundle.main.url(forResource:"1", withExtension: "gif")

        print("fileURL:\(fileURL)")
        
        if FileManager.default.fileExists(atPath: (fileURL?.path)!){
            do {
                 let data = try Data(contentsOf: fileURL!)
                let image = UIImage.sd_animatedGIF(with: data)
                print("images:\(image?.images)")

                imageView.image = image
                
            } catch {
                
            }
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK: OnAction
    @IBAction func onNext(){
        self.performSegue(withIdentifier: "ShowEditorVCIdentifier", sender: nil)
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEditorVCIdentifier" {
            if let vc:EditorVC = segue.destination as? EditorVC {
                vc.images = imageView.image?.images
            }
        }
    }
}

