//
//  ViewController.swift
//  TestProject
//
//  Created by Zaven Madoyan on 30.09.23.
//

import UIKit

final class MessageViewController: UIViewController  {
    @IBOutlet private weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let viewModel: MessageViewModel = MessageViewModel()
    private let scrollToSpecificIndex = 1000
    private let identifier = "MessageCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        viewModel.loadData()
    }
    
    private func setupCollectionView() {
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.register(UINib(nibName: identifier, bundle: nil),
                                forCellWithReuseIdentifier: identifier)
    }
    
    private func loading(_ isLoading: Bool) {
        isLoading ? loadingActivityIndicator.startAnimating() : loadingActivityIndicator.stopAnimating()
    }
    
    // MARK: - IBAction
    
    @IBAction func selectItemAction(_ sender: Any) {
        let desiredIndex = scrollToSpecificIndex - 1
        scrollToCellInMiddle(desiredIndex)
    }
    
    // MARK: - Scroll to the desired index
    
    private func scrollToCellInMiddle(_ index: Int) {
        while index > viewModel.data.count {
            loadMoreData()
        }
        
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let boundsHeight = scrollView.bounds.height
        
        // Load more data when scrolling to the bottom
        if offsetY > contentHeight - boundsHeight {
            loading(true)
            loadMoreData()
        }
    }
    
    // Simulate loading more data
    func loadMoreData() {
        viewModel.loadData()
        collectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loading(false)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension MessageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! MessageCollectionViewCell
        cell.titleLabel.text = viewModel.data[indexPath.item].text
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MessageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message =  viewModel.data[indexPath.item]
        return CGSize(width: collectionView.frame.width, height: message.height)
    }
}
