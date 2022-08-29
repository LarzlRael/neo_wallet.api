"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const express_validator_1 = require("express-validator");
const mailController_1 = require("../controllers/mailController");
const middelwares_1 = require("../middlewares/middelwares");
const validarJwt_1 = require("../middlewares/validarJwt");
const passport_1 = __importDefault(require("passport"));
const router = express_1.Router();
// /sendmail/
router.post('/', [
    express_validator_1.check('email', 'El email es obligatorio').isEmail(),
    middelwares_1.validarCampos
], mailController_1.SendEmailActivation);
/* router.post('/recoverypassword', [

    check('email', 'El email es obligatorio').isEmail(),
    validarCampos
], sendEmailToRecoveryPassword);
 */
router.get('/confirm/:token/:email', [
    validarJwt_1.validateIfEmailExists
], mailController_1.renderConfirmEmail);
router.get('/verifiedemail', [], mailController_1.verifiedEmail);
router.get('/verifycheck/:token/', [
    validarJwt_1.validarJWTEmail,
    validarJwt_1.validateIfEmailExists
], mailController_1.verifyCheck);
router.post('/recoverypassword/', [
    express_validator_1.check('email', 'El email es obligatorio').isEmail(),
    middelwares_1.validarCampos,
    validarJwt_1.validateIfEmailExists,
], mailController_1.sendEmailToRecoveryPassword);
router.get('/recoverypasswordform/:token/', [validarJwt_1.validarJWTEmail], mailController_1.renderRecoveryForm);
router.post('/confirmchangepassword/:token/', [
    express_validator_1.check('newPassword', 'Ingrese una nueva contraseña').not().isEmpty(),
    middelwares_1.validarCampos,
    validarJwt_1.validarJWTEmail
], mailController_1.passwordChanged);
router.get('/special', passport_1.default.authenticate('jwt', { session: false }), (req, res) => {
    res.send('success');
});
exports.default = router;
//# sourceMappingURL=mail.js.map