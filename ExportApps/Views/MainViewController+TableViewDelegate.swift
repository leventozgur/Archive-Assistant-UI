//
//  MainViewController+TableViewDelegate.swift
//  ExportApps
//
//  Created by Levent ÖZGÜR on 29.09.2023.
//

import Cocoa

extension MainViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView === self.activeTableView {
            return self.viewModel.getActiveQueueList().count
        } else if tableView === self.complatedTableView {
            return self.viewModel.getComplatedQueueList().count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        guard let column = tableColumn else { return nil }
        guard let columnIndex = tableView.tableColumns.firstIndex(of: column) else { return nil }
        
        if tableView === self.activeTableView {
            return self.viewModel.getActiveQueueList()[row].getValueWithIndex(index: columnIndex)
        } else if tableView === self.complatedTableView {
            return self.viewModel.getComplatedQueueList()[row].getValueWithIndex(index: columnIndex)
        }
        
        return nil
    }
    
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        if tableView === self.activeTableView {
            let item = self.viewModel.getActiveQueueList()[row]
            self.viewModel.setSelectedRowItemFromActiveTable(item: item)
        }
        return true
    }
}
