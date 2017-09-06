//
//  VerticalHorizontalScrollingCollectionViewLayout.swift
//  Capstone
//
//  Created by Mithun Reddy on 9/5/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class VerticalHorizontalScrollingCollectionViewLayout: UICollectionViewLayout {

    let cell_width = 179.5
    let cell_height = 39.0
    
    var cellAttrsDictionary = Dictionary<IndexPath, UICollectionViewLayoutAttributes>()
    
    var contentSize = CGSize.zero
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    
    override func prepare() {
        guard let collectionView = collectionView else { return }
        // Cycle through each section of the data source
        if collectionView.numberOfSections > 0 {
            for section in 0...collectionView.numberOfSections - 1 {
                //Cycle through each item in the section
                if collectionView.numberOfItems(inSection: section) > 0 {
                    for item in 0...collectionView.numberOfItems(inSection: section) - 1 {
                        // Build the UICollectionViewLayoutAttributes for the cell.
                        let cellIndex = IndexPath(item: item, section: section)
                        let xPos = Double(section) * cell_width
                        let yPos = Double(item) * cell_height
                        
                        let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex)
                        cellAttributes.frame = CGRect(x: xPos, y: yPos, width: cell_width, height: cell_height)
                        cellAttributes.zIndex = 1
                        
                        // Save the attributes
                        cellAttrsDictionary[cellIndex] = cellAttributes
                    }
                }
            }
            
        }
        
        // Update content size.
        let contentWidth = Double(collectionView.numberOfSections) * cell_width
        let contentHeight = 4 * cell_height
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
        
    }
    
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttrsDictionary[indexPath]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // Create an array to hold all elements found in our current view.
        var attributesInRect = [UICollectionViewLayoutAttributes]()
        
        // Check each element to see if it should be returned.
        for cellAttributes in cellAttrsDictionary.values {
            if rect.intersects(cellAttributes.frame) {
                attributesInRect.append(cellAttributes)
            }
        }
        
        // Return list of elements.
        return attributesInRect
    }
}
