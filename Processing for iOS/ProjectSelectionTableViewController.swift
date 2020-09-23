//
//  ProjectSelectionTableViewController.swift
//  Processing for iOS
//
//  Created by Frederik Riedel on 5/15/18.
//  Copyright © 2018 Frederik Riedel. All rights reserved.
//

import UIKit
import CoreServices

class ProjectSelectionTableViewController: UITableViewController,
    UIViewControllerPreviewingDelegate,
UIAlertViewDelegate {
    
    @IBOutlet weak var projectsCountLabel: UIBarButtonItem!
    
    var projects: [SimpleTextProject]?
    var filteredProjects: [SimpleTextProject]?
    let searchController = UISearchController(searchResultsController: nil)
    
    var adType: Benefit = .export
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Int.random(in: (0...1)) == 1 {
            adType = .codeFix
        }
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Projects"
        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        }
        searchController.searchBar.keyboardAppearance = .dark
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barStyle = .black
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = UIColor.processing()
            self.navigationItem.scrollEdgeAppearance = navBarAppearance
            self.navigationItem.standardAppearance = navBarAppearance
        }
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        }
        definesPresentationContext = true
        
        SketchController.loadProjects { (projects) in
            self.projects = projects
            self.tableView.reloadData()
        }
        
//        SketchController.loadSketches { (projects) in
//            self.projects = projects
//            self.tableView.reloadData()
//        }
        
        refreshProjectsCountLabel()
        projectsCountLabel.isEnabled = false
        projectsCountLabel.setTitleTextAttributes(
            [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)],
            for: .disabled
        )
        registerForPreviewing(with: self, sourceView: tableView)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didChangeSubscriptionStatus),
            name: NSNotification.Name(rawValue: "upgradedToPro"),
            object: nil
        )
    }
    
    
    @IBAction func importProject(_ sender: Any) {
        
        let documentBrowser = UIDocumentPickerViewController(documentTypes: ["public.txt", "public.js", "io.frogg.processing.pde"], in: .open)
        documentBrowser.delegate = self
        self.present(documentBrowser, animated: true)
        
//        let actionSheet = UIAlertController(title: "Import folder or file?", message: "Do you want to import a whole project, consisting of multiple files, or a single .pde or .js file?", preferredStyle: .alert)
//
//        let folderOption = UIAlertAction(title: "Import folder…", style: .default) { (_) in
//            let documentBrowser = UIDocumentPickerViewController(documentTypes: [kUTTypeFolder as String], in: .open)
//            documentBrowser.delegate = self
//            self.present(documentBrowser, animated: true)
//        }
//
//        let fileOption = UIAlertAction(title: "Import single file…", style: .default) { (_) in
//            let documentBrowser = UIDocumentPickerViewController(documentTypes: [kUTTypeText as String], in: .open)
//            documentBrowser.delegate = self
//            self.present(documentBrowser, animated: true)
//        }
//
//        let cancelOption = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
//
//        }
//
//        actionSheet.addAction(folderOption)
//        actionSheet.addAction(fileOption)
//        actionSheet.addAction(cancelOption)
//
//
//        present(actionSheet, animated: true)
 
        

    }
    
    @objc func didChangeSubscriptionStatus() {
        tableView.reloadSections([0], with: .automatic)
    }
    
    func refreshProjectsCountLabel() {
        if let numberOfProjects = projects?.count {
            projectsCountLabel.title = "\(numberOfProjects) Projects"
        } else {
            projectsCountLabel.title = "0 Projects"
        }
    }
    
    @IBAction func startSearch(_ sender: Any) {
        searchController.searchBar.becomeFirstResponder()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if ProBenefitsViewController.currentMembershipStatus == .subscribed {
                return 0
            }
            return 1
        }
        
        if isFiltering() {
            if let count = filteredProjects?.count {
                return count
            }
            return 0
        }
        
        if let count = projects?.count {
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if adType == .export {
                let cell = tableView.dequeueReusableCell(withIdentifier: "pro-ad-cell", for: indexPath)
                cell.layoutSubviews()
                cell.layoutIfNeeded()
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "pro-ad-cell-show-bugs", for: indexPath)
            cell.layoutSubviews()
            cell.layoutIfNeeded()
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "project-cell", for: indexPath)
            as? ProjectTableViewCell else {
                fatalError("Misconfigured cell type!")
        }
        
        if isFiltering() {
            if let project = filteredProjects?[indexPath.row] {
                cell.projectNameLabel.text = project.name
            }
            return cell
        }
        
        if let project = projects?[indexPath.row] {
            cell.projectNameLabel.text = project.name
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium
            
            cell.creationDateLabel.text = "Created: \(dateFormatter.string(from: project.creationDate))"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return UITableViewAutomaticDimension
        }
        
        return 66
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if indexPath.section == 0 {
            return false
        }
        
        if isFiltering() {
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let project = projects?[indexPath.row] {
                
                let alertController = UIAlertController(
                    title: "Delete Project",
                    message: "Are you sure that you want to delete the project \"\(project.name)\"? " +
                    "This cannot be undone.",
                    preferredStyle: .alert)
                
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                    SketchController.deleteSketch(withName: project.name)
                    
                    SketchController.loadProjects { (projects) in
                        self.projects = projects
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                        self.refreshProjectsCountLabel()
                    }
                }
                alertController.addAction(deleteAction)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
                    
                }
                alertController.addAction(cancelAction)
                
                present(alertController, animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let proBenefistVC = ProBenefitsViewController()
            proBenefistVC.shownBenefits = adType
            let navC = UINavigationController(rootViewController: proBenefistVC)
            navC.modalPresentationStyle = .formSheet
            
            self.present(navC, animated: true)
            
            return
        }
        
        var currentProjects = projects
        if isFiltering() {
            currentProjects = filteredProjects
        }
        
        if let project = currentProjects?[indexPath.row] {
            let editor = EditorTabViewController(withProject: project)
            //            let editor = PDEEditorViewController(pdeSketch: project)!
            navigationController?.pushViewController(editor, animated: true)
        }
    }
    
    @IBAction func about(_ sender: Any) {
        let aboutVC = AboutViewController()
        let aboutNavigationController = ProcessingNavigationViewController(rootViewController: aboutVC)
        aboutNavigationController.modalTransitionStyle = .coverVertical
        aboutNavigationController.modalPresentationStyle = .formSheet
        
        self.navigationController?.present(aboutNavigationController, animated: true, completion: nil)
    }
    
    @IBAction func createNewProject(_ sender: UIBarButtonItem) {
        
//        self.showCreateAlert(title: "New Processing Project", name: "")
        
        guard let button = sender.value(forKey: "view") as? UIView else {
            return
        }

        let actionSheet = UIAlertController(title: "Create a new Project", message: "This app supports working with Processing (.pde) and P5.js (.js) project files.", preferredStyle: .actionSheet)

        actionSheet.modalPresentationStyle = .popover


        let processing = UIAlertAction(title: "New Processing Project", style: .default) { (_) in
            self.showCreateAlert(title: "New Processing Project", name: "")
        }

        let p5js = UIAlertAction(title: "New P5.js Project", style: .default) { (_) in
            self.showCreateAlert(title: "New P5.js Project", name: "", type: "js")
        }
        
        let importButton = UIAlertAction(title: "Import Project…", style: .default) { (sender) in
            self.importProject(sender)
        }

        actionSheet.addAction(processing)
        actionSheet.addAction(p5js)
        actionSheet.addAction(importButton)

        if let popover = actionSheet.popoverPresentationController {
            popover.sourceView = button
        }

        present(actionSheet, animated: true)
    }
    
    
    private func showImportError(error: String) {
        let alert = UIAlertController(title: "Import Error", message: error, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .cancel) { (_) in
            
        }
        
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
    
    
    func importFiles(files: [URL]) {
        
        if files.isEmpty {
            showImportError(error: "No file has been selected.")
            return
        }
        
        var fileType = ""
        var fileName = ""
        if files.count == 1 {
            fileType = files.first!.pathExtension
            fileName = files.first!.lastPathComponent.replacingOccurrences(of: ".\(fileType)", with: "")
        } else {
            
            let firstKnownFileExtension = files.first { (url) -> Bool in
                return url.pathExtension == "pde" || url.pathExtension == "js"
            }?.pathExtension
            
            if let firstKnowFileExtension = firstKnownFileExtension {
                fileType = firstKnowFileExtension
            } else {
                showImportError(error: "Folder does not conain any known file formats (.pde or .js).")
                return
            }
        }
        
        if fileType == "" {
            showImportError(error: "Unknown file format.")
            return
        }
        
        
        showCreateAlert(title: "Import Project", name: fileName, type: fileType, importingFiles: files)
    }
    
    func showCreateAlert(title: String, name: String, type: String = "pde", importingFiles: [URL] = []) {
        
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        alertController.addAction(createAlertAction(alertController: alertController, type: type, importingFiles: importingFiles))
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.textAlignment = .left
            textField.text = name
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func createAlertAction(alertController: UIAlertController, type: String, importingFiles: [URL]) -> UIAlertAction {
        return UIAlertAction(title: "Create", style: .default, handler: { (_) in
            if let fileName = alertController.textFields?[0].text {
                let letters = NSMutableCharacterSet.letters as? NSMutableCharacterSet
                letters?.addCharacters(in: "-_1234567890")
                
                var message = ""
                var suggestedName = fileName
                if fileName == "" {
                    message = "Name should be at least one character"
                } else if self.nameAlreadyExists(name: fileName) {
                    message = "File with name '\(fileName)' already exists. " +
                    "Please choose another name or delete the exiting one first."
                } else if fileName.contains(" ") {
                    message = "File name should not contain spaces."
                    suggestedName = fileName.replacingOccurrences(of: " ", with: "_")
                } else if !(letters?.isSuperset(of: CharacterSet.init(charactersIn: fileName)))! {
                    message = "File name should contain no fancy symbols."
                } else {
                    
                    if type == "pde" {
                        self.createNewProcessingProject(name: fileName, importingFiles: importingFiles)
                    } else if type == "js" {
                        self.createNewP5JSProject(name: fileName, importingFiles: importingFiles)
                    }
                    
                    return
                }
                
                self.showCreateAlert(title: message, name: suggestedName)
            }
        })
    }
    
    private func createNewProcessingProject(name: String, importingFiles: [URL]) {
        // filename is correct
        let newProject = PDEProject(withProjectName: name, importingFiles: importingFiles)
        selectNewSketch(withName: newProject.name)
    }
    
    private func createNewP5JSProject(name: String, importingFiles: [URL]) {
        // filename is correct
        let newProject = P5JSProject(withProjectName: name, importingFiles: importingFiles)
        selectNewSketch(withName: newProject.name)
    }
    
    private func selectNewSketch(withName name: String) {
        
        SketchController.loadProjects { (projects) in
            self.projects = projects
            self.tableView.reloadData()
            self.refreshProjectsCountLabel()
            
            let index = projects?.enumerated().reduce(nil, { (result, enumerator) -> Int? in
                if name == enumerator.element.name {
                    return enumerator.offset
                }
                
                return result
            })
            
            if let index = index {
                self.tableView.selectRow(
                    at: IndexPath(row: index, section: 1),
                    animated: true,
                    scrollPosition: .middle
                )
            }
            
        }
        
    
    }
    
    
    private func nameAlreadyExists(name: String) -> Bool {
        for project in projects! where project.name == name {
            return true
        }
        return false
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        
        if let indexPath = tableView.indexPathForRow(at: location) {
            
            if indexPath.section == 0 {
                return nil
            }
            
            let cell = tableView.cellForRow(at: indexPath)
            previewingContext.sourceRect = (cell?.frame)!
            
            let project: SimpleTextProject
            if isFiltering() {
                project = filteredProjects![indexPath.row]
            } else {
                project = projects![indexPath.row]
            }
            let editor = EditorTabViewController(withProject: project)
            return editor
        }
        
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: false)
        
    }
    
    private func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredProjects = projects?.filter({ (project) -> Bool in
            return project.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension ProjectSelectionTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension ProjectSelectionTableViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        if let folder = urls.first {
            folder.startAccessingSecurityScopedResource()
            if let filesInFolder = try? FileManager.default.contentsOfDirectory(atPath: folder.path) {
                self.importFiles(files: filesInFolder.map({ (path) -> URL in
                    return URL(fileURLWithPath: path)
                }))
                folder.stopAccessingSecurityScopedResource()
                return
            }
            folder.stopAccessingSecurityScopedResource()
        }
        
        self.importFiles(files: urls)
    }
}
