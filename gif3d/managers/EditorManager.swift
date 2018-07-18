//
//  EditorManager.swift
//  gif3d
//
//  Created by Sam on 7/11/18.
//  Copyright © 2018 chuongtran. All rights reserved.
//

import UIKit

final class EditorManager {
    // Can't init is singleton
    private init() {
        
    }
    
    //MARK: Shared Instance
    
    static let shared:EditorManager = EditorManager()
    
    //MARK: Local Variable
    var editors:[Editor] = []
    
    func setupEditor(images:[UIImage]){
        editors.removeAll()
        images.forEach { (image) in
            editors.append(Editor(image: image))
        }
    }
    
    func cleanData(){
        editors.forEach { (editor) in
            editor.image = nil
            editor.tools?.removeAll()
        }
        editors.removeAll()
    }
}
