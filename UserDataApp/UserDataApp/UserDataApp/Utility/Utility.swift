//
//  Utility.swift

import UIKit
import Photos
import UserDataAppBase

struct Utility {
    
    /// This function set empty message for UITableView by passing message.
    /// - Parameters:
    ///   - message: Empty message, That going to display when no data in UITableView (Defult: "No Result Found.")
    ///   - arr: Array which is used in displaying UITableView
    ///   - tbl: UITableView
    ///   - separatorStyle: UITableViewCell.SeparatorStyle
    static func tblEmptyMessageWithArr<T>(_ message:String = "No Result Found." , arr : Array<T>, tbl:UITableView , separatorStyle : UITableViewCell.SeparatorStyle = .none) -> Int {
        if arr.count > 0 {
            tbl.backgroundView = nil
            tbl.separatorStyle = separatorStyle
            return 1
        }
        
        let rect = CGRect(x: 0,
                          y: 0,
                          width: tbl.bounds.size.width,
                          height: tbl.bounds.size.height)
        let noDataLabel: UILabel = UILabel(frame: rect)
        
        noDataLabel.text = message
        noDataLabel.textColor = .gray
        noDataLabel.numberOfLines = 0
        noDataLabel.textAlignment = NSTextAlignment.center
        noDataLabel.font = Font.poppinsTextMedium.withSize(20)
        tbl.backgroundView = noDataLabel
        tbl.separatorStyle = .none
        return 0
    }
    /// This function set empty message for UICollectionView by passing message.
    /// - Parameters:
    ///   - message: Empty message, That going to display when no data in UICollectionView (Defult: "No Result Found.")
    ///   - arr: Array which is used in displaying UICollectionView
    ///   - cv: UICollectionView
    ///   - textAlignment: NSTextAlignment , These constants specify text alignment.
    static func cvEmptyMessageWithArr<T>(_ message:String = "No Result Found." , arr : Array<T>?, cv:UICollectionView ,textAlignment:NSTextAlignment  = .center) -> Int {
        if (arr?.count ?? 0) > 0 {
            cv.backgroundView = nil
            return 1
        }
        
        let rect = CGRect(x: 0,
                          y: 0,
                          width: cv.bounds.size.width,
                          height: cv.bounds.size.height)
        let noDataLabel: UILabel = UILabel(frame: rect)
        
        noDataLabel.text = message
        noDataLabel.textColor = .gray
        noDataLabel.numberOfLines = 0
        noDataLabel.textAlignment = textAlignment
        noDataLabel.font = Font.poppinsTextMedium.withSize(20)
        cv.backgroundView = noDataLabel
        return 0
    }


}


// MARK: - Documents Directory Clear
func clearTempFolder() {
    let fileManager = FileManager.default
    let tempFolderPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    do {
        let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
        for filePath in filePaths {
            try fileManager.removeItem(atPath: tempFolderPath + "/" + filePath)
        }
    } catch {
        print("Could not clear temp folder: \(error)")
    }
}


//MARK: - Camera Permissions Methods
func checkCameraPermissionsGranted() -> Bool {
    var cameraPermissionStatus : Bool = false
    if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
        // Already Authorized
        cameraPermissionStatus = true
        return true
    } else {
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
            if granted == true {
                cameraPermissionStatus = granted
                print("Granted access to Camera");
            } else {
                cameraPermissionStatus = granted
                print("Not granted access to Camera");
            }
        })
        return cameraPermissionStatus
    }
}

//MARK: - Photo Library Permissions Methods
func checkPhotoLibraryPermissionsGranted() -> Bool {
    var photoLibraryPermissionStatus : Bool = false
    let status = PHPhotoLibrary.authorizationStatus()
    if (status == PHAuthorizationStatus.authorized) {
        photoLibraryPermissionStatus = true
    } else if (status == PHAuthorizationStatus.denied) {
        photoLibraryPermissionStatus = false
    } else if (status == PHAuthorizationStatus.notDetermined) {
        PHPhotoLibrary.requestAuthorization({ (newStatus) in
            if (newStatus == PHAuthorizationStatus.authorized) {
                photoLibraryPermissionStatus = true
            } else {
                photoLibraryPermissionStatus = false
            }
        })
    } else if (status == PHAuthorizationStatus.restricted) {
        photoLibraryPermissionStatus = false
    }
    return photoLibraryPermissionStatus
}

//MARK: - Photo Library Permissions Methods
func saveImage(data: Data, name: String? = UUID().uuidString) -> URL? {
    
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return  nil }

       let fileName = (name ?? UUID().uuidString) + ".jpg"
       let fileURL = documentsDirectory.appendingPathComponent(fileName)

       //Checks if file exists, removes it if so.
       if FileManager.default.fileExists(atPath: fileURL.path) {
           do {
               try FileManager.default.removeItem(atPath: fileURL.path)
               print("Removed old image")
           } catch let removeError {
               print("couldn't remove file at path", removeError)
           }

       }

       do {
           try data.write(to: fileURL)
           return fileURL
       } catch let error {
           print("error saving file with error", error)
       }
    return nil
}




//MARK: - Check Device JailBreak
func isJailbroken() -> Bool {
    #if arch(i386) || arch(x86_64)
    // This is a Simulator not an idevice
    return false
    #else
    let fm = FileManager.default
    if(fm.fileExists(atPath: "/private/var/lib/apt")) {
        // This Device is jailbroken
        return true
    } else {
        // Continue the device is not jailbroken
        return false
    }
    #endif
}

//MARK: - Notification Enable/Disable Check Method
func isNotificationEnabled(completion:@escaping (_ enabled:Bool)->()) {
    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings: UNNotificationSettings) in
            let status =  (settings.authorizationStatus == .authorized)
            completion(status)
        })
    } else {
        if let status = UIApplication.shared.currentUserNotificationSettings?.types{
            let status = status.rawValue != UIUserNotificationType(rawValue: 0).rawValue
            completion(status)
        }else{
            completion(false)
        }
    }
}

//MARK: - Auto resized TableView & CollectionView
final class ContentSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

final class ContentHeightCollectionView: UICollectionView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
final class ContentWidthCollectionView: UICollectionView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: contentSize.width , height: UIView.noIntrinsicMetric)
    }
}
final class ContentSizedCollectionView: UICollectionView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: contentSize.width , height: contentSize.height)
    }
}
class ScaledHeightImageView: UIImageView {

    override var intrinsicContentSize: CGSize {

        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width

            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio

            return CGSize(width: myViewWidth, height: scaledHeight)
        }

        return CGSize(width: -1.0, height: -1.0)
    }

}


class SimpleOver: NSObject, UIViewControllerAnimatedTransitioning {

    var popStyle: Bool = false

    
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        if popStyle {

            animatePop(using: transitionContext)
            return
        }

        let fz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let tz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!

        tz.view.shadowColorView = .black
        tz.view.shadowRadiusView = 5
        tz.view.shadowOpacityView = 0.3
        
        
        let f = transitionContext.finalFrame(for: tz)
//        f = CGRect(x: f.minX, y: f.minY, width: f.width, height: f.height - 60)
        let fOff = f.offsetBy(dx: -f.width, dy: 0)
        tz.view.frame = fOff

        transitionContext.containerView.insertSubview(tz.view, aboveSubview: fz.view)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                tz.view.frame = f
        }, completion: {_ in
                transitionContext.completeTransition(true)
        })
    }

    func animatePop(using transitionContext: UIViewControllerContextTransitioning) {

        let fz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let tz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
//        fz.view.shadowColorView = .black
//        fz.view.shadowRadiusView = 5
//        fz.view.shadowOpacityView = 0.3
        let f = transitionContext.initialFrame(for: fz)
        let fOffPop = f.offsetBy(dx: -f.width, dy: 0)

        transitionContext.containerView.insertSubview(tz.view, belowSubview: fz.view)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                fz.view.frame = fOffPop
        }, completion: {_ in
                transitionContext.completeTransition(true)
        })
    }
}
