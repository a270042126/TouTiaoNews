//
//  MineViewController.swift
//  TouTiaoNews
//

//

import UIKit

class MineViewController: UITableViewController {
    
    fileprivate lazy var headerView = NoLoginHeaderView.loadViewFormNib()
    // 存储 cell的数据
    fileprivate lazy var sections = [[ICellModel]]()
    // 存储我的关注数据
    fileprivate lazy var concerns = [IConcern]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setupUI()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation_background_white" + (UserDefaults.standard.bool(forKey: isNight) ? "_night" : "")), for: .default)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension MineViewController{
    
    fileprivate func setupUI(){
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = headerView
        tableView.theme_backgroundColor = "colors.tableViewBackgroundColor"
        tableView.separatorColor = .none
        tableView?.ym_registerCell(cell: IFirstSectionCell.self)
        tableView?.ym_registerCell(cell: IOtherCell.self)
    }
}

extension MineViewController{
    
    fileprivate func loadData(){
        let iConcerViewModel = IConcernViewModel()
        iConcerViewModel.loadMyCellData {
            self.sections = iConcerViewModel.iCellModels
            self.tableView.reloadData()
            
            iConcerViewModel.loadMyConcernData {
                self.concerns = iConcerViewModel.iConcerns
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        }
    }
}

extension MineViewController{
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 0 : 10
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let swidth = self.view.bounds.width
        let view = UIView(frame: CGRect(x: 0, y: 0, width: swidth, height: 10))
        view.theme_backgroundColor = "colors.tableViewBackgroundColor"
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0{
            return (concerns.count == 0 || concerns.count == 1) ? 40 : 114
        }else{
            return 40
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0{
            let cell = tableView.ym_dequeueReusableCell(indexPath: indexPath) as IFirstSectionCell
            cell.iCellModel = sections[indexPath.section][indexPath.row]
            cell.collectionView.isHidden = (concerns.count == 0 || concerns.count == 1)
            if concerns.count == 1{cell.iConcern = concerns[0]}
            if concerns.count > 1{cell.iConcerns = concerns}
            
            return cell
        }else{
            let cell = tableView.ym_dequeueReusableCell(indexPath: indexPath) as IOtherCell
            let myCellModel = sections[indexPath.section][indexPath.row]
            cell.cellModel = myCellModel
            return cell
        }
    }
}
