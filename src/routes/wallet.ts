import { Router } from 'express';
import { check } from 'express-validator';
import { createWallet, deleteWallet, getWalletsByUser, renameWallet } from '../controllers/wallet';
import { validarCampos } from '../middlewares/middelwares';
import { validarJWT } from '../middlewares/validarJwt';

const router = Router();

// wallet/createWallet
router.post('/createwallet',
    [
        check('walletName', 'Ingrese nombre de lal billetera').not().isEmpty(),
        validarJWT,
        validarCampos
    ], createWallet);

// wallet/deleteWallet

router.put('/renameWallet',
    [
        check('walletId', 'Ingrese un id de billetera').not().isEmpty(),
        check('newName', 'Ingrese un nombre valdido').not().isEmpty(),
        validarJWT,
        validarCampos
    ], renameWallet);


router.delete('/deleteWallet',
    [
        check('walletId', 'Ingrese un id de billetera').not().isEmpty(),
        validarJWT,
        validarCampos
    ], deleteWallet);

// wallet/walletByUsers
router.get('/walletbyuser', validarJWT, getWalletsByUser);

export default router;