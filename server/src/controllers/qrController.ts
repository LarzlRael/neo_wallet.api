import { Request, Response } from 'express';
import QRCode from 'qrcode';
const { createCanvas, loadImage } = require('canvas');

export const generateQR = async (req: Request, res: Response) => {

    const { url } = req.body;

    if (url.length === 0) {
        res.json({
            ok: false,
            msg: 'El url ingresado esta vacio'
        });
    }
    const srcImage = await QRCode.toDataURL(url, {
        scale: 10,
        /* color: {
            dark: '#ffffff',
            light: '#1B242D',
        }, */
        margin:1,

    });

    const onlyBase64Png = srcImage.split(',');
    res.json({
        ok: true,
        srcImage: onlyBase64Png[1]
    });
    

}





export const generateQRLogo = async (req: Request, res: Response) => {

    const image = 'https://negocioexitoso.online/wp-content/uploads/2021/06/logo-blanco-1Kx1K-150x150.png';
    const { url } = req.body;

    const srcImage = await create_qrcode(url, image);

    const onlyBase64Png = srcImage.split(',');
    res.json({
        ok: true,
        srcImage: onlyBase64Png[1]
    })
}

async function create_qrcode(dataForQRcode: any, center_image: any, width = 200, cwidth = 100) {
    // grab data you want on qrcode here
    const cvs = createCanvas(1, 1);
    const url = await QRCode.toCanvas(cvs, dataForQRcode, {
        errorCorrectionLevel: 'H',	// LMQH
        /* margin: 1, */
        color: {
            dark: '#ffffff',	// black pixels
            light: '#1B242D',	// white background
        },
        /* scale: 7 */
    });
    const canvas = createCanvas(width, width);
    const ctx = canvas.getContext("2d");
    const img = await loadImage(center_image);
    ctx.drawImage(url, 0, 0, 108, 108, 0, 0, width, width);
    const center = (width - cwidth) / 2;
    ctx.drawImage(img, center, center, cwidth, cwidth);
    return canvas.toDataURL("image/png");
}


