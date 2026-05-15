//
//  DropdownListView.swift
//  BringTheFun
//
//  Created by Manpreet Singh
//
import Foundation
import UIKit

final class DropdownListView: UIView, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    private let blurView                                                    = UIVisualEffectView(effect: UIBlurEffect(style: .systemThickMaterialLight))
    private let searchBar                                                   = UISearchBar()
    private let tableView                                                   = UITableView()
                                                
    private let items                                                       : [String]
    private var filteredItems                                               : [String]
    private let selectedItem                                                : String?
    private let rowHeight                                                   : CGFloat
    private let maxHeight                                                   : CGFloat
    private let showSearch                                                  : Bool
    private let textAlignment                                               : NSTextAlignment
    private let onSelect                                                    : (Int, String) -> Void
    
    init(items: [String], selectedItem: String?, rowHeight: CGFloat,textAlignment: NSTextAlignment, maxHeight: CGFloat, showSearch: Bool, onSelect: @escaping (_ index: Int, _ item: String) -> Void) {
        
        self.items                                                          = items
        self.filteredItems                                                  = items
        self.selectedItem                                                   = selectedItem
        self.rowHeight                                                      = rowHeight
        self.textAlignment                                                  = textAlignment
        self.maxHeight                                                      = maxHeight
        self.showSearch                                                     = showSearch
        self.onSelect                                                       = onSelect
        
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        backgroundColor                                                     = .clear
        clipsToBounds                                                       = false
        
        layer.cornerRadius                                                  = 8
        layer.shadowColor                                                   = UIColor.black.cgColor
        layer.shadowOpacity                                                 = 0.18
        layer.shadowRadius                                                  = 8
        layer.shadowOffset                                                  = CGSize(width: 0.5, height: 4)
        
        blurView.backgroundColor                                            = .clear
        blurView.isOpaque                                                   = false
        blurView.layer.cornerRadius                                         = 8
        blurView.layer.masksToBounds                                        = true
        
        addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints                  = false
        
        NSLayoutConstraint.activate([blurView.topAnchor.constraint(equalTo: topAnchor),
                                     blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     blurView.bottomAnchor.constraint(equalTo: bottomAnchor)])
        
        let stack                                                           = UIStackView()
        stack.axis                                                          = .vertical
        stack.spacing                                                       = 0
        stack.backgroundColor                                               = .clear
        
        blurView.contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints                     = false
        
        NSLayoutConstraint.activate([stack.topAnchor.constraint(equalTo: blurView.contentView.topAnchor),
                                     stack.leadingAnchor.constraint(equalTo: blurView.contentView.leadingAnchor),
                                     stack.trailingAnchor.constraint(equalTo: blurView.contentView.trailingAnchor),
                                     stack.bottomAnchor.constraint(equalTo: blurView.contentView.bottomAnchor)])
        
        if showSearch {
            
            searchBar.placeholder                                           = "Search"
            searchBar.delegate                                              = self
            searchBar.searchBarStyle                                        = .minimal
            searchBar.backgroundImage                                       = UIImage()
            searchBar.backgroundColor                                       = .clear
            searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
            stack.addArrangedSubview(searchBar)
        }
        
        tableView.dataSource                                                = self
        tableView.delegate                                                  = self
        tableView.rowHeight                                                 = rowHeight
        tableView.separatorStyle                                            = .none
        tableView.backgroundColor                                           = .clear
        tableView.isOpaque                                                  = false
        tableView.keyboardDismissMode                                       = .onDrag
        tableView.isScrollEnabled                                           = true
        tableView.allowsSelection                                           = true
        
        stack.addArrangedSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell                                                            = UITableViewCell(style: .default, reuseIdentifier: nil)
        let item                                                            = filteredItems[indexPath.row]
                                                        
        let selectedText                                                    = selectedItem?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let itemText                                                        = item.trimmingCharacters(in: .whitespacesAndNewlines)
        let isSelected                                                      = itemText.caseInsensitiveCompare(selectedText) == .orderedSame
        
        cell.selectionStyle                                                 = .none
        cell.backgroundColor                                                = .clear
        cell.contentView.backgroundColor                                    = .clear
        cell.isOpaque                                                       = false
        cell.contentView.isOpaque                                           = false
        
        cell.textLabel?.font                                                = UIFont.systemFont(ofSize: 14, weight: .medium)
        cell.textLabel?.textAlignment                                       = textAlignment
        
        if isSelected {
            cell.backgroundColor                                            = UIColor(resource: .accent).withAlphaComponent(0.75)
            cell.textLabel?.textColor                                       = .white
            cell.textLabel?.text                                            = "✓ \(item)"
        }
        else {
            cell.backgroundColor                                            = .clear
            cell.textLabel?.textColor                                       = .black
            cell.textLabel?.text                                            = item
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        onSelect(indexPath.row, filteredItems[indexPath.row])
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let text                                        = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if text.isEmpty {
            filteredItems                               = items
        }
        else {
            filteredItems = items.filter {
                $0.localizedCaseInsensitiveContains(text)
            }
        }
        tableView.reloadData()
    }
}
