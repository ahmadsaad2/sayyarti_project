import Joi from 'joi';

export function validateUser(obj) {
    const schema = Joi.object({
        name: Joi.string().min(3).max(255),
        email: Joi.string().email().required(),
        password: Joi.string().min(8).required()
    });

    return schema.validate(obj);
}
export function validateResetPassword(obj) {
    const schema = Joi.object({
        email: Joi.string().email().required(),
        password: Joi.string().min(8).required(),
        otp: Joi.string().regex(/^\d{6}$/).required()
    });
}
export function validateEmail(obj) {
    const schema = Joi.object({
        email: Joi.string().email().required()
    });
}
// module.exports ={
//     validateResetPassword,
//     validateUser,
//     validateEmail
// }
