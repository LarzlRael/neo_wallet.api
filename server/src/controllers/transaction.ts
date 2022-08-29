import { Request, Response } from 'express';
import TransactionModel from './../models/transacionModel';
import WalletModel from './../models/walletModel';
import UserModel from '../models/userModel';
import mongoose from 'mongoose';
import { sendPushNotification } from '../helpers/pushNotification';

export const sendAmount = async (req: Request, res: Response) => {

    const { amount, userOriginWallet, userTargetWallet, userOriginName } = req.body;

    const { uid } = req;

    /* verifyWallet(userOriginWallet, res); */

    if (verifyId(userOriginWallet) && verifyId(userTargetWallet)) {

        await verifyWallet(userTargetWallet, res);
        await verifyWallet(userOriginWallet, res);

        const newTransaction = new TransactionModel();

        newTransaction.amount = amount;

        newTransaction.originUser = uid;

        newTransaction.userOriginWallet = userOriginWallet;
        newTransaction.userTargetWallet = userTargetWallet;


        const userTargetWAlletDB = await WalletModel.findById(userTargetWallet);


        const userOriginWAlletDB = await WalletModel.findById(userOriginWallet);

        // check if the amount is greater than the balance

        if (amount > userOriginWAlletDB!.balance) {
            return res.json({
                ok: false,
                msg: 'Saldo insuficiente',
            });
        }
        //? sustraction
        userOriginWAlletDB!.balance = userOriginWAlletDB!.balance - amount;
        await userOriginWAlletDB!.save();

        //? add new amount 

        newTransaction.destinyUser = userTargetWAlletDB!.idUser;

        userTargetWAlletDB!.balance = userTargetWAlletDB!.balance + amount;
        await userTargetWAlletDB!.save();

        //? save new transaction 
        const newTransactionRaw = await newTransaction.save();

        //? Send Push notifications
        const usersDevices = await getDevicesUserDestiny(userTargetWAlletDB!.idUser);


        await sendPushNotification(usersDevices, userOriginName, amount);



        return res.json({
            ok: true,
            msg: 'Transaccion realizada con exito :D',
            newTransactionRaw
        });

    }
    else {
        return res.status(403).json({
            ok: false,
            msg: 'Verifique los datos'
        });
    }
}


export const getTransactionByWallet = async (req: Request, res: Response) => {


    const { walletId } = req.body;

    if (verifyId(walletId)) {

        
        const userTransactions = await TransactionModel.find({

            $or: [{ userOriginWallet: walletId }, { userTargetWallet: walletId }],

        }).sort('-createdAt ');

        return res.json({
            ok: true,
            userTransactions
        })
    } else {
        return res.status(400).json({
            ok: true,
            msg: 'Hubo un error en la consulta'
        })

    }



}

export const getTransactionsByUser = async (req: Request, res: Response) => {

    const { uid } = req;


    const getuserTransaction = await TransactionModel.find({

        $or: [{ originUser: uid }, { destinyUser: uid }],

    }).sort('-createdAt ');

    res.json({
        ok: true,
        userTransactions: getuserTransaction
    })
}



// 
const verifyId = (id: any): boolean => {
    return mongoose.Types.ObjectId.isValid(id);
}

const verifyWallet = async (id: any, res: Response): Promise<boolean | Object> => {
    const userOriginWAlletDB = await WalletModel.findById(id);

    if (userOriginWAlletDB) {
        return true;
    } else {
        return res.json({
            ok: true,
            msg: 'billetera no encontrada'
        })
    }

}

export const getTransactionsHistory = async (req: Request, res: Response) => {

    const transactionsHistory = await TransactionModel.find().sort('-createdAt');

    res.json({
        ok: true,
        userTransactions: transactionsHistory
    })


}

const getDevicesUserDestiny = async (idUserDestiny: string): Promise<String[] | undefined> => {
    const userDevicesId = await UserModel.findById(idUserDestiny);

    return userDevicesId!.devices;
}

/* const getOriginUser = async (idUserOrigin: string) => {
    const userOriginInfo = await UserModel.findById(idUserOrigin);
    return userOriginInfo?.name;
} */