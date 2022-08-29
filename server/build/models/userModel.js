"use strict";
var __rest = (this && this.__rest) || function (s, e) {
    var t = {};
    for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p) && e.indexOf(p) < 0)
        t[p] = s[p];
    if (s != null && typeof Object.getOwnPropertySymbols === "function")
        for (var i = 0, p = Object.getOwnPropertySymbols(s); i < p.length; i++) {
            if (e.indexOf(p[i]) < 0 && Object.prototype.propertyIsEnumerable.call(s, p[i]))
                t[p[i]] = s[p[i]];
        }
    return t;
};
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = require("mongoose");
const documents_1 = require("./documents");
const UserSchema = new mongoose_1.Schema({
    name: {
        type: String,
        required: true
    },
    email: {
        type: String,
        required: true,
        unique: true
    },
    password: {
        type: String,
        required: true
    },
    online: {
        type: Boolean,
        default: false
    },
    activated: {
        type: Boolean,
        default: false
    },
    wallets: [
        {
            type: mongoose_1.Schema.Types.ObjectId,
            ref: documents_1.WALLET,
        }
    ],
    devices: [
        {
            type: String,
        },
    ]
});
UserSchema.method('toJSON', function () {
    const _a = this.toObject(), { __v, _id, password } = _a, object = __rest(_a, ["__v", "_id", "password"]);
    object.uid = _id;
    return object;
});
exports.default = mongoose_1.model('Users', UserSchema);
//# sourceMappingURL=userModel.js.map