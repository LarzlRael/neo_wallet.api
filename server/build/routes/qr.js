"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const express_validator_1 = require("express-validator");
const qrController_1 = require("../controllers/qrController");
const middelwares_1 = require("../middlewares/middelwares");
const validarJwt_1 = require("../middlewares/validarJwt");
const router = express_1.Router();
router.post('/', [
    express_validator_1.check('url', 'Ingrese un url valido').not().isEmpty(),
    middelwares_1.validarCampos,
    validarJwt_1.validarJWT,
], qrController_1.generateQR);
exports.default = router;
//# sourceMappingURL=qr.js.map