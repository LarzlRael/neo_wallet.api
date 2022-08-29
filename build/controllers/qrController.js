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
exports.generateQRLogo = exports.generateQR = void 0;
const qrcode_1 = __importDefault(require("qrcode"));
const { createCanvas, loadImage } = require('canvas');
const generateQR = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { url } = req.body;
    if (url.length === 0) {
        res.json({
            ok: false,
            msg: 'El url ingresado esta vacio'
        });
    }
    const srcImage = yield qrcode_1.default.toDataURL(url, {
        scale: 10,
        /* color: {
            dark: '#ffffff',
            light: '#1B242D',
        }, */
        margin: 1,
    });
    const onlyBase64Png = srcImage.split(',');
    res.json({
        ok: true,
        srcImage: onlyBase64Png[1]
    });
});
exports.generateQR = generateQR;
const generateQRLogo = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const image = 'https://negocioexitoso.online/wp-content/uploads/2021/06/logo-blanco-1Kx1K-150x150.png';
    const { url } = req.body;
    const srcImage = yield create_qrcode(url, image);
    const onlyBase64Png = srcImage.split(',');
    res.json({
        ok: true,
        srcImage: onlyBase64Png[1]
    });
});
exports.generateQRLogo = generateQRLogo;
function create_qrcode(dataForQRcode, center_image, width = 200, cwidth = 100) {
    return __awaiter(this, void 0, void 0, function* () {
        // grab data you want on qrcode here
        const cvs = createCanvas(1, 1);
        const url = yield qrcode_1.default.toCanvas(cvs, dataForQRcode, {
            errorCorrectionLevel: 'H',
            /* margin: 1, */
            color: {
                dark: '#ffffff',
                light: '#1B242D', // white background
            },
            /* scale: 7 */
        });
        const canvas = createCanvas(width, width);
        const ctx = canvas.getContext("2d");
        const img = yield loadImage(center_image);
        ctx.drawImage(url, 0, 0, 108, 108, 0, 0, width, width);
        const center = (width - cwidth) / 2;
        ctx.drawImage(img, center, center, cwidth, cwidth);
        return canvas.toDataURL("image/png");
    });
}
//# sourceMappingURL=qrController.js.map