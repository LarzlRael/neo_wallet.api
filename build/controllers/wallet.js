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
exports.verifyWalletOwner = exports.deleteWallet = exports.renameWallet = exports.getWalletsByUser = exports.createWallet = void 0;
const walletModel_1 = __importDefault(require("../models/walletModel"));
const userModel_1 = __importDefault(require("../models/userModel"));
const createWallet = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { uid } = req;
        const newWallet = new walletModel_1.default();
        newWallet.idUser = uid;
        newWallet.walletName = req.body.walletName;
        const newWalletCreated = yield newWallet.save();
        const getUser = yield userModel_1.default.findById(uid);
        getUser === null || getUser === void 0 ? void 0 : getUser.wallets.push(newWalletCreated.id);
        yield (getUser === null || getUser === void 0 ? void 0 : getUser.save());
        res.json({
            ok: true,
            userWallets: newWalletCreated
        });
    }
    catch (error) {
        console.log(error);
    }
});
exports.createWallet = createWallet;
const getWalletsByUser = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { uid } = req;
        const userWallets = yield walletModel_1.default.find({ idUser: uid }).sort('-createdAt');
        res.json({
            ok: true,
            userWallets
        });
    }
    catch (error) {
        console.log(error);
    }
});
exports.getWalletsByUser = getWalletsByUser;
const renameWallet = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { uid } = req;
        // TODO revisar que la billetera pertenezca a esta persona
        // TODO check if the wallet is bearer of this user
        const { walletId } = req.body;
        const { newName } = req.body;
        const userWalletUpdated = yield walletModel_1.default.findOne({ _id: walletId });
        if (yield exports.verifyWalletOwner(uid, walletId)) {
            if (userWalletUpdated) {
                userWalletUpdated.walletName = newName;
                yield (userWalletUpdated === null || userWalletUpdated === void 0 ? void 0 : userWalletUpdated.save());
                res.json({
                    ok: true,
                    userWalletUpdated
                });
            }
            else {
                res.status(400).json({
                    ok: false,
                    msg: 'No se econtro la billetera'
                });
            }
        }
        else {
            res.status(400).json({
                ok: false,
                msg: 'No puedes renombrar una billetera que no es tuya'
            });
        }
    }
    catch (error) {
        console.log(error);
    }
});
exports.renameWallet = renameWallet;
const deleteWallet = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { walletId } = req.body;
        const { uid } = req;
        if (yield exports.verifyWalletOwner(uid, walletId)) {
            const currentWallet = yield walletModel_1.default.findById(walletId);
            if (currentWallet) {
                if (currentWallet.balance > 0) {
                    return res.status(400).json({
                        ok: false,
                        msg: 'Esta billetara aun tiene saldo, transfieralo a otra billetara'
                    });
                }
                const getUserOwnerWallet = yield userModel_1.default.findById(currentWallet.idUser);
                let walletIdTemp = walletId;
                getUserOwnerWallet.wallets = getUserOwnerWallet.wallets.filter((wallet) => walletIdTemp != wallet);
                yield (getUserOwnerWallet === null || getUserOwnerWallet === void 0 ? void 0 : getUserOwnerWallet.save());
                const walletDeleted = yield walletModel_1.default.findByIdAndDelete(walletId);
                return res.json({
                    ok: true,
                    msg: 'billetera Eliminada correctamente',
                    walletDeleted
                });
            }
            else {
                return res.status(400).json({
                    ok: false,
                    msg: 'La billetera no existe'
                });
            }
        }
        else {
            return res.status(400).json({
                ok: false,
                msg: 'no puedes borrar una billetera que no sea tuya'
            });
        }
    }
    catch (error) {
        console.log(error);
    }
});
exports.deleteWallet = deleteWallet;
const verifyWalletOwner = (idUser, idWallet) => __awaiter(void 0, void 0, void 0, function* () {
    const verifyWallet = yield walletModel_1.default.findOne({ _id: idWallet }).sort('-createdAt');
    return ((verifyWallet === null || verifyWallet === void 0 ? void 0 : verifyWallet.idUser) == idUser);
});
exports.verifyWalletOwner = verifyWalletOwner;
//# sourceMappingURL=wallet.js.map