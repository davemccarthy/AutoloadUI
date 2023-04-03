//
//  ContentView.swift
//  AutoloadUI
//
//  Created by David McCarthy on 25/04/2022.
//

import SwiftUI

struct TestView: View {
    
    var body: some View {
        
        DatabaseView(
            domain: "http://192.168.1.3:8000", database: "babbleton", table: "centres", columns: "name"
        ){ columns, records in
           
            List {
                //  Iterate each field in each record
                ForEach(records) { record in
                    
                    VStack(alignment: .leading) {
                        ForEach(record.fields) { field in
                            Text(field.value).font(field.font)
                        }
                    }
                }
            }
        }
    }
}

struct ContentView: View {
    
    let OperatorsCount = ChartView(
        domain: "http://192.168.1.3:8000", type:ChartType.BAR, database: "babbleton", table: "centres c",
        columns: "c.abbreviation,(count(o.id)/3)::text as ibm,(count(o.id)/2)::text as microsoft,count(o.id)::text as google,(count(o.id)/4)::text as apple",
        join: "inner join operators o on o.centreid=c.id", groupby: "1"
    )
    
    let OperatorsCount2 = ChartView(
        domain: "http://192.168.1.3:8000", type:ChartType.LINE, database: "babbleton", table: "centres c",
        columns: "c.abbreviation,(count(o.id)/3)::text as ibm,(count(o.id)/2)::text as microsoft,count(o.id)::text as google,(count(o.id)/4)::text as apple",
        join: "inner join operators o on o.centreid=c.id", groupby: "1"
    )
    
    let Mappy = MapView(domain: "http://192.168.1.3:8000", table: "Places")
    
    let CentreView = TableView(
        domain: "http://192.168.1.3:8000", database: "babbleton", table: "centres", columns: "name"
    )
    
    let OperatorView = TableView(
        domain: "http://192.168.1.3:8000", database: "babbleton", table: "operators o", columns: "fname||' '||sname,c.name,'Code: '||identifier", join: "inner join centres c on o.centreid=c.id"
    )
    
    let AdministratorView = TableView(
        domain: "http://192.168.1.3:8000", database: "babbleton", table: "administrators", columns: "username,password"
    )
    
    let ConferenceView = TableView(
        //domain: "http://192.168.1.3:8000", table: "conferences c", columns: "b.name,to_char(c.start,'YYYY-MM-DD HH24:MI:SS')", join: "inner join eventcall_bookings b on c.reference=b.id::text"
        domain: "http://192.168.1.3:8000", table: "auth_user", columns: "username,email"
    )
    
    let test = TestView()
    
    let centresView = CentresView()
    
    //let SessionView = TableView(
    //    domain: "http://192.168.1.3:8000", database: "babbleton", table: "sessions s", columns: "o.fname||\' \'||o.sname,start,duration", join: "inner join operators o on s.operid=o.id"
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
