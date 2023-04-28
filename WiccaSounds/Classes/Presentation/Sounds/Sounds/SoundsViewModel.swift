//
//  SoundsViewModel.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 24.04.2023.
//

import RxSwift
import RxCocoa

final class SoundsViewModel {
    private lazy var mediaCacheService = MediaCacheService()
    private lazy var audioPlayerService = AudioPlayerService.shared
    
    func add(noises: Set<NoiseSound>) -> Completable {
        audioPlayerService.add(noises: noises)
    }
    
    var noiseVolume: Binder<(to: Int, volume: Float)> {
        audioPlayerService.rx.noiseVolume
    }
    
    func copy(url: [URL]) -> Signal<Void> {
        mediaCacheService.copy(urls: url)
            .asObservable()
            .retryWithDelay(interval: .seconds(2))
            .asSignal(onErrorSignalWith: .empty())
    }
    
    var playNoise: Binder<Void> {
        audioPlayerService.rx.playNoise
    }
}

extension Observable {
    func retryWithDelay(
        interval: RxTimeInterval,
        repeat attempts: Int = .max
    ) -> Observable<Element> {
        retry {
            $0.enumerated().flatMap  { index, error -> Observable<Int> in
                if index <= attempts {
                    return Observable<Int>
                        .timer(interval, scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
                }
                return Observable<Int>.error(error)
            }
        }
    }
}
