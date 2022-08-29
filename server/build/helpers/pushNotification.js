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
exports.sendPushNotification = void 0;
const axios_1 = __importDefault(require("axios"));
const sendPushNotification = (devicesTargets, nameOrigin, saldo) => __awaiter(void 0, void 0, void 0, function* () {
    const sendData = {
        registration_ids: devicesTargets,
        notification: {
            title: `Saldo recibido`,
            body: `EL usuario ${nameOrigin} te envio ${saldo} BS`,
            icon: 'https://www.gstatic.com/devrel-devsite/prod/v4ff7513a940c844d7a200d0833ef676f25fef10662a3b57ca262bcf76cbd98e2/firebase/images/touchicon-180.png'
        }
    };
    try {
        yield axios_1.default({
            method: 'POST',
            url: 'https://fcm.googleapis.com/fcm/send',
            data: sendData,
            headers: {
                Authorization: `key=${process.env.FIREBASE_TOKEN}`
            }
        });
    }
    catch (error) {
        console.log(error);
    }
});
exports.sendPushNotification = sendPushNotification;
//# sourceMappingURL=pushNotification.js.map