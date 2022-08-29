import { Request } from 'express';
import { Strategy, ExtractJwt, StrategyOptions } from 'passport-jwt';
import { IPayload } from '../interfaces/interfaces';

const opts: StrategyOptions = {
    jwtFromRequest: ExtractJwt.fromHeader('x-token'),
    secretOrKey: process.env.JWT_KEY,
}

export default new Strategy(opts, (payload: IPayload, done) => {

    return done(null, payload);

});