import { Router } from 'express';
import { check } from 'express-validator';
import { getTransactionsByUser, sendAmount, getTransactionsHistory, getTransactionByWallet } from '../controllers/transaction';
import { validarCampos } from '../middlewares/middelwares';
import { validarJWT } from '../middlewares/validarJwt';


const router = Router();

// send Amount
// /transactions/send/
//amount, userTarget, userOriginWallet, userTargetWallet
router.post('/send',
    [
        check(
            'amount', 'El monto es obligatorio').not().isEmpty().isNumeric(),

        check('userOriginWallet', 'La billeta de origen es obligatorio').not().isEmpty(),

        check('userTargetWallet', 'La billeta de destino es obligatorio').not().isEmpty(),
        check('userOriginName', 'Debes proveer el nombre del usuario de origen').not().isEmpty(),

        validarCampos,
        validarJWT,
    ], sendAmount);

///transactions/getransactions/
router.get('/gettransactions', validarJWT, getTransactionsByUser);

//History
router.get('/transactionsHistory', validarJWT, getTransactionsHistory);


router.post('/transactionByWallet', [
    check('walletId', 'Debes ingresar el id de la billetera').not().isEmpty(),
    validarCampos,
    validarJWT],
    getTransactionByWallet);

export default router;