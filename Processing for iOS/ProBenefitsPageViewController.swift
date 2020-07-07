//
//  ProBenefitsPageViewController.swift
//  Processing for iOS
//
//  Created by Frederik Riedel on 7/7/20.
//  Copyright © 2020 Frederik Riedel. All rights reserved.
//

import UIKit

protocol ProBenefitsPageViewControllerDelegate {
    func didChangePageToIndex(index: Int)
}

class ProBenefitsPageViewController: UIPageViewController {

    let numberOfVCs = 3
    var lastPendingViewControllerIndex = 0
    
    var pageDelegate: ProBenefitsPageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isDoubleSided = false
        dataSource = self
        delegate = self
        
        
        setViewControllers([ viewControllerForIndex(index: 0) ], direction: .forward, animated: false)
        
        // Do any additional setup after loading the view.
    }
    
    func scrollToIndex(index: Int) {
        setViewControllers([ viewControllerForIndex(index: index) ], direction: .forward, animated: true)
    }

    private func viewControllerForIndex(index: Int) -> UIViewController {
        let newPage = ProBenefitViewController()
        newPage.index = index
        return newPage
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func mod(_ a: Int, _ n: Int) -> Int {
        precondition(n > 0, "modulus must be positive")
        let r = a % n
        return r >= 0 ? r : r + n
    }
}


extension ProBenefitsPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let index = mod(((viewController as! IndexedPageViewController).index - 1), numberOfVCs)
        
        return viewControllerForIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let index = mod(((viewController as! IndexedPageViewController).index + 1), numberOfVCs)
        
        return viewControllerForIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            pageDelegate?.didChangePageToIndex(index: lastPendingViewControllerIndex)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let viewController = pendingViewControllers.first as? IndexedPageViewController {
            lastPendingViewControllerIndex = viewController.index
        }
    }
}
