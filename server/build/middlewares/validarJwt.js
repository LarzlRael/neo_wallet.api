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
exports.validateIfEmailExists = exports.validarJWTEmail = exports.validarJWT = void 0;
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const userModel_1 = __importDefault(require("../models/userModel"));
const validarJWT = (req, res, next) => {
    //Leer token
    const token = req.header('x-token');
    if (!token) {
        return res.status(401).json({
            ok: false,
            msg: 'No hay token en la peticion'
        });
    }
    try {
        const { uid } = jsonwebtoken_1.default.verify(token, process.env.JWT_KEY);
        req.uid = uid;
        next();
    }
    catch (error) {
        return res.status(401).json({
            ok: false,
            msg: 'Token no valido'
        });
    }
};
exports.validarJWT = validarJWT;
const validarJWTEmail = (req, res, next) => {
    //Leer token
    const { token } = req.params;
    if (!token) {
        return res.status(401).json({
            ok: false,
            msg: 'No hay token en la peticion'
        });
    }
    try {
        const { email } = jsonwebtoken_1.default.verify(token, process.env.JWT_KEY);
        req.email = email;
        next();
    }
    catch (error) {
        return res.status(401).send('Hubo un error');
    }
};
exports.validarJWTEmail = validarJWTEmail;
const validateIfEmailExists = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    const { email } = req.body;
    const verfyEmail = yield userModel_1.default.findOne({ email: req.email != null ? req.email : email });
    if (!verfyEmail) {
        return res.status(401).json({
            ok: false,
            msg: 'Email no valido'
        });
    }
    next();
});
exports.validateIfEmailExists = validateIfEmailExists;
//# sourceMappingURL=validarJwt.js.map