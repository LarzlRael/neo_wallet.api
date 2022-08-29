"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const express_validator_1 = require("express-validator");
const auth_1 = require("../controllers/auth");
const middelwares_1 = require("../middlewares/middelwares");
const validarJwt_1 = require("../middlewares/validarJwt");
const router = express_1.Router();
router.post('/register', [
    express_validator_1.check('name', 'El nombre es obligatorio').not().isEmpty(),
    express_validator_1.check('password', 'La contraseña is obligatoria').not().isEmpty(),
    express_validator_1.check('email', 'El email es obligatorio').isEmail(),
    middelwares_1.validarCampos
], auth_1.registerUser);
router.post('/login', [
    express_validator_1.check('email', 'El email es obligatorio').isEmail(),
    express_validator_1.check('password', 'La contraseña is obligatoria').not().isEmpty(),
    middelwares_1.validarCampos
], auth_1.login);
router.post('/saveNewDevice', [
    express_validator_1.check('deviceId', 'ingrese id de dispositivo').not().isEmpty(),
    middelwares_1.validarCampos,
    validarJwt_1.validarJWT
], auth_1.saveNewDevice);
router.get('/logout/:deviceId', [
    express_validator_1.check('deviceId', 'ingrese id de dispositivo').not().isEmpty(),
    middelwares_1.validarCampos,
    validarJwt_1.validarJWT
], auth_1.logout);
router.get('/renew', validarJwt_1.validarJWT, auth_1.renewToken);
exports.default = router;
//# sourceMappingURL=auth.js.map