//
//  ProfileManager.swift
//  Soccer
//
//  Created by Андрей Чернышев on 05.07.2022.
//

import RxSwift

protocol ProfileManagerProtocol {
    func set(skillLevelId: Int?,
             weekSchedule: WeekSchedule?,
             drillsIds: [Int]?,
             focusZonesIds: [Int]?) -> Single<Void>
    func obtainProfile(forceUpdate: Bool) -> Single<Profile?>
    func syncTokens(oldToken: String, newToken: String) -> Single<Void>
    func login(userToken: String) -> Single<Void>
}

final class ProfileManager {
    enum Constants {
        static let skillLevelId = "profile_manager_skill_level_id_key"
        static let weekSchedule = "profile_manager_week_schedule_key"
        static let drillsIds = "profile_manager_drills_ids_key"
        static let focusZonesIds = "profile_manager_focus_zones_ids_key"
    }
    
    private lazy var defaultRequestWrapper = DefaultRequestWrapper()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: ProfileManagerProtocol
extension ProfileManager: ProfileManagerProtocol {
    func set(skillLevelId: Int? = nil,
             weekSchedule: WeekSchedule? = nil,
             drillsIds: [Int]? = nil,
             focusZonesIds: [Int]? = nil) -> Single<Void> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let weekScheduleDays = weekSchedule.map { weekSchedule -> [Int] in
            [
                weekSchedule.su ? 0 : nil,
                weekSchedule.mo ? 1: nil,
                weekSchedule.tu ? 2 : nil,
                weekSchedule.we ? 3 : nil,
                weekSchedule.th ? 4 : nil,
                weekSchedule.fr ? 5 : nil,
                weekSchedule.sa ? 6 : nil
            ].compactMap { $0 }
        }
        
        let timezone = TimeZone.current.secondsFromGMT()
        
        let request = SetRequest(
            userToken: userToken,
            skillLevel: skillLevelId,
            weekSchedule: weekScheduleDays,
            drills: drillsIds,
            focusZones: focusZonesIds,
            timezone: String(timezone)
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
            .do(onSuccess: { [weak self] in
                self?.store(skillLevelId: skillLevelId)
                self?.store(weekSchedule: weekSchedule)
                self?.store(drillsIds: drillsIds)
                self?.store(focusZonesIds: focusZonesIds)
            })
    }
    
    func obtainProfile(forceUpdate: Bool) -> Single<Profile?> {
        forceUpdate ? loadProfile() : cachedProfile()
    }
    
    func syncTokens(oldToken: String, newToken: String) -> Single<Void> {
        let request = SyncTokensRequest(oldToken: oldToken,
                                        newToken: newToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
    
    func login(userToken: String) -> Single<Void> {
        let request = LoginRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
}

// MARK: Private
private extension ProfileManager {
    func loadProfile() -> Single<Profile?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetProfileRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetProfileResponse.map(from: $0) }
            .do(onSuccess: { [weak self] profile in
                self?.store(skillLevelId: profile?.skillLevelId)
                self?.store(weekSchedule: profile?.weekSchedule)
                self?.store(drillsIds: profile?.drillsIds)
                self?.store(focusZonesIds: profile?.focusZonesIds)
            })
    }
    
    func cachedProfile() -> Single<Profile?> {
        Single
            .zip(
                cachedSkillLevelId(),
                cachedWeekSchedule(),
                cachedDrillsIds(),
                cachedFocusZonesIds()
            )
            .map { skillLevelId, weekSchedule, drillsIds, focusZonesIds -> Profile in
                Profile(skillLevelId: skillLevelId,
                        weekSchedule: weekSchedule,
                        drillsIds: drillsIds,
                        focusZonesIds: focusZonesIds)
            }
    }
    
    func store(skillLevelId: Int?) {
        guard let skillLevelId = skillLevelId else {
            return
        }
        
        UserDefaults.standard.set(skillLevelId, forKey: Constants.skillLevelId)
        
        ProfileMediator.shared.notify(skillLevelId: skillLevelId)
    }
    
    func cachedSkillLevelId() -> Single<Int?> {
        Single<Int?>.create { event in
            let skillLevelId = UserDefaults.standard.value(forKey: Constants.skillLevelId) as? Int
            
            event(.success(skillLevelId))
            
            return Disposables.create()
        }
    }
    
    func store(weekSchedule: WeekSchedule?) {
        guard let weekSchedule = weekSchedule else {
            return
        }
        
        let data = try? JSONEncoder().encode(weekSchedule)
        
        UserDefaults.standard.set(data, forKey: Constants.weekSchedule)
        
        ProfileMediator.shared.notify(weekSchedule: weekSchedule)
    }
    
    func cachedWeekSchedule() -> Single<WeekSchedule?> {
        Single<WeekSchedule?>.create { event in
            guard let data = UserDefaults.standard.data(forKey: Constants.weekSchedule) else {
                event(.success(nil))
                return Disposables.create()
            }
            
            let weekSchedule = try? JSONDecoder().decode(WeekSchedule.self, from: data)
            
            event(.success(weekSchedule))
            
            return Disposables.create()
        }
    }
    
    func store(drillsIds: [Int]?) {
        guard let drillsIds = drillsIds else {
            return
        }
        
        UserDefaults.standard.set(drillsIds, forKey: Constants.drillsIds)
        
        ProfileMediator.shared.notify(drillsIds: drillsIds)
    }
    
    func cachedDrillsIds() -> Single<[Int]?> {
        Single<[Int]?>.create { event in
            let drillsIds = UserDefaults.standard.value(forKey: Constants.drillsIds) as? [Int]
            
            event(.success(drillsIds))
            
            return Disposables.create()
        }
    }
    
    func store(focusZonesIds: [Int]?) {
        guard let focusZonesIds = focusZonesIds else {
            return
        }
        
        UserDefaults.standard.set(focusZonesIds, forKey: Constants.focusZonesIds)
        
        ProfileMediator.shared.notify(focusZonesIds: focusZonesIds)
    }
    
    func cachedFocusZonesIds() -> Single<[Int]?> {
        Single<[Int]?>.create { event in
            let focusZonesIds = UserDefaults.standard.value(forKey: Constants.focusZonesIds) as? [Int]
            
            event(.success(focusZonesIds))
            
            return Disposables.create()
        }
    }
}
