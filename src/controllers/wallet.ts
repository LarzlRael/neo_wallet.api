import { Request, Response, } from 'express';

import WalletModel from '../models/walletModel';
import UserModel from '../models/userModel';




export const createWallet = async (req: Request, res: Response) => {

    try {
        const { uid } = req;
        const newWallet = new WalletModel();

        newWallet.idUser = uid;
        newWallet.walletName = req.body.walletName;

        const newWalletCreated = await newWallet.save();

        const getUser = await UserModel.findById(uid);
        getUser?.wallets.push(newWalletCreated.id);
        await getUser?.save();

        res.json({
            ok: true,
            userWallets: newWalletCreated
        })
    } catch (error) {
        console.log(error);
    }

}
export const getWalletsByUser = async (req: Request, res: Response) => {

    try {
        const { uid } = req;
        const userWallets = await WalletModel.find({ idUser: uid }).sort('-createdAt');

        res.json({
            ok: true,
            userWallets
        })
    } catch (error) {
        console.log(error);
    }
}
export const renameWallet = async (req: Request, res: Response) => {

    try {
        const { uid } = req;

        // TODO revisar que la billetera pertenezca a esta persona
        // TODO check if the wallet is bearer of this user
        const { walletId } = req.body;
        const { newName } = req.body;

        const userWalletUpdated = await WalletModel.findOne({ _id: walletId });
        if (await verifyWalletOwner(uid, walletId)) {
            if (userWalletUpdated) {
                userWalletUpdated!.walletName = newName;
                await userWalletUpdated?.save();
                res.json({
                    ok: true,
                    userWalletUpdated
                })
            } else {
                res.status(400).json({
                    ok: false,
                    msg: 'No se econtro la billetera'
                })
            }
        } else {
            res.status(400).json({
                ok: false,
                msg: 'No puedes renombrar una billetera que no es tuya'
            })
        }

    } catch (error) {
        console.log(error);
    }

}

export const deleteWallet = async (req: Request, res: Response) => {

    try {
        const { walletId } = req.body;

        const { uid } = req;


        if (await verifyWalletOwner(uid, walletId)) {
            const currentWallet = await WalletModel.findById(walletId);

            if (currentWallet) {

                if (currentWallet.balance > 0) {
                    return res.status(400).json({
                        ok: false,
                        msg: 'Esta billetara aun tiene saldo, transfieralo a otra billetara'
                    });
                }

                const getUserOwnerWallet = await UserModel.findById(currentWallet.idUser);

                let walletIdTemp = walletId;

                getUserOwnerWallet!.wallets = getUserOwnerWallet!.wallets.filter((wallet) => walletIdTemp != wallet);

                await getUserOwnerWallet?.save();

                const walletDeleted = await WalletModel.findByIdAndDelete(walletId);

                return res.json({
                    ok: true,
                    msg: 'billetera Eliminada correctamente',
                    walletDeleted
                });


            } else {
                return res.status(400).json({
                    ok: false,
                    msg: 'La billetera no existe'
                });
            }
        } else {
            return res.status(400).json({
                ok: false,
                msg: 'no puedes borrar una billetera que no sea tuya'
            });
        }

    } catch (error) {
        console.log(error);
    }

}


export const verifyWalletOwner = async (idUser: string, idWallet: string): Promise<boolean> => {

    const verifyWallet = await WalletModel.findOne({ _id: idWallet }).sort('-createdAt');

    return (verifyWallet?.idUser == idUser);

}
