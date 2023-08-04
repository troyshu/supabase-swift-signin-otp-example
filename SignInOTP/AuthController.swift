//
//  AuthController.swift
//  SignInOTP
//
//  Created by Troy Shu on 8/4/23.
//

import GoTrue
import SwiftUI

final class AuthController: ObservableObject {
  @Published var session: Session?

  var currentUserID: UUID {
    guard let id = session?.user.id else {
      preconditionFailure("Required session.")
    }

    return id
  }
}
