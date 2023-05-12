//
//  ContentView.swift
//  Plane-Booking App
//
//  Created by Marlvin Goremusandu on 5/12/23.
import SwiftUI

struct Flight: Identifiable {
    let id = UUID()
    let airline: String
    let flightNumber: String
    let departureCity: String
    let departureTime: String
    let arrivalCity: String
    let arrivalTime: String
    let price: Double
}

class FlightStore: ObservableObject {
    @Published var flights: [Flight] = []
    
    // Function to fetch flights from a remote API
    func fetchFlights() {
        // Simulated API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.flights = [
                Flight(airline: "American Airlines", flightNumber: "A2337", departureCity: "Jackson", departureTime: "10:00 AM", arrivalCity: "North Carolina", arrivalTime: "12:00 PM", price: 120.0),
                Flight(airline: "Southwest", flightNumber: "S456", departureCity: "Salt Lake City", departureTime: "02:00 PM", arrivalCity: "Denver", arrivalTime: "04:00 PM", price: 450.0),
                Flight(airline: "Delta Airlines", flightNumber: "D2932", departureCity: "Austin", departureTime: "06:00 PM", arrivalCity: "Houston", arrivalTime: "07:12 PM", price: 100.0),
                Flight(airline: "United", flightNumber: "U992", departureCity: "New York", departureTime: "04:00 PM", arrivalCity: "Boston", arrivalTime: "08:12 PM", price: 100.0),
                Flight(airline: "Frontier", flightNumber: "F2378", departureCity: "Portland", departureTime: "03:00 PM", arrivalCity: "Dallas", arrivalTime: "08:34 PM", price: 234.0),
                Flight(airline: "WestJet", flightNumber: "W6782", departureCity: "Austin", departureTime: "06:00 PM", arrivalCity: "Houston", arrivalTime: "07:12 PM", price: 124.30),
                Flight(airline: "American Airlines", flightNumber: "A7834", departureCity: "Raleigh", departureTime: "06:06 PM", arrivalCity: "Washington, D.C", arrivalTime: "07:12 PM", price: 342.24),
                Flight(airline: "Delta Airlines", flightNumber: "D7849", departureCity: "San Diego", departureTime: "06:00 PM", arrivalCity: "Charleston", arrivalTime: "07:12 PM", price: 345.56),
                Flight(airline: "WestJet", flightNumber: "W7523", departureCity: "Nashville", departureTime: "02:00 PM", arrivalCity: "Jackson", arrivalTime: "03:33 PM", price: 452.20),
                Flight(airline: "British Airlines", flightNumber: "B563", departureCity: "Jackson", departureTime: "01:00 PM", arrivalCity: "Harare", arrivalTime: "03:33 AM", price: 1452.20)            ]
        }
    }
}

struct ContentView: View {
    @StateObject private var flightStore = FlightStore()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(flightStore.flights) { flight in
                        NavigationLink(destination: FlightDetailView(flight: flight)) {
                            FlightCard(flight: flight)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Flights")
            .onAppear {
                flightStore.fetchFlights()
            }
        }
        .accentColor(.red)
    }
}

struct FlightCard: View {
    let flight: Flight
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image("airlineLogo")
                    .resizable()
                    .frame(width: 40, height: 40)
                Text(flight.airline)
                    .font(.headline)
                    .foregroundColor(.blue)
                Spacer()
            }
            
            Text("Flight \(flight.flightNumber)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                Image(systemName: "airplane.departure")
                    .foregroundColor(.blue)
                Text("\(flight.departureCity)")
                Spacer()
                Text(flight.departureTime)
            }
            
            HStack {
                Image(systemName: "airplane.arrival")
                    .foregroundColor(.green)
                Text("\(flight.arrivalCity)")
                Spacer()
                Text(flight.arrivalTime)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: Color(.systemGray5), radius: 8, x: 0, y: 4)
        .padding(.bottom, 10)
    }
}

struct FlightDetailView: View {
    let flight: Flight
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image("airlineLogo")
                    .resizable()
                    .frame(width: 80, height: 80)
                VStack(alignment: .leading, spacing: 8) {
                    Text(flight.airline)
                        .font(.custom("AvenirNext-Bold", size: 24))
                        .foregroundColor(.blue)
                    Text("Flight \(flight.flightNumber)")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Departure")
                        .font(.title3)
                        .foregroundColor(.blue)
                    Text("\(flight.departureCity)")
                        .font(.title2)
                    Text(flight.departureTime)
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                Spacer()
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Arrival")
                        .font(.title3)
                        .foregroundColor(.green)
                    Text("\(flight.arrivalCity)")
                        .font(.title2)
                    Text(flight.arrivalTime)
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                Spacer()
            }
            
            Text("Price: $\(flight.price, specifier: "%.2f")")
                .font(.title)
                .foregroundColor(.red)
                .padding(.top)
            
            Spacer()
            
            NavigationLink(destination: BookingFormView(flight: flight)) {
                Text("Book Flight")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.bottom)
        }
        .padding()
        .navigationTitle("Flight Details")
    }
}

struct BookingFormView: View {
    @State private var name = ""
    @State private var contactDetails = ""
    @State private var creditCardNumber = ""
    @State private var seatPreference: SeatPreference = .window
    @State private var allergies = ""
    
    let flight: Flight
    
    enum SeatPreference {
        case window
        case aisle
    }
    
    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                TextField("Name", text: $name)
                TextField("Contact Details", text: $contactDetails)
            }
            
            Section(header: Text("Payment Information")) {
                TextField("Credit Card Number", text: $creditCardNumber)
            }
            Section(header: Text("Preferences")) {
                Picker("Seat Preference", selection: $seatPreference) {
                    Text("Window").tag(SeatPreference.window)
                    Text("Aisle").tag(SeatPreference.aisle)
                }
                TextField("Allergies", text: $allergies)
            }
            
            Button(action: {
                // Handle booking submission
            }) {
                Text("Submit Booking")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top)
        }
        .navigationTitle("Booking")
    }
}

@main
struct FlightBookingApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
