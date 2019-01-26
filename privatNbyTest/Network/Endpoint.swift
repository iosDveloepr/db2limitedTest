//
//  Endpoint.swift
//  Onix Test
//
//  Created by Yermakov Anton on 1/24/19.
//  Copyright © 2019 Yermakov Anton. All rights reserved.
//

import Foundation

enum Endpoint: String{
    case privatBank = "https://api.privatbank.ua/p24api/pubinfo?json&exchange&coursid=3"
    case nby = "https://bank.gov.ua/NBUStatService/v1/statdirectory/exchange?json"
}
