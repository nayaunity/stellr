//
//  MatchesView.swift
//  Intent
//
//  Created by Nyaradzo Bere on 9/4/23.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct MatchesView: View {
    @State private var matchedUsers: [User] = []

    var body: some View {
        VStack {
            Text("Your Matches")
                .font(.largeTitle)
                .padding()

            List(matchedUsers) { user in
                HStack {
                    WebImage(url: URL(string: user.profilePictureUrl))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                    Text(user.name)
                }
            }
        }
        .onAppear(perform: fetchMatches)
    }

    func fetchMatches() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("User is not signed in.")
            return
        }

        print("Fetching matches for user \(currentUserId)")

        let db = Firestore.firestore()
        let likesRef = db.collection("likes")

        // Fetch users that the current user has liked
        likesRef.whereField("likerId", isEqualTo: currentUserId).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error fetching liked users: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            let likedUserIds = documents.compactMap { $0["likedUserId"] as? String }

            // Fetch users that have liked the current user
            likesRef.whereField("likedUserId", isEqualTo: currentUserId).getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching users who liked the current user: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                let usersWhoLikedCurrentUser = documents.compactMap { $0["likerId"] as? String }

                // Find mutual likes to determine matches
                let mutualLikes = Set(likedUserIds).intersection(usersWhoLikedCurrentUser)

                // Fetch details of matched users
                let usersRef = db.collection("users")
                if !mutualLikes.isEmpty {
                    usersRef.whereField("uid", in: Array(mutualLikes)).getDocuments { snapshot, error in
                        guard let documents = snapshot?.documents else {
                            print("Error fetching matched user details: \(error?.localizedDescription ?? "Unknown error")")
                            return
                        }

                        self.matchedUsers = documents.compactMap { User(fromSnapshot: $0) }
                    }
                }
            }
        }
    }
}

struct MatchesView_Previews: PreviewProvider {
    static var previews: some View {
        MatchesView()
    }
}