//
//  RapEvaluationList.swift
//  RapApp
//
//  Created by yuta kodama on 2025/09/22.
//

import SwiftUI

struct RapEvaluationList: View {
    @State private var evaluationData: [(user: User, rate: Rate)] = []
    @State private var isLoading = true
    @State private var averageScore: Double = 0.0
    @State private var totalBattleCount: Int = 0
    
    private let evaluationGateway = EvaluationGateway()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("バトル評価履歴")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                
                                Text("相手からの評価を確認しよう")
                                    .font(.body)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                    }

                    HStack(spacing: 16) {
                        VStack(spacing: 4) {
                            Text("\(totalBattleCount)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                            Text("総バトル数")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(spacing: 4) {
                            Text(String(format: "%.1f", averageScore))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                            Text("平均スコア")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(24)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )

                    if isLoading {
                        ProgressView("読み込み中...")
                            .frame(maxWidth: .infinity, minHeight: 200)
                    } else if evaluationData.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "music.note.list")
                                .font(.system(size: 48))
                                .foregroundColor(.gray.opacity(0.5))
                            
                            Text("まだ評価がありません")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                            
                            Text("バトルに参加して評価をもらおう！")
                                .font(.body)
                                .foregroundColor(.gray.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity, minHeight: 200)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    } else {
                        List(evaluationData, id: \.rate.id) { data in
                            NavigationLink(destination: RapBattleEvaluationView(user: data.user, rate: data.rate)) {
                                EvaluationListCell(user: data.user, rate: data.rate)
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                        .listStyle(PlainListStyle())
                        .scrollContentBackground(.hidden)
                    }
                }
                .padding(.horizontal, 16)
            }
            .background(Color.gray.opacity(0.05))
            .refreshable {
                await loadEvaluationData()
            }
        }
        .onAppear {
            Task {
                await loadEvaluationData()
            }
        }
    }
    
    @MainActor
    private func loadEvaluationData() async {
        isLoading = true
        
        async let evaluationDataTask = evaluationGateway.fetchEvaluationData()
        async let averageScoreTask = evaluationGateway.calculateAverageScore()
        async let battleCountTask = evaluationGateway.getTotalBattleCount()
        
        do {
            let (fetchedEvaluationData, fetchedAverageScore, fetchedBattleCount) = await (
                evaluationDataTask,
                averageScoreTask,
                battleCountTask
            )
            
            self.evaluationData = fetchedEvaluationData
            self.averageScore = fetchedAverageScore
            self.totalBattleCount = fetchedBattleCount
        }
        
        isLoading = false
    }
}

#Preview {
    RapEvaluationList()
}
