//
//  ReservationViewController - APIs .swift
//  CarShare
//
//  Created by nicholas on 3/28/23.
//

import UIKit

extension ReservationViewController {
    // MARK: - Reservation
    func createReservation() {
        guard let orderInfo: CSBody = makeOrderInfo() else { return }
        self.dismissWorker()
        let worker = CSAPIWorker(with: CSEndPoints.createReservationWithPaymentRequest(orderInfo: orderInfo))?
            .prepare()
            .when(success: { [weak self] (result) in
                if let reservation: CSReservation = CSReservation(json: result) {
                    self?.reservation = reservation
                    self?.preparePayment(with: reservation)
                }
                self?.dismissWorker()
            })
            .when(failure: { [weak self] (error) in
                self?.dismissWorker()
            })
            .fire()
        worker?.debug = true
        self.apiWorker = worker
    }
    
    func makeOrderInfo() -> CSBody? {
        guard let carDetail = self.carDetail,
              let startDate = startDate,
              let endDate = endDate,
              let days = startDate.days(between: endDate)
        else { return nil }
        var orderInfo: CSBody = CSBody()
        orderInfo["title"] = carDetail.makeAndModel + "\((carDetail.year?.isEmpty == false) ? "\(" - "+carDetail.year!)" : "")"
        orderInfo["price"] = Decimal(days) * carDetail.rentalPrice
        orderInfo["description"] = carDetail.makeAndModel + "\(carDetail.year?.isEmpty == true ? "" : " \(carDetail.year!)")" + (carDetail.colour ?? "")
        orderInfo["isSubscription"] = false
        orderInfo["paymentInterval"] = ""
        return orderInfo
    }
    
    // MARK: - Transactions
    func createTransaction() {
        guard let transaction: CSBody = makeTransactionRecord() else { return }
        self.dismissWorker()
        let worker = CSAPIWorker(with: CSEndPoints.createTransaction(transactionInfo: transaction), debug: true)?
            .prepare()
            .when(success: { [weak self] (result) in
                self?.transaction = CSTransaction(json: result["data"])
                self?.dismissWorker()
                self?.createPaymentRecord()
            })
            .when(failure: { [weak self] (error) in
                self?.dismissWorker()
            })
            .fire()
        self.apiWorker = worker
    }
        
    func makeTransactionRecord() -> CSBody? {
        guard let carDetail = self.carDetail,
              let startDate = startDate,
              let endDate = endDate,
              let days = startDate.days(between: endDate)
        else { return nil }
        let transactionInfo = [
            "data": [
                "title": carDetail.makeAndModel + "\((carDetail.year?.isEmpty == false) ? "\(" - "+carDetail.year!)" : "")",
                "RentalDate": DateFormatter.standard.string(from: Date()),
                "TotalRentalFee": Decimal(days) * carDetail.rentalPrice,
                "RentalStatus": true,
                "RentalStartDate": DateFormatter.standard.string(from: startDate),
                "RentalEndDate": DateFormatter.standard.string(from: endDate)
            ]
        ]
        return transactionInfo
    }
    
    // MARK: - Cars
    func updateCars() {
        guard let carDetail = self.carDetail,
              let carInfo: CSBody = makeCarRecord() else { return }
        self.dismissWorker()
        let worker = CSAPIWorker(with: CSEndPoints.update(car: carInfo,
                                                          with: String(carDetail.carID)))?
            .prepare()
            .when(success: { [weak self] (result) in
                self?.onCarUpdated()
                self?.dismissWorker()
            })
            .when(failure: { [weak self] (error) in
                self?.dismissWorker()
            })
            .fire()
        self.apiWorker = worker
    }
    
    func makeCarRecord() -> CSBody? {
        guard let transaction = self.transaction
        else { return nil }
        let paymentInfo = [
            "data": [
                "rental_transcation": transaction.transactionID
            ]
        ]
        return paymentInfo
    }
    
    // MARK: - Payment
    func createPaymentRecord() {
        guard let payment: CSBody = makePaypalPaymentRecord()
        else { return }
        self.dismissWorker()
        let worker = CSAPIWorker(with: CSEndPoints.createPayment(body: payment))?
            .prepare()
            .when(success: { [weak self] (result) in
                self?.onPaymentTransactionCreated()
                self?.dismissWorker()
                self?.updateCars()
            })
            .when(failure: { [weak self] (error) in
                self?.dismissWorker()
            })
            .fire()
        self.apiWorker = worker
    }
    
    func makePaypalPaymentRecord() -> CSBody? {
        guard let reservation = self.reservation,
              let transaction = self.transaction
        else { return nil }
        let paymentInfo = [
            "data": [
                "rental_transcation": transaction.transactionID,
                "PaymentDate": DateFormatter.standard.string(from: Date()),
                "PaymentType": "PayPal",
                "PayPalPaymentRef": reservation.paypalOrderID,
            ]
        ]
        return paymentInfo
    }
}
