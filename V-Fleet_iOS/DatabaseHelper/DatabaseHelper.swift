//
//  DatabaseHelper.swift
//  V-Fleet_iOS
//
//  Created by Yagnesh Bagrodia on 27/05/25.
//

import Foundation
import SQLite

class DatabaseHelper {
    
    static let shared = DatabaseHelper()
    
    private var db: Connection?
    
    private let users = Table("users")

    private let id = Expression<Int64>("id")
    private let name = Expression<String>("name")
    private let email = Expression<String>("email")
    private let role = Expression<String>("role")
    private let accessNotExpired = Expression<Bool>("accessNotExpired")
    private let userEnabled = Expression<Bool>("userEnabled")
    private let superCompanyName = Expression<String>("superCompanyName")
    private let mobile = Expression<String>("mobile")
    private let companyId = Expression<Int64>("companyId")
    private let driverId = Expression<Int64>("driverId")
    private let userShiftStatus = Expression<Bool>("userShiftStatus")
    private let attendanceStatus = Expression<Bool>("attendanceStatus")
    private let superCompanyId = Expression<Int64>("superCompanyId")

    private let accessFleet = Expression<Bool>("access_fleet")
    private let accessFuel = Expression<Bool>("access_fuel")
    private let accessExpense = Expression<Bool>("access_expense")
    private let accessRental = Expression<Bool>("access_rental")
    
    //MRAK: - getAllVehicleDetails Api
    private let vehicles = Table("vehicles")
    private let vehicleId = Expression<Int64>("id")
    private let vehicleNumber = Expression<String>("vehicleNumber")
    private let noOfWheel = Expression<Int64>("noOfWheel")
    private let qrCode = Expression<String>("qrCode") // Stored as comma-separated string
    private let active = Expression<Bool>("active")
    private let model = Expression<String>("model")
    private let brand = Expression<String>("brand")
    private let type = Expression<String>("type")
    private let capacity = Expression<String>("capacity")
    private let vehicleSuperCompanyId = Expression<Int64>("superCompanyId")
    private let vehicleCompanyId = Expression<Int64>("companyId")
    
    //Mark: - getFuelInfoForOfflineSyncForAllVehicles
    private let fuelInfoTable = Table("fuel_info")

    private let previousOdometer = Expression<Double>("previousOdometer")
    private let averageMileage = Expression<Double>("averageMileage")
    private let fuelCountByVehicleId = Expression<Int>("fuelCountByVehicleId")
    private let previousMileage = Expression<Double>("previousMileage")
    private let vehicleIdForFuel = Expression<Int64>("vehicleId") // Reuse if already defined
    private let prevQuantityFilled = Expression<Double>("prevQuantityFilled")
    private let totalUnusedFuel = Expression<Double>("totalUnusedFuel")
    private let remainFuel = Expression<Double>("remainFuel")

    

    // MARK: - Init & DB Setup
    
    private init() {
        setupDatabase()
    }
    
    private func setupDatabase() {
        do {
            let documentDir = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            let dbPath = documentDir.appendingPathComponent("vfleet.sqlite3").path
            db = try Connection(dbPath)
            print("Database created at path: \(dbPath)")
        } catch {
            print("Database setup failed: \(error)")
        }
    }

    func createUsersTable() {
        do {
            try db?.run(users.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(name)
                table.column(email)
                table.column(role)
                table.column(accessNotExpired)
                table.column(userEnabled)
                table.column(superCompanyName)
                table.column(mobile)
                table.column(companyId)
                table.column(driverId)
                table.column(userShiftStatus)
                table.column(attendanceStatus)
                table.column(superCompanyId)
                table.column(accessFleet)
                table.column(accessFuel)
                table.column(accessExpense)
                table.column(accessRental)
            })
            print("Users table created.")
        } catch {
            print("Create users table failed: \(error)")
        }
    }

    func insertUser(_ user: UserDeatilsDataModel) {
        guard
            let id = user.id,
            let name = user.name,
            let role = user.role,
            let email = user.email,
            let accessNotExpired = user.accountNotExpired,
            let userEnabled = user.enabled,
            let superCompanyName = user.superCompanyName,
            let mobile = user.mobile,
            let companyId = user.companyId,
            let driverId = user.driverId,
            let userShiftStatus = user.shiftStatus,
            let attendanceStatus = user.attendanceStatus,
            let superCompanyId = user.superCompanyId
        else {
            print("Invalid user data")
            return
        }

        let fleet = user.access?.fleet ?? false
        let fuel = user.access?.fuel ?? false
        let expense = user.access?.expense ?? false
        let rental = user.access?.rental ?? false

        let insert = users.insert(
            self.id <- Int64(id),
            self.name <- name,
            self.role <- role,
            self.email <- email,
            self.accessNotExpired <- accessNotExpired,
            self.userEnabled <- userEnabled,
            self.superCompanyName <- superCompanyName,
            self.mobile <- mobile,
            self.companyId <- Int64(companyId),
            self.driverId <- Int64(driverId),
            self.userShiftStatus <- userShiftStatus,
            self.attendanceStatus <- attendanceStatus,
            self.superCompanyId <- Int64(superCompanyId),
            self.accessFleet <- fleet,
            self.accessFuel <- fuel,
            self.accessExpense <- expense,
            self.accessRental <- rental
        )

        do {
            try db?.run(insert)
            print("Inserted user: \(name)")
            print("Inserted user: \(email)")
        } catch {
            print("Insert failed: \(error)")
        }
    }
    
    func updateUser(_ user: UserDeatilsDataModel) {
        guard
            let id = user.id,
            let name = user.name,
            let role = user.role,
            let email = user.email,
            let accessNotExpired = user.accountNotExpired,
            let userEnabled = user.enabled,
            let superCompanyName = user.superCompanyName,
            let mobile = user.mobile,
            let companyId = user.companyId,
            let driverId = user.driverId,
            let userShiftStatus = user.shiftStatus,
            let attendanceStatus = user.attendanceStatus,
            let superCompanyId = user.superCompanyId
        else {
            print("Invalid user data")
            return
        }

        let fleet = user.access?.fleet ?? false
        let fuel = user.access?.fuel ?? false
        let expense = user.access?.expense ?? false
        let rental = user.access?.rental ?? false

        let userToUpdate = users.filter(self.id == Int64(id))

        let update = userToUpdate.update(
            self.name <- name,
            self.role <- role,
            self.email <- email,
            self.accessNotExpired <- accessNotExpired,
            self.userEnabled <- userEnabled,
            self.superCompanyName <- superCompanyName,
            self.mobile <- mobile,
            self.companyId <- Int64(companyId),
            self.driverId <- Int64(driverId),
            self.userShiftStatus <- userShiftStatus,
            self.attendanceStatus <- attendanceStatus,
            self.superCompanyId <- Int64(superCompanyId),
            self.accessFleet <- fleet,
            self.accessFuel <- fuel,
            self.accessExpense <- expense,
            self.accessRental <- rental
        )

        do {
            let rowsUpdated = try db?.run(update) ?? 0
            if rowsUpdated > 0 {
                print("Updated user: \(name) (\(email))")
            } else {
                print("No user updated. User with ID \(id) may not exist.")
            }
        } catch {
            print("Update failed: \(error)")
        }
    }

    func isUserExists(id: Int64) -> Bool {
        do {
            let query = users.filter(self.id == id)
            return try db?.pluck(query) != nil
        } catch {
            print("User existence check failed: \(error)")
            return false
        }
    }
    
    func getAllUserMobileNumbers() -> [String] {
        var mobileNumbers: [String] = []

        do {
            guard let rows = try db?.prepare(users.select(mobile)) else {
                print("No data found in users table.")
                return []
            }

            for row in rows {
                mobileNumbers.append(row[mobile])
            }
        } catch {
            print("Failed to fetch mobile numbers: \(error)")
        }

        return mobileNumbers
    }

    func createVehiclesTable() {
        do {
            try db?.run(vehicles.create(ifNotExists: true) { table in
                table.column(vehicleId, primaryKey: true)
                table.column(vehicleNumber)
                table.column(noOfWheel)
                table.column(qrCode)
                table.column(active)
                table.column(model)
                table.column(brand)
                table.column(type)
                table.column(capacity)
                table.column(vehicleSuperCompanyId)
                table.column(vehicleCompanyId)
            })
            print("Vehicles table created.")
        } catch {
            print("Create vehicles table failed: \(error)")
        }
    }
    
    func insertVehicle(_ vehicle: GetAllVehicleDetailsResponseData) {
        let qrDataString = vehicle.qrCode?.map { String($0) }.joined(separator: ",") ?? ""

        let insert = vehicles.insert(
            vehicleId <- Int64(vehicle.id ?? 0),
            vehicleNumber <- vehicle.vehicleNumber ?? "",
            noOfWheel <- Int64(vehicle.noOfWheel ?? 0),
            qrCode <- qrDataString,
            active <- vehicle.active ?? false,
            model <- vehicle.model ?? "",
            brand <- vehicle.brand ?? "",
            type <- vehicle.type ?? "",
            capacity <- vehicle.capacity?.rawValue ?? "",
            vehicleSuperCompanyId <- Int64(vehicle.superCompanyID ?? 0),
            vehicleCompanyId <- Int64(vehicle.companyID ?? 0)
        )

        do {
            try db?.run(insert)
            print("Inserted vehicle: \(vehicle.vehicleNumber ?? "Unknown")")
        } catch {
            print("Insert vehicle failed: \(error)")
        }
    }

    func updateVehicle(_ vehicle: GetAllVehicleDetailsResponseData) {
        let qrDataString = vehicle.qrCode?.map { String($0) }.joined(separator: ",") ?? ""
        let targetVehicle = vehicles.filter(vehicleId == Int64(vehicle.id ?? 0))

        let update = targetVehicle.update(
            vehicleNumber <- vehicle.vehicleNumber ?? "",
            noOfWheel <- Int64(vehicle.noOfWheel ?? 0),
            qrCode <- qrDataString,
            active <- vehicle.active ?? false,
            model <- vehicle.model ?? "",
            brand <- vehicle.brand ?? "",
            type <- vehicle.type ?? "",
            capacity <- vehicle.capacity?.rawValue ?? "",
            vehicleSuperCompanyId <- Int64(vehicle.superCompanyID ?? 0),
            vehicleCompanyId <- Int64(vehicle.companyID ?? 0)
        )

        do {
            try db?.run(update)
            print("Updated vehicle: \(vehicle.vehicleNumber ?? "Unknown")")
        } catch {
            print("Update vehicle failed: \(error)")
        }
    }
    
    func isVehicleExists(id: Int64) -> Bool {
        do {
            let query = vehicles.filter(vehicleId == id)
            return try db?.pluck(query) != nil
        } catch {
            print("Check vehicle exists failed: \(error)")
            return false
        }
    }
    
    func createFuelInfoTable() {
        do {
            try db?.run(fuelInfoTable.create(ifNotExists: true) { table in
                table.column(vehicleIdForFuel, primaryKey: true) // Assuming one row per vehicle
                table.column(previousOdometer)
                table.column(averageMileage)
                table.column(fuelCountByVehicleId)
                table.column(previousMileage)
                table.column(prevQuantityFilled)
                table.column(totalUnusedFuel)
                table.column(remainFuel)
            })
            print("Fuel info table created.")
        } catch {
            print("Create fuel info table failed: \(error)")
        }
    }

    func insertFuelInfo(_ model: FuelDetailsResponseDataModel) {
        guard
            let vehicleId = model.vehicleID,
            let previousOdometer = model.previousOdometer,
            let averageMileage = model.averageMileage,
            let fuelCount = model.fuelCountByVehicleID,
            let previousMileage = model.previousMileage,
            let prevQuantityFilled = model.prevQuantityFilled,
            let totalUnusedFuel = model.totalUnusedFuel,
            let remainFuel = model.remainFuel
        else {
            print("Invalid fuel data")
            return
        }

        let insert = fuelInfoTable.insert(
            vehicleIdForFuel <- Int64(vehicleId),
            self.previousOdometer <- Double(previousOdometer),
            self.averageMileage <- averageMileage,
            self.fuelCountByVehicleId <- fuelCount,
            self.previousMileage <- Double(previousMileage),
            self.prevQuantityFilled <- Double(prevQuantityFilled),
            self.totalUnusedFuel <- Double(totalUnusedFuel),
            self.remainFuel <- Double(remainFuel)
        )

        do {
            try db?.run(insert)
            print("Inserted fuel info for vehicleId: \(vehicleId)")
        } catch {
            print("Insert fuel info failed: \(error)")
        }
    }

    func updateFuelInfo(_ model: FuelDetailsResponseDataModel) {
        guard
            let vehicleId = model.vehicleID,
            let previousOdometer = model.previousOdometer,
            let averageMileage = model.averageMileage,
            let fuelCount = model.fuelCountByVehicleID,
            let previousMileage = model.previousMileage,
            let prevQuantityFilled = model.prevQuantityFilled,
            let totalUnusedFuel = model.totalUnusedFuel,
            let remainFuel = model.remainFuel
        else {
            print("Invalid fuel data")
            return
        }

        let record = fuelInfoTable.filter(vehicleIdForFuel == Int64(vehicleId))

        let update = record.update(
            self.previousOdometer <- Double(previousOdometer),
            self.averageMileage <- averageMileage,
            self.fuelCountByVehicleId <- fuelCount,
            self.previousMileage <- Double(previousMileage),
            self.prevQuantityFilled <- Double(prevQuantityFilled),
            self.totalUnusedFuel <- Double(totalUnusedFuel),
            self.remainFuel <- Double(remainFuel)
        )

        do {
            if try db?.run(update) ?? 0 > 0 {
                print("Updated fuel info for vehicleId: \(vehicleId)")
            } else {
                print("No record found to update for vehicleId: \(vehicleId)")
            }
        } catch {
            print("Update fuel info failed: \(error)")
        }
    }
    
    func isFuelRecordExists(vehicleId: Int64) -> Bool {
        do {
            let query = fuelInfoTable.filter(vehicleIdForFuel == vehicleId)
            return try db?.pluck(query) != nil
        } catch {
            print("Check fuel record exists failed: \(error)")
            return false
        }
    }


    
}

