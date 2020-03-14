//
//  DrawViewController.swift
//  AiBeautify
//
//  Created by aUcid on 2019/5/1.
//  Copyright © 2019 Dalian University Of Technology. All rights reserved.
//

import UIKit
import MaLiang
import UIImageColors
import Photos
import Chrysan
import FileKit
import Alamofire
import ObjectMapper
import Agrume

class DrawViewController: UIViewController,
UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    private var drawView: DrawView!
    
    private var imageFetcher: ImageFetcher!
    
    private var pencilSetting: UIBarButtonItem!
    private var undo: UIBarButtonItem!
    private var redo: UIBarButtonItem!
    private var download: UIBarButtonItem!
    private var save: UIBarButtonItem!
    private var clear: UIBarButtonItem!
    private var upload: UIBarButtonItem!
    
    private var imageTitle: String!
    private var imagePath: Path!
    private var settingPencilViewController: SettingPencilViewController!
    private var preferredSettingPencilViewSize: CGSize?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        drawView?.imageData?.getColors { (colors) in
            self.view.backgroundColor = colors?.background
        }
        self.title = imageTitle ?? "未命名"
    }
    
    public init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.drawView.imageData = image
    }
    
    public init(withPath path: Path, withImage image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        drawView = DrawView(image: image, frame: view.frame)
        self.view.addSubview(drawView)
        self.view.bringSubviewToFront(drawView.canvas)
        
        imagePath = path
        //        print(path.relativeDirectoryPath(document: "Documents"))
        imageTitle = path.components.last?.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    private func prepareBar() {
        pencilSetting = UIBarButtonItem(image: #imageLiteral(resourceName: "pencil-2"), style: .plain, target: self, action: #selector(popoverPencilSettings))
        undo = UIBarButtonItem(image: #imageLiteral(resourceName: "undo"), style: .plain, target: self, action: #selector(undoPainting))
        redo = UIBarButtonItem(image: #imageLiteral(resourceName: "redo"), style: .plain, target: self, action: #selector(redoPainting))
        download = UIBarButtonItem(image: #imageLiteral(resourceName: "download"), style: .plain, target: self, action: #selector(saveToAlbum))
        save = UIBarButtonItem(image: #imageLiteral(resourceName: "save"), style: .plain, target: self, action: #selector(saveToDirectory))
        clear = UIBarButtonItem(image: #imageLiteral(resourceName: "clear"), style: .plain, target: self, action: #selector(clearCanvas))
        upload = UIBarButtonItem(image: #imageLiteral(resourceName: "upload"), style: .plain, target: self, action: #selector(uploadToServer))
        self.navigationItem.rightBarButtonItems = [download,save,upload]
        self.navigationItem.leftBarButtonItems = [undo, redo, pencilSetting, clear]
    }
    
 
    @objc private func uploadToServer() {
        
        let alertController = UIAlertController(title: "Tips", message:"Please press this button after correctly manipulating the picture." , preferredStyle:.alert)
        let confirm = UIAlertAction(title: "Confirm", style: .default) { (action) in
            do {
                let JSONString = POSTJSON.toJSON()
                print("JSONString:\(JSONString)")
                let url = "http://39.106.33.139:5000/image/info/upload"
                let headers: HTTPHeaders = [
                    "Authorization": "Info XXX",
                    "Accept": "application/json",
                    "Content-Type" :"application/json"
                ]
                timer = Timer.init(timeInterval: 8, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
                RunLoop.current.add(timer, forMode: .default)
                AF.request(url, method: .post, parameters:JSONString, encoding: JSONEncoding.default,headers: headers).responseString { response in
                   if let responseJson = Mapper<GETURL>().map(JSONString: response.value!)
                   {
                      let responseJsonData = responseJson.data
                    PictureURLString = responseJsonData.url
                   }
                    debugPrint(response)
                    }
                
            }}
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(cancel)
    alertController.addAction(confirm)
    present(alertController, animated: true, completion: nil)
}
    
    
    @objc func timerAction()
    {
        if(!PictureURLString.isEmpty)
        {
            if let url = URL.init(string: PictureURLString)
            {
                do {
                    let data = try Data(contentsOf: url)
                    let image = UIImage(data: data)
                    saveBeautifiedPicture(image: image!)
                    let images = [image,self.drawView.imageData]
                    let agrume = Agrume(images: images as! [UIImage])
                    agrume.show(from: self)
                    timer.invalidate()
                }catch let error as NSError {
                    print(error)
                }
            }
        }
    }
    
    private func saveBeautifiedPicture(image :UIImage)
    {
        self.checkAblumAuthorized { (error) in
            guard error == nil else {
                self.alert(message: error?.localizedDescription)
                return
            }
            DispatchQueue.global(qos: .userInitiated).async
                {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }) { (succeed, error) in
                    if let error = error {
                        //self.alert(message: error.localizedDescription)
                        print(error.localizedDescription)
                    } else {
                        //self.alert(message: "Image saved to album succeeded!")
                        print("Image saved to album succeeded!")
                    }
                }
            }
        }
    }
    
    
@objc private func popoverPencilSettings() {
    if settingPencilViewController == nil {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PencilSettingViewController") as? SettingPencilViewController {
            settingPencilViewController = vc
        }
    }
    settingPencilViewController.delegate = self
    
    settingPencilViewController.preferredContentSize = preferredSettingPencilViewSize ?? CGSize(width: 260, height: 238)
    
    let nav = UINavigationController(rootViewController: settingPencilViewController)
    nav.modalPresentationStyle = UIModalPresentationStyle.popover
    nav.popoverPresentationController?.delegate = self
    nav.popoverPresentationController?.barButtonItem = pencilSetting
    settingPencilViewController.title = "Brush Setting"
    present(nav, animated: true, completion: nil)
}

@objc private func undoPainting() {
    drawView.canvas.undo()
}

@objc private func redoPainting() {
    drawView.canvas.redo()
}

@objc private func clearCanvas() {
    drawView.canvas.clear()
}

@objc private func saveToAlbum() {
        //索要授权 **
        self.checkAblumAuthorized { (error) in
            guard error == nil else {
                self.alert(message: error?.localizedDescription)
                return
            }
            self.performSavingAction()
        }
    }
    
    @objc private func saveToDirectory()
    {
        //多线程？ **
        DispatchQueue.global(qos: .userInitiated).async
            {
                let image = self.drawView.combineImage()
                let data = image.jpegData(compressionQuality: 1.0)
                
                if let url = try? FileManager.default.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: true
        ).appendingPathComponent(self.imagePath.relativeDirectoryPath(document: "Documents"))
                {
                    do {
                        //                    print(url.path)
                        try data!.write(to: url)
                        print("write sucessfully")

                    } catch let error {
                        print("could not save because \(error)")
                    }
                }
        }
    }
    
    private func performSavingAction() {
        DispatchQueue.global(qos: .userInitiated).async
            {
            PHPhotoLibrary.shared().performChanges({
                let image = self.drawView.combineImage()
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { (succeed, error) in
                if let error = error {
                    self.alert(message: error.localizedDescription)
                } else {
                    self.alert(message: "Image saved to album succeeded!")
                }
            }
        }
    }
    //模式化告警框 **
    private func alert(message: String?) {
        let alert = UIAlertController(title: "Tips", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    typealias FinishHandler = (Error?) -> ()
    
    func checkAblumAuthorized(finished: @escaping FinishHandler) {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch authorizationStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (_) in
                self.checkAblumAuthorized(finished: finished)
            }
        case .denied: alert(message: "can not access album")
        case .authorized: finished(nil)
        case .restricted:
            let error = NSError(domain: "Ablunm Authorization", code: -99, userInfo: [NSLocalizedDescriptionKey: "can not access album"])
            finished(error)
        @unknown default: break
        }
    }//索要授权 **
    
    //好像跟笔刷有关 **
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.popoverPresentationController?.delegate = self
        
        if let settingViewController = segue.destination as? SettingPencilViewController
        {
            settingViewController.delegate = self
            settingViewController.brush = drawView.canvas.currentBrush.pointSize
            settingViewController.color = drawView.canvas.currentBrush.color
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return.none
    }
    
}

extension DrawViewController: SettingPencilViewControllerDelegate
{
    func settingPencilViewControllerFinished(_ settingPencilViewController: SettingPencilViewController)
    {
        if let color = settingPencilViewController.color
        {
            drawView.canvas.currentBrush.color = color
            if color != UIColor.white {
                self.pencilSetting.tintColor = settingPencilViewController.color
            }
        }
        if let brush = settingPencilViewController.brush {
            drawView.canvas.currentBrush.pointSize = brush
        }
        
        preferredSettingPencilViewSize = settingPencilViewController.preferredContentSize.height > 238 ? CGSize(width: settingPencilViewController.preferredContentSize.width, height: 238) : settingPencilViewController.preferredContentSize
    }
}

// Feature for Fetch Image with URL
//
//private var bgImage: UIImage? {
//        set {
//            drawView.backgroundImage = newValue
//        }
//        get {
//                guard let image = self.drawView.canvas.snapshot() else {
//                    return self.drawView.imageView.image
//                }
//                let data = image.pngData()!
//                let png = UIImage(data: data)!
//                guard let combine = self.drawView.imageView.image?.overlayWith(image: png, posX: 0, posY: 0).pngData()! else { return nil }
//                return UIImage(data: combine)!
//        }
//    }

//    private var imageSaver: ImageSaver? {
//        get {
//            if let url = backgroundImageAndURL.url {
//                return ImageSaver(url: url)
//            }
//            return nil
//        }
//        set {
//            backgroundImageAndURL = (nil, nil)
//            if let url = newValue?.url {
//                imageFetcher = ImageFetcher(fetch: url) {
//                    (url, image) in DispatchQueue.main.async {
//                        self.backgroundImageAndURL = (url, image)
//                    }
//                }
//            }
//        }
//    }

//    private var bgURL: URL?
//
//    private var backgroundImageAndURL: (url: URL?, image: UIImage?) {
//        get {
//            return (bgURL, bgImage)
//        }
//        set {
//            bgURL = newValue.url
//            bgImage = newValue.image
//            drawView.imageData = bgImage
//        }
//    }
//
