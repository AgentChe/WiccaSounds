//
//  AudioPlayerService.swift
//  SleepWell
//
//  Created by Alexander Mironov on 25/10/2019.
//  Copyright © 2019 Andrey Chernyshev. All rights reserved.
//

import AVFoundation
import RxSwift
import RxCocoa
import MediaPlayer

enum PlayAndPauseStyle {
    case force
    case gentle
}

final class AudioPlayerService: ReactiveCompatible {
    
    static let shared = AudioPlayerService()
    
    func add(noises: Set<NoiseSound>) -> Completable {
        let currentIds = Set(noiseRelay.value?.audioPlayers.map { $0.id } ?? [])
        let addedIds = Set(noises.map { $0.id })
        let filtered = currentIds.intersection(addedIds)
        let removed = currentIds.subtracting(filtered)
        let newIds = addedIds.subtracting(filtered)
        noiseRelay.value?.remove(ids: removed)
        
        let newPlayers = noises.filter { newIds.contains($0.id) }
            .compactMap { noise -> AudioPlayer? in
                guard let player = try? AVAudioPlayer(contentsOf: noise.soundUrl.localUrl) else {
                    assertionFailure("There is no local file")
                    return nil
                }
                return AudioPlayer(player: player, id: noise.id)
            }
        
        if let value = noiseRelay.value {
            value.add(audioPlayers: newPlayers)
            noiseRelay.accept(value)
        } else {
            noiseRelay.accept(NoiseAudio(audioPlayers: newPlayers))
        }
        
        noiseRelay.value?.play()
        
        return .empty()
    }
    
    func pauseNoise() -> Signal<Void> {
        noiseRelay.value?.pause() ?? .just(())
    }
    
    var isNoisePlaying: Driver<Bool> {
        
        noiseRelay.asDriver()
            .flatMapLatest {
                $0?.isPlaying ?? .just(false)
            }
    }
    
    fileprivate let noiseRelay = BehaviorRelay<NoiseAudio?>(value: nil)
    fileprivate let audioType = BehaviorRelay<AudioType>(value: .none)
    fileprivate let disposeBag = DisposeBag()
    private let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
    
    private init() {
        let isSoundsEmpty = noiseRelay.asDriver()
            .map { $0 == nil }
            .filter { $0 }
            .map { _ in AudioType.none }
        
        Driver<AudioType>
            .merge(
                isSoundsEmpty,
                isNoisePlaying.filter { $0 }.map { _ in .noise }
            )
            .distinctUntilChanged()
            .drive(audioType)
            .disposed(by: disposeBag)
        
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        setupRemoteTransportControls()
        
        Driver
            .combineLatest(
                noiseRelay.asDriver(),
                audioType.asDriver()
            )
            .map { noise, type -> [String: Any] in
                switch type {
                case .noise where noise != nil:
                    let commandCenter = MPRemoteCommandCenter.shared()
                    commandCenter.skipForwardCommand.isEnabled = false
                    commandCenter.skipBackwardCommand.isEnabled = false
                    
                    let nowPlayingInfo: [String: Any] = [
                        MPMediaItemPropertyTitle: "Noise"
                    ]
                    
                    return nowPlayingInfo
                default:
                    return [:]
                }
            }
            .drive(Binder(self) { base, info in
                base.nowPlayingInfoCenter.nowPlayingInfo = info
                if info.isEmpty {
                    base.noiseRelay.value?.forcePause()
                    try? AVAudioSession.sharedInstance().setActive(
                        false,
                        options: .notifyOthersOnDeactivation
                    )
                } else {
                    try? AVAudioSession.sharedInstance().setActive(
                        true,
                        options: .notifyOthersOnDeactivation
                    )
                }
            })
            .disposed(by: disposeBag)
    }
}

private extension AudioPlayerService {
    enum AudioType {
        case noise
        case none
    }
}

private extension AudioPlayerService {
    
    func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand
            .addTarget { [weak self] _ in
                if
                    let self = self,
                    let noise = self.noiseRelay.value,
                    !noise._isPlaying
                {
                    noise.play()
                    return .success
                }
                return .commandFailed
            }

        commandCenter.pauseCommand
            .addTarget { [weak self] _ in
                if
                    let self = self,
                    let noise = self.noiseRelay.value,
                    noise._isPlaying
                {
                    noise.forcePause()
                    return .success
                }
                return .commandFailed
            }
        
        commandCenter.previousTrackCommand.isEnabled = false
        commandCenter.nextTrackCommand.isEnabled = false
    }
}

extension Reactive where Base: AudioPlayerService {
    var playNoise: Binder<Void> {
        Binder(base) { base, _ in
            base.noiseRelay.value?.play()
        }
    }
    
    var noiseVolume: Binder<(to: Int, volume: Float)> {
        Binder(base) { base, tuple in
            base.noiseRelay.value?.setVolume(to: tuple.to, value: tuple.volume)
        }
    }
}
