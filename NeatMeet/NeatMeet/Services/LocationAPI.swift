//
//  LocationAPI.swift
//  NeatMeet
//
//  Created by Damyant Jain on 11/21/24.
//

import Alamofire
import Foundation

public class LocationAPI {
    
    func getHeaders() -> HTTPHeaders {
        return [
            "x-rapidapi-key":
                "fb54764b3bmshed8a057a9dfc48bp1ff81ejsn950b6e626f84",
            "x-rapidapi-host":
                "country-state-city-search-rest-api.p.rapidapi.com",
        ]
    }

    func getAllCities(stateCode: String) async -> [City] {
        var citiesList: [City] = []
        let url =
            "https://country-state-city-search-rest-api.p.rapidapi.com/cities-by-countrycode-and-statecode"
        let parameters: [String: String] = [
            "countrycode": "US",
            "statecode": stateCode,
        ]
        let headers: HTTPHeaders = getHeaders()
        let request = AF.request(
            url, method: .get, parameters: parameters, headers: headers)
        let response = await request.serializingData().response
        let status = response.response?.statusCode
        switch response.result {
        case .success(let data):
            if let statusCode = status {
                switch statusCode {
                case 200...299:
                    do {
                        citiesList = try JSONDecoder().decode(
                            [City].self, from: data)
                    } catch {
                        print("JSON Decoding Failed")
                    }
                case 400...499:
                    print(
                        "Client Error (\(statusCode)): \(response.description)")
                default:
                    print(
                        "Server Error (\(statusCode)): \(response.description)")
                }
            }
        case .failure(let error):
            print("Request failed with error: \(error.localizedDescription)")
        }
        return citiesList
    }
    
    func getAllStates() async -> [State] {
        var statesList: [State] = []
        let url =
            "https://country-state-city-search-rest-api.p.rapidapi.com/states-by-countrycode"
        let parameters: [String: String] = [
            "countrycode": "us",
        ]
        let headers: HTTPHeaders = getHeaders()
        let request = AF.request(
            url, method: .get, parameters: parameters, headers: headers)
        let response = await request.serializingData().response
        let status = response.response?.statusCode
        switch response.result {
        case .success(let data):
            if let statusCode = status {
                switch statusCode {
                case 200...299:
                    do {
                        statesList = try JSONDecoder().decode(
                            [State].self, from: data)
                    } catch {
                        print("JSON Decoding Failed")
                    }
                case 400...499:
                    print(
                        "Client Error (\(statusCode)): \(response.description)")
                default:
                    print(
                        "Server Error (\(statusCode)): \(response.description)")
                }
            }
        case .failure(let error):
            print("Request failed with error: \(error.localizedDescription)")
        }
        return statesList
    }
}
