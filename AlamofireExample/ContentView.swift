//
//  ContentView.swift
//  AlamofireExample
//
//  Created by Teddy on 11/21/23.
//

import SwiftUI

struct ContentView: View {
    @State private var label: String = "label"
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(label)

            Button(action: {
                Task {
                    label = await fetchBoreActivity().activity
                }
            }, label: {
                Text("Tap to Fetch Activities From Bore Open API")
            })
        }
        .padding()
    }

    private func fetchBoreActivity() async -> BoreResponseDTO {
        do {
            return try await APIManager.shared.call(type: BoreResponseDTO.self, endPoint: Endpoint.activity)
        } catch {
            return BoreResponseDTO(activity: "API ERROR, Please retry after few minutes")
        }
    }
}
