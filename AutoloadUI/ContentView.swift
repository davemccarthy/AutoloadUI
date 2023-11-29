//
//  ContentView.swift
//  AutoloadUI
//
//  Created by David McCarthy on 25/04/2022.
//

import SwiftUI

struct DemoPop: View {

    @State private var path = NavigationPath()
    
    var body: some View {
        
        VStack {
            
            NavigationStack(path: $path) {
                   
                List {
                    Section("List One") {
                        NavigationLink("Navigate to View 1", value: "View 1")
                        NavigationLink("Navigate to View 2", value: "View 2")
                    }
                }
                .navigationDestination(for: String.self) { textDesc in
                    
                    VStack {
                        Text(textDesc).padding()
                        Button("Navigate to View 3") {
                            path.append("View 3")
                        }.padding()
                        
                        Button("Pop to Root View") {
                            path.removeLast(path.count)
                        }.padding()
                    }
                }
                .navigationTitle("Test Pop To Root")
            }
        }
    }
}

struct ContentView2: View {
    
    var body: some View {
        
        Form {
            Group {
                Text("Hello, world!")
                Text("Hello, world!")
                Text("Hello, world!")
                Text("Hello, world!")
                Text("Hello, world!")
                Text("Hello, world!")
            }

            Group {
                Text("Hello, world!")
                Text("Hello, world!")
                Text("Hello, world!")
                Text("Hello, world!")
                Text("Hello, world!")
            }
            Group {
                Text("Hello, world!")
                Text("Hello, world!")
                Text("Hello, world!")
                Text("Hello, world!")
                Text("Hello, world!")
                Text("Hello, world!")
            }

            Group {
                Text("Hello, world!")
                Text("Hello, world!")
                Text("Hello, world!")
                Text("Hello, world!")
                Text("Hello, world!")
            }
            Group {
                Text("Hello, world!")
                Text("Hello, world!")
                Text("Hello, world!")
                Text("Hello, world!")
                Text("Hello, world!")
                Text("Hello, world!")
            }

            Group {
                Text("Hello, world!")
                Text("Hello, world!")
                Text("Hello, world!")
                Text("Hello, world!")
                Text("Hello, world!")
            }
        }
    }
}

struct ContentView: View {
    
    let OperatorsCount = ChartView(
        domain: "http://192.168.1.6:8000", type:ChartType.BAR, database: "babbleton", table: "centres c",
        columns: "c.abbreviation,(count(o.id)/3)::text as ibm,(count(o.id)/2)::text as microsoft,count(o.id)::text as google,(count(o.id)/4)::text as apple",
        join: "inner join operators o on o.centreid=c.id", groupby: "1"
    )
    
    let OperatorsCount2 = ChartView(
        domain: "http://192.168.1.6:8000", type:ChartType.BAR, database: "babbleton", table: "centres c",
        columns: "c.abbreviation,(count(o.id)/3)::text as ibm,(count(o.id)/2)::text as microsoft,count(o.id)::text as google,(count(o.id)/4)::text as apple",
        join: "inner join operators o on o.centreid=c.id", groupby: "1"
    )
    
    let Mappy = MapView(domain: "http://192.168.1.6:8000", table: "Places")
    
    let CentreView = TableView(
        domain: "http://192.168.1.6:8000", database: "babbleton", table: "centres", columns: "name"
    )
    
    let OperatorView = TableView(
        domain: "http://192.168.1.6:8000", database: "babbleton", table: "operators o", columns: "fname||' '||sname,c.name,'Code: '||identifier", join: "inner join centres c on o.centreid=c.id"
    )
    
    let AdministratorView = TableView(
        domain: "http://192.168.1.6:8000", database: "babbleton", table: "administrators", columns: "username,password"
    )
    
    let ConferenceView = TableView(
        //domain: "http://192.168.1.6:8000", table: "conferences c", columns: "b.name,to_char(c.start,'YYYY-MM-DD HH24:MI:SS')", join: "inner join eventcall_bookings b on c.reference=b.id::text"
        domain: "http://192.168.1.6:8000", table: "auth_user", columns: "username,email"
    )
    
    let centresView = CentresView()
    
    //let centresView = CentresView(domain: "http://192.168.1.6:8000", database: "babbleton", table: "centres", //columns:"id::text,name,coalesce(address1,'(null)'),coalesce(address2,''),coalesce(address3,''),coalesce(address4,'')")
    
    
    //let centresView = TableExView(domain: "http://192.168.1.6:8000", database: "babbleton", table: "centres", columns:"id::text,name,abbreviation,contact,email",
    //                              onDetail: {Text("1")},onEdit: {Text("2")})
    
    
    //let SessionView = TableView(
    //    domain: "http://192.168.1.6:8000", database: "babbleton", table: "sessions s", columns: "o.fname||\' \'||o.sname,start,duration", join: "inner join operators o on s.operid=o.id"
    //)
    
    var body: some View {
        
        TabView {
            
            centresView.tabItem {
                
                Text("Centres")
                Image(systemName: "star.fill")
            }
            
            OperatorView.tabItem {
                
                Text("Operators")
                Image(systemName: "photo.fill")
            }
            
            OperatorsCount2.tabItem {
                
                Text("Graph")
                Image(systemName: "multiply.circle.fill")
            }
            /*
            OperatorsView().tabItem {
                
                Text("OPRS")
                Image(systemName: "photo.fill")
            }
            
            ConferenceView.tabItem {
                
                Text("Users")
                Image(systemName: "heart.fill")
            }
            
            test.tabItem {
                
                Text("Sessions")
                Image(systemName: "star.fill")
            }
            
            OperatorsCount.tabItem {
                
                Text("Sessions")
                Image(systemName: "star.fill")
            }*/
            
            Mappy.tabItem {
                
                Text("Map")
                Image(systemName: "star.fill")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
