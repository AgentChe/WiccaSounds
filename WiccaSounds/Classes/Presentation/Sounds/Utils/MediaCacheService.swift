//
//  MediaCacheService.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 24.04.2023.
//

import RxSwift

final class MediaCacheService {
    
    enum Error: Swift.Error {
        case internetConnection
    }
    
    func copy(urls: [URL]) -> Single<Void> {
        
        let fileManager = FileManager.default
        guard let path = try? fileManager
            .url(
                for: .cachesDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).path else {
                return .just(())
            }
        let completables = urls.map { url -> Completable in
            
            Completable.create { completable in
                guard !url.isContained else {
                    completable(.completed)
                    return Disposables.create()
                }
                
                if let data = try? Data(contentsOf: url) {
                    
                    fileManager.createFile(
                        atPath: path + "/" + url.localPath,
                        contents: data,
                        attributes: nil
                    )
                    
                    completable(.completed)
                    return Disposables.create()
                }
                
                completable(.error(Error.internetConnection))
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
        }
        
        return Completable.zip(completables)
            .andThen(Single.just(()))
    }
}
