//
//  FavoriteListViewModelSpec.swift
//  moviesTests
//
//  Created by Jacqueline Alves on 16/12/19.
//  Copyright © 2019 jacquelinealves. All rights reserved.
//

import Quick
import Nimble

@testable import Movs

class FavoriteListViewModelSpec: QuickSpec {
    override func spec() {
        var sut: FavoriteListViewModel!
        var dataProvider: DataProvidable!
        
        describe("the 'Favorite List' view model") {
            context("when filter array of movies ") {
                var filteredMovies = [Movie]()
                
                context("by name ") {
                    context("with more than one match ") {
                        beforeEach {
                            dataProvider = MockedDataProvider()
                            sut = FavoriteListViewModel(dataProvider: dataProvider)
                            filteredMovies = sut.filterArray(sut.dataProvider.favoriteMovies, with: "The")
                        }
                        
                        it("should return two movies.") {
                            expect(filteredMovies.count).to(be(2))
                        }
                    }
                    
                    context("with no matches ") {
                        beforeEach {
                            dataProvider = MockedDataProvider()
                            sut = FavoriteListViewModel(dataProvider: dataProvider)
                            filteredMovies = sut.filterArray(sut.dataProvider.favoriteMovies, with: "Captain")
                        }
                        
                        it("should return two movies.") {
                            expect(filteredMovies.count).to(be(0))
                        }
                    }
                }
                
                context("by custom filters ") {
                    context("using date ") {
                        beforeEach {
                            dataProvider = MockedDataProvider()
                            sut = FavoriteListViewModel(dataProvider: dataProvider)
                            
                            var filters = sut.filters.value
                            
                            let releaseDateFilter = ReleaseDateFilter(withOptions: ["1989", "2010", "2009", "2016"])
                            releaseDateFilter.selected.send([1])
                            
                            filters.append(releaseDateFilter)
                            
                            filteredMovies = sut.filterArray(sut.dataProvider.favoriteMovies, with: filters)
                        }
                        
                        it("should return two movies.") {
                            expect(filteredMovies.count).to(be(2))
                        }
                    }
                    
                    context("using genre ") {
                        beforeEach {
                            dataProvider = MockedDataProvider()
                            sut = FavoriteListViewModel(dataProvider: dataProvider)
                            
                            var filters = sut.filters.value
                            
                            let genreFilter = GenreFilter(withOptions: ["Animation", "Comedy", "Adventure", "Drama"], dict: sut.dataProvider.genres)
                            genreFilter.selected.send([0])
                            
                            filters.append(genreFilter)
                            
                            filteredMovies = sut.filterArray(sut.dataProvider.favoriteMovies, with: filters)
                        }
                        
                        it("should return three movies.") {
                            expect(filteredMovies.count).to(be(3))
                        }
                    }
                    
                    context("using date and genre ") {
                        beforeEach {
                            dataProvider = MockedDataProvider()
                            sut = FavoriteListViewModel(dataProvider: dataProvider)
                            
                            var filters = sut.filters.value
                            
                            let releaseDateFilter = ReleaseDateFilter(withOptions: ["1989", "2010", "2009", "2016"])
                            releaseDateFilter.selected.send([1])
                            
                            let genreFilter = GenreFilter(withOptions: ["Animation", "Comedy", "Adventure", "Drama"], dict: sut.dataProvider.genres)
                            genreFilter.selected.send([3])
                            
                            filters.append(releaseDateFilter)
                            filters.append(genreFilter)
                            
                            filteredMovies = sut.filterArray(sut.dataProvider.favoriteMovies, with: filters)
                        }
                        
                        it("should return two movies.") {
                            expect(filteredMovies.count).to(be(1))
                        }
                    }
                }
            }
            
            context("when get all movie dates") {
                var returnedDates = [String]()
                let correctDates: [String] = ["1989", "2009", "2010"]
                
                beforeEach {
                    dataProvider = MockedDataProvider()
                    sut = FavoriteListViewModel(dataProvider: dataProvider)
                    returnedDates = sut.getAllDates(from: dataProvider.favoriteMovies)
                }
                
                it("should return correct dates.") {
                    expect(returnedDates).to(equal(correctDates))
                }
            }
            
            context("when get all movie genres") {
                var returnedGenres = [String]()
                let correctGenres: [String] = ["Animation", "Comedy", "Drama"]
                
                beforeEach {
                    dataProvider = MockedDataProvider()
                    sut = FavoriteListViewModel(dataProvider: dataProvider)
                    returnedGenres = sut.getAllGenres(from: dataProvider.favoriteMovies, genresDictionary: dataProvider.genres)
                }
                
                it("should return correct genres.") {
                    expect(returnedGenres).to(equal(correctGenres))
                }
            }
            
            context("when clean an array ") {
                var cleanedArray = [String]()
                let testArray = ["9", "2", nil, "7", nil, "2"]
                let correctArray = ["2", "7", "9"]
                
                beforeEach {
                    dataProvider = MockedDataProvider()
                    sut = FavoriteListViewModel(dataProvider: dataProvider)
                    cleanedArray = sut.cleanArray(testArray)
                }
                
                it("should return sorted, non nil and non duplicates values in array.") {
                    expect(cleanedArray).to(equal(correctArray))
                }
            }
        }
    }
}
