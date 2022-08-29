import { Router } from 'express'
import { check } from 'express-validator'
import { generateQR, generateQRLogo } from '../controllers/qrController'
import { validarJWT, validarCampos } from '../middlewares'

const router = Router()

router.post(
  '/',
  [
    check('url', 'Ingrese un url valido').not().isEmpty(),
    validarCampos,
    validarJWT,
  ],
  generateQR,
)

export default router
