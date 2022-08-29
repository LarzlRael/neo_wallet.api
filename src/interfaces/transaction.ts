export interface ITransaction {
    originUser: string;
    destinyUser:string;
    targetUser: string;
    amount: number;
    
    userOriginWallet: string,
    userTargetWallet: string
}