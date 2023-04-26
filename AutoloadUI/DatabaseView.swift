//
//  DatabaseView.swift
//  AutoloadUI
//
//  Created by David McCarthy on 28/04/2022.
//

import SwiftUI

//  Format from server
public struct TableData: Decodable {
    
    let id: String
    let count:Int
    let limit: Int
    let offset: Int
    let message: String
    let columns: [String]
    let rows:[[String]]
}

//  Format from server
public struct TrashData: Decodable {
    
    let id: String
    let message: String
}

//  Generic string field
struct Field: Identifiable {
    
    var id = UUID()
    var value:String
    //var font:Font = .subheadline
    
    init(value:String) {
        self.value = value
    }
}

//  Column
struct Column: Identifiable {
 
    var id = UUID()
    var name:String
    
    init(name:String){
        self.name = name.uppercased()
    }
}

//  Generic record
struct Record: Identifiable {
    
    var id = UUID()
    var fields:[Field] = []
    
    init(values:[String]) {
        
        for value in values {
            self.fields.append(Field(value:value))
        }
    }
}

//  Database model
class DatabaseModel: ObservableObject {
    
    var session:URLSession = URLSession.shared
    
    //  Params
    var id = ""
    var domain = ""
    var database = ""
    var table = ""
    var join = ""
    var pagesize:Int = 1000
    
    //  Selected results
    @Published var columns:[Column] = []
    @Published var records:[Record] = []
    
    //  Generic message
    @Published var message:String = ""
    
    //  Select database rows
    func select(columns:String, offset:Int = 0, filter:String = "", groupby:String="", orderby:String = "",completion:@escaping (Bool,String)->()={b,s in}){
        
        let params:[String : Any] = [
            "database" : "\(database)",
            "table" : "\(table)",
            "columns" : "\(columns)",
            "join" : "\(join)",
            "filter" : "\(filter)",
            "groupby" : "\(groupby)",
            "orderby" : "\(orderby)",
            "limit" : "\(self.pagesize)",
            "offset" : "\(offset)"
        ]
        
        //  Post query and populate response
        query(method: "tablemaker", params: params) { code, jsonData in

            let tableData: TableData = try! JSONDecoder().decode(TableData.self, from: jsonData)
            
            self.columns.removeAll()
            self.records.removeAll()
            
            //  Error message?
            if(tableData.message != ""){
                self.records.append(Record(values: [tableData.message]))
            }
            
            //  Build rows
            for col in tableData.columns {
                self.columns.append(Column(name: col))
            }
            
            //  Build records from query resulting rows
            for row in tableData.rows {
                self.records.append(Record(values: row))
            }
        }
    }
    
    //  Create database row
    func insert(columns:String, values:String, completion:@escaping (Bool,String)->()={b,s in}){
        
        let params:[String : Any] = [
            "database" : "\(database)",
            "table" : "\(table)",
            "columns" : "\(columns)",
            "values" : "\(values)"
        ]
        
        query(method: "tablecreator", params: params) { code, jsonData in
            
            let trashData: TrashData = try! JSONDecoder().decode(TrashData.self, from: jsonData)
            
            print(trashData.message)
            
            completion(code == 200 ? true : false, trashData.message)
        }
    }
    
    //  Update database row
    func update(columns:String, values:String, key:String, condition:String,completion:@escaping (Bool,String)->()={b,s in}){
        
        let params:[String : Any] = [
            "database" : "\(database)",
            "table" : "\(table)",
            "columns" : "\(columns)",
            "values" : "\(values)",
            "key" : "\(key)",
            "condition" : "\(condition)"
        ]
        
        query(method: "tableupdater", params: params) { code, jsonData in
            
            let trashData: TrashData = try! JSONDecoder().decode(TrashData.self, from: jsonData)
            
            completion(code == 200 ? true : false, trashData.message)
        }
    }
    
    //  Delete row
    func delete(key:String, condition:String, completion:@escaping (Bool,String) -> ()={b,s in}){
        
        let params:[String : Any] = [
            "database" : "\(database)",
            "table" : "\(table)",
            "key" : "\(key)",
            "condition" : "\(condition)"
        ]
        
        query(method: "tabledeleter", params: params) { code, jsonData in
            
            let trashData: TrashData = try! JSONDecoder().decode(TrashData.self, from: jsonData)
            
            completion(code == 200 ? true : false, trashData.message)
        }
    }
    
    //  Generic database proxy query
    func query(method:String,params:[String : Any],completion:@escaping (Int,Data) -> ()){
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        
        var request = URLRequest(url: URL(string: "\(domain)/\(method)/ios/")!)
        
        request.httpBody = ("Params=\(jsonString)").data(using: .utf8)
        request.httpMethod = "POST"
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
        
            guard let jsonData:Data = data else {
                
                if let error = error { print("HTTP Request Failed \(error)")}
                return;
            }
        
            DispatchQueue.main.async {
            
                let httpResponse = response as! HTTPURLResponse
            
                completion(httpResponse.statusCode,jsonData)
            }
        })
            
        task.resume()
    }
}

//  Database view
struct DatabaseView<Content: View>: View {
    
    @StateObject fileprivate var viewModel = DatabaseModel()
    
    @State var table:String
    @State var title:String
    @State var filter:String
    
    let content: ([Column], [Record]) -> Content
    
    //  Params
    var domain: String
    var database: String
    var columns:String
    var join:String
    var groupby:String
    
    init(domain:String, database:String = "default", table:String, columns:String, join:String = "",groupby:String = "",content: @escaping ([Column], [Record]) -> Content) {
        
        self.domain = domain
        self.database = database
        self.table = table
        self.columns = columns
        self.join = join
        self.filter = ""
        self.groupby = groupby
        self.title = table.components(separatedBy: " ")[0]
        self.content = content
    }
    
    //  Main view
    var body: some View {
    
        content(viewModel.columns,viewModel.records)
        .listStyle(.grouped)
        .onAppear {
            
            //  Relay params
            viewModel.domain = domain
            viewModel.database = database
            viewModel.table = table
            viewModel.join = join
            
            //  Select and force update
            viewModel.select(columns: columns, groupby: groupby)
            viewModel.objectWillChange.send()
        }
    }
}
