import { Socket } from 'dgram';
import { io } from '..';
import UserModel from '../models/userModel';



io.on('connection', (socket: Socket) => {

    /*     console.log('a user connected'); */


    socket.on('transaction-real-time', async (payload) => {

        console.log('emitiendo los valores');
        io.emit('transaction-real-time', payload);

    });

    socket.on('verify-account-activate', async ({ email }) => {

        const activateuser = await UserModel.findOne({ email });

        io.emit('verify-account-activate', { activate: activateuser?.activated });

    });

    socket.on('disconnect', () => {
        /* console.log('user disconnected'); */
    });
});




