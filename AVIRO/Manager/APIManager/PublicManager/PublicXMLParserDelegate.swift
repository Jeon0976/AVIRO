//
//  XMLParserDelegate.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/28.
//

import Foundation

class PublicXMLParserDelegate: NSObject, XMLParserDelegate {
    
    var results = PublicAddressDTO(juso: [])
    var currentElement: String?
    var currentJuso: Juso?
    var currentData: String = ""
    
    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String: String] = [:]
    ) {
        currentElement = elementName
        
        if elementName == "juso" {
            currentJuso = Juso()
        }
    }
    
    func parser(
        _ parser: XMLParser,
        foundCharacters string: String
    ) {
        currentData = string
    }
    
    func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?
    ) {
        switch elementName {
        case "totalCount":
            results.totalCount = currentData
        case "currentPage":
            results.currentPage = currentData
        case "roadAddr":
            currentJuso?.roadAddr = currentData
        case "jibunAddr":
            currentJuso?.jibunAddr = currentData
        case "zipNo":
            currentJuso?.zipNo = currentData
        case "juso":
            if let juso = currentJuso {
                results.juso.append(juso)
            }
        default:
            break
        }
        
        currentData = ""
    }
}
