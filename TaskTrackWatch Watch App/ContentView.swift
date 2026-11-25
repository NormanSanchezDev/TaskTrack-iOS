//
//  ContentView.swift
//  TaskTrackWatch Watch App
//
//  Created by Norman Sánchez on 25/11/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Welcome to TaskTracking")
            Text("Could you add some task that you are working now?")
            
            Button(action: {
                
            }, label: {
                Text("Add task")
            })
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
