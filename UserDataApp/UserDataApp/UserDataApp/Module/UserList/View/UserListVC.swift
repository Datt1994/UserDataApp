//
//  UserListVC.swift
//  UserDataApp
//
//  Created by Datt Patel on 11/02/22.
//

import UIKit
import UserDataAppBase
import SnapKit
import RxSwift
import RxCocoa
import NSObject_Rx
import RxDataSources

class UserListVC: BaseViewController, UIScrollViewDelegate {
    
    private let userListTableView = UITableView()
    private let addUserView = UIView()
    
    private let viewModel = UserListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        apiCall()
        bindUI()
        uiActions()
    }
    
}

//MARK: Private methods
private extension UserListVC {
    func setUpUI() {
        view.backgroundColor = .black
        // Setup NavigationBar
        let resetButtonItem = UIBarButtonItem.init(
            title: "Reset",
            style: .done,
            target: self,
            action: #selector(resetButtonAction(sender:))
        )
        self.navigationItem.rightBarButtonItem = resetButtonItem
        
        title = Title.userList
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Setup TableView
        userListTableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.cellId)
        userListTableView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
        view.addSubview(userListTableView)
        userListTableView.rowHeight = 82
        
        userListTableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(view)
        }
        
        // Setup TableView
        addUserView.backgroundColor = .accentColor().withAlphaComponent(0.7)
        view.addSubview(addUserView)
        
        let addUserlabel = UILabel()
        addUserlabel.text = "User"
        addUserlabel.font = Font.poppinsTextRegular.withSize(15)
        addUserlabel.textAlignment = .center
        addUserView.addSubview(addUserlabel)
        
        let smallConfiguration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: "plus",withConfiguration: smallConfiguration)
        let addUserImageView = UIImageView(image: image)
        addUserImageView.tintColor = .white
        addUserView.addSubview(addUserImageView)
        
        addUserView.snp.makeConstraints { make in
            make.height.width.equalTo(70)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        addUserlabel.snp.makeConstraints { make in
            make.centerX.equalTo(addUserView)
            make.centerY.equalTo(addUserView).offset(10)
        }
        
        addUserImageView.snp.makeConstraints { make in
            make.centerX.equalTo(addUserView)
            make.centerY.equalTo(addUserView).offset(-10)
        }
        
        addUserView.isCircle = true
    }
    
    func apiCall() {
        viewModel.getUserApi(self.view) { [weak self] error in
            if let error = error {
                self?.view.makeToast(error)
                return
            }
        }
    }
    
    func bindUI() {
        // Display Data
        viewModel.users
            .flatMap({ req -> Observable<[UserSection]> in
                return Observable.just([UserSection(header: "Users", users: req)])
            })
            .bind(to: userListTableView.rx.items(dataSource: dataSource()))
            .disposed(by: rx.disposeBag)
        
        // Delete row
        userListTableView.rx.itemDeleted.asDriver()
            .drive(onNext: { [weak self] indexPath in
                // remove from coredata
                self?.viewModel.users.value[indexPath.row].value?.destroy()
                // remove from table
                self?.viewModel.users.remove(at: indexPath.row)
            }).disposed(by: rx.disposeBag)
        
        // select row
        userListTableView.rx.itemSelected.asDriver()
            .drive(onNext: { [weak self] indexPath in
                let objAddEditUserVC = AddEditUserVC()
                objAddEditUserVC.isEdit = true
                if let user = self?.viewModel.users.value[indexPath.row] {
                    objAddEditUserVC.viewModel.user = user
                }
                self?.navigationController?.pushViewController(objAddEditUserVC)
                self?.userListTableView.deselectRow(at: indexPath, animated: true)
            }).disposed(by: rx.disposeBag)
        
    }
    
    func uiActions() {
        // add new user button action
        addUserView.addTapGestureRecognizer { [weak self] in
            let objAddEditUserVC = AddEditUserVC()
            objAddEditUserVC.viewModel.user = BehaviorRelay.init(value: nil)
            self?.navigationController?.pushViewController(objAddEditUserVC)
            objAddEditUserVC.viewModel.user.asDriver().drive(onNext: { [weak self] user in
                guard let user = user else { return }
                self?.viewModel.users.add(BehaviorRelay.init(value: user))
            }).disposed(by: objAddEditUserVC.rx.disposeBag)
        }
    }
    
    // Tableview dataSource
    func dataSource() -> RxTableViewSectionedAnimatedDataSource<UserSection> {
        return RxTableViewSectionedAnimatedDataSource(
            animationConfiguration: AnimationConfiguration(insertAnimation: .top,
                                                           reloadAnimation: .fade,
                                                           deleteAnimation: .left),
            configureCell: { (dataSource, table, idxPath, item) in
                let cell = table.dequeueReusableCell(withIdentifier: UserTableViewCell.cellId, for: idxPath) as! UserTableViewCell
                item.asDriver().drive(onNext: { [weak cell] user in
                    cell?.userNameLabel.text = user?.name
                    cell?.userImageView.image = UIImage.userPlaceholder()
                    if let imagepath =  user?.imagepath, imagepath.count > 0 {
                        cell?.userImageView.image = UIImage.load(filePath: imagepath)
                    }
                }).disposed(by: self.rx.disposeBag)
                
                return cell
            },
            canEditRowAtIndexPath: { _, _ in
                return true
            }
        )
    }
    
    @objc func resetButtonAction(sender: UIBarButtonItem) {
        viewModel.resetApp(view)
    }
    
}

//MARK: Public methods
extension UserListVC {
    
    
}
