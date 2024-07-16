//
//  LikesViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 21.06.24.
//

import Foundation



class LikesViewModel: BaseAlertViewModel {
    // MARK: properties
    private let firebaseManager = FirebaseManager.shared
    private let rangeManager: RangeManager = .shared
    private let userService: UserService
    private let likeService: LikesService

    private var finishedLoadingUserLikes = false
    private var finishedLoadingLikedUsers = false
    private var finishedLoadingSuperLikedUsers = false

    private var userIdsWhoLikedCurrent: Set<String> = []
    private var userIdsCurrentUserLiked: Set<String> = []
    private var superLikedUserIds: Set<String> = []


    @Published private (set) var usersWhoLikedCurrentUser: [FireUser] = []
    @Published private (set) var superLikedUsers: [FireUser] = []
    @Published private (set) var usersCurrentUserLiked: [FireUser] = []

    @Published var likesTab: LikesTab = .likes
    @Published var activeSort: UserSortOption = .distance
    @Published var sortOrder: SortOrder = .ascending

    // MARK: init
    init(userService: UserService = .shared, likeService: LikesService = .shared) {
        self.userService = userService
        self.likeService = likeService
        super.init()
    }

    // MARK: computed properties
    var currentUsers: [FireUser] {
        switch likesTab {
        case .likes: usersWhoLikedCurrentUser + superLikedUsers
        case .likedUsers: usersCurrentUserLiked
        case .matches: userMatches
        }
    }

    var finishedInitialLoading: Bool {
        finishedLoadingUserLikes && finishedLoadingLikedUsers && finishedLoadingSuperLikedUsers
    }

    var sortedUsers: [FireUser] {
        activeSort.sort(users: currentUsers, rangeManager: rangeManager, userLocation: userService.user.location, order: sortOrder)
    }

    var userMatches: [FireUser] {
        let setLiked = Set(usersCurrentUserLiked)
        let setUsersWhoLiked = Set(usersWhoLikedCurrentUser)
        let intersection = setLiked.intersection(setUsersWhoLiked)
        return Array(intersection)
    }

    var currentUserId: String? {
        firebaseManager.userId
    }


    // MARK: functions
    func distance(to targetLocation: Location) -> String? {
        rangeManager.distanceString(from: userService.user.location, to: targetLocation)
    }

    func updateLikesIdsAndFetchUsers() {
        self.userIdsWhoLikedCurrent = likeService.userIdsWhoLikedCurrent
        self.userIdsCurrentUserLiked = likeService.userIdsCurrentUserLiked
        self.superLikedUserIds = likeService.superLikedUserIds
        fetchAllUsers()
    }

    /// called from view when onAppear executes
    func subscripe() {
        print("subscriped likesViewModel)")
        updateLikesIdsAndFetchUsers()
    }
}


// MARK: fetch users
extension LikesViewModel {
    // fetch users for each category (ownLikes, likes, superlikes), as well as filter out already existing users
    private func fetchAllUsers() {
        var userIdsWhoLikedCurrent = userIdsWhoLikedCurrent.filter { id in
            !usersWhoLikedCurrentUser.contains(where: { $0.id == id })
        }
        print(userIdsWhoLikedCurrent)
        fetchUsers(userIds: Array(userIdsWhoLikedCurrent)) { userList in
            self.usersWhoLikedCurrentUser.append(contentsOf: userList)
            self.finishedLoadingUserLikes = true
        }

        var userIdsCurrentUserLiked = userIdsCurrentUserLiked.filter { id in
            !usersCurrentUserLiked.contains(where: { $0.id == id })
        }
        fetchUsers(userIds: Array(userIdsCurrentUserLiked)) { userList in
            self.usersCurrentUserLiked.append(contentsOf: userList)
            self.finishedLoadingLikedUsers = true
        }

        var superLikedUserIds = superLikedUserIds.filter { id in
            !superLikedUsers.contains(where: { $0.id == id })
        }
        fetchUsers(userIds: Array(superLikedUserIds)) { userList in
            self.superLikedUsers.append(contentsOf: userList)
            self.finishedLoadingSuperLikedUsers = true
        }

    }

    private func fetchUsers(userIds: [String], completion: @escaping ([FireUser]) -> Void) {
        guard !userIds.isEmpty else {
            completion([])
            return
        }
        firebaseManager.database.collection("users")
            .whereField("id", in: userIds)
            .whereField("isHidden", isEqualTo: false)
            .getDocuments { querySnapshot, error in
                if let error {
                    print("Error fetching user documents in likesViewModel", error.localizedDescription)
                    completion([])
                    return
                }
                let users = querySnapshot?.documents.compactMap { doc in
                    try? doc.data(as: FireUser.self)
                } ?? []
                completion(users)
            }
    }
}
