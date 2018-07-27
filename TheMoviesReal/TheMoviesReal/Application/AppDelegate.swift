//
//  AppDelegate.swift
//  TheMoviesReal
//
//  Created by Hai on 7/23/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa
import NSObject_Rx

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        bindViewModel()
        configNavigationBar()
        return true
    }
    
    private func configNavigationBar() {
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = .orange
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.orange]
    }
    
    private func bindViewModel() {
        guard let window = window else { return }
        let navigator = AppNavigator(window: window)
        let appUseCase = AppUseCase()
        let appViewModel = AppViewModel(navigator: navigator, useCase: appUseCase)
        let input = AppViewModel.Input(loadTrigger: Driver.just(()))
        let output = appViewModel.transform(input)
        output.toMain.drive().disposed(by: rx.disposeBag)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TheMoviesReal")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

