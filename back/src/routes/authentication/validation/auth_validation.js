import Joi from 'joi';

function validateUser(obj) {
    const schema = Joi.object({
        email: Joi.string().email().required(),
        password: Joi.string().min(8).required()
    });

    return schema.validate(obj);
}
function validateResetPassword(obj){
    const schema = Joi.object({
        email: Joi.string().email().required(),
        password: Joi.string().min(8).required(),
        otp: Joi.string().regex(/^\d{6}$/).required()
    });
}
function validateEmail(obj){
    const schema = Joi.object({
        email: Joi.string().email().required()
    });
}
module.exports ={
    validateResetPassword,
    validateUser,
    validateEmail
}
