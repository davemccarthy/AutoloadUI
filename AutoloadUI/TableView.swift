//
//  TableView.swift
//  AutoloadUI
//
//  Created by David McCarthy on 24/03/2023.
//
import SwiftUI

//  Database view
struct TableView: View {
    
    @State var table:String
    @State var filter:String
    
    //  Params
    var domain: String
    var database: String
    var columns:String
    var join:String
    
    init(domain:String, database:String = "default", table:String, columns:String, join:String = "") {
        
        self.domain = domain
        self.database = database
        self.table = table
        self.columns = columns
        self.join = join
        self.filter = ""
    }
    
    //  Main view
    var body: some View {
        
        DatabaseView(
            domain: domain, database: database, table: table, columns: columns, join: join
        ){ columns, records in
           
            List {
                //  Iterate each field in each record
                ForEach(records) { record in
                    
                    VStack(alignment: .leading) {
                        ForEach(record.fields) { field in
                            Text(field.value)
                        }
                    }
                }
            }
        }
    }
}
