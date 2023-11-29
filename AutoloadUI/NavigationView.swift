//
//  CentresView.swift
//  AutoloadUI
//
//  Created by David McCarthy on 28/04/2022.
//

import SwiftUI

enum ActionType {
    case select, update, insert, delete
}

struct Action: Identifiable,  Hashable {
    
    var id = UUID()
    
    var record:Record
    var type:ActionType
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Action, rhs: Action) -> Bool {
         return lhs.id == rhs.id
    }
}

struct AppView: View {
    
    var name:String
    var value:String
    
    var body: some View {
    
        VStack(alignment: .leading, spacing: 5){
        
            Text(name)
                .foregroundColor(.blue)
                .font(.caption)
                .bold()
                //.padding()
                .frame(width: 120, height: 20, alignment: .leading)
            
            Text(value)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                //.padding()
        }
    }
}

struct AppEntry: View {
    
    var name:String
    var value:Binding<String> = .constant("init")
    
    var body: some View {
            
        TextField(name, text: value)
    }
}

struct AppEntry2: View {
    
    var name:String
    var value:Binding<String> = .constant("init")
    
    var body: some View {
    
        VStack(alignment: .leading, spacing: 5){
        
            Text(name)
                .foregroundColor(.blue)
                .font(.caption)
                .bold()
                //.padding()
                .frame(width: 120, height: 25, alignment: .leading)
            
            TextField(name, text: value)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                //.padding()
        }
    }
}

struct AppButton: View {
    
    var label:String
    var role:ButtonRole
    var onClick: ()->()
    
    var body: some View {
        Button(role: role,action: {
            onClick()
        }) {
            Text(label).frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width / 2)
        }
        .buttonStyle(.borderedProminent)
    }
}

struct CentresView: View {
    
    @State var message:String = ""
    
    @State var isPresenting = false
    @State var showingAlert = false
    
    @State var name = ""
    @State var abbreviation = ""
    @State var contact = ""
    @State var email = ""
    @State var mobile = ""
    @State var address1 = ""
    @State var address2 = ""
    @State var address3 = ""
    @State var address4 = ""
    
    var body: some View {
        
        VStack{
            if(message == ""){
                NavigationView(domain: "http://192.168.1.6:8000", database: "babbleton", table: "centres", columns:"id::text,name,abbreviation,contact,email,coalesce(mobile,''),coalesce(address1,''),coalesce(address2,''),coalesce(address3,''),coalesce(address4,'')", orderby: "id",
                    onNew: { tableEx in
                    
                        Form{
                            Section {

                                TextField("Name", text: $name)
                                TextField("Abbreviation", text: $abbreviation)
                                TextField("Contact", text: $contact)
                                            
                            } header: {
                                Text("Identity")
                            }
                            Section {

                                TextField("Email", text: $email)
                                TextField("Mobile", text: $mobile)
                            
                            } header: {
                                Text("Contact Info")
                            }
                            Section {

                                TextField("Address1", text: $address1)
                                TextField("Address2", text: $address2)
                                TextField("Address3", text: $address3)
                                TextField("Address4", text: $address4)
                            
                            } header: {
                                Text("Address")
                            }
                        
                            Section {
                                Button("Create centre"){
                                
                                    tableEx.viewModel.insert(columns: "id,name,abbreviation,contact,email", values: "default,'\(name)','\(abbreviation)','\(contact)','\(email)'"){ success,message in
                                    
                                        if(success){
                                        
                                            tableEx.path.removeLast(1)
                                            tableEx.refresh()
                                        }
                                        else{
                                            self.message = message
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                        .onAppear(){
                        
                            name = ""
                            abbreviation = ""
                            contact = ""
                            email = ""
                        }.navigationTitle("New Centre")
                    },
                    onDetail: {tableEx, record in
                        
                        Form{
                        
                            Section {

                                TextField("Name", text: $name)
                                TextField("Abbreviation", text: $abbreviation)
                                TextField("Contact", text: $contact)
                            
                            } header: {
                                Text("Identity")
                            }
                            
                            Section {

                                TextField("Email", text: $email)
                                TextField("Mobile", text: $mobile)
                            
                            } header: {
                                Text("Contact Info")
                            }
                            Section {

                                TextField("Address1", text: $address1)
                                TextField("Address2", text: $address2)
                                TextField("Address3", text: $address3)
                                TextField("Address4", text: $address4)
                            
                            } header: {
                                Text("Address")
                            }
                        }
                        .onAppear(){
                            name = record.fields[1].value
                            abbreviation = record.fields[2].value
                            contact = record.fields[3].value
                            email = record.fields[4].value
                            mobile = record.fields[5].value
                            address1 = record.fields[6].value
                            address2 = record.fields[7].value
                            address3 = record.fields[8].value
                            address4 = record.fields[9].value
                        }
                        .disabled(true)
                        .navigationTitle(name)
                    },
                    onEdit: {tableEx, record in
                    
                        Form{
                            Section {
                            
                                TextField("Name", text: $name)
                                TextField("Abbreviation", text: $abbreviation)
                                TextField("Contact", text: $contact)
                            
                            } header: {
                                Text("Identity")
                            }
                            Section {
                            
                                TextField("Email", text: $email)
                                TextField("Mobile", text: $mobile)
                            
                            } header: {
                                Text("Contact Info")
                            }
                            Section {
                            
                                TextField("Address1", text: $address1)
                                TextField("Address2", text: $address2)
                                TextField("Address3", text: $address3)
                                TextField("Address4", text: $address4)
                            
                            } header: {
                                Text("Address")
                            }
                        
                            Section {
                                
                                Button("Save centre") {
                                    
                                    tableEx.viewModel.update(columns: "name,abbreviation,contact,email,mobile,address1,address2,address3,address4", values: "'\(name)','\(abbreviation)','\(contact)','\(email)','\(mobile)','\(address1)','\(address2)','\(address3)','\(address4)'",key: "id", condition: record.fields[0].value){ success,message in
                                        
                                        if(!success){
                                            name = message
                                        }
                                        else{
                                            tableEx.path.removeLast(1)
                                            tableEx.refresh()
                                        }
                                    }
                                }
                            }
                            .onAppear(){
                                
                                name = record.fields[1].value
                                abbreviation = record.fields[2].value
                                contact = record.fields[3].value
                                email = record.fields[4].value
                                mobile = record.fields[5].value
                                address1 = record.fields[6].value
                                address2 = record.fields[7].value
                                address3 = record.fields[8].value
                                address4 = record.fields[9].value
                            }
                        }
                        .navigationTitle(name)
                    },
                    onDelete: {tableEx, record in
                    
                        VStack{
                            AppView(name: "Name", value: record.fields[1].value)
                            AppView(name: "Abbreviation", value: record.fields[2].value)
                            AppView(name: "Contact", value: record.fields[3].value)
                            AppView(name: "Email", value: record.fields[4].value)
                            
                            Spacer()
                    
                            Button("DELETE", role: .destructive) {
                                isPresenting = true
                            }
                            .buttonStyle(.borderedProminent)
                            .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width / 2)
                            
                            Button("CANCEL", role: .cancel) {
                                tableEx.path.removeLast(1)
                            }
                            .buttonStyle(.borderedProminent)
                            .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width / 2)
                            
                        }
                        .navigationTitle(record.fields[1].value)
                        .confirmationDialog("Are you sure?", isPresented: $isPresenting) {
                            
                            AppButton(label: "Delete \(record.fields[1].value)?", role: .destructive) {
                               
                                tableEx.viewModel.delete(key: "id", condition: record.fields[0].value){ success,message in
                                    
                                    if(!success){
                                        name = message
                                    }
                                    else{
                                        tableEx.path.removeLast(1)
                                        tableEx.refresh()
                                    }
                                }
                           }
                       }.alert(message, isPresented: $showingAlert) {
                           Button("OK", role: .cancel) { }
                       }
                    }
                )
            }
            else{
            
                Text(message).padding()
            }
        }
    }
}

struct NavigationView<OnNew: View,OnDetail: View, OnEdit:View, OnDelete:View>: View {
    
    var domain:String
    var database:String
    var table:String
    var columns:String
    var orderby:String = ""
    
    var onNew: (NavigationView) -> OnNew
    var onDetail: (NavigationView,Record) -> OnDetail
    var onEdit: (NavigationView,Record) -> OnEdit
    var onDelete: (NavigationView,Record) -> OnDelete
     
    //  Autoloader
    @StateObject fileprivate var viewModel = DatabaseModel()
    
    @State var path = NavigationPath()
    @State var addview = false
    
    //  Message
    @State var message:String = ""
    @State var displayNew:Bool = false
    
    @State private var isPresentingConfirm: Bool = false
    @State private var showingAlert = false
    
    @State var textInput = ""
    
    var body: some View {
        
        NavigationStack(path: $path) {
            
            List(viewModel.records) { record in
                NavigationLink(record.fields[1].value, value: Action(record: record, type: ActionType.select))
                    .swipeActions {
                        
                        Button("Delete", role: .destructive) {
                            path.append(Action(record: record, type: ActionType.delete))
                        }
                        .tint(.red)
                        
                        Button("Edit") {
                            path.append(Action(record: record, type: ActionType.update))
                        }
                        .tint(.blue)
                    }
            }
            .listStyle(.plain)
            .navigationTitle(table.capitalized)
            .navigationDestination(for: Action.self) { action in
                
                switch(action.type){
                    
                case ActionType.select:
                    onDetail(self,action.record)
                    
                case ActionType.update:
                    onEdit(self,action.record)
    
                case ActionType.insert:
                    onNew(self)
                    
                case ActionType.delete:
                    onDelete(self,action.record)
                }
            }
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {path.append(Action(record: Record(values: []), type: ActionType.insert))}, label: {Image(systemName: "plus")})
                }
            }
        }
        .onAppear {
            
            viewModel.domain = domain
            viewModel.database = database
            viewModel.table = table
            
            refresh()
        }
    }
    
    func refresh(){
        viewModel.select(columns: columns,orderby: orderby)
    }
}

struct Test: View {

    @State var value = "Sydney"
    
    var body: some View {
        VStack {
            Text("This is on the top")
            Spacer()
            Text("This is in the middle")
            Spacer()
        }
    }
}

struct EntryView_Previews: PreviewProvider {

    static var previews: some View {
        
        Test()
    }
}
