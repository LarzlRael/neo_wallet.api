"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const express_validator_1 = require("express-validator");
const wallet_1 = require("../controllers/wallet");
const middelwares_1 = require("../middlewares/middelwares");
const validarJwt_1 = require("../middlewares/validarJwt");
const router = express_1.Router();
// wallet/createWallet
router.post('/createwallet', [
    express_validator_1.check('walletName', 'Ingrese nombre de lal billetera').not().isEmpty(),
    validarJwt_1.validarJWT,
    middelwares_1.validarCampos
], wallet_1.createWallet);
// wallet/deleteWallet
router.put('/renameWallet', [
    express_validator_1.check('walletId', 'Ingrese un id de billetera').not().isEmpty(),
    express_validator_1.check('newName', 'Ingrese un nombre valdido').not().isEmpty(),
    validarJwt_1.validarJWT,
    middelwares_1.validarCampos
], wallet_1.renameWallet);
router.delete('/deleteWallet', [
    express_validator_1.check('walletId', 'Ingrese un id de billetera').not().isEmpty(),
    validarJwt_1.validarJWT,
    middelwares_1.validarCampos
], wallet_1.deleteWallet);
// wallet/walletByUsers
router.get('/walletbyuser', validarJwt_1.validarJWT, wallet_1.getWalletsByUser);
exports.default = router;
//# sourceMappingURL=wallet.js.map