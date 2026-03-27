#  TaskExplorerKnC (iOS - UIKit + RxSwift)

A simple iOS application to display, search, filter, and manage favorite tasks using **UIKit**, **RxSwift**, and **MVVM architecture**.

---

## Features

*  Fetch task list from API
*  Search tasks (real-time with debounce)
*  Filter tasks:

  * All
  * Completed
  * Not Completed
  * Favorite
*  Mark / Unmark task as favorite
*  Persist favorite tasks using UserDefaults
*  Auto refresh when returning from detail screen
*  Loading indicator support
*  Clean UI with SnapKit

---

##  Architecture

This project uses **MVVM (Model-View-ViewModel)** combined with **Reactive Programming (RxSwift)**.

### Structure:

* **View (UIViewController)**

  * Handle UI & user interaction
  * Bind data from ViewModel

* **ViewModel**

  * Business logic
  * Filter, search, and state handling

* **Model**

  * Task entity

* **Service**

  * API call abstraction (`ApiServiceProtocol`)

* **Storage**

  * Local persistence using `UserDefaults`

---

## Tech Stack

* UIKit
* RxSwift
* RxCocoa
* SnapKit

---

##  Screens

### Task List

* Search + Filter
* Dynamic list rendering

### Task Detail

* Task information
* Favorite toggle (bookmark)

---

## Data Flow

1. Fetch tasks from API
2. Store in `allTasks`
3. Apply:

   * Filter
   * Search
4. Bind result to UI via `BehaviorRelay`

---

## Favorite System

Favorites are stored locally using `UserDefaults`.

* Add favorite → append ID
* Remove favorite → remove ID
* Data automatically reflected in list after returning from detail screen

---

##  Reactive Flow Example

```swift
viewModel.tasks
    .bind(to: tableView.rx.items(...))
    .disposed(by: disposeBag)
```

---

## How to Run

1. Clone this repository
2. Run `pod install`
3. Open `.xcworkspace`
4. Run on simulator or real device

---

##  Author

Built by Hafsah

---
