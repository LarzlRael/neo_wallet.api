"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const express_validator_1 = require("express-validator");
const transaction_1 = require("../controllers/transaction");
const middelwares_1 = require("../middlewares/middelwares");
const validarJwt_1 = require("../middlewares/validarJwt");
const router = express_1.Router();
// send Amount
// /transactions/send/
//amount, userTarget, userOriginWallet, userTargetWallet
router.post('/send', [
    express_validator_1.check('amount', 'El monto es obligatorio').not().isEmpty().isNumeric(),
    express_validator_1.check('userOriginWallet', 'La billeta de origen es obligatorio').not().isEmpty(),
    express_validator_1.check('userTargetWallet', 'La billeta de destino es obligatorio').not().isEmpty(),
    express_validator_1.check('userOriginName', 'Debes proveer el nombre del usuario de origen').not().isEmpty(),
    middelwares_1.validarCampos,
    validarJwt_1.validarJWT,
], transaction_1.sendAmount);
///transactions/getransactions/
router.get('/gettransactions', validarJwt_1.validarJWT, transaction_1.getTransactionsByUser);
//History
router.get('/transactionsHistory', validarJwt_1.validarJWT, transaction_1.getTransactionsHistory);
router.post('/transactionByWallet', [
    express_validator_1.check('walletId', 'Debes ingresar el id de la billetera').not().isEmpty(),
    middelwares_1.validarCampos,
    validarJwt_1.validarJWT
], transaction_1.getTransactionByWallet);
exports.default = router;
//# sourceMappingURL=transaction.js.map