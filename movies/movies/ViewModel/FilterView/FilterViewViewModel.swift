//
//  FilterViewViewModel.swift
//  movies
//
//  Created by Jacqueline Alves on 10/12/19.
//  Copyright © 2019 jacquelinealves. All rights reserved.
//

import Foundation
import Combine

protocol FilterViewDelegate: class {
    func showFilterOptionsView(withViewModel: FilterOptionsViewModel)
}

class FilterViewViewModel {
    weak var delegate: FilterViewDelegate?
    
    private let filters: [Filter]
    private let subject: CurrentValueSubject<[Filter], Never> // Filters subject from favorite list view
    
    var filterCount: Int {
        return self.filters.count
    }
    
    // Cancellables
    private var filtersSubscriber: AnyCancellable?
    
    init(filterSubject: CurrentValueSubject<[Filter], Never>) {
        self.filters = filterSubject.value.map { $0.copy() } // Set filter as copy of current filters, without their selected values
        self.subject = filterSubject
    }
    
    // MARK: - Flow
    
    public func showFilterOptionsForItem(at index: Int) {
        guard let viewModel = viewModelForFilterOptions(at: index) else { return }
        self.delegate?.showFilterOptionsView(withViewModel: viewModel)
    }
    
    // MARK: - Data Conversion
    
    public func viewModelForFilter(at index: Int) -> FilterCategoryCellViewModel? {
        guard index < self.filters.count else { return nil }
        return FilterCategoryCellViewModel(filter: self.filters[index])
    }
    
    public func viewModelForFilterOptions(at index: Int) -> FilterOptionsViewModel? {
        guard index < self.filters.count else { return nil }
        return FilterOptionsViewModel(filter: self.filters[index])
    }
    
    public func applyFilters() {
        self.subject.send(self.filters.map { $0.copy() })
    }
}
