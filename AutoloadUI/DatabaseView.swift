//
//  DatabaseView.swift
//  AutoloadUI
//
//  Created by David McCarthy on 28/04/2022.
//

import SwiftUI

//  Generic string field
struct Field: Identifiable {
    
    var id = UUID()
    var value:String
    var font:Font = .subheadline
    
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
        
        self.fields[0].font = .headline
    }
}

//  Database model
class DatabaseViewModel: ObservableObject, Autoloadable {
    
    //  Selected results
    @Published var columns:[Column] = []
    @Published var records:[Record] = []
    
    //  Generic message
    @Published var message:String = ""
    
    var loader = Autoload()
    
    //  Initialize
    init() {
        loader.delegate = self;
    }
    
    //  Query results
    func selected(data:TableData) {
        
        columns.removeAll()
        records.removeAll()
        
        //  Error message?
        if(data.message != ""){
            records.append(Record(values: [data.message]))
        }
        
        //  Build rows
        for col in data.columns {
            columns.append(Column(name: col))
        }
        
        //  Build records from query resulting rows
        for row in data.rows {
            records.append(Record(values: row))
        }
    }
    
    //  Deleted callback
    func deleted(data:TrashData){
        message = data.message
    }
}

//  Database view
struct DatabaseView<Content: View>: View {
    
    @StateObject fileprivate var viewModel = DatabaseViewModel()
    
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
            viewModel.loader.domain = domain
            viewModel.loader.database = database
            viewModel.loader.table = table
            viewModel.loader.join = join
            
            //  Select and force update
            viewModel.loader.select(columns: columns, groupby: groupby)
            viewModel.objectWillChange.send()
        }
    }
}
