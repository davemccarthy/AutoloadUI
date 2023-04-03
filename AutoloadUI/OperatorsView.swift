//
//  OperatorsView.swift
//  AutoloadUI
//
//  Created by David McCarthy on 28/04/2022.
//

import SwiftUI

//  Database record equivalent
struct Operator: Identifiable {
    
    var id:String
    var name:String
    var centre:String
    var code:String
    var calls:String
    var minutes:String
    var pacd:String
    
    init(row:[String]){
        
        id = row[0]
        name = row[1]
        centre = row[2]
        code = row[3]
        calls = row[4]
        minutes = row[5]
        pacd = row[6]
    }
}

//  Model to retrive rows
private class OprsViewModel: ObservableObject, Autoloadable {
    
    @Published var operators: [Operator] = []
    
    var loader = Autoload()
    
    init() {
        
        loader.domain = "http://192.168.1.33:8000"
        loader.database = "babbleton"
        loader.table = "operators o"
        loader.delegate = self;
        loader.join = "inner join centres c on o.centreid=c.id"
        loader.pagesize = 500
    }
    
    //  Result of query
    func selected(data:TableData) {
            
        operators.removeAll()
        
        for row in data.rows {
            
            operators.append(Operator(row: row))
        }
    }
    
    func deleted(data:TrashData){}
}

struct FieldView: View {
    
    var label: String
    var value: String
    
    var body: some View {
                
        HStack {
         
            Text(label)
                .padding(3)
                .foregroundColor(.blue)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .background(.white)
            
            Text(value)
                .padding(3)
                .foregroundColor(.black)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}

//  Single operator view
struct OperatorView: View {
    
    @StateObject fileprivate var viewModel = OprsViewModel()
    
    @State var filter:String
    
    var columns = "o.id::text,fname||' '||sname,c.name,identifier,o.calltotal::text,to_char(o.callduration,'HH24:MI:SS'),to_char(o.callduration/o.calltotal,'HH24:MI:SS')"
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            ForEach(viewModel.operators) { opr in
                
                FieldView(label: "Name:", value: opr.name)
                FieldView(label: "Centre:", value: opr.centre)
                FieldView(label: "Dial code:", value: opr.code)
                FieldView(label: "Calls:", value: opr.calls)
                FieldView(label: "Minutes:", value: opr.minutes)
                FieldView(label: "PACD:", value: opr.pacd)
            }
        }
        .onAppear {
            viewModel.loader.select(columns: columns, filter: filter, orderby: "o.id desc")
        }
    }
}

//  Multiple operators view
struct OperatorsView: View {
    
    @StateObject fileprivate var viewModel = OprsViewModel()
    
    var columns = "o.id::text,fname||' '||sname,c.name,identifier,o.calltotal::text,to_char(o.callduration,'HH24:MI:SS'),to_char(o.callduration/o.calltotal,'HH24:MI:SS')"
    
    var body: some View {
        
        NavigationView {
        
            List(viewModel.operators) { opr in
                
                NavigationLink(destination: OperatorView(filter: "o.id=\(opr.id)")) {
                
                    Text(opr.name)
                }
            }
            .navigationTitle("Operators")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.loader.select(columns:columns, orderby: "o.id desc")
            }
        }
    }
}
