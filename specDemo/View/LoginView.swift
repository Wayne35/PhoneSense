//
//  LoginView.swift
//  specDemo
//
//  Created by Yiyum on 2023/5/12.
//

import SwiftUI
import AuthenticationServices

struct AppleUser: Codable {
    
    let userId: String
    let firstName: String
    let lastName: String
    let email: String
    
    
    init?(credentials: ASAuthorizationAppleIDCredential, status: Bool) {
        guard
            let firstName = credentials.fullName?.givenName,
            let lastName = credentials.fullName?.familyName,
            let email = credentials.email
        else { return nil }
        
        self.userId = credentials.user
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}

struct LoginInfo: Codable {
    let status: Bool
    init?(status: Bool) {
        self.status = status
    }
}

struct LoginView: View {
    
    @State var status: Bool = true
    @State var userName: String = "姓名"
    @State var userEmail: String = "123@xx.com"
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            if(status) {
                LoggedView(
                    status: $status,
                    userName: $userName,
                    userEmail: $userEmail)
            } else {
                UnLoginView(
                    status: $status,
                    userName: $userName,
                    userEmail: $userEmail)
            }
        }
        .onAppear {
            guard
                let loginStatusData = UserDefaults.standard.data(forKey: "loginStatus"),
                let loginStatus = try? JSONDecoder().decode(LoginInfo.self, from: loginStatusData),
                let appleUserData = UserDefaults.standard.data(forKey: "appleUser"),
                let appleUser = try? JSONDecoder().decode(AppleUser.self, from: appleUserData)
            else { return }
            userName = appleUser.lastName + appleUser.firstName
            userEmail = appleUser.email
            status = loginStatus.status
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct UnLoginView: View {
    
    @Binding var status: Bool
    @Binding var userName: String
    @Binding var userEmail: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 400) {
            //说明文字
            VStack(alignment: .leading, spacing: 10){
                Text("开启真实的世界")
                    .foregroundColor(.white)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                Text("首次登录自动创建新账号")
                    .foregroundColor(.white)
                    .font(.system(size: 17))
            }
            //登录方式
            VStack(alignment: .center, spacing: 15) {
                SignInWithAppleButton(
                    .signIn,
                    onRequest: configure,
                    onCompletion: handle
                )
                .frame(width: 300, height: 55)
                .cornerRadius(8)
                
//                Button(action: {}) {
//                    Text("账号密码登录")
//                        .font(.system(size: 20))
//                        .bold()
//                        .frame(width: 300, height: 55)
//                        .foregroundColor(.white)
//                        .background(.red)
//                        .cornerRadius(8)
//                }
            }
        }.padding()
    }
    func configure(_ request: ASAuthorizationAppleIDRequest) {
            request.requestedScopes = [.fullName, .email]
    }
        
    func handle(_ authResult: Result<ASAuthorization, Error>) {
        switch authResult {
        case .success(let auth):
            status = true
            print(auth)
            switch auth.credential {
            case let appleIdCredentials as ASAuthorizationAppleIDCredential:
                if let appleUser = AppleUser(credentials: appleIdCredentials, status: true),
                    let loginStatus = LoginInfo(status: true),
                    let appleUserData = try? JSONEncoder().encode(appleUser),
                    let loginStatusData = try?
                    JSONEncoder().encode(loginStatus){
                    UserDefaults.standard.setValue(appleUserData, forKey: "appleUser")
                    UserDefaults.standard.setValue(loginStatusData, forKey: "loginStatus")
                    userName = appleUser.lastName + appleUser.firstName
                    userEmail = appleUser.email
                    print("saved apple user", appleUser)
                } else {
                    print("missing some fields", appleIdCredentials.email, appleIdCredentials.fullName, appleIdCredentials.user)
                        
                    if let loginStatus = LoginInfo(status: true),
                       let loginStatusData = try?
                        JSONEncoder().encode(loginStatus) {
                        UserDefaults.standard.setValue(loginStatusData, forKey: "loginStatus")
                    }
                    guard
                        let appleUserData = UserDefaults.standard.data(forKey: "appleUser"),
                        let appleUser = try? JSONDecoder().decode(AppleUser.self, from: appleUserData)
                    else { return }
                        
                    print(appleUser)
                }
                    
            default:
                print(auth.credential)
            }
                
        case .failure(let error):
            print(error)
        }
    }
}


struct profileButtonView: View {
    
    @State var name: String
    @State var imageName: String
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: imageName)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(.leading, 10)
                Text(name)
                    .foregroundColor(.black)
                    .font(.system(size: 20))
                Spacer()
            }
            
            Rectangle()
                .frame(height: 1)
                .frame(maxWidth: .infinity)
        }
        .frame(height: 50)
    }
}

struct LoggedView: View {
    
    @Environment(\.openURL) var openURL
    @Binding var status: Bool
    @Binding var userName: String
    @Binding var userEmail: String
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Image("profile")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .padding(.leading, 10)
                VStack(alignment: .leading,spacing: 10) {
                    Text(userName)
                        .font(.system(size: 30, weight: .bold, design: .default))
                        .foregroundStyle(.white)
                        .opacity(0.8)
                    Text(userEmail)
                        .font(.system(size: 15, weight: .medium, design: .default))
                        .foregroundStyle(.secondary)
                        .onTapGesture {
                            //修改个人资料
                        }
                }
                Spacer()
                Image(systemName: "gearshape.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .opacity(0.5)
                    .offset(y: -10)
                    .padding(.trailing, 10)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .background(.ultraThinMaterial, in:  RoundedRectangle(cornerRadius: 20, style: .continuous))
            
            HStack {
                ScrollView {
                    profileButtonView(
                        name: "艾斌实验室",
                        imageName: "globe")
                    .onTapGesture {
                        openURL(URL(string: "http://www.ailabcqu.com")!)
                    }
                    profileButtonView(
                        name: "反馈",
                        imageName: "doc.append")
                    .onTapGesture {
                        
                    }
                }
                .offset(y:15)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 500)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            
            HStack {
                Text("退出登陆")
                    .font(.system(size: 20))
                    .bold()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .foregroundStyle(.red)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            .onTapGesture {
                status = false
                if let loginStatus = LoginInfo(status: false),
                   let loginStatusData = try?
                    JSONEncoder().encode(loginStatus){
                    UserDefaults.standard.setValue(loginStatusData, forKey: "loginStatus")
                } else {
                    return
                }
            }
            
            Spacer()
        }
    }
}
