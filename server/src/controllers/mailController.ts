import { Request, Response } from 'express';
import bcrypt from 'bcryptjs';
import nodemailer from 'nodemailer';
import UserModel from '../models/userModel';
import { generarJWT, comprobarJWT } from '../helpers/jwt';



const transporter = nodemailer.createTransport({
    host: 'smtp.gmail.com',
    port: 465,
    secure: true, // true for 465, false for other ports
    auth: {
        user: process.env.USER_MAIL_SERVER, // generated ethereal user
        pass: process.env.PASS_MAIL_SERVER // generated ethereal password
    },
});

transporter.verify(() => {
    console.log('Ready to send emails');
})


export const SendEmailActivation = async (req: Request, res: Response) => {

    const hostname = req.headers.host;
    const protocol = req.protocol;

    const myUrl = `${protocol}://${hostname}/sendmail`;


    try {
        const { email } = req.body;
        const token = await generarJWT('', '5M', email);
        const navigateTo = `${myUrl}/verifycheck/${token}`;

        transporter.sendMail({
            from: 'N.E.O', // sender address
            to: email, // list of receivers
            subject: "Activacion de email", // Subject line
            /* text: "Hello world?", // plain text body */

            html: htmlTemplate(email, navigateTo), // html body

        });
        res.json({
            ok: true,
            msg: 'email sent, review your email'
        })
    } catch (error) {
        res.status(400).json({ ok: false, msg: error })

    }
}
export const sendEmailToRecoveryPassword = async (req: Request, res: Response) => {


    const hostname = req.headers.host;
    const protocol = req.protocol;

    const myUrl = `${protocol}://${hostname}`;

    try {
        const { email } = req.body;

        const findEmail = await UserModel.findOne({ email: email });

        if (findEmail) {

            const token = await generarJWT('', '3M', email);

            transporter.sendMail({
                from: 'N.E.O', // sender address
                to: email, // list of receivers
                subject: "Recuperacion de contraseña", // Subject line
                /* text: "Hello world?", // plain text body */
                html: `<p>
            Para recuperar su contraseña ingrese aqui <a href="${myUrl}/sendmail/recoverypasswordform/${token}">recuperar contraseña</a>
            </p>`, // html body
            });
            res.json({
                ok: true,
                msg: 'email sent, review your email'
            });
        } else {
            res.status(400).json({ ok: false, msg: 'No hay ninguna cuenta registrada con ese correo' })
        }
    } catch (error) {
        res.status(400).json({ ok: false, msg: error })

    }
}


export const renderConfirmEmail = async (req: Request, res: Response) => {

    const { token, email } = req.params;

    res.render('index', {
        token,
        email
    });
}

export const verifyCheck = async (req: Request, res: Response) => {


    const getUserWithThatEmail = await UserModel.findOne({ email: req.email });

    getUserWithThatEmail!.activated = true;

    await getUserWithThatEmail?.save();


    // TODO emit the socket event

    var io = require('socket.io');
    res.redirect('/sendmail/verifiedemail');



    /* res.render('index'); */
}


export const verifiedEmail = async (req: Request, res: Response) => {
    res.render('verifiedemail');
}

export const renderRecoveryForm = async (req: Request, res: Response) => {

    const { token } = req.params;

    const getUserWithThatEmail = await UserModel.findOne({ email: req.email });
    console.log(getUserWithThatEmail);

    if (getUserWithThatEmail) {
        return res.render('recoveryPasswordForm', { token, email: req.email });

    } else {
        return res.send('Error');
    }

}

export const passwordChanged = async (req: Request, res: Response) => {

    const { newPassword } = req.body;

    const getUserWithThatEmail = await UserModel.findOne({ email: req.email });

    if (getUserWithThatEmail) {

        const salt = bcrypt.genSaltSync();

        getUserWithThatEmail.password = bcrypt.hashSync(
            newPassword, salt
        );

        await getUserWithThatEmail!.save();
        return res.send('Contraseña cambiada correctamente');


    } else {
        res.send('Error');
    }


}

const htmlTemplate = (name: string, navigateTo: string): string => {

    return `
    <body>

    <div class="container" style="
    width: 90%;
    margin: auto;
    font-family: Arial, Helvetica, sans-serif;
        -webkit-box-shadow: 1px 1px 26px -4px #1b242d;
        box-shadow: 1px 1px 26px -4px #1b242d;
        ">
        <div class="header" style="border-top: 1px solid #ccc;
        background: #1b242d;
        height:150px;
        display: flex;
        justify-content: center;
        align-items: center;
        ">
            <img src="https://negocioexitoso.online/wp-content/uploads/2021/06/logo-blanco-1Kx1K-150x150.png"
                style="height: 70%;" alt="">

        </div>

        <div class="body" style="padding: 1rem;">
            <p>${name}</p>
            <p>Para activar su cuenta en neo, por favor verifica tu email, Tu cuenta no se puede activar hasta que tu
                direccion
                de correo electronico este confirmado.</p>

            <div style="display: flex;
            width: 100%;
            justify-content: center;
            margin: 2rem 0;
            ">
                <a href="${navigateTo}" 
                style="
            text-decoration: none;
            padding: 1rem 3rem;
            color: white;
            background: #1b242d;
            text-align: center;
            border: none;
            font-weight: bold;
            font-size: 0.9rem;
            border-radius: 40px;
            transition: all 0.3s;
            ">Confimar tu email</a>
            </div>
        </div>
    </div>
</body>
    `;
}