//
//  ArchiveViewModel.swift
//  sekolahmu_test
//
//  Created by macbook on 19/03/22.
//

import Foundation

class ArchiveViewModel {
    // Closure
    var reloadArchiveClosure: ((_ isSuccess: Bool, _ message: String) -> ())?
    // Archive Request
    var archiveRequest = ArchiveRequest()
    var arrAchive: [Archive]?
    
    // Request data
    func archiveDataRequest(year: String, month: String) {
        archiveRequest.url = "\(Endpoints.News.archive.url)/\(year)/\(month).json"
        archiveRequest.prepare(requestHandler: self)
        archiveRequest.start()
    }
    
    // save data to variable
    func getArchiveData(completion: ((_ data: [Archive]) -> Void)) {
        let data = self.arrAchive ?? []
        completion(data)
    }
}

// Request Delegate
extension ArchiveViewModel: ArchiveRequestDelegate {
    func ArchiveRequestSuccess(_ archiveList: ArchiveList) {
        self.arrAchive = archiveList.arrArchive
        
        print("arrArchiveRESULT \(archiveList.arrArchive.toJSON())")
        self.reloadArchiveClosure?(true, "")
    }
    
    func ArchiveRequestFailed(_ message: String) {
        self.reloadArchiveClosure?(false, message)
    }
}
