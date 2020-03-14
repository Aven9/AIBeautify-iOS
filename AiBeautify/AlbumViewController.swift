//
//  ViewController.swift
//  AiBeautify
//
//  Created by aUcid on 2019/5/1.
//  Copyright © 2019 Dalian University Of Technology. All rights reserved.
//

import UIKit
import FileKit
import CollectionKit
import MaterialComponents
import YPImagePicker
class AlbumViewController: UIViewController {
    
    
    
    var config : YPImagePickerConfiguration = YPImagePickerConfiguration()
    //let picker = YPImagePicker(configuration: config)
    
    internal var newFolder: UIBarButtonItem!
    internal var newPhoto: UIBarButtonItem!
    internal var deleteFolder: UIBarButtonItem!
    
    //属于CollectionKit **
    internal var collectionView: CollectionView!
    internal var directoryProvider: BasicProvider<Path, FolderCell>!
    internal var directoryDataSource: DataSource<Path>!
    internal var fileDataSource: DataSource<Path>!
    internal var fileProvider: BasicProvider<Path, FolderCell>!
    
    //属于FileKit **
    internal var rootPath: Path = Path(rawValue: NSHomeDirectory()) + "Documents"
    internal var titleString: String = "Home"
    
    public init(to path: Path) {
        super.init(nibName: nil, bundle: nil)
        
        rootPath = path
        titleString = path.components.last!.rawValue
        title = titleString
        
        config.showsCrop = .rectangle(ratio: 0.5)
        config.targetImageSize = .cappedTo(size: 512)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        prepareNaviItems()
        
        collectionView = CollectionView(frame: view.bounds)
        view.addSubview(collectionView)
        
        directoryProvider = prepareDirectoryProvider()
        //prepareDirectoryProvider() model里的 **
        fileProvider = prepareFileProvider()
        //prepareFileProvider() model里的 **
        collectionView.provider = ComposedProvider(animator: FadeAnimator(),
                                                   sections: [directoryProvider, fileProvider])
        collectionView.setNeedsReload()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if rootPath != Path(NSHomeDirectory()) {
            self.updateDataSource(at: rootPath)
        }
    }
    
    
    internal func prepareNaviItems() {
        newFolder = UIBarButtonItem(image: #imageLiteral(resourceName: "create_folder"), style: .plain, target: self,
                                    action: #selector(createFolderAction))
        newPhoto = UIBarButtonItem(image: #imageLiteral(resourceName: "add_photo"), style: .plain, target: self,
                                   action: #selector(fromAlbum))
        
        if rootPath != Path(NSHomeDirectory()) {
            deleteFolder = UIBarButtonItem(image: #imageLiteral(resourceName: "delete"), style: .plain, target: self, action: #selector(deleteCurrentPath))
            self.navigationItem.rightBarButtonItems = [newPhoto, newFolder, deleteFolder]
        } else {
            self.navigationItem.rightBarButtonItems = [newPhoto, newFolder]
            //不出现删除按钮 **
        }
    }
    
    //创建新目录 **
    @objc
    internal func createFolderAction() {
        let alertController = UIAlertController(title: "New Folder",
                                                message: "Input your folder name",
                                                preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Folder Name"
        }
        let confirm = UIAlertAction(title: "Finish", style: .default) { (action) in
            do {
                try self.createFolder(at: self.rootPath, name: (alertController.textFields?.first?.text!)!)
            } catch {
                
            }
            self.updateDataSource(at: self.rootPath)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        alertController.addAction(confirm)
        present(alertController, animated: true, completion: nil)
    }
}

extension AlbumViewController {
    internal func createFolder(at path: Path, name: String) throws {
        let newPath = path + name
        print(newPath)
        try newPath.createDirectory()
    }
}
