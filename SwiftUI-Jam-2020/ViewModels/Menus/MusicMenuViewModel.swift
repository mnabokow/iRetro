//
//  MusicMenuViewModel.swift
//  SwiftUI-Jam-2020
//
//  Created by Max Nabokow on 2/19/21.
//

import Combine
import SwiftUI

class MusicMenuViewModel: MenuViewModel, ObservableObject {
    lazy var menuOptions = [
        MenuOption(title: "Cover Flow", nextMenu: AnyView(Text("Cover Flow"))),
        MenuOption(title: "Playlists", nextMenu: nil,
                   withDisclosure: true, onSelect: showPlaylistsListView),
        MenuOption(title: "Artists", nextMenu: nil,
                   withDisclosure: true, onSelect: showArtistsListView),
        MenuOption(title: "Albums", nextMenu: AnyView(Text("Albums"))),
        MenuOption(title: "Compilations", nextMenu: AnyView(Text("Compilations"))),
        MenuOption(title: "Songs", nextMenu: nil,
                   withDisclosure: true, onSelect: showSongsListView),
        MenuOption(title: "Genres", nextMenu: AnyView(Text("Genres"))),
        MenuOption(title: "Composers", nextMenu: AnyView(Text("Composers"))),
        MenuOption(title: "Audiobooks", nextMenu: AnyView(Text("Audiobooks"))),
    ]

    @Published var currentIndex: Int = 0
    var sinks = Set<AnyCancellable>()

    private func showSongsListView() {
        let dict: [String: AnyView] = ["view": AnyView(SongsListView())]
        let name = MyNotifications.showFullScreenView.rawValue
        let notification = Notification(name: .init(name), userInfo: dict)
        NotificationCenter.default.post(notification)
    }

    private func showPlaylistsListView() {
        let dict: [String: AnyView] = ["view": AnyView(PlaylistsListView())]
        let name = MyNotifications.showFullScreenView.rawValue
        let notification = Notification(name: .init(name), userInfo: dict)
        NotificationCenter.default.post(notification)
    }

    private func showArtistsListView() {
        let dict: [String: AnyView] = ["view": AnyView(ArtistsListView())]
        let name = MyNotifications.showFullScreenView.rawValue
        let notification = Notification(name: .init(name), userInfo: dict)
        NotificationCenter.default.post(notification)
    }

    func prevTick() {
        if currentIndex != 0 {
            currentIndex -= 1
            ClickWheelService.shared.playTick()
        }
    }

    func nextTick() {
        if currentIndex != menuOptions.count - 1 {
            currentIndex += 1
            ClickWheelService.shared.playTick()
        }
    }

    func prevClick() {
        Haptics.rigid()
        ClickWheelService.shared.playTock()
    }

    func nextClick() {
        Haptics.rigid()
        ClickWheelService.shared.playTock()
    }

    func menuClick() {
        Haptics.rigid()
        ClickWheelService.shared.playTock()
    }

    func playPauseClick() {
        Haptics.rigid()
        ClickWheelService.shared.playTock()
    }

    func centerClick() {
        Haptics.rigid()
        ClickWheelService.shared.playTock()

        if let onSelect = menuOptions[currentIndex].onSelect {
            onSelect()
        }
    }

    func startClickWheelSubscriptions(
        prevTick: (() -> Void)? = nil,
        nextTick: (() -> Void)? = nil,
        prevClick: (() -> Void)? = nil,
        nextClick: (() -> Void)? = nil,
        menuClick: (() -> Void)? = nil,
        playPauseClick: (() -> Void)? = nil,
        centerClick: (() -> Void)? = nil
    ) {
        ClickWheelService.shared.prevTick
            .receive(on: RunLoop.main)
            .sink {
                self.prevTick()
                if let tick = prevTick {
                    tick()
                }
            }
            .store(in: &sinks)

        ClickWheelService.shared.nextTick
            .receive(on: RunLoop.main)
            .sink {
                self.nextTick()
                if let tick = nextTick {
                    tick()
                }
            }
            .store(in: &sinks)

        ClickWheelService.shared.prevClick
            .receive(on: RunLoop.main)
            .sink {
                self.prevClick()
                if let click = prevClick {
                    click()
                }
            }
            .store(in: &sinks)

        ClickWheelService.shared.nextClick
            .receive(on: RunLoop.main)
            .sink {
                self.nextClick()
                if let click = nextClick {
                    click()
                }
            }
            .store(in: &sinks)

        ClickWheelService.shared.menuClick
            .receive(on: RunLoop.main)
            .sink {
                self.menuClick()
                if let click = menuClick {
                    click()
                }
            }
            .store(in: &sinks)

        ClickWheelService.shared.playPauseClick
            .receive(on: RunLoop.main)
            .sink {
                self.playPauseClick()
                if let click = playPauseClick {
                    click()
                }
            }
            .store(in: &sinks)

        ClickWheelService.shared.centerClick
            .receive(on: RunLoop.main)
            .sink {
                self.centerClick()
                if let center = centerClick {
                    center()
                }
            }
            .store(in: &sinks)
    }
}
