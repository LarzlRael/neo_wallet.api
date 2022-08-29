import jwt, { verify } from 'jsonwebtoken';
import { NextFunction, Request, Response } from 'express';
import { IPayload } from '../interfaces/interfaces';
import UserModel from '../models/userModel';


export const validarJWT = (req: Request, res: Response, next: NextFunction) => {

    //Leer token

    const token = req.header('x-token');

    if (!token) {
        return res.status(401).json({
            ok: false,
            msg: 'No hay token en la peticion'
        });
    }

    try {
        const { uid } = jwt.verify(token, process.env.JWT_KEY!) as IPayload;
        req.uid = uid;

        next();


    } catch (error) {
        return res.status(401).json({
            ok: false,
            msg: 'Token no valido'
        })
    }

}
export const validarJWTEmail = (req: Request, res: Response, next: NextFunction) => {

    //Leer token

    const { token } = req.params;

    if (!token) {
        return res.status(401).json({
            ok: false,
            msg: 'No hay token en la peticion'
        });
    }

    try {
        const { email } = jwt.verify(token, process.env.JWT_KEY!) as IPayload;
        req.email = email;

        next();


    } catch (error) {
        return res.status(401).send('Hubo un error');
    }

}
export const validateIfEmailExists = async (req: Request, res: Response, next: NextFunction) => {

    const { email } = req.body;

    const verfyEmail = await UserModel.findOne({ email: req.email != null ? req.email : email });

    if (!verfyEmail) {
        return res.status(401).json({
            ok: false,
            msg: 'Email no valido'
        });
    }

    next();

}
