import jwt from 'jsonwebtoken';
import { IPayload } from '../interfaces/interfaces';

export const generarJWT = (uid: any, expiresIn: string | number = '24h', email: string = '') => {
    return new Promise((resolve, reject) => {
        const payload = { uid, email };

        jwt.sign(payload, process.env.JWT_KEY!, {
            expiresIn: expiresIn
        }, (err, token) => {
            if (err) {
                reject('No se pudo generar el JWT');
            } else {
                resolve(token);
            }
        });
    });
}


export const comprobarJWT = (token: string = '') => {

    try {
        const { uid } = jwt.verify(token, process.env.JWT_KEY!) as IPayload;
        return true;
    } catch (error) {
        return false
    }
}