//
//  CentresView.swift
//  AutoloadUI
//
//  Created by David McCarthy on 28/04/2022.
//

import SwiftUI

struct CentresView: View {
    
    //  Autoloader
    @StateObject fileprivate var viewModel = DatabaseViewModel()
    
    @State private var path = NavigationPath()
    
    //  Message
    @State var message:String = ""
    
    var body: some View {
        
        NavigationStack(path: $path) {
            
            List(viewModel.records) { record in
                NavigationLink(record.fields[1].value, value: record)
            }
            .listStyle(.plain)
            .navigationTitle("Centres")
            .navigationDestination(for: Record.self) { record in
                
                VStack {
                    Text(record.fields[1].value).padding()
                    Button("DELETE") {
                        
                        viewModel.delete(key: "id", condition: /*record.fields[0].value*/"999"){ success,message in
                            
                            self.message = message
                            
                            if(success){
                                path.removeLast(1)
                                refresh()
                            }
                        }
                        
                    }.padding()
                    
                    if(message != ""){
                        Button(message){
                            message = ""
                            path.removeLast(1)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        }
        .onAppear {
            refresh()
        }
    }
    
    func refresh(){
        viewModel.select(columns: "id::text,name,coalesce(address1,'(null)'),coalesce(address2,''),coalesce(address3,''),coalesce(address4,'')")
    }
}
