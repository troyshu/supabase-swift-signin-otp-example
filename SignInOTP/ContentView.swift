//
//  ContentView.swift
//  SignInOTP
//
//  Created by Troy Shu on 8/4/23.
//

import SwiftUI
import GoTrue

struct ContentView: View {
    @State var authEvent: AuthChangeEvent?
    @EnvironmentObject var auth: AuthController
    @State var error: Error?
    
    var body: some View {
        VStack {
            if authEvent == .signedOut {
                Button("Sign In") {
                    Task {
                        await signIn()
                    }
                }
            } else {
                Text("You're in!")
                Button("Sign Out") {
                    Task {
                        try? await supabase.auth.signOut()
                    }
                }
            }
        }
        .task {
            for await event in supabase.auth.authEventChange {
                withAnimation {
                    authEvent = event
                }
                
                auth.session = try? await supabase.auth.session
            }
        }
    }
    
    func signIn() async {
        do {
            error = nil
            try await supabase.auth.signInWithOTP(
                email: "your_email@gmail.com",
                redirectTo: URL(string: "io.supabase.test://login-callback/")
            )
        } catch {
            self.error = error
        }
    }
}

