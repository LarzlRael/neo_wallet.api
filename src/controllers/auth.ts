import { Request, Response } from 'express'
import { generarJWT } from '../helpers'
import { UserModel } from '../models/'
import bcrypt from 'bcryptjs'

export const registerUser = async (req: Request, res: Response) => {
  const { email, password } = req.body

  try {
    const existeEmail = await UserModel.findOne({ email })

    if (existeEmail) {
      return res.status(400).json({
        ok: false,
        msg: 'EL correo ya fue registrado',
      })
    }

    const usuario = new UserModel(req.body)

    //Encriptar contraseña
    const salt = bcrypt.genSaltSync()
    usuario.password = bcrypt.hashSync(password, salt)

    await usuario.save()

    //generar el JWT_KEY

    const token = await generarJWT(usuario.id)
    res.json({
      ok: true,
      usuario,
      token,
    })
  } catch (error) {
    console.log(error)
  }
}

export const login = async (req: Request, res: Response) => {
  const { password, email } = req.body

  const userExist = await UserModel.findOne({ email }).populate('wallets')

  if (!userExist) {
    return res.status(403).json({
      ok: false,
      msg: 'EL usuario no existe',
    })
  }
  const validPassword = bcrypt.compareSync(password, userExist.password!)
  if (!validPassword) {
    return res.status(403).json({
      ok: false,
      msg: 'Contraseña incorrecta',
    })
  }
  // generar token

  const token = await generarJWT(userExist.id)
  res.json({
    ok: true,
    usuario: userExist,
    token,
  })
}

export const renewToken = async (req: Request, res: Response) => {
  const { uid } = req

  // generar un nuevo JWT, generarJWT
  const token = await generarJWT(uid)

  // obtener el suaurio por el UID, Usuario.findbyId...
  const usuario = await UserModel.findById(uid).populate('wallets')
  res.json({
    ok: true,
    usuario,
    token,
  })
}

export const saveNewDevice = async (req: Request, res: Response) => {
  const { uid } = req
  const { deviceId } = req.body
  const userExist = await UserModel.findById(uid)

  const userDevices = userExist!.devices

  await vertifyUserBearer(deviceId)

  if (userDevices!.indexOf(deviceId) === -1) {
    userDevices!.push(deviceId)
    await userExist?.save()

    return res.json({
      ok: true,
      msg: 'nuevo id de dispositivo registrado',
    })
  } else {
    return res.json({
      ok: false,
      msg: 'El id ya fue registado',
    })
  }
}

const vertifyUserBearer = async (idDevice: string) => {
  const userExist = await UserModel.find({ devices: { $in: [idDevice] } })

  if (userExist.length == 0) {
    return
  }

  const filterDevices = userExist[0]!.devices!.filter(
    (device) => idDevice != device,
  )

  userExist[0].devices = filterDevices

  await userExist[0].save()
}

export const logout = async (req: Request, res: Response) => {
  const { deviceId } = req.params

  const getUserListDevices = await UserModel.findById(req.uid)

  getUserListDevices!.devices = getUserListDevices!.devices?.filter(
    (device) => deviceId != device,
  )

  await getUserListDevices?.save()

  return res.json({ ok: true, msg: 'Logout' })
}
