//
//  CSEndPoints.swift
//  CarShare
//
//  Created by nicholas on 3/23/23.
//

import Alamofire

struct CSEndPoints: CSAPI {
    
    var baseURLString: String
    
    var targetPath: String
    
    var method: HTTPMethod
    
    var encoding: ParameterEncoding
    
    var header: CSHeaders?
    
    var body: CSBody?
    
    var debug: Bool = true
    
    init(base: String = apiURL,
         target: String,
         method: HTTPMethod = .get,
         encoding: ParameterEncoding? = nil,
         header: CSHeaders? = nil,
         body: CSBody? = nil)
    {
        self.baseURLString  = base
        self.targetPath     = target
        self.method         = method
        
        // Assign encoding type
        if let _encoding = encoding
        {
            self.encoding = _encoding
        }
        else if method == .get
        {
            self.encoding = URLEncoding.default
        } else
        {
            self.encoding = JSONEncoding.default
        }
        
        // Assign header
        self.header = CSEndPoints.defaultHeader()
        
        if let _header = header, !_header.isEmpty
        {
            self.header?.merge(_header, uniquingKeysWith: { $1 })
        }
        
        // Assign body
//        self.body = CSEndPoints.defaultBody()
        
        if let _body = body, !_body.isEmpty
        {
            self.body = CSEndPoints.defaultBody().merging(_body, uniquingKeysWith: { $1 })
        }
    }
    
    static let defaultBase: String = "https://devlab.link"
    static let subPath: String = "/api"
    static let paymentRequestSubPath: String = "/strapi-paypal"
    
    static let apiURL: String = defaultBase + subPath
    static let paymentRequestURL: String = defaultBase + paymentRequestSubPath
    
    static func defaultHeader() -> CSHeaders
    {
        var headers = CSHeaders()
        if let token = CSAuthenticator.manager.token
        {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        return headers
    }
    
    static func defaultBody() -> CSBody
    {
        return CSBody()
    }
}
