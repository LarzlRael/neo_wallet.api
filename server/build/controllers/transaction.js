"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getTransactionsHistory = exports.getTransactionsByUser = exports.getTransactionByWallet = exports.sendAmount = void 0;
const transacionModel_1 = __importDefault(require("./../models/transacionModel"));
const walletModel_1 = __importDefault(require("./../models/walletModel"));
const userModel_1 = __importDefault(require("../models/userModel"));
const mongoose_1 = __importDefault(require("mongoose"));
const pushNotification_1 = require("../helpers/pushNotification");
const sendAmount = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { amount, userOriginWallet, userTargetWallet, userOriginName } = req.body;
    const { uid } = req;
    /* verifyWallet(userOriginWallet, res); */
    if (verifyId(userOriginWallet) && verifyId(userTargetWallet)) {
        yield verifyWallet(userTargetWallet, res);
        yield verifyWallet(userOriginWallet, res);
        const newTransaction = new transacionModel_1.default();
        newTransaction.amount = amount;
        newTransaction.originUser = uid;
        newTransaction.userOriginWallet = userOriginWallet;
        newTransaction.userTargetWallet = userTargetWallet;
        const userTargetWAlletDB = yield walletModel_1.default.findById(userTargetWallet);
        const userOriginWAlletDB = yield walletModel_1.default.findById(userOriginWallet);
        // check if the amount is greater than the balance
        if (amount > userOriginWAlletDB.balance) {
            return res.json({
                ok: false,
                msg: 'Saldo insuficiente',
            });
        }
        //? sustraction
        userOriginWAlletDB.balance = userOriginWAlletDB.balance - amount;
        yield userOriginWAlletDB.save();
        //? add new amount 
        newTransaction.destinyUser = userTargetWAlletDB.idUser;
        userTargetWAlletDB.balance = userTargetWAlletDB.balance + amount;
        yield userTargetWAlletDB.save();
        //? save new transaction 
        const newTransactionRaw = yield newTransaction.save();
        //? Send Push notifications
        const usersDevices = yield getDevicesUserDestiny(userTargetWAlletDB.idUser);
        yield pushNotification_1.sendPushNotification(usersDevices, userOriginName, amount);
        return res.json({
            ok: true,
            msg: 'Transaccion realizada con exito :D',
            newTransactionRaw
        });
    }
    else {
        return res.status(403).json({
            ok: false,
            msg: 'Verifique los datos'
        });
    }
});
exports.sendAmount = sendAmount;
const getTransactionByWallet = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { walletId } = req.body;
    if (verifyId(walletId)) {
        const userTransactions = yield transacionModel_1.default.find({
            $or: [{ userOriginWallet: walletId }, { userTargetWallet: walletId }],
        }).sort('-createdAt ');
        return res.json({
            ok: true,
            userTransactions
        });
    }
    else {
        return res.status(400).json({
            ok: true,
            msg: 'Hubo un error en la consulta'
        });
    }
});
exports.getTransactionByWallet = getTransactionByWallet;
const getTransactionsByUser = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { uid } = req;
    const getuserTransaction = yield transacionModel_1.default.find({
        $or: [{ originUser: uid }, { destinyUser: uid }],
    }).sort('-createdAt ');
    res.json({
        ok: true,
        userTransactions: getuserTransaction
    });
});
exports.getTransactionsByUser = getTransactionsByUser;
// 
const verifyId = (id) => {
    return mongoose_1.default.Types.ObjectId.isValid(id);
};
const verifyWallet = (id, res) => __awaiter(void 0, void 0, void 0, function* () {
    const userOriginWAlletDB = yield walletModel_1.default.findById(id);
    if (userOriginWAlletDB) {
        return true;
    }
    else {
        return res.json({
            ok: true,
            msg: 'billetera no encontrada'
        });
    }
});
const getTransactionsHistory = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const transactionsHistory = yield transacionModel_1.default.find().sort('-createdAt');
    res.json({
        ok: true,
        userTransactions: transactionsHistory
    });
});
exports.getTransactionsHistory = getTransactionsHistory;
const getDevicesUserDestiny = (idUserDestiny) => __awaiter(void 0, void 0, void 0, function* () {
    const userDevicesId = yield userModel_1.default.findById(idUserDestiny);
    return userDevicesId.devices;
});
/* const getOriginUser = async (idUserOrigin: string) => {
    const userOriginInfo = await UserModel.findById(idUserOrigin);
    return userOriginInfo?.name;
} */ 
//# sourceMappingURL=transaction.js.map