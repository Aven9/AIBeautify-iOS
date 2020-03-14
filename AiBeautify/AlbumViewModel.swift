//
//  AlbumViewModel.swift
//  AiBeautify
//
//  Created by aUcid on 2019/5/1.
//  Copyright © 2019 Dalian University Of Technology. All rights reserved.
//

import FileKit
import CollectionKit
import MaterialComponents

extension AlbumViewController {
    
    internal func prepareFileProvider() -> BasicProvider<Path, FolderCell>
    {
        //筛选 **
        let currentChildren = rootPath.children(recursive: false).filter( {
            !$0.isDirectory && $0.rawValue.hasSuffix(".photo")
        } )
        self.fileDataSource = ArrayDataSource(data: currentChildren)
        let viewSource = ClosureViewSource(viewUpdater: { (view: FolderCell, data: Path, index: Int) in
            view.label.text = data.components.last?.rawValue
            view.imageView.image = #imageLiteral(resourceName: "photo")
        })
        let sizeSource = { (index: Int, data: Path, collectionSize: CGSize) -> CGSize in
            return CGSize(width: (self.view.bounds.width - 40) / 3, height: 120)
        }
        
        let provider = BasicProvider(
            dataSource: self.fileDataSource,
            viewSource: viewSource,
            sizeSource: sizeSource,
            layout: FlowLayout(spacing: 10).inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
            tapHandler: { (context) in
                let docsName = context.data.relativeDirectoryPath(document: "Documents")
                if let url = try? FileManager.default.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: false
                    ).appendingPathComponent(docsName) {
                
                    let data = FileManager.default.contents(atPath: url.path)
                    if let image = UIImage(data: data!) {
                        let vc = DrawViewController(withPath: context.data, withImage: image)
                        let nav = UINavigationController(rootViewController: vc)
                        self.showDetailViewController(nav, sender: self)
                        
                    }
                }
            }
        )
        
        return provider
    }
    
    internal func prepareDirectoryProvider() -> BasicProvider<Path, FolderCell> {
        let currentChildren = rootPath.children(recursive: false).filter( { $0.isDirectory } )
        
        self.directoryDataSource = ArrayDataSource(data: currentChildren)
        let viewSource = ClosureViewSource(viewUpdater: { (view: FolderCell, data: Path, index: Int) in
            view.label.text = data.components.last?.rawValue
            view.imageView.image = #imageLiteral(resourceName: "folder")
        })
        let sizeSource = { (index: Int, data: Path, collectionSize: CGSize) -> CGSize in
            return CGSize(width: (self.view.bounds.width - 40) / 3, height: 120)
        }
        
        let provider = BasicProvider(
            dataSource: self.directoryDataSource,
            viewSource: viewSource,
            sizeSource: sizeSource,
            layout: FlowLayout(spacing: 10).inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)),
            tapHandler: { (context) in
                self.show(AlbumViewController(to: context.data), sender: self)
            }
        )
        
        return provider
    }

    internal func updateDataSource(at path: Path) {
        directoryDataSource = ArrayDataSource(data:
            path.children(recursive: false).filter( {
                $0.isDirectory
            } )
        )
        directoryProvider.dataSource = directoryDataSource
    }
    
    @objc internal func deleteCurrentPath() {
        do {
            try rootPath.deleteFile()
        } catch {
            print(error.localizedDescription)
        }
        self.navigationController?.popViewController(animated: true)
    }
}
