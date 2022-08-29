"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const passport_jwt_1 = require("passport-jwt");
const opts = {
    jwtFromRequest: passport_jwt_1.ExtractJwt.fromHeader('x-token'),
    secretOrKey: process.env.JWT_KEY,
};
exports.default = new passport_jwt_1.Strategy(opts, (payload, done) => {
    return done(null, payload);
});
//# sourceMappingURL=passport.js.map