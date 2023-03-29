//
//  CSAPI.swift
//  CarShare
//
//  Created by nicholas on 3/23/23.
//

import UIKit
import Alamofire

typealias CSHeaders = [AnyHashable: Any]
typealias CSBody = [AnyHashable: Any]

protocol CSAPI
{
    var baseURLString:  String { get }
    var targetPath:     String { get }
    var method:         HTTPMethod { get }
    var encoding:       ParameterEncoding { get set }
    var header:         CSHeaders? { get set }
    var body:           CSBody? { get set }
}

extension CSAPI
{
    var endPoint: String { baseURLString + targetPath }
}

