//
//  MapView.swift
//  AutoloadUI
//
//  Created by David McCarthy on 28/03/2023.
//

import SwiftUI
import MapKit

struct StrokeText: View {
    let text: String
    let width: CGFloat
    let color: Color

    var body: some View {
        ZStack{
            ZStack{
                Text(text).offset(x:  width, y:  width)
                Text(text).offset(x: -width, y: -width)
                Text(text).offset(x: -width, y:  width)
                Text(text).offset(x:  width, y: -width)
            }
            .foregroundColor(color)
            Text(text)
        }
    }
}

struct PlaceAnnotationView: View {
    @State private var showTitle = true
  
    let title: String
  

    var body: some View {
        VStack(spacing: 0) {
        
            StrokeText(text: title, width: 2, color: .white)
                .foregroundColor(.black)
                .font(.system(size: 12, weight: .none))
                .offset(x: 0, y: -32)
        
            Image(systemName: "mappin.circle.fill")
                .font(.title)
                .foregroundColor(.red)
                .offset(x: 0, y: -27)
      
            Image(systemName: "arrowtriangle.down.fill")
                .font(.caption)
                .foregroundColor(.red)
                .offset(x: 0, y: -32)
        }
        .onTapGesture {
            withAnimation(.easeInOut) {
                showTitle.toggle()
            }
        }
    }
}

//  Database view
struct MapView: View {
    
    //  Params
    var domain: String
    var database: String
    var table:String
    
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50))
    
    init(domain:String, database:String = "default", table:String) {
        
        self.domain = domain
        self.database = database
        self.table = table
    }
    
    //  Main view
    var body: some View {
        
        DatabaseView(
            domain: domain, database: database, table: table, columns: "name,latitute::text,longitute::text"
        ){ columns, records in
            
            ZStack {
            
                Map(coordinateRegion: $region,showsUserLocation: true, annotationItems: records){ record in
                    //MapMarker(coordinate: CLLocationCoordinate2D(latitude: Double(record.fields[1].value)!,longitude: Double(record.fields[2].value)!))
                    
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: Double(record.fields[1].value)!,longitude: Double(record.fields[2].value)!)) {
                        PlaceAnnotationView(title: record.fields[0].value)
                    }
                }
            }
        }
    }
}
