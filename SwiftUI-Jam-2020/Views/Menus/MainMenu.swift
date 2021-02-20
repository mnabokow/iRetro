//
//  iPodMenu.swift
//  SwiftUI-Jam-2020
//
//  Created by Max Nabokow on 2/19/21.
//

import SwiftUI

struct MainMenu: View {
    @StateObject private var vm = MainMenuViewModel()
    @State private var childrenShowing = Array(repeating: false, count: 12) // dangerous, yes.

    init() {
        childrenShowing = Array(repeating: false, count: vm.menuOptions.count)
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(0 ..< vm.menuOptions.count, id: \.self) { i in
                    if let dest = vm.destination(at: i) {
                        NavigationLink(destination: dest, isActive: $childrenShowing[i], label: {
                            vm.row(at: i)
                        })
                    } else {
                        vm.row(at: i)
                    }
                }

                Spacer()
            }
            .font(.headline)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear(perform: vm.startPlayStateSubscriptions)
            .onAppear(perform: startClickWheelSubscriptions)
            .onDisappear(perform: stopClickWheelSubscriptions)
        }
    }

    private func startClickWheelSubscriptions() {
        vm.startClickWheelSubscriptions(
            prevTick: nil,
            nextTick: nil,
            prevClick: nil,
            nextClick: { childrenShowing[vm.currentIndex] = true },
            menuClick: nil,
            playPauseClick: nil,
            centerClick: { childrenShowing[vm.currentIndex] = true })
    }

    private func stopClickWheelSubscriptions() {
        vm.stopClickWheelSubscriptions()
    }
}