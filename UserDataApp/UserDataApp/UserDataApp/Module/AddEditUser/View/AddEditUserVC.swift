//
//  AddEditUserVC.swift
//  UserDataApp
//
//  Created by Datt Patel on 12/02/22.
//

import UIKit
import UserDataAppBase
import SkyFloatingLabelTextField
import PhoneNumberKit
import IQKeyboardManagerSwift
import MapKit
import LocationPicker
import RxSwift


class AddEditUserVC: BaseViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = IQPreviousNextView()
    
    private let userProfileImageView = UIImageView()
    private let nameTextField = SkyFloatingLabelTextField()
    private let usernameTextField = SkyFloatingLabelTextField()
    private let emailTextField = SkyFloatingLabelTextField()
    private let phoneTextField = PhoneNumberTextField()
    private let websiteTextField = SkyFloatingLabelTextField()
    
    private let mapView = MKMapView()
    private let changeAddressButton = UIButton(type: .system)
    private let streetTextField = SkyFloatingLabelTextField()
    private let suiteTextField = SkyFloatingLabelTextField()
    private let cityTextField = SkyFloatingLabelTextField()
    private let zipcodeTextField = SkyFloatingLabelTextField()
    
    private let companyNameTextField = SkyFloatingLabelTextField()
    private let catchPhraseTextField = SkyFloatingLabelTextField()
    private let bsTextField = SkyFloatingLabelTextField()
    
    private let saveButton = UIButton(type: .system)
    
    private var location: Location?
    
    
    var isEdit = false
    var viewModel = AddEditUserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        bindUI()
        uiActions()
    }

}
//MARK: Private methods
private extension AddEditUserVC {
    func setUpUI() {
        title = isEdit ? Title.editUser : Title.addUser
        view.backgroundColor = .black
        
        // Setup scroll view
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        // Setup user profile
        userProfileImageView.image = UIImage.userPlaceholder()
        userProfileImageView.contentMode = .scaleAspectFill
        userProfileImageView.isCircle = true
        contentView.addSubview(userProfileImageView)
        
        userProfileImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.height.width.equalTo(150)
            make.centerX.equalTo(contentView)
        }
        
        // Setup user info
        nameTextField.placeholder = "Name"
        nameTextField.textContentType = .name
        usernameTextField.placeholder = "Username"
        usernameTextField.textContentType = .username
        emailTextField.placeholder = "Email"
        emailTextField.textContentType = .emailAddress
        emailTextField.keyboardType = .emailAddress
        websiteTextField.placeholder = "Website"
        websiteTextField.textContentType = .URL
        websiteTextField.keyboardType = .URL
        phoneTextField.withPrefix = true
        phoneTextField.withFlag = true
        phoneTextField.withExamplePlaceholder = true
        phoneTextField.withDefaultPickerUI = true
        phoneTextField.bottomLineColor = .gray
        phoneTextField.bottomLineWidth = 1
        phoneTextField.textContentType = .telephoneNumber
        
        let userDetailStackView = UIStackView(arrangedSubviews: [nameTextField, usernameTextField, emailTextField, phoneTextField, websiteTextField])
        userDetailStackView.subviews.forEach { textField in
            if let textField = textField as? SkyFloatingLabelTextField {
                textField.selectedTitleColor = .white
                textField.selectedLineColor = .white
            }
        }
        userDetailStackView.axis = .vertical
        userDetailStackView.distribution = .fillEqually
        userDetailStackView.spacing = 16
        
        
        contentView.addSubview(userDetailStackView)
        
        nameTextField.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
        
        userDetailStackView.snp.makeConstraints { make in
            make.top.equalTo(userProfileImageView.snp.bottom).offset(20)
            make.leading.equalTo(contentView).offset(22)
            make.trailing.equalTo(contentView).inset(22)
        }
        
        
        // Setup address view
        let addressView = UIView()
        
        let addressLabel = UILabel()
        addressLabel.font = Font.poppinsTextSemiBold.withSize(25)
        addressLabel.text = "Address"
        
        changeAddressButton.titleLabel?.font = Font.poppinsTextMedium.withSize(16)
        changeAddressButton.setTitle("Change", for: .normal)
        
        contentView.addSubview(addressView)
        addressView.addSubview(addressLabel)
        addressView.addSubview(changeAddressButton)
        addressView.addSubview(mapView)
        
        
        addressView.snp.makeConstraints { make in
            make.top.equalTo(userDetailStackView.snp.bottom).offset(30)
            make.leading.equalTo(contentView).offset(22)
            make.trailing.equalTo(contentView).inset(22)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(addressView)
        }
        
        changeAddressButton.snp.makeConstraints { make in
            make.trailing.equalTo(addressView)
            make.centerY.equalTo(addressLabel)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(addressView).offset(50)
            make.height.equalTo(200)
            make.leading.trailing.bottom.equalTo(addressView)
        }
        
        
        // Setup address info
        suiteTextField.placeholder = "Suite"
        streetTextField.placeholder = "Street"
        streetTextField.textContentType = .fullStreetAddress
        cityTextField.placeholder = "City"
        cityTextField.textContentType = .addressCity
        zipcodeTextField.placeholder = "Zipcode"
        zipcodeTextField.textContentType = .postalCode
        zipcodeTextField.keyboardType = .numberPad
        
        let cityZipStackView = UIStackView(arrangedSubviews:[cityTextField, zipcodeTextField])
        cityZipStackView.subviews.forEach { textField in
            if let textField = textField as? SkyFloatingLabelTextField {
                textField.selectedTitleColor = .white
                textField.selectedLineColor = .white
            }
        }
        cityZipStackView.distribution = .fillEqually
        cityZipStackView.spacing = 16
        let addressStackView = UIStackView(arrangedSubviews: [suiteTextField, streetTextField, cityZipStackView])
        addressStackView.subviews.forEach { textField in
            if let textField = textField as? SkyFloatingLabelTextField {
                textField.selectedTitleColor = .white
                textField.selectedLineColor = .white
            }
        }
        addressStackView.axis = .vertical
        addressStackView.distribution = .fillEqually
        addressStackView.spacing = 16
        
        contentView.addSubview(addressStackView)
        
        streetTextField.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
        
        addressStackView.snp.makeConstraints { make in
            make.top.equalTo(addressView.snp.bottom).offset(12)
            make.leading.equalTo(contentView).offset(22)
            make.trailing.equalTo(contentView).inset(22)
        }
        
        // Setup company info
        
        let companyLabel = UILabel()
        companyLabel.font = Font.poppinsTextSemiBold.withSize(25)
        companyLabel.text = "Company Info"
        
        contentView.addSubview(companyLabel)
        
        companyLabel.snp.makeConstraints { make in
            make.top.equalTo(addressStackView.snp.bottom).offset(35)
            make.leading.equalTo(contentView).offset(22)
            make.trailing.equalTo(contentView).inset(22)
        }
        
        companyNameTextField.placeholder = "Name"
        companyNameTextField.textContentType = .organizationName
        catchPhraseTextField.placeholder = "Catch Phrase"
        bsTextField.placeholder = "bs"
        
        let companyStackView = UIStackView(arrangedSubviews: [companyNameTextField, catchPhraseTextField, bsTextField])
        companyStackView.subviews.forEach { textField in
            if let textField = textField as? SkyFloatingLabelTextField {
                textField.selectedTitleColor = .white
                textField.selectedLineColor = .white
            }
        }
        companyStackView.axis = .vertical
        companyStackView.distribution = .fillEqually
        companyStackView.spacing = 16
        
        contentView.addSubview(companyStackView)
        
        companyNameTextField.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
        
        companyStackView.snp.makeConstraints { make in
            make.top.equalTo(companyLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentView).offset(22)
            make.trailing.equalTo(contentView).inset(22)
            make.bottom.equalTo(contentView).inset(100)
        }
        
        
        saveButton.titleLabel?.font = Font.poppinsTextMedium.withSize(22)
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .accentColor()
        saveButton.tintColor = .white
        saveButton.cornerRadiusView = 8
        saveButton.shadowColorView = .black
        saveButton.shadowRadiusView = 10
        saveButton.shadowOpacityView = 0.5
        saveButton.shadowOffsetSizeView = CGSize(width: 0, height: 2)
        
        view.addSubview(saveButton)
        
        saveButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(22)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(22)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(60)
        }
    }
    
    func bindUI() {
        // Bind TextField
        nameTextField.rx.text.orEmpty.bind(to: viewModel.name).disposed(by: rx.disposeBag)
        usernameTextField.rx.text.orEmpty.bind(to: viewModel.username).disposed(by: rx.disposeBag)
        emailTextField.rx.text.orEmpty.bind(to: viewModel.email).disposed(by: rx.disposeBag)
        phoneTextField.rx.text.orEmpty.bind(to: viewModel.phone).disposed(by: rx.disposeBag)
        websiteTextField.rx.text.orEmpty.bind(to: viewModel.website).disposed(by: rx.disposeBag)
        suiteTextField.rx.text.orEmpty.bind(to: viewModel.suite).disposed(by: rx.disposeBag)
        streetTextField.rx.text.orEmpty.bind(to: viewModel.street).disposed(by: rx.disposeBag)
        cityTextField.rx.text.orEmpty.bind(to: viewModel.city).disposed(by: rx.disposeBag)
        zipcodeTextField.rx.text.orEmpty.bind(to: viewModel.zipcode).disposed(by: rx.disposeBag)
        companyNameTextField.rx.text.orEmpty.bind(to: viewModel.companyName).disposed(by: rx.disposeBag)
        catchPhraseTextField.rx.text.orEmpty.bind(to: viewModel.catchPhrase).disposed(by: rx.disposeBag)
        bsTextField.rx.text.orEmpty.bind(to: viewModel.bs).disposed(by: rx.disposeBag)
        
        // Display Data
        viewModel.user.asDriver().drive(onNext: { [weak self] user in
            guard let self = self, let user = user else { return }
            self.nameTextField.text = user.name
            self.usernameTextField.text = user.username
            self.emailTextField.text = user.email
            self.phoneTextField.text = user.phone?.components(separatedBy: " x").first
            self.phoneTextField.updateFlag()
            self.websiteTextField.text = user.website
            
            self.viewModel.imagepath.accept(user.imagepath ?? "")
            self.viewModel.lng.accept(user.address?.geo?.lng ?? "")
            self.viewModel.lat.accept(user.address?.geo?.lat ?? "")
            
            self.viewModel.getPlacemarkFromLatLon(CLLocation(latitude: user.address?.geo?.lat?.double ?? 0.0, longitude: user.address?.geo?.lng?.double ?? 0.0)) { [weak self] placemark in
                self?.location = Location(name: user.address?.city, placemark: placemark)
            }
            
            self.suiteTextField.text = user.address?.suite
            self.streetTextField.text = user.address?.street
            self.cityTextField.text = user.address?.city
            self.zipcodeTextField.text = user.address?.zipcode
            
            self.companyNameTextField.text = user.company?.name
            self.catchPhraseTextField.text = user.company?.catchPhrase
            self.bsTextField.text = user.company?.bs
            
            
            _ = self.view.getAllTextFields().map { $0.sendActions(for: .valueChanged) }
        }).disposed(by: rx.disposeBag)
        
        // Bind Map View
        Observable.combineLatest(viewModel.lat, viewModel.lng)
            .subscribe { [weak self] lat, lng in
                self?.changeAddressButton.setTitle(lat.count == 0 ? "Pick" : "Change", for: .normal)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat.double ?? 23.0225, longitude: lng.double ?? 72.5714)
                let center = annotation.coordinate
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
                self?.mapView.setRegion(region, animated: true)
                self?.mapView.removeAnnotations(self?.mapView.annotations ?? [])
                guard lat.count != 0 else { return }
                self?.mapView.addAnnotation(annotation)
            }.disposed(by: rx.disposeBag)
        
        // Bind Profile Image
        viewModel.imagepath.asDriver().drive(onNext: { [weak self] imagepath in
            if imagepath.count == 0 {
                self?.userProfileImageView.image = UIImage.userPlaceholder()
            } else {
                self?.userProfileImageView.image = UIImage.load(filePath: imagepath)
            }
        }).disposed(by: rx.disposeBag)
        
    }
    
    func uiActions() {
        // Address Change Button Action
        changeAddressButton.action { [weak self] button in
            let locationPicker = LocationPickerViewController()
            locationPicker.location = self?.location
            locationPicker.showCurrentLocationButton = true
            locationPicker.useCurrentLocationAsHint = true
            locationPicker.selectCurrentLocationInitially = true
            locationPicker.title = "Pick Location"
            locationPicker.completion = { [weak self] location in
                self?.location = location
                self?.viewModel.lng.accept("\(location?.coordinate.longitude ?? 0.0)")
                self?.viewModel.lat.accept("\(location?.coordinate.latitude ?? 0.0)")
                self?.suiteTextField.text = location?.placemark.name
                self?.streetTextField.text = location?.placemark.thoroughfare ?? location?.placemark.subLocality
                self?.cityTextField.text = location?.placemark.locality
                self?.zipcodeTextField.text = location?.placemark.postalCode
                _ = self?.view.getAllTextFields().map { $0.sendActions(for: .valueChanged) }
            }
            self?.navigationController?.pushViewController(locationPicker)
        }
        
        // Save Button Action
        saveButton.action { [weak self] button in
            guard let self = self else { return }
            switch self.viewModel.saveData(image: self.userProfileImageView.image) {
            case .valid:
                self.popVC()
            case .invalid(let error):
                self.view.makeToast(error)
            }
        }
        
        // Profile image tap
        userProfileImageView.addTapGestureRecognizer { [weak self] in
            self?.takeAndChoosePhoto(true) { [weak self] removeAction in
                self?.userProfileImageView.image = UIImage.userPlaceholder()
                self?.viewModel.profileImageChanges = .remove
            }
        }
    }
    
}
//MARK: ChoosePicture, UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension AddEditUserVC: ChoosePicture, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage : UIImage!
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            newImage = possibleImage
        }
        else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            newImage = possibleImage
        }
        guard newImage != nil else {
            picker.dismiss(animated: true)
            return
        }
        let orientationFixedImage = newImage.fixOrientation()
        viewModel.profileImageChanges = .new
        userProfileImageView.image = orientationFixedImage
        
        picker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
