"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.io = void 0;
const express_1 = __importDefault(require("express"));
const app = express_1.default();
const morgan_1 = __importDefault(require("morgan"));
require('dotenv').config();
const path_1 = __importDefault(require("path"));
const express_handlebars_1 = __importDefault(require("express-handlebars"));
const passport_1 = __importDefault(require("passport"));
const passport_2 = __importDefault(require("./middlewares/passport"));
const auth_1 = __importDefault(require("./routes/auth"));
const wallet_1 = __importDefault(require("./routes/wallet"));
const transaction_1 = __importDefault(require("./routes/transaction"));
const qr_1 = __importDefault(require("./routes/qr"));
const mail_1 = __importDefault(require("./routes/mail"));
//DB config
require('./database/databaseConfig').dbConnection();
const port = process.env.PORT;
//Node server
const server = require('http').createServer(app);
exports.io = require('socket.io')(server);
require("./sockets/socket");
app.enable('trust proxy');
app.set('views', path_1.default.join(__dirname, 'views'));
app.engine('.hbs', express_handlebars_1.default({
    defaultLayout: 'main',
    layoutsDir: path_1.default.join(app.get('views'), 'layouts'),
    partialsDir: path_1.default.join(app.get('views'), 'partials'),
    extname: '.hbs'
}));
app.set('view engine', '.hbs');
//Lectura y parse de BODY
app.use(express_1.default.json());
app.use(express_1.default.urlencoded({ extended: false }));
app.use(morgan_1.default('dev'));
app.use(passport_1.default.initialize());
passport_1.default.use(passport_2.default);
//Index server index
const publicPath = path_1.default.resolve(__dirname, '../public');
app.use(express_1.default.static(publicPath));
//routes
app.use('/auth', auth_1.default);
app.use('/wallet', wallet_1.default);
app.use('/transactions', transaction_1.default);
app.use('/qr', qr_1.default);
app.use('/sendmail', mail_1.default);
server.listen(port, () => {
    console.log(`Server on port ${port}`);
});
//TODO add uploads file to image profile
//TODO add google signing 
//TODO ?report by month
//# sourceMappingURL=index.js.map