//
//  ChartView.swift
//  AutoloadUI
//
//  Created by David McCarthy on 22/03/2023.
//

import SwiftUI
import Charts

enum ChartType {
    case LINE
    case POINT
    case BAR
    case MIXED
}

//  Database view
struct ChartView: View {
    
    //  Params
    var domain: String
    var type:ChartType
    var database: String
    var table:String
    var columns:String
    var join:String
    var groupby:String
    
    init(domain:String, type:ChartType = ChartType.LINE, database:String = "default", table:String, columns:String, join:String = "",groupby:String = "") {
        
        self.domain = domain
        self.type = type
        self.database = database
        self.table = table
        self.columns = columns
        self.join = join
        self.groupby = groupby
    }
    
    //  Main view
    var body: some View {
        
        DatabaseView(
            domain: domain, database: database, table: table, columns: columns, join: join, groupby: groupby
        ){ columns, records in
            
            Chart{
                
                ForEach(1..<max(columns.count,1), id: \.self){ col in
                
                    ForEach(records){ record in
                        
                        let x = record.fields[0].value
                        let y = Int(record.fields[col].value)
                        
                        switch(type){
                            
                            //  Line
                        case ChartType.LINE:
                            LineMark(x: .value("", x),y: .value("", y!))
                                .foregroundStyle(by: .value("Type", "\(columns[col].name)"))
                            
                            //  Point
                        case ChartType.POINT:
                            PointMark(x: .value("", x),y: .value("", y!))
                                .foregroundStyle(by: .value("Type", "\(columns[col].name)"))
                            
                            // Mixed
                        case ChartType.MIXED:
                            LineMark(x: .value("", x),y: .value("", y!))
                                .foregroundStyle(by: .value("Type", "\(columns[col].name)"))
                            
                            PointMark(x: .value("", x),y: .value("", y!))
                                .foregroundStyle(by: .value("Type", "\(columns[col].name)"))
                            
                            //  PoinBart
                        case ChartType.BAR:
                            BarMark(x: .value("", x),y: .value("", y!))
                                .foregroundStyle(by: .value("Type", "\(columns[col].name)"))
                            
                        }
                    }
                }
            }
            .padding()
        }
    }
}
