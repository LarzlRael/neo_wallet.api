import { Schema, model } from 'mongoose';
import { IWallet } from '../interfaces/interfaces';
import { USERS, WALLET } from './documents';

const WalletSchema = new Schema({

    balance: {
        type: Number,
        default: 0
    },
    idUser: {
        type: Schema.Types.ObjectId,
        ref: USERS,
        required: true
    },
    walletName:{
        type: String,
        required: true
    },
    block: {
        type: Boolean,
        default: false,
        required: true
    },

}, {
    timestamps: true,
});



WalletSchema.method('toJSON', function () {
    const { __v, ...object } = this.toObject();
    return object;
})

export default model<IWallet>(WALLET, WalletSchema);