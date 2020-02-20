//
//  FilterSpec.swift
//  moviesTests
//
//  Created by Jacqueline Alves on 16/12/19.
//  Copyright © 2019 jacquelinealves. All rights reserved.
//

import Quick
import Nimble

@testable import Movs

class FilterSpec: QuickSpec {
    override func spec() {
        describe("the 'Filter' ") {
            var filteredMovies: [Movie] = []
            var dataProvider: MockedDataProvider!
            
            context("when by date ") {
                beforeEach {
                    dataProvider = MockedDataProvider()
                    
                    let options = ["1989", "2010", "2009", "2016"]
                    let sut = ReleaseDateFilter(withOptions: options)
                    sut.selected.send([3])
                    
                    filteredMovies = sut.filter(dataProvider.popularMovies)
                }
                
                it("should return two movies.") {
                    expect(filteredMovies.count).to(be(2))
                }
            }
            
            context("when by genres ") {
                beforeEach {
                    dataProvider = MockedDataProvider()
                    
                    let options = ["Animation", "Comedy", "Adventure", "Drama"]
                    let sut = GenreFilter(withOptions: options, dict: dataProvider.genres)
                    sut.selected.send([1, 2])
                    
                    filteredMovies = sut.filter(dataProvider.popularMovies)
                }
                
                it("should return three movies.") {
                    expect(filteredMovies.count).to(be(3))
                }
            }
        }
    }
}
