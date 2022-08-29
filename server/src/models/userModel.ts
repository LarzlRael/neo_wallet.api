
import { Schema, model } from "mongoose";
import { IUser } from "../interfaces/interfaces";
import { WALLET } from "./documents";


const UserSchema = new Schema<IUser>({
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
            type: Schema.Types.ObjectId,
            ref: WALLET,
        }
    ],
    devices: [
        {
            type: String,
        },
    ]
});

UserSchema.method('toJSON', function () {

    const { __v, _id, password, ...object } = this.toObject();
    object.uid = _id;
    return object;

});

export default model<IUser>('Users', UserSchema);