//
//  CSActivityIndicator.swift
//  CarShare
//
//  Created by nicholas on 3/21/23.
//

import UIKit
import NVActivityIndicatorView

final class CSActivityIndicator: NSObject
{
    private var activityIndicator: CSActivityView?
    
    private var activateViews: [CSActivityView] = []
    
    static let shared: CSActivityIndicator = {
        let indicator = CSActivityIndicator()
        return indicator
    }()
    
    override init()
    {
        super.init()
    }
    
    func startLoading(in view: UIView?,
                      with blocking: Bool = true)
    {
        DispatchQueue.main.async
        {
            var parentView: UIView?
            if let _view: UIView = view
            {
                parentView = _view
            } else if let mainWindow = UIWindow.mainWindow
            {
                parentView = mainWindow
            }
            
            guard let parentView = parentView else { return }
            
            let indicator = self.createIndicatorView()
            indicator.blocking = blocking
            self.activityIndicator = indicator
            self.activateViews.append(indicator)
            UIView.transition(with: parentView,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: { [weak parentView] in
                                parentView?.addSubview(indicator)
                              })
            indicator.startAnimating()
        }
    }
    
    func endLoading()
    {
        DispatchQueue.main.async
        {
            guard let parentView = self.activityIndicator?.superview else { return }
            if let indicator = self.activityIndicator {
                self.activateViews.removeAll(where: { $0 == indicator })
            }
            
            UIView.transition(with: parentView,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations:
                                { [weak self] in
                                    self?.activityIndicator?.removeFromSuperview()
                                })
            self.activityIndicator?.stopAnimating()
        }
    }
    
    func resetIndicators() {
        activateViews.forEach({$0.removeFromSuperview()})
        activateViews = []
    }
    
    func createIndicatorView() -> CSActivityView
    {
        let indicator = CSActivityView()
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        indicator.frame = UIScreen.main.bounds
        return indicator
    }
    
}


class CSActivityView: UIView
{
    private var activityIndicator: NVActivityIndicatorView
    
    var blocking: Bool  = true { didSet { updateBlockBehaviour() } }
    
    convenience init(frame: CGRect, blocking: Bool)
    {
        self.init(frame: frame)
        self.blocking = blocking
    }
    
    override init(frame: CGRect)
    {
        let activityView = NVActivityIndicatorView(frame: CGRect(origin: .zero,
                                                                 size: NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE),
                                                   type: .ballGridPulse,
                                                   color: UIColor(named: "TownGasColor"))
        self.activityIndicator = activityView
        super.init(frame: frame)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(activityView)
        backgroundColor = .systemBackground.withAlphaComponent(0.6)
        NSLayoutConstraint.activate([
            activityView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateBlockBehaviour()
    {
        isUserInteractionEnabled = (blocking == true)
        let color: UIColor = .systemBackground.withAlphaComponent((blocking ? 0.6 : 0.0))
        backgroundColor = color
    }
    
    
    func startAnimating()
    {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating()
    {
        activityIndicator.stopAnimating()
    }
}


extension UIWindow
{
    static var mainWindow: UIWindow? { get { UIApplication.shared.keyWindow } }
}
