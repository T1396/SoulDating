//
//  BlockedUsersView.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 16.07.24.
//

import SwiftUI

struct BlockedUsersView: View {
    // MARK: properties
    @StateObject private var blockedVm: BlockedUsersViewModel = .init()

    private let gridItems = [ GridItem(.flexible()), GridItem(.flexible()) ]

    var body: some View {
        NavigationStack {
            Group {
                if blockedVm.blockedUsers.isEmpty && blockedVm.isLoadingFinished {
                    Text("You dont have any blocked users yet")
                        .appFont(size: 22, textWeight: .bold)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                } else {

                    Text("Your currently blocked users")
                        .appFont(size: 20, textWeight: .bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    GeometryReader { geometry in
                        let width = (geometry.size.width - 40) / 2
                        let height = width * 4 / 3


                        ScrollView {
                            //Spacer(minLength: 32)
                            LazyVGrid(columns: gridItems, content: {
                                ForEach(blockedVm.blockedUsers) { user in
                                    ZStack {
                                        ImageWithGradientAndName(user: user, distance: nil, minWidth: width, minHeight: height)


                                        Button {
                                            blockedVm.attemptRemoveBlockedUser(user: user)
                                        } label: {
                                            Image(systemName: "trash.fill")
                                                .padding()
                                                .foregroundStyle(.red)
                                                .background()
                                                .clipShape(Circle())
                                        }
                                        .padding([.trailing, .top], 8)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                    }
                                }
                            }).padding(.horizontal)
                        }
                    }
                }
            }
        }

        .alert(blockedVm.alertTitle, isPresented: $blockedVm.showAlert) {
            if let action = blockedVm.onAcceptAction {
                Button(Strings.cancel, role: .cancel, action: blockedVm.dismissAlert)
                Button("OK", role: .destructive, action: action)
            } else {
                Button(Strings.cancel, action: blockedVm.dismissAlert)
            }
        } message: {
            Text(blockedVm.alertMessage)
        }
    }
}

#Preview {
    BlockedUsersView()
}
