//
//  User.swift
//  tumble-ios
//
//  Created by Adis Veletanlic on 2023-02-13.
//

import SwiftUI

struct UserOverview: View {
    
    @Binding var userImage: UIImage?
    let name: String
    let username: String
    let schoolName: String
    
    @State private var inputImage: UIImage?
    @State private var showImagePicker: Bool = false
    
    let createToast: (ToastStyle, String, String) -> Void
    let toggleAutoSignup: (Bool) -> Void
    let userBookings: [Response.KronoxResourceData]
    let updateUserImage: (UIImage) -> Void
    
    @Binding var autoSignup: Bool
    
    var body: some View {
        ZStack {
                    
            Color("PrimaryColor")
            
            VStack {
                HStack {
                    Button(action: {
                        showImagePicker = true
                    }, label: {
                        UserAvatar(image: $userImage, name: name)
                    })
                    VStack (alignment: .leading, spacing: 0) {
                        Text(name)
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                        Text(username)
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                        Text(schoolName)
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .padding(.top, 5)
                        Spacer()
                    }
                    .padding(10)
                    .padding(.top, 20)
                }
                .padding()
                .padding(.top, 80)
                .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 3.5, alignment: .leading)
                .background(Color.background)
                .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
                .shadow(radius: 5)
            
                Spacer()
                VStack {
                    UserActions (title: "User options", image: "gearshape") {
                        Toggle(isOn: $autoSignup) {
                            Text("Automatic exam signup")
                                .font(.system(size: 17, design: .rounded))
                                .foregroundColor(.onBackground)
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .primary))
                        .onChange(of: autoSignup, perform: { (value: Bool) in
                            toggleAutoSignup(value)
                        })
                    }
                    UserActions (title: "Your bookings", image: "tray.full",
                                 destination: AnyView(Text("Book rooms")
                                    .customNavigationBackButton(previousPage: "Account"))) {
                        if userBookings.isEmpty {
                            Text("No bookings yet")
                                .font(.system(size: 17, weight: .regular, design: .rounded))
                                .foregroundColor(.onBackground)
                                .padding(.top, 5)
                        }
                    }
                    UserActions (title: "Your exams", image: "newspaper",
                                 destination: AnyView(Text("Book exams")
                                    .customNavigationBackButton(previousPage: "Account"))) {
                        if userBookings.isEmpty {
                            Text("No registered exams yet")
                                .font(.system(size: 17, weight: .regular, design: .rounded))
                                .foregroundColor(.onBackground)
                                .padding(.top, 5)
                        }
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 1.85).cornerRadius(15)
                .background(Color.background)
                .cornerRadius(15, corners: [.topLeft, .topRight])
            }
            
        }
        .sheet(isPresented: $showImagePicker, onDismiss: loadImage, content: {
            ImagePicker(image: self.$inputImage)
        })
        .edgesIgnoringSafeArea([.top, .bottom])
    }
    
    func loadImage() -> Void {
        guard let inputImage = inputImage else { return }
        if inputImage.getSizeIn(.megabyte) <= 8 {
            updateUserImage(inputImage)
            createToast(.success, "New profile picture", "Successfully changed profile picture for your account")
        } else {
            createToast(.info, "Image too large", "Profile pictures are limited to 8MB")
        }
        
    }
    
}
