//
//  AlbumView+Photo.swift
//  AiBeautify
//
//  Created by aUcid on 2019/5/4.
//  Copyright © 2019 Dalian University Of Technology. All rights reserved.
//

import UIKit
import FileKit
import CollectionKit
import YPImagePicker

extension AlbumViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
   
    //添加新图片按钮的关联函数 **
    @objc
    internal func fromAlbum() {
        let picker = YPImagePicker(configuration: config)
        var nav = UINavigationController()
        
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                var image = UIImage()
                    if (photo.modifiedImage == nil)
                    {
                        image = photo.originalImage
                }
                    else {image = photo.modifiedImage!}
                
                var nameSet: [String?] = []
                var name = "untitle"
                
                for path in self.rootPath.children() {
                    let file = path.components.last?.rawValue
                    //? **
                    nameSet+=[file!.fileName()]
                }
                
                name = name.madeUnique(withRespectTo: nameSet as! [String])+".photo"
                
                picker.dismiss(animated: true, completion: { () -> Void in
                    
                    do {
                        try self.createFile(at: self.rootPath, name: name);
                    } catch {
                        print(error.localizedDescription)
                    }
                    self.updateFileDataSource(at: self.rootPath)
                })
                print("我出现啦")
                //?? **
                let vc = DrawViewController(withPath: self.rootPath + name, withImage: image)
                 nav = UINavigationController(rootViewController: vc)
            }
            self.ShowDetailViewController(nav: nav)
            
            //picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//            let picker = UIImagePickerController()
//            picker.delegate = self
//            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
//            self.present(picker, animated: true, completion: { () -> Void in
//            })
//        }
    }
    
    
    private func ShowDetailViewController(nav : UINavigationController)
    {
        showDetailViewController(nav, sender: self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let image = info[.originalImage] as! UIImage
        
        var nameSet: [String?] = []
        var name = "untitle"
        
        for path in self.rootPath.children() {
            let file = path.components.last?.rawValue
            //? **
            nameSet+=[file!.fileName()]
        }
        
        name = name.madeUnique(withRespectTo: nameSet as! [String])+".photo"
        
        picker.dismiss(animated: true, completion: { () -> Void in
            
            do {
                try self.createFile(at: self.rootPath, name: name);
            } catch {
                print(error.localizedDescription)
            }
            self.updateFileDataSource(at: self.rootPath)
        })
        print("我出现啦")
        //?? **
        let vc = DrawViewController(withPath: self.rootPath + name, withImage: image)
        let nav = UINavigationController(rootViewController: vc)
        showDetailViewController(nav, sender: self)
    }
    
    internal func updateFileDataSource(at path: Path) {
        let currentChildren = rootPath.children(recursive: false).filter( {
            !$0.isDirectory && $0.rawValue.hasSuffix(".photo")
        } )
        fileDataSource = ArrayDataSource(data: currentChildren)
        fileProvider.dataSource = fileDataSource
    }
    
}

extension AlbumViewController {
    internal func createFile(at path: Path, name: String) throws {
        let newPath = path + name
        try newPath.createFile()
    }
}
