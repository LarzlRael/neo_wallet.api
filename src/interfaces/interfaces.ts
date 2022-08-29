export interface IPayload {
    uid: string;
    iat: number;
    exp: number;
    email: number;
}
export interface IWallet {
    _id: any;
    balance: number;
    walletName: string;
    idUser: string;
    block: boolean;
}

export interface IUser {
    uid:string,
    name: string;
    email: string;
    password?: string;
    online?: boolean;
    activated?: boolean;
    devices?: String[],
    wallets: IWallet[]
}