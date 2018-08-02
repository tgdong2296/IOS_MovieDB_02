//
//  DatabaseManager.swift
//  TheMoviesReal
//
//  Created by Trịnh Giang Đông on 8/1/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import RxCocoa
import RxSwift

enum DatabaseResultState {
    case insertSuccess
    case deleteSucess
}

fileprivate protocol DatabaseManagerType {
    func insert(movie: Movie) -> Observable<DatabaseResultState>
    func delete(movie: Movie) -> Observable<DatabaseResultState>
    func getAllMovie() -> Observable<[Movie]>
    func checkAvailable(movie: Movie) -> Observable<Bool>
}

class DatabaseManager: DatabaseManagerType {
    private static let instance = DatabaseManager()
    
    static func sharedInstance() -> DatabaseManager {
        return instance
    }
    
    private struct Constants {
        static let entityName = "MovieTable"
        static let idColumn = "id"
        static let titleColumn = "title"
        static let voteAverangeColumn = "vote_averange"
        static let posterPathColumn = "poster_path"
        static let popularColumn = "popularity"
    }
    
    private func getManagedObjectContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    func insert(movie: Movie) -> Observable<DatabaseResultState> {
        return Observable.create { [weak self] observer in
            guard let `self` = self, let context = self.getManagedObjectContext() else {
                observer.onError(BaseError.unexpectedError)
                return Disposables.create()
            }
            let newMovie = NSEntityDescription.insertNewObject(forEntityName: Constants.entityName, into: context)
            newMovie.setValue(movie.id, forKey: Constants.idColumn)
            newMovie.setValue(movie.title, forKey: Constants.titleColumn)
            newMovie.setValue(movie.posterPath, forKey: Constants.posterPathColumn)
            newMovie.setValue(movie.voteAverage, forKey: Constants.voteAverangeColumn)
            newMovie.setValue(movie.popularity, forKey: Constants.popularColumn)
            do {
                try context.save()
                observer.onNext(.insertSuccess)
                observer.onCompleted()
                print("Insert success!!!")
            } catch let error {
                print("Insert movie error: \(error.localizedDescription)")
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func delete(movie: Movie) -> Observable<DatabaseResultState> {
        return Observable.create { [weak self] observer in
            guard let `self` = self, let context = self.getManagedObjectContext(),
                let movie = self.findMovieById(movieID: movie.id) else {
                observer.onError(BaseError.unexpectedError)
                return Disposables.create()
            }
            do {
                context.delete(movie)
                try context.save()
                observer.onNext(.deleteSucess)
                observer.onCompleted()
                print("Delete success!!!")
            } catch let error {
                print("Delete movie error: \(error.localizedDescription)")
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func getAllMovie() -> Observable<[Movie]> {
        return Observable.create { [weak self] observer in
            var movies = [Movie]()
            guard let `self` = self, let context = self.getManagedObjectContext() else {
                observer.onError(BaseError.unexpectedError)
                return Disposables.create()
            }
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.entityName)
            do {
                let movieList = try context.fetch(fetchRequest)
                for movie in movieList {
                    let movieID = movie.value(forKey: Constants.idColumn) as? Int ?? 0
                    let movieTitle = movie.value(forKey: Constants.titleColumn) as? String ?? ""
                    let moviePoster = movie.value(forKey: Constants.posterPathColumn) as? String ?? ""
                    let movieVote = movie.value(forKey: Constants.voteAverangeColumn) as? Float ?? 0.0
                    let moviePopular = movie.value(forKey: Constants.popularColumn) as? Int ?? 0
                    let movieItem = Movie(id: movieID, title: movieTitle, posterPath: moviePoster, voteAverage: movieVote, popularity: moviePopular)
                    movies.append(movieItem)
                }
                observer.onNext(movies)
                observer.onCompleted()
            } catch let error {
                print("Get all movie error: \(error.localizedDescription)")
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func checkAvailable(movie: Movie) -> Observable<Bool> {
        return Observable.create { [weak self] observer in
            guard let `self` = self, let context = self.getManagedObjectContext() else {
                observer.onError(BaseError.unexpectedError)
                return Disposables.create()
            }
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.entityName)
            do {
                let movieList = try context.fetch(fetchRequest)
                for item in movieList {
                    let movieID = item.value(forKey: Constants.idColumn) as? Int
                    if movie.id == movieID {
                        observer.onNext(true)
                        observer.onCompleted()
                    }
                }
                observer.onNext(false)
                observer.onCompleted()
            } catch let error {
                print("Find movie by ID error: \(error.localizedDescription)")
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    private func findMovieById(movieID id: Int) -> NSManagedObject? {
        guard let context = getManagedObjectContext() else {
            return nil
        }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.entityName)
        do {
            let movieList = try context.fetch(fetchRequest)
            for movie in movieList {
                let movieID = movie.value(forKey: Constants.idColumn) as? Int
                if id == movieID {
                    return movie
                }
            }
        } catch let error {
            print("Find movie by ID error: \(error.localizedDescription)")
            return nil
        }
        return nil
    }
}
