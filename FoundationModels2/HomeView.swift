//
//  HomeView.swift
//  FoundationModels2
//
//  Created by Mario Alexander on 03/12/2025.
//

import SwiftUI
import FoundationModels
import Lottie

struct HomeView: View {
    @Environment(NavigationManger.self) var navManager
    @State private var prompt = ""
    @State private var reply = ""
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    HStack {
                        Menu {
                            Button("Model 1.0") {}
                                .glassEffect(.clear.interactive())
                            Button("Model 2.0") {}
                                .glassEffect(.clear.interactive())
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "line.3.horizontal")
                                    .padding(12)
                                    .foregroundStyle(.black)
                                    .glassEffect(.regular.interactive())
                            }
                        }

                        Spacer()

                        Text("Sample")
                            .font(.title3.weight(.semibold))
                        
                        Spacer()

                        Button { } label: {
                            Image(systemName: "face.dashed")
                                .padding(12)
                                .foregroundStyle(.black)
                                .glassEffect(.regular.interactive())
                        }
                    }
                    .padding(.horizontal)

                    Spacer()

                    // MARK: - Middle Prompt Area
                    if reply.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "apple.writing.tools")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.indigo)
                            
                            Text("Ask me Anything!")
                                .font(.title2.weight(.medium))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.black.opacity(0.85))
                        }
                        .padding(.horizontal)
                    } else {
                        ScrollView {
                            Text(reply)
                        }
                    }

                    Spacer()

                    // MARK: - Chat Input
                    HStack {
                        TextField("Ask me Anything", text: $prompt)
                            .padding(.horizontal, 16)
                            .frame(height: 55)
                            .glassEffect(.regular.interactive())

                        HStack(spacing: 6) {
                            Image(systemName: "paperplane.fill")
                                .font(.system(size: 22))
                        }
                        .padding(14)
                        .foregroundColor(.black)
                        .glassEffect(.clear.interactive())
                        .onTapGesture {
                            sendMessage()
                        }
                    }
                    .padding(.horizontal)
                }

                // MARK: - Loading Overlay
                if isLoading {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .overlay(
                            VStack {
                                LottieView(name: "Trail loading", loopMode: .loop)
                                    .frame(width: 120, height: 120)
                            }
                            .padding(24)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        )
                }
            }
            .navigationBarHidden(true)
        }
    }

    // MARK: - Handle Sending
    private func sendMessage() {
        guard !prompt.isEmpty else { return }
        let question = prompt
        prompt.removeAll()

        let session = LanguageModelSession()
        isLoading = true

        Task {
            do {
                reply = try await session.respond(to: question).content
            } catch {
                reply = "Something went wrong. Please try again.\n\(error.localizedDescription)"
            }
            isLoading = false
        }
    }
}


#Preview {
    @Previewable @State var navManager = NavigationManger()
    HomeView()
        .environment(navManager)
}

