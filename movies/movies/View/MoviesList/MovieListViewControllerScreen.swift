//
//  MovieListViewControllerScreen.swift
//  movies
//
//  Created by Jacqueline Alves on 01/12/19.
//  Copyright © 2019 jacquelinealves. All rights reserved.
//

import UIKit
import Combine

final class MovieListViewControllerScreen: UIView {
    
    lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
        
        let view: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCollectionViewCell")
        view.backgroundColor = .systemBackground
        
        return view
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: CGRect.zero)
        view.isUserInteractionEnabled = false
        view.startAnimating()
        
        return view
    }()
    
    let genericErrorView = ErrorView(imageName: "error_icon", text: "An error occured. Please try again.")
    let noDataErrorView = ErrorView(imageName: "search_icon", text: "Your search didn't return anything.")
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect = .zero, state: AnyPublisher<MovieListViewState, Never>) {
        self.init(frame: frame)
        
        _ = state
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] state in
                self?.updateViewState(to: state)
            })
    }
    
    func updateViewState(to state: MovieListViewState) {
        // State = .movies
        collectionView.isHidden = !(state == .movies)
        // State = .loading
        activityIndicator.isHidden = !(state == .loading)
        // State = .error
        genericErrorView.isHidden = !(state == .error)
        // State = .noDataError
        noDataErrorView.isHidden = !(state == .noDataError)
    }
}

extension MovieListViewControllerScreen: CodeView {
    
    func buildViewHierarchy() {
        addSubview(collectionView)
        addSubview(activityIndicator)
        addSubview(genericErrorView)
        addSubview(noDataErrorView)
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.right.bottom.equalToSuperview().inset(10)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.right.bottom.equalToSuperview().inset(10)
        }
        
        genericErrorView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.right.bottom.equalToSuperview().inset(10)
        }
        
        noDataErrorView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.right.bottom.equalToSuperview().inset(10)
        }
    }
    
    func setupAdditionalConfiguration() {
        backgroundColor = UIColor.systemBackground
    }
}
