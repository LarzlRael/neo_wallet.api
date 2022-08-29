import express from 'express';
const app = express();
import morgan from 'morgan';
require('dotenv').config();
import path from 'path';
import expressHandleBars from 'express-handlebars';
import passport from 'passport';
import passportMiddleware from './middlewares/passport';

import authRoutes from './routes/auth';
import walletRoutes from './routes/wallet';
import transactionsRoutes from './routes/transaction';
import qrRoutes from './routes/qr';
import mailRoutes from './routes/mail';

//DB config
require('./database/databaseConfig').dbConnection();

const port = process.env.PORT;
//Node server

const server = require('http').createServer(app);
export const io = require('socket.io')(server);
import './sockets/socket';

app.enable('trust proxy');
app.set('views', path.join(__dirname, 'views'));
app.engine('.hbs', expressHandleBars({
    defaultLayout: 'main',
    layoutsDir: path.join(app.get('views'), 'layouts'),
    partialsDir: path.join(app.get('views'), 'partials'),
    extname: '.hbs'
}));
app.set('view engine', '.hbs');

//Lectura y parse de BODY
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(morgan('dev'))
app.use(passport.initialize());
passport.use(passportMiddleware);

//Index server index
const publicPath = path.resolve(__dirname, '../public');
app.use(express.static(publicPath));

//routes

app.use('/auth', authRoutes);
app.use('/wallet', walletRoutes);
app.use('/transactions', transactionsRoutes);
app.use('/qr', qrRoutes);
app.use('/sendmail', mailRoutes);






server.listen(port, () => {
    console.log(`Server on port ${port}`);
});


//TODO add uploads file to image profile
//TODO add google signing 
//TODO ?report by month



