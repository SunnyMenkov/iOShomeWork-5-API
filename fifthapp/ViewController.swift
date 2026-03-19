//
//  ViewController.swift
//  fifthapp
//
//  Created by меньков александр on 19.03.2026.
//

import UIKit

class ViewController: UIViewController {

    
    var catFacts: [String] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        // Do any additional setup after loading the view.
        
        setupTableView()
        
        let label = UILabel()
        label.text = "Cat Fact Here"
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
   
        label.frame = CGRect(x:20,y:50,width:200,height:100)
        label.center = view.center
    
        fetchData()
//        view.addSubview(label)
//        label.translatesAutoresizingMaskIntoConstraints = false
        
//        NSLayoutConstraint.activate([
////            label.widthAnchor.constraint(equalToConstant: 200),
////            
////            // надпись
////            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
//            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//        ])
        
     
        
    }
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        ])
        
    }

    private func fetchData(){
        //"https://jsonplaceholder.typicode.com/todos/"
        let urlString = "https://meowfacts.herokuapp.com/?count=50"
        
        guard let url = URL(string: urlString) else {
            print("bad url")
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {[weak self] data, response, error in
            if let error {
                print(error)
                return
            }
            
            // обрабатываем все кейсы если статус код не тот
            if let http = response as? HTTPURLResponse {
                print("Status", http.statusCode)
                guard (200...299).contains(http.statusCode) else
                {return}
            }
            
            guard let data else {return}
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(catFact.self, from: data)
//                print(result.data)
                DispatchQueue.main.async {
                    self?.catFacts = result.data}
                
                for fact in result.data {
                    print(fact)
                }
                
            } catch {
                print(error)
            }
        }
        task.resume()
        
    }

}

struct catFact: Codable {
    let data: [String]
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catFacts.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let fact = catFacts[indexPath.row]
        cell.textLabel?.text = fact
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = .systemFont(ofSize: 14)
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
//        return 100
//    }
//    
}
