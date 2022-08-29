import { Schema, model } from 'mongoose';
import { ITransaction } from '../interfaces/transaction';
import { TRANSACTION, USERS, WALLET } from './documents';

const TransactionSchema = new Schema({

    originUser: {
        type: Schema.Types.ObjectId,
        ref: USERS,
        required: true
    },
    destinyUser: {
        type: Schema.Types.ObjectId,
        ref: USERS,
        required: true
    },
    userOriginWallet: {
        type: Schema.Types.ObjectId,
        ref: WALLET,
        required: true
    },
    
    userTargetWallet: {
        type: Schema.Types.ObjectId,
        ref: WALLET,
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
    const { __v, _id, ...object } = this.toObject();
    return object;
});

export default model<ITransaction>(TRANSACTION, TransactionSchema);