//
//  BaseClases.swift
//  TheForkChallenge
//
//  Created by Manuel Alvarez on 1/25/22.
//

import Foundation
import UIKit

enum AnimationType: String {
    case loader = "loader"
}

    // MARK: - Base ViewController
class BaseViewController: UIViewController {
    
    var animationName: AnimationType = .loader
    
    var baseViewModel: BaseViewModel?  {
        return nil
    }
    
    private var loaderAnimator: LoaderAnimator = LoaderAnimatorAdapter.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        genericBind()
        baseViewModel?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        baseViewModel?.viewDidAppear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        baseViewModel?.viewWillAppear()
    }
    
    private func genericBind() {
        baseViewModel?.isLoadingObservable.observeChanges(on: self) { [weak self ] (bool) in
            bool ? self?.showLoadingView() : self?.hideLoadingView()
        }
    }
    
    private func showLoadingView() {
        if let window = UIApplication.shared.keyWindow {
            loaderAnimator.show(view: window, name: baseViewModel?.animationName ?? .loader )
        }
    }

    private func hideLoadingView() {
        self.loaderAnimator.hide()
    }
    
    func setupToEndEditingOnTap(delegate: UIGestureRecognizerDelegate? = nil) {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(view.finishEditing))
        tap.cancelsTouchesInView = false
        tap.delegate = delegate
        view.addGestureRecognizer(tap)
    }
}

    // MARK: - BaseViewModel
protocol BaseViewModel {
    func viewDidLoad()
    func viewDidAppear()
    func viewWillAppear()
    var isLoadingObservable: TheForkObservableWhenValueChange<Bool> { get }
    var animationName: AnimationType { get }
}

class BaseViewModelImplementation: NSObject, BaseViewModel {
    var isLoadingObservable = TheForkObservableWhenValueChange<Bool>(false)
    
    var animationName: AnimationType = .loader
    
    func viewWillAppear() {}
    func viewDidLoad() {}
    func viewDidAppear() {}
}

    // MARK: - Base Navigator

class BaseNavigator {
    weak var view: UIViewController?
    
}
