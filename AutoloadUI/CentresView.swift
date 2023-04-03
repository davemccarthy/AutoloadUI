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
    @Environment(\.presentationMode) var presentationMode
    
    //  Message
    @State var message:String = ""
    
    var body: some View {
        
        NavigationStack {
            
            List(viewModel.records) { record in
            
                NavigationLink {
                
                    ZStack {
                    
                        VStack(alignment: .leading) {
                            
                            Text(record.fields[1].value)
                            Text(record.fields[2].value)
                            Text(record.fields[3].value)
                            Text(record.fields[4].value)
                            
                            Button("DELETE"){
                                
                                /*
                                viewModel.loader.delete(key: "id", condition: record.fields[0].value){ success,message in
                                    
                                    if(success){
                                        presentation.wrappedValue.dismiss()
                                        refresh()
                                    }
                                    else{
                                        self.message = message
                                    }
                                }*/
                            }
                        }
                        
                        if(message != ""){
                            Button(message){
                                message = ""
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    
                } label: {
                    Text(record.fields[1].value)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Centres")
        }
        .onAppear {
            
            //  Relay params
            viewModel.loader.domain = "http://192.168.1.3:8000"
            viewModel.loader.database = "babbleton"
            viewModel.loader.table = "centres"
            
            refresh()
        }
    }
    
    func refresh(){
        viewModel.loader.select(columns: "id::text,name,coalesce(address1,'(null)'),coalesce(address2,''),coalesce(address3,''),coalesce(address4,'')")
    }
}
