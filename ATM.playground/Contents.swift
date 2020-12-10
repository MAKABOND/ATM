import Foundation


// ---------------------------------------
// MARK: - Домашнее задание
// ---------------------------------------

/*
 Реализуйте программу `Банкомат`, которая поддерживает финансовые операции выдачи необходимой суммы клиенту

 Программа должна поддерживать:
 1. Выдачу суммы банкнотами различного номинала в соответствующем валютном эквиваленте (евро, доллары и белорусские рубли)
 2. Для данного решения рекомендую использовать Generic Types, Enums, Functions / Closures.
 3. Реализуйте корректную обработку всех возможных ошибок, как минимум 5ти:
    - Закончились деньги в АТМ
    - Закончились деньги на карте клиента
    - Нет нужной валюты
    - и тд */


// MARK: - Solution

var cardBalance = 6543
private(set) var pinCode = 4142
var banckotInAtm = 10000
var summForWidthrow = 505

enum Currency {
    case bynov
    case dollars
    case euros
}

enum ErrorsOfAtm: Error {
    case noMoneyInAtm
    case noMoneyOnCard
    case noCurrency
    case noElectricity
    case pinError
    case wrongEnteredCash
}

func cashWidthrow(summ: Int, electricity: Bool, pin: Int, currency: Currency) throws {
    guard banckotInAtm > summ else { throw ErrorsOfAtm.noMoneyInAtm }
    guard summ <= cardBalance else { throw ErrorsOfAtm.noMoneyOnCard }
    guard electricity else { throw ErrorsOfAtm.noElectricity }
    guard pin == pinCode else { throw ErrorsOfAtm.pinError }
    guard summ % 5 == 0 else { throw ErrorsOfAtm.wrongEnteredCash }
    
    
    print("Банкомат выдает сумму - \(summ) \(currency)")
    banckotInAtm -= summ
    cardBalance -= summ
    print("Остаток на карте - \(cardBalance)")
    
}

class Atm {
    var hudreads: BancknotsInAtm
    var fifty: BancknotsInAtm
    var twenty: BancknotsInAtm
    var ten: BancknotsInAtm
    var five: BancknotsInAtm
    
    private var startPile: BancknotsInAtm {
        return self.hudreads
    }
    
    init(hudreads: BancknotsInAtm, fifty: BancknotsInAtm, twenty: BancknotsInAtm, ten: BancknotsInAtm, five: BancknotsInAtm) {
        self.hudreads = hudreads
        self.fifty = fifty
        self.twenty = twenty
        self.ten = ten
        self.five = five
    }
    
    func canWithdraw(value: Int) -> String {
        return " \(self.startPile.canWithdraw(one: value))"
    }
}

class BancknotsInAtm {
    var value: Int
    var quantity: Int
    var nextPack: BancknotsInAtm?
    
    init(value: Int, quantity: Int, nextPack: BancknotsInAtm?) {
        self.value = value
        self.quantity = quantity
        self.nextPack = nextPack
    }
    
    func canWithdraw(one: Int) -> Bool {
        var one = one
        
        func canTakeSomeBill(want: Int) -> Bool {
            return (want / self.value) > 0
        }
        
        var sec = self.quantity
        
        while canTakeSomeBill(want: one) {
            if sec == 0 {
                break
            }
            one -= self.value
            sec -= 1
        }
        if one == 0 {
            return true // справились с выдачей текущей пачкой
        } else if let next = self.nextPack { //а вот если нет, то пробуем выдать купюрами следющей пачки
            return next.canWithdraw(one: one)
        }
        
        return false // никак недьзя выдать нужную сумму
    }
}

let five = BancknotsInAtm(value: 5, quantity: 100, nextPack: nil)
let ten = BancknotsInAtm(value: 10, quantity: 100, nextPack: five)
let twenty = BancknotsInAtm(value: 20, quantity: 50, nextPack: ten)
let fifty = BancknotsInAtm(value: 50, quantity: 50, nextPack: twenty)
let hundreds = BancknotsInAtm(value: 100, quantity: 50, nextPack: fifty)

var atm = Atm(hudreads: hundreds, fifty: fifty, twenty: twenty, ten: ten, five: five)

print("are there enough bills: \(atm.canWithdraw(value: summForWidthrow))")   // проверка наличия нужных купюр в банкомате

do {
    try cashWidthrow(summ: summForWidthrow, electricity: true, pin: 4142, currency: .dollars)   // снятие наличных
} catch ErrorsOfAtm.noMoneyInAtm {
    print("There is no money in ATM")
} catch ErrorsOfAtm.noMoneyOnCard {
    print("Fill your card with money")
} catch ErrorsOfAtm.noCurrency {
    print("There is no currency you need")
} catch ErrorsOfAtm.noElectricity {
    print("WAR IN THE CITY! THERE ISN'T ELECTRICITY")
} catch ErrorsOfAtm.pinError {
    print("Entered wrong PIN")
} catch ErrorsOfAtm.wrongEnteredCash {
    print("There are no coins, enter the summ that multiples 5!")
}

