//
//  SignInOTPApp.swift
//  SignInOTP
//
//  Created by Troy Shu on 8/4/23.
//

import SwiftUI
import Supabase

@main
struct SignInOTPApp: App {
    @State var supabaseInitialized = false
    @StateObject var auth = AuthController()
    
    var body: some Scene {
        WindowGroup {
            main
        }
    }
    
    @ViewBuilder
    var main: some View {
        if supabaseInitialized {
            ContentView()
                .environmentObject(auth)
                .onOpenURL { url in
                    print("App was opened with a URL: \(url)")
                    
                    guard let params = parseParameters(from: url), let access_token = params["access_token"], let refresh_token = params["refresh_token"] else {
                        print("Invalid URL params: \(url.absoluteString)")
                        return
                    }
                    
                    Task {
                        do {
                            try await supabase.auth.setSession(accessToken: access_token, refreshToken: refresh_token)
                        } catch {
                            print("Error setting session: \(error)")
                        }
                    }
                
                    
                    
                }
        } else {
            ProgressView()
                .task {
                    await supabase.auth.initialize()
                    supabaseInitialized = true
                }
        }
    }
    
    private func parseParameters(from url: URL) -> [String: String]? {
        guard let fragment = url.fragment else {
            return nil
        }
        
        let components = URLComponents(string: "dummy://host?" + fragment)
        var params = [String: String]()
        
        if let queryItems = components?.queryItems {
            for item in queryItems {
                params[item.name] = item.value
            }
        }
        
        return params
    }
}

let supabase = SupabaseClient(
    supabaseURL: Secrets.supabaseURL,
    supabaseKey: Secrets.supabaseAnonKey
)
