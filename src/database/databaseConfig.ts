import mongoose from 'mongoose'

export const dbConnection = async () => {
  try {
    await mongoose.connect(process.env.DB_CNN_STRING!, {})
    console.log('DB online')
  } catch (error) {
    console.log(error)
    throw new Error(
      error
        ? 'Error a la hora de iniciar la base de datos'
        : 'Error a la hora de iniciar la base de datos',
    )
  }
}
