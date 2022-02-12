
import UIKit

//MARK: - Images
extension UIImage {
    class func userPlaceholder() -> UIImage { return UIImage(named: "UserPlaceholder")! }
}

//MARK: - Colors
extension UIColor {
    class func StepGrayColor() -> UIColor { return UIColor(r: 196, g: 196, b: 196)}
    class func accentColor() -> UIColor { return UIColor(named: "AccentColor")!}
}

//MARK: - Font Name
public enum Font: String {
    case poppinsTextRegular                 = "Poppins-Regular"
    case poppinsTextBold                    = "Poppins-Bold"
    case poppinsTextMedium                  = "Poppins-Medium"
    case poppinsTextSemiBold                = "Poppins-SemiBold"
    
    public func withSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: rawValue, size: size)!
    }
}

public extension UIFont {
    convenience init(_ font: Font, _ size: CGFloat) {
        self.init(name: font.rawValue, size: size)!
    }
}

//MARK: - Title
enum Title {
    static let userList = "User List"
    static let addUser = "Add User Detail"
    static let editUser = "Edit User Detail"
}

//MARK: - Message's
enum AlertMessage {
    
    //In Progress Message
    static let inProgress = "In Progress"
    
    //Internet Connection Message
    static let networkConnection = "You are not connected to internet. Please connect and try again"
    
    //Camera, Images and ALbums Related Messages
    static let cameraPermission = "Please enable camera access from Privacy Settings"
    static let photoLibraryPermission = "Please enable access for photos from Privacy Settings"
    static let noCamera = "Device Has No Camera"
    
    //Webservice Fail Message
    static let error = "Something went wrong. Please try after sometime"
    
    //Camera, Images and ALbums Related Messages
    static let msgPhotoLibraryPermission = "Please enable access for photos from Privacy Settings"
    static let msgCameraPermission = "Please enable camera access from Privacy Settings"
    static let msgNoCamera = "Device Has No Camera"
    
    // Validation messages
    static let name = "Please enter name"
    static let username = "Please enter username"
    static let email = "Please enter email"
    static let validEmail = "Please enter valid email"
    static let phone = "Please enter phone"
    static let validPhone = "Please enter valid phone"
    static let website = "Please enter website"
    static let pickLocation = "Please pick address location"
    static let suite = "Please enter suite"
    static let street = "Please enter street"
    static let city = "Please enter city"
    static let zipcode = "Please enter zipcode"
    static let companyName = "Please enter company name"
    static let catchPhrase = "Please enter catch phrase"
    static let bs = "Please enter bs"
    
}

//MARK: - Web Service URLs
enum WebServiceURL {

    static let mainURL = "https://jsonplaceholder.typicode.com/"
    
    static let users = mainURL + "users"
    
}

//MARK: -  NotificationCenter
enum AppNotificationCenter {
    static let selectedAddressChanged = Notification.Name("selectedAddressChanged")
}


//MARK: - Framework Keys
enum GlobalKeys {
    static let razorPayKey = ""
}
//MARK: - UserDefault
enum UserDefaultKeys {
    static let isUserDataLoaded = "isUserDataLoaded"
    static let deviceToken = "deviceToken"
    static let isTesting = "isTesting"
}
//MARK: - KeychainKeys
enum KeychainKeys {
    static let email = "email"
    static let pass = "pass"
}
