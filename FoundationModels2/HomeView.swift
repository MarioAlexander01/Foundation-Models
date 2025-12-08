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
    let session = LanguageModelSession(instructions: "You are a culinary assistant AI that specializes in generating high-quality, practical, and creative recipes. Your purpose is to help users craft meals based on their preferences, dietary restrictions, available ingredients, cooking skill level, and desired cuisine style.")
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    headerView
                    
                    Spacer()
                    
                    replySectionView
                    
                    Spacer()
                    
                    promptView
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        HStack {
            Menu {
                Button("Model 1.0") {}
                    .glassEffect(.clear.interactive())
                Button("Model 2.0") {}
                    .glassEffect(.clear.interactive())
            } label: {
                Image(systemName: "line.3.horizontal")
                    .padding(12)
                    .foregroundStyle(.black)
                    .glassEffect(.regular.interactive())
            }
            
            Spacer()
            
            Text("ChefGPT")
                .font(.title3.weight(.semibold))
            
            Spacer()
            
            Button {
                reply.removeAll()
            } label: {
                Image(systemName: "arrow.clockwise")
                    .padding(12)
                    .foregroundStyle(.black)
                    .glassEffect(.regular.interactive())
            }
        }
        .padding(.horizontal)
    }
    
    private var replySectionView: some View {
        if reply.isEmpty {
            return AnyView(
                VStack(spacing: 12) {
                    Image(systemName: "apple.writing.tools")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.indigo)
                    
                    Text("What do you want to cook today?")
                        .font(.title2.weight(.medium))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.black.opacity(0.85))
                }
                    .padding(.horizontal)
            )
        } else {
            return AnyView(
                ScrollView {
                    VStack(spacing: 16) {
                        if session.isResponding {
                            LottieView(name: "Trail loading", loopMode: .loop)
                                .frame(width: 120, height: 120)
                        }
                        
                        Text(.init(reply))
                            .padding()
                    }
                }
            )
        }
    }
    
    private var promptView: some View {
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
            .disabled(session.isResponding)
        }
        .padding(.horizontal)
        .padding(.bottom, 16)
    }
    
    // MARK: - Handle Sending
    private func sendMessage() {
        guard !prompt.isEmpty else { return }
        
        Task {
            do {
                let stream = session.streamResponse(to: prompt)
                for try await partial in stream {
                    withAnimation {
                        reply = partial.content
                    }
                }
                prompt.removeAll()
            } catch {
                reply = "Something went wrong. Please try again.\n\(error.localizedDescription)"
            }
        }
    }
}


#Preview {
    @Previewable @State var navManager = NavigationManger()
    HomeView()
        .environment(navManager)
}

