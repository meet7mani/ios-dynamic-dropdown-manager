//
//  DropdownManager.swift
//  BringTheFun
//
//  Created by Manpreet Singh
//

import Foundation
import UIKit

final class DropdownManager: NSObject {
    
    static let shared = DropdownManager()
    
    private var overlayView: UIView?
    private var dropdownView: UIView?
    
    private override init() {}
    
    func showDropdown(from sourceView: UIView,
                      in parentView: UIView,
                      items: [String],
                      selectedItem: String?,
                      textAlignment: NSTextAlignment = .center,
                      rowHeight: CGFloat = 36,
                      maxHeight: CGFloat = 300,
                      showSearch: Bool = false,
                      onSelect: @escaping (_ index: Int, _ item: String) -> Void) {
        
        dismiss()
        
        let overlay = UIView(frame: parentView.bounds)
        overlay.backgroundColor = .clear
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleOverlayTap))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        overlay.addGestureRecognizer(tap)
        
        parentView.addSubview(overlay)
        overlayView = overlay
        
        let dropdown = DropdownListView(items: items,
                                        selectedItem: selectedItem,
                                        rowHeight: rowHeight,
                                        textAlignment: textAlignment,
                                        maxHeight: maxHeight,
                                        showSearch: showSearch) { [weak self] (index, item)  in
            onSelect(index,item)
            self?.dismiss()
        }
        
        overlay.addSubview(dropdown)
        dropdown.translatesAutoresizingMaskIntoConstraints = false
        dropdownView = dropdown
        
        let sourceFrame = sourceView.convert(sourceView.bounds, to: parentView)

        let padding         : CGFloat = 12
        let parentWidth     = parentView.bounds.width
        let parentHeight    = parentView.bounds.height

        let searchHeight    : CGFloat = showSearch ? 44 : 0
        var totalHeight     = min(CGFloat(items.count) * rowHeight + searchHeight, maxHeight)

        let maxAllowedWidth = parentWidth - (padding * 2)

        let calculatedWidth = calculateDropdownWidth(items: items,
                                                     selectedItem: selectedItem,
                                                     minWidth: 70,
                                                     maxWidth: maxAllowedWidth,
                                                     horizontalPadding: 36)

        let finalWidth = calculatedWidth
        let safeFinalWidth = min(finalWidth, maxAllowedWidth)

        // X position
        var x = sourceFrame.minX

        if x + safeFinalWidth > parentWidth - padding {
            x = parentWidth - padding - safeFinalWidth
        }

        if x < padding {
            x = padding
        }

        // Y position
        let spaceBelow = parentHeight - sourceFrame.maxY - padding
        let spaceAbove = sourceFrame.minY - padding

        var y: CGFloat

        if totalHeight <= spaceBelow {
            // enough space below
            y = sourceFrame.maxY + 4
        } else if totalHeight <= spaceAbove {
            // not enough below, enough above
            y = sourceFrame.minY - totalHeight - 4
        } else {
            // not enough full space either side, choose bigger side and shrink height
            if spaceBelow >= spaceAbove {
                y = sourceFrame.maxY + 4
                totalHeight = max(80, spaceBelow - 4)
            }
            else {
                totalHeight = max(80, spaceAbove - 4)
                y = sourceFrame.minY - totalHeight - 4
            }
        }

        NSLayoutConstraint.activate([dropdown.topAnchor.constraint(equalTo: overlay.topAnchor,
                                                                   constant: y),
                                     dropdown.leadingAnchor.constraint(equalTo: overlay.leadingAnchor,
                                                                       constant: x),
                                     dropdown.widthAnchor.constraint(equalToConstant: safeFinalWidth),
                                     dropdown.heightAnchor.constraint(equalToConstant: totalHeight)])
    }
    
    private func calculateDropdownWidth(items: [String], selectedItem: String?, minWidth: CGFloat, maxWidth: CGFloat, horizontalPadding: CGFloat) -> CGFloat {
        
        var allTexts = items
        
        if let selectedItem = selectedItem {
            allTexts.append("✓ \(selectedItem)")
        }
        
        let maxTextWidth = allTexts.map { text in
            (text as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular)]).width
        }.max() ?? minWidth
        
        return min(max(maxTextWidth + horizontalPadding, minWidth), maxWidth)
    }
    
    @objc private func handleOverlayTap() {
        dismiss()
    }
    
    func dismiss() {
        dropdownView?.removeFromSuperview()
        overlayView?.removeFromSuperview()
        dropdownView = nil
        overlayView = nil
    }
}
extension DropdownManager : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        
        guard let dropdownView = dropdownView else { return true }
        
        // If touch is inside dropdown, do not dismiss
        let touchPoint = touch.location(in: dropdownView)
        
        if dropdownView.bounds.contains(touchPoint) {
            return false
        }
        
        return true
    }
}
