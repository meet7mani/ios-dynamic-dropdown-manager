# iOS Dynamic Dropdown Manager

A reusable UIKit dropdown manager for iOS with smart positioning, dynamic width, optional search, and selection callback support.

This component can show a dropdown from any `UIView` and automatically adjusts its position based on content and available screen space.

---

## 🚀 Features

- Show dropdown from any `UIView`
- Auto-position upward or downward based on available screen space
- Dynamic width based on content
- Optional search bar for large lists
- Pre-selected item support
- Custom text alignment
- Custom row height
- Maximum dropdown height support
- Returns selected index and selected item
- Simple reusable API

---

## 📱 Screenshots

### Compact Dropdown

Small option list dropdown with automatic sizing and selected state.

<img width="393" height="763" alt="dropdown-simple-medium" src="https://github.com/user-attachments/assets/c34142a7-5280-4982-8502-f3255958043c" />


---

### Searchable Dropdown

Large list dropdown with search support and smart positioning.

<img width="810" height="1355" alt="dropdown-search-medium" src="https://github.com/user-attachments/assets/dcc52ab3-e409-499e-ae64-11ff8251b85f" />


---

## ⚙️ Usage

### Basic Dropdown

Use this for small option lists such as page size, status, sorting, or filters.

```swift
DropdownManager.shared.showDropdown(
    from: sender,
    in: self.view,
    items: ["10", "25", "50", "100"],
    selectedItem: "10"
) { index, item in

    print("\(item)")
}
```

---

### Dropdown with Search

For larger lists, such as country names, enable search conditionally.

```swift
DropdownManager.shared.showDropdown(
    from: sender,
    in: view.window ?? self.view,
    items: countriesName,
    selectedItem: preSelectedCountry,
    textAlignment: countriesName.count > 6 ? .left : .center,
    showSearch: countriesName.count > 10
) { [weak self] index, item in

    print("\(item)")
}
```

---

## 🧩 Main Method

```swift
func showDropdown(
    from sourceView: UIView,
    in parentView: UIView,
    items: [String],
    selectedItem: String?,
    textAlignment: NSTextAlignment = .center,
    rowHeight: CGFloat = 36,
    maxHeight: CGFloat = 300,
    showSearch: Bool = false,
    onSelect: @escaping (_ index: Int, _ item: String) -> Void
)
```

---

## 📌 Parameters

| Parameter | Type | Description |
|---|---|---|
| `sourceView` | `UIView` | View from which dropdown should appear |
| `parentView` | `UIView` | Parent view where dropdown will be added |
| `items` | `[String]` | Dropdown items |
| `selectedItem` | `String?` | Pre-selected item |
| `textAlignment` | `NSTextAlignment` | Text alignment for dropdown rows |
| `rowHeight` | `CGFloat` | Height of each dropdown row |
| `maxHeight` | `CGFloat` | Maximum dropdown height |
| `showSearch` | `Bool` | Shows search bar when enabled |
| `onSelect` | Closure | Returns selected index and item |

---

## 🧠 How It Works

The dropdown manager calculates:

- available space above the source view
- available space below the source view
- required dropdown height
- content-based width

Based on this, it decides whether the dropdown should open upward or downward.

This prevents the dropdown from going outside the screen and makes it usable across different layouts and screen sizes.

---

## 🔍 Search Behavior

Search is optional and can be enabled only when needed.

Example:

```swift
showSearch: countriesName.count > 10
```

This keeps small dropdowns simple and makes large dropdowns easier to use.

---

## 💡 Use Cases

This dropdown manager can be used for:

- Country selection
- State selection
- Venue selection
- Pagination limits
- Filters
- Sorting options
- Category selection
- Status selection
- Server-driven dropdown lists

---

## 🔗 Medium Article

Read the full explanation here:

👉 https://medium.com/@manpreet.s_92558/building-a-dynamic-dropdown-manager-in-ios-auto-position-search-selection-58e1d0d047c9

---

## ✍️ Author
Built with 💙 by Manpreet Singh  
