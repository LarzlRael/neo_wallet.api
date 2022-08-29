"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.passwordChanged = exports.renderRecoveryForm = exports.verifiedEmail = exports.verifyCheck = exports.renderConfirmEmail = exports.sendEmailToRecoveryPassword = exports.SendEmailActivation = void 0;
const bcryptjs_1 = __importDefault(require("bcryptjs"));
const nodemailer_1 = __importDefault(require("nodemailer"));
const userModel_1 = __importDefault(require("../models/userModel"));
const jwt_1 = require("../helpers/jwt");
const transporter = nodemailer_1.default.createTransport({
    host: 'smtp.gmail.com',
    port: 465,
    secure: true,
    auth: {
        user: process.env.USER_MAIL_SERVER,
        pass: process.env.PASS_MAIL_SERVER // generated ethereal password
    },
});
transporter.verify(() => {
    console.log('Ready to send emails');
});
const SendEmailActivation = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const hostname = req.headers.host;
    const protocol = req.protocol;
    const myUrl = `${protocol}://${hostname}/sendmail`;
    try {
        const { email } = req.body;
        const token = yield jwt_1.generarJWT('', '5M', email);
        const navigateTo = `${myUrl}/verifycheck/${token}`;
        transporter.sendMail({
            from: 'N.E.O',
            to: email,
            subject: "Activacion de email",
            /* text: "Hello world?", // plain text body */
            html: htmlTemplate(email, navigateTo), // html body
        });
        res.json({
            ok: true,
            msg: 'email sent, review your email'
        });
    }
    catch (error) {
        res.status(400).json({ ok: false, msg: error });
    }
});
exports.SendEmailActivation = SendEmailActivation;
const sendEmailToRecoveryPassword = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const hostname = req.headers.host;
    const protocol = req.protocol;
    const myUrl = `${protocol}://${hostname}`;
    try {
        const { email } = req.body;
        const findEmail = yield userModel_1.default.findOne({ email: email });
        if (findEmail) {
            const token = yield jwt_1.generarJWT('', '3M', email);
            transporter.sendMail({
                from: 'N.E.O',
                to: email,
                subject: "Recuperacion de contraseña",
                /* text: "Hello world?", // plain text body */
                html: `<p>
            Para recuperar su contraseña ingrese aqui <a href="${myUrl}/sendmail/recoverypasswordform/${token}">recuperar contraseña</a>
            </p>`, // html body
            });
            res.json({
                ok: true,
                msg: 'email sent, review your email'
            });
        }
        else {
            res.status(400).json({ ok: false, msg: 'No hay ninguna cuenta registrada con ese correo' });
        }
    }
    catch (error) {
        res.status(400).json({ ok: false, msg: error });
    }
});
exports.sendEmailToRecoveryPassword = sendEmailToRecoveryPassword;
const renderConfirmEmail = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { token, email } = req.params;
    res.render('index', {
        token,
        email
    });
});
exports.renderConfirmEmail = renderConfirmEmail;
const verifyCheck = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const getUserWithThatEmail = yield userModel_1.default.findOne({ email: req.email });
    getUserWithThatEmail.activated = true;
    yield (getUserWithThatEmail === null || getUserWithThatEmail === void 0 ? void 0 : getUserWithThatEmail.save());
    // TODO emit the socket event
    var io = require('socket.io');
    res.redirect('/sendmail/verifiedemail');
    /* res.render('index'); */
});
exports.verifyCheck = verifyCheck;
const verifiedEmail = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    res.render('verifiedemail');
});
exports.verifiedEmail = verifiedEmail;
const renderRecoveryForm = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { token } = req.params;
    const getUserWithThatEmail = yield userModel_1.default.findOne({ email: req.email });
    console.log(getUserWithThatEmail);
    if (getUserWithThatEmail) {
        return res.render('recoveryPasswordForm', { token, email: req.email });
    }
    else {
        return res.send('Error');
    }
});
exports.renderRecoveryForm = renderRecoveryForm;
const passwordChanged = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { newPassword } = req.body;
    const getUserWithThatEmail = yield userModel_1.default.findOne({ email: req.email });
    if (getUserWithThatEmail) {
        const salt = bcryptjs_1.default.genSaltSync();
        getUserWithThatEmail.password = bcryptjs_1.default.hashSync(newPassword, salt);
        yield getUserWithThatEmail.save();
        return res.send('Contraseña cambiada correctamente');
    }
    else {
        res.send('Error');
    }
});
exports.passwordChanged = passwordChanged;
const htmlTemplate = (name, navigateTo) => {
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
};
//# sourceMappingURL=mailController.js.map