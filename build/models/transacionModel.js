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
const TransactionSchema = new mongoose_1.Schema({
    originUser: {
        type: mongoose_1.Schema.Types.ObjectId,
        ref: documents_1.USERS,
        required: true
    },
    destinyUser: {
        type: mongoose_1.Schema.Types.ObjectId,
        ref: documents_1.USERS,
        required: true
    },
    userOriginWallet: {
        type: mongoose_1.Schema.Types.ObjectId,
        ref: documents_1.WALLET,
        required: true
    },
    userTargetWallet: {
        type: mongoose_1.Schema.Types.ObjectId,
        ref: documents_1.WALLET,
        required: true
    },
    amount: {
        type: Number,
        required: true
    }
}, {
    timestamps: true,
});
TransactionSchema.method('toJSON', function () {
    const _a = this.toObject(), { __v, _id } = _a, object = __rest(_a, ["__v", "_id"]);
    return object;
});
exports.default = mongoose_1.model(documents_1.TRANSACTION, TransactionSchema);
//# sourceMappingURL=transacionModel.js.map