import UIKit


protocol PodcastAppFactory {
    func createApp() -> PodcastApp
    func syncAppPlayTime(with app: PodcastApp) -> PodcastApp
}

extension PodcastAppFactory {
    func syncAppPlayTime(with app: PodcastApp) -> PodcastApp {
        let newApp = createApp()
        newApp.sync(with: app)
        return newApp
    }
}

class GooglePodcastFactory: PodcastAppFactory {
    func createApp() -> PodcastApp {
        return GooglePodcast()
    }
}

class ApplePodcastFactory: PodcastAppFactory {
    func createApp() -> PodcastApp {
        return ApplePodcast()
    }
}


protocol PodcastApp {
    var currentTime: TimeInterval { get set }
    func sync(with app: PodcastApp)
    func playPodcast()
    func rewind()
    func forward()
    func updateTime(with currentTime: TimeInterval)
}

class GooglePodcast: PodcastApp {
    var currentTime: TimeInterval = 0
    
    func sync(with app: PodcastApp) {
        updateTime(with: app.currentTime)
    }
    
    func playPodcast() {
        currentTime += 100
        print("Playing Podcast from Google Podcast...")
    }
    
    func rewind() {
        guard currentTime - 15 > 0 else {
            currentTime = 0
            return
        }
        currentTime -= 15
    }
    
    func forward() {
        currentTime += 15
    }
    
    func updateTime(with currentTime: TimeInterval) {
        self.currentTime = currentTime
    }
    
}

class ApplePodcast: PodcastApp {
    var currentTime: TimeInterval = 0
    
    func sync(with app: PodcastApp) {
        updateTime(with: app.currentTime)
    }
    
    func playPodcast() {
        currentTime += 100
        print("Playing Podcast from Apple Podcast...")
    }
    
    func rewind() {
        guard currentTime - 15 > 0 else {
            currentTime = 0
            return
        }
        currentTime -= 15
    }
    
    func forward() {
        currentTime += 15
    }
    
    func updateTime(with currentTime: TimeInterval) {
        self.currentTime = currentTime
    }
    
}

class Client {
    var currentPodcastApp: PodcastApp?
    
    func playPodcast(with factory: PodcastAppFactory) {
        let podcastApp = factory.createApp()
        
        guard let currentApp = currentPodcastApp else {
            currentPodcastApp = podcastApp
            podcastApp.playPodcast()
            return
        }
        podcastApp.sync(with: currentApp)
        
        currentPodcastApp = podcastApp
        podcastApp.playPodcast()
    }
}


import XCTest

class FactoryMethodRealWorld: XCTestCase {

    func testFactoryMethodRealWorld() {

        let clientCode = Client()

        /// Present info over WiFi
        clientCode.playPodcast(with: ApplePodcastFactory())

        /// Present info over Bluetooth
        clientCode.playPodcast(with: GooglePodcastFactory())
    }
}

FactoryMethodRealWorld.defaultTestSuite.run()
