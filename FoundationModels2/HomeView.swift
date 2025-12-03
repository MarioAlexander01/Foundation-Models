//
//  HomeView.swift
//  FoundationModels2
//
//  Created by Mario Alexander on 03/12/2025.
//

import SwiftUI
import FoundationModels

struct HomeView: View {
    @Environment(NavigationManger.self) var navManager
    @State private var isExpanded: Bool = false
    @Namespace private var namespace
    @State private var prompt = ""
    @State private var reply = ""
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - Gradient Background
                LinearGradient(
                    colors: [
                        .purple.opacity(0.7),
                        .blue.opacity(0.7),
                        .white.opacity(0.7),
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea() // makes the gradient fill the whole screen
                
                VStack(alignment: .center) {
                    ScrollView {
                        Text(reply)
                            .padding(.top, 8)
                    }
                    .padding()
                    
                    GlassEffectContainer {
                        
                        HStack {
                            TextField("Question", text: $prompt)
                                .padding()
                                .frame(height: 80.0)
                                .glassEffect()
                                .glassEffectID("text", in: namespace)
                            
                            Image(systemName: "paperplane.fill")
                                .frame(width: 80.0, height: 80.0)
                                .font(.system(size: 36))
                                .glassEffect(.regular.interactive())
                                .glassEffectID("text", in: namespace)
                                .disabled(prompt.isEmpty)
                                .onTapGesture {
                                    let session = LanguageModelSession()
                                    let question = prompt
                                    prompt.removeAll()

                                    isLoading = true
                                    Task {
                                        do {
                                            reply = try await session.respond(to: question).content
                                        } catch {
                                            reply = "Something went wrong. Please try again.\n\n\(error.localizedDescription)"
                                        }
                                        isLoading = false
                                    }
                                }
                        }
                    }
                    
                    GlassEffectContainer() {
                        HStack(spacing: 0) {
                            GlassEffectContainer(spacing: 40.0) {
                                HStack(spacing: 30) {
                                    Image(systemName: "ellipsis")
                                        .frame(width: 80.0, height: 80.0)
                                        .font(.system(size: 36))
                                        .glassEffect(.regular.interactive())
                                        .glassEffectID("pencil", in: namespace)
                                        .onTapGesture {
                                            withAnimation {
                                                isExpanded.toggle()
                                            }
                                        }
                                    
                                    
                                    if isExpanded {
                                        Group {
                                            Image(systemName: "eraser.fill")
                                                .frame(width: 80.0, height: 80.0)
                                                .font(.system(size: 36))
                                                .glassEffect()
                                                .glassEffectID("eraser", in: namespace)
                                            
                                            Image(systemName: "arrow.trianglehead.clockwise")
                                                .frame(width: 80.0, height: 80.0)
                                                .font(.system(size: 36))
                                                .glassEffect()
                                                .glassEffectID("eraser", in: namespace)
                                        }
                                        .glassEffectUnion(id: "menu", namespace: namespace)
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            
                        }
                    }
                    
                }
                .padding()
                .allowsHitTesting(!isLoading)
                
                // Loading overlay
                if isLoading {
                    Color.black.opacity(0.25)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .zIndex(1)
                        .overlay(
                            VStack(spacing: 16) {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .tint(.white)
                                Text("Thinking…")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                            }
                            .padding(24)
                            .background(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(.ultraThinMaterial)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                        )
                        .allowsHitTesting(true)
                }
            }
            .navigationTitle(navManager.selectedTab.rawValue)
        }
    }
}


#Preview {
    @Previewable @State var navManager = NavigationManger()
    HomeView()
        .environment(navManager)
}

