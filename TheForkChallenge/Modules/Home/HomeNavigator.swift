//
//  HomeNavigator.swift
//  TheForkChallenge
//
//  Created by Manuel Alvarez on 1/25/22.
//

import UIKit
import Photos

class HomeNavigator : BaseNavigator{

    private var navigation: UINavigationController? {
        return view?.navigationController
    }

    enum Destination {
        case getPermissions(image: UIImage), showSuccessDownloadImage
    }

    func navigate(to destination: HomeNavigator.Destination) {
        switch destination {
            case .getPermissions(let image):
                showAllowAccessPermissions(image: image)
            case .showSuccessDownloadImage:
                showDownloadImageSuccess()
                
        }
    }
    
    
    private func showAllowAccessPermissions(image: UIImage) {
        PHPhotoLibrary.requestAuthorization() { [weak self] (status) -> Void in
            switch status {
                case .authorized:
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    self?.showDownloadImageSuccess()
                default:
                    self?.showAllowPermissionsError()
                    
            }
        }
    }
    
    private func showAllowPermissionsError() {
        let alert = UIAlertController(title: "Allow Photo Access", message: "To save the image, we need access to your photo roll, please check", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
        DispatchQueue.main.async {
            self.navigation?.present(alert, animated: true, completion: nil)
        }
    }
    
    private func showDownloadImageSuccess() {
        let alert = UIAlertController(title: "Photo Downloaded", message: "Great, you can see the photo in your gallery", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.navigation?.present(alert, animated: true, completion: nil)
        }
    }
    
    
}
