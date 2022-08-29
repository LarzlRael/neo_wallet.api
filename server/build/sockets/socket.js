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
const __1 = require("..");
const userModel_1 = __importDefault(require("../models/userModel"));
__1.io.on('connection', (socket) => {
    /*     console.log('a user connected'); */
    socket.on('transaction-real-time', (payload) => __awaiter(void 0, void 0, void 0, function* () {
        console.log('emitiendo los valores');
        __1.io.emit('transaction-real-time', payload);
    }));
    socket.on('verify-account-activate', ({ email }) => __awaiter(void 0, void 0, void 0, function* () {
        const activateuser = yield userModel_1.default.findOne({ email });
        __1.io.emit('verify-account-activate', { activate: activateuser === null || activateuser === void 0 ? void 0 : activateuser.activated });
    }));
    socket.on('disconnect', () => {
        /* console.log('user disconnected'); */
    });
});
//# sourceMappingURL=socket.js.map