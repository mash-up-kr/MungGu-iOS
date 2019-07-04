//
//  MasterViewController.swift
//  MungGu iOS
//
//  Created by 안예림 on 29/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    @IBOutlet weak var mySearchBar: UISearchBar!
    var files = [
        File(title: "인간행동과 심리", content: "인간행동과 심리 파일이 없습니다.", date: 0627),
        File(title: "인간이란", content: "루이스 캐럴(필명)이 속했던 옥스퍼드 크라이스트 처치 칼리지 학장의 딸이자 캐럴과 친분도 있던 앨리스 플레전스 리들을 위해 즉석에서 지어내어 들려주었던 이야기를 수정하여 1865년에 출판하였다. 루이스 캐럴이 직접 삽화까지 그린 <땅속 나라의 앨리스>가 원본으로, <이상한 나라의 앨리스>는 <땅속 나라의 앨리스>의 판매용 개정판이라 볼 수 있다.이상한 나라의 앨리스 출간으로부터 약 6년 후 속편 <거울 나라의 앨리스>를 발표하였다. 170여개의 언어로 번역되었으며, 러시아어 판본은 롤리타를 집필한 작가 블라디미르 나보코프가 번역했다고 한다.처음 출판되기까지 꽤 복잡한 일을 겪은 소설인데 몇권 남지 않은 진짜 초판본은 고서적 분야에서 성배 취급을 받으며 엄청난 가격이 매겨진다.이 작품이 사회 전반에 끼친 영향은 실로 대단했다. 앨리스 마니아가 없는 분야가 없을 정도여서, 철학자, 수학자, 물리학자, 심리학자들에게 많은 영감을 주었다. 특히 물리학에서는 빅뱅이론, 카오스 이론, 상대성 이론, 양자역학 등을 설명할 때, 이 작품과 거울 나라의 앨리스가 약방의 감초처럼 인용된다. 그 외에도 진화생물학 등 다른 과학계에서도 폭넓게 인용되며, 이상한 나라의 앨리스 증후군이라는 질병도 있다. 롤리타로 유명한 블라디미르 나보코프에게도 많은 영향을 줬다.", date: 0628)
    ]
    var filteredFiles = [File]()
    weak var delegate: MasterViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        filteredFiles = files
        setUpSearchBar()
    }

    private func setUpSearchBar() {
        mySearchBar.delegate = self
    }

    // MARK: - TableviewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFiles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let file = filteredFiles[indexPath.row]
        cell.textLabel?.text = file.title

        return cell
    }

    // MARK: - tableviewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedData = files[indexPath.row]
        print(selectedData)
        print(delegate)
        delegate?.didselect(with: selectedData)
    }
}

extension MasterViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            filteredFiles = files
            tableView.reloadData()
            return
        }
        filteredFiles = files.filter({ file -> Bool in
            file.title.contains(searchText)
        })
        tableView.reloadData()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
