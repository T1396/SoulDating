//
//  LikesViewModel.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 21.06.24.
//

import Foundation



class LikesViewModel: BaseAlertViewModel {
    // MARK: properties
    private let TAG = "(LikesViewModel)"
    private let firebaseManager = FirebaseManager.shared
    private let rangeManager: RangeManager = .shared
    private let userService: UserService

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
    init(userService: UserService = .shared) {
        self.userService = userService
        super.init()
        fetchUsersWhoLiked()
        fetchUsersCurrentUserLiked()
        fetchUsersCurrentUserSuperLiked()
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


    private func fetchUsersWhoLiked() {
        guard let currentUserId else { return }
        firebaseManager.database.collection("userLikes").document(currentUserId)
            .collection("like")
            .addSnapshotListener { querySnapshot, error in
                if let error {
                    print("\(self.TAG) error in snapshotlistener for likes", error.localizedDescription)
                    return
                }
                let userIds = querySnapshot?.documents.compactMap { doc in
                    doc.data()["fromUserId"] as? String
                } ?? []
                self.userIdsWhoLikedCurrent.formUnion(userIds)
                // filter the ids of the users to only fetch users that werent fetched already
                let usersToFetch = self.userIdsWhoLikedCurrent.filter { id in
                    !self.usersWhoLikedCurrentUser.contains(where: { $0.id == id })
                }
                // fetch the new users and append them
                self.fetchUsers(userIds: Array(usersToFetch)) { fetchedUsers in
                    self.usersWhoLikedCurrentUser.append(contentsOf: fetchedUsers)
                    self.finishedLoadingUserLikes = true
                }
            }
    }

    private func fetchUsersCurrentUserLiked() {
        guard let currentUserId else { return }
        firebaseManager.database.collection("userActions").document(currentUserId)
            .collection("actions")
            .whereField("action", isEqualTo: SwipeAction.like.rawValue)
            .addSnapshotListener { docSnapshot, error in
                if let error {
                    print("Error fetching the users the current user likes", error.localizedDescription)
                    return
                }
                let usersWhoLikedIds = docSnapshot?.documents.compactMap { doc in
                    doc.data()["targetUserId"] as? String
                } ?? []
                self.userIdsCurrentUserLiked.formUnion(usersWhoLikedIds)
                // filter the ids of the users to only fetch users that werent fetched already
                let usersToFetch = self.userIdsCurrentUserLiked.filter { id in
                    !self.usersCurrentUserLiked.contains(where: { $0.id == id })
                }
                // fetch the new users and append them
                self.fetchUsers(userIds: Array(usersToFetch)) { fetchedUsers in
                    self.usersCurrentUserLiked.append(contentsOf: fetchedUsers)
                    self.finishedLoadingLikedUsers = true
                }
            }
    }

    private func fetchUsersCurrentUserSuperLiked() {
        guard let currentUserId else { return }
        firebaseManager.database.collection("userActions").document(currentUserId)
            .collection("actions")
            .whereField("action", isEqualTo: SwipeAction.superlike.rawValue)
            .addSnapshotListener { docSnapshot, error in
                if let error {
                    print("Error fetching the users the current user likes", error.localizedDescription)
                    return
                }

                let superLikedUserIds = docSnapshot?.documents.compactMap { doc in
                    doc.data()["targetUserId"] as? String
                } ?? []
                self.superLikedUserIds.formUnion(superLikedUserIds)
                // filter the ids of the users to only fetch users that werent fetched already
                let usersToFetch = self.superLikedUserIds.filter { id in
                    !self.superLikedUsers.contains(where: { $0.id == id })
                }
                // fetch the new users and append them
                self.fetchUsers(userIds: Array(usersToFetch)) { fetchedUsers in
                    self.superLikedUsers.append(contentsOf: fetchedUsers)
                    self.finishedLoadingSuperLikedUsers = true
                }
            }
    }
}


// MARK: fetch users
extension LikesViewModel {
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
