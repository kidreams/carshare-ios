//
//  CSAPIWorker.swift
//  CarShare
//
//  Created by nicholas on 3/23/23.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

typealias SuccessBlock = ((JSON) -> ())
typealias FailureBlock = ((Error) -> ())

enum CSAPIWorkerJob {
    case request
    case response(AFDataResponse<Data>)
}

class CSAPIWorker: NSObject
{
    private
    let notificationFeedback = UINotificationFeedbackGenerator()
    
    private
    var api: CSAPI
    
    private
    var dataRequest: DataRequest?
    
    private
    var success: SuccessBlock?
    
    private
    var failure: FailureBlock?
    
    var debug: Bool
    
    // MARK: - Public
    public
    required init?(with api: CSAPI,
                   debug: Bool = true)
    {
        guard !api.endPoint.isEmpty
        else
        {
            return nil
        }
        self.api    = api
        self.debug  = debug
        print("Initializing Worker: EndPoint -> \(api.endPoint)")
        super.init()
    }
    
    @discardableResult
    public
    func prepare(indicator: Bool = true) -> Self
    {
        if (indicator)
        {
            CSActivityIndicator.shared.startLoading(in: nil)
        }
        notificationFeedback.prepare()
        return self
    }
    
    @discardableResult
    public
    func when(success: SuccessBlock?) -> Self
    {
        self.success = success
        return self
    }
    
    @discardableResult
    public
    func when(failure: FailureBlock?) -> Self
    {
        self.failure = failure
        return self
    }
    
    @discardableResult
    public
    func fire() -> Self
    {
        var headers: HTTPHeaders?
        
        if let header: [HTTPHeader] = api.header?.compactMap(
            { (key, value) in
                guard let _value: String = value as? String
                else
                {
                    return nil
                }
                return HTTPHeader(name: key as! String, value: _value)
            })
        {
            headers = HTTPHeaders(header)
        }
        let endPoint = api.endPoint
        
        let request = AF.request(
            endPoint,
            method: api.method,
            parameters: api.body as? Parameters,
            encoding: api.encoding,
            headers: headers,
            interceptor: nil,
            requestModifier: nil)
            .responseData(queue: .main,
                          completionHandler:
                            { [weak self, weak indicator = CSActivityIndicator.shared] (response) in
                                indicator?.endLoading()
                                
                                switch response.result {
                                case .success(let jsonValue):
                                    self?.handle(result: JSON(jsonValue), with: response)
                                    
                                case .failure(let error):
                                    self?.handle(error: error, with: response)
                                }
                            })
        dataRequest = request
        printDebug(job: .request)
        return self
    }
    
    public 
    func retire()
    {
        CSActivityIndicator.shared.resetIndicators()
        dataRequest?.cancel()
        dataRequest = nil
        self.success = nil
        self.failure = nil
    }
    
    
    // MARK: - Private
    private
    func handle(result: JSON,
                with response: AFDataResponse<Data>)
    {
        notificationFeedback.notificationOccurred(.success)
        printDebug(job: .response(response))
        self.success?(result)
        if let statusCode = result["statusCode"].int,
           statusCode != 200
        {
            let title: String = result["error"].stringValue
            let message = result["message"].arrayValue.first?["messages"].arrayValue.first?["message"].string
            print(result["message"].arrayValue.first?["messages"].arrayValue.first?["message"].string)
            UIApplication.topViewController()?.show(title:title, message: message)
        }
    }
    
    private
    func handle(error: Error,
                with response: AFDataResponse<Data>, retry: Bool = false)
    {
        notificationFeedback.notificationOccurred(.error)
        
        printDebug(job: .response(response))
        
        self.failure?(error)
        
        let alertController = UIAlertController(title: "Oops", message: error.localizedDescription, preferredStyle: .alert)
        
        let confirmTitle = retry ? "Retry" : "Dismiss"
        
        let cancelTitle = "Cancel"
        
        let confirm = UIAlertAction(title: confirmTitle, style: .default)
        { (action) in
            
        }
        
        alertController.addAction(confirm)
        
        if retry
        {
            let cancel = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
            alertController.addAction(cancel)
        }
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
    
    private
    func printDebug(job: CSAPIWorkerJob)
    {
        if debug
        {
            var debugMessage: String = ""
            
            switch job
            {
            case .request:
                debugMessage += "********************** API MESSAGE - FETCHING **********************"
                debugMessage += "\nBody --> \(api.body != nil ? "\n\(api.body!)" : "Empty")"
                debugMessage += "\nHeaders --> \(api.header != nil ? "\n\(api.header!)" : "Empty")"
                
            case .response(let response):
                debugMessage += "********************** API MESSAGE - RESPONSE **********************"
                switch response.result
                {
                case .success(let json):
                    debugMessage += "\nSuccess - Result --> \n\(json)"
                    
                case .failure(let error):
                    debugMessage += "\nFailure - Error --> \n\(error)"
                }
            }
            
            var encoding: String = "General"
            if api.encoding is JSONEncoding
            {
                encoding = "JSONEncoding"
            } else  if api.encoding is URLEncoding
            {
                encoding = "URLEncoding"
            }
            
            debugMessage += "\nEncoding --> \(encoding)"
            debugMessage += "\nEndpoint --> \(api.method.rawValue.uppercased()) \(api.endPoint)"
            debugMessage += "\n********************** API MESSAGE - END **********************"
            print(debugMessage)
        }
        
    }
    
    deinit
    {
        print("Deinitializing Worker: EndPoint -> \(api.endPoint)")
    }
}
