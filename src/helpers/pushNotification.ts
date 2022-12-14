import axios from 'axios'
import { IpushNotification } from '../interfaces'

export const sendPushNotification = async (
  devicesTargets: String[] | undefined,
  nameOrigin: any,
  saldo: string,
) => {
  const sendData: IpushNotification = {
    registration_ids: devicesTargets!,
    notification: {
      title: `Saldo recibido`,
      body: `EL usuario ${nameOrigin} te envio ${saldo} BS`,
      icon:
        'https://www.gstatic.com/devrel-devsite/prod/v4ff7513a940c844d7a200d0833ef676f25fef10662a3b57ca262bcf76cbd98e2/firebase/images/touchicon-180.png',
    },
  }

  try {
    await axios({
      method: 'POST',
      url: 'https://fcm.googleapis.com/fcm/send',
      data: sendData,
      headers: {
        Authorization: `key=${process.env.FIREBASE_TOKEN}`,
      },
    })
  } catch (error) {
    console.log(error)
  }
}
