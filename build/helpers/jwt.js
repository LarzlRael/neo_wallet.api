"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.comprobarJWT = exports.generarJWT = void 0;
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const generarJWT = (uid, expiresIn = '24h', email = '') => {
    return new Promise((resolve, reject) => {
        const payload = { uid, email };
        jsonwebtoken_1.default.sign(payload, process.env.JWT_KEY, {
            expiresIn: expiresIn
        }, (err, token) => {
            if (err) {
                reject('No se pudo generar el JWT');
            }
            else {
                resolve(token);
            }
        });
    });
};
exports.generarJWT = generarJWT;
const comprobarJWT = (token = '') => {
    try {
        const { uid } = jsonwebtoken_1.default.verify(token, process.env.JWT_KEY);
        return true;
    }
    catch (error) {
        return false;
    }
};
exports.comprobarJWT = comprobarJWT;
//# sourceMappingURL=jwt.js.map