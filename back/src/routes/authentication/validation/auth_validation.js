import Joi from 'joi';

export const validateUser = (data) => {
    const schema = Joi.object({
        email: Joi.string().email().required(),
        password: Joi.string().min(6).required(),
    });
    return schema.validate(data);
};

export const validateEmail = (data) => {
    const schema = Joi.object({
        email: Joi.string().email().required(),
    });
    return schema.validate(data);
};

export const validateResetPassword = (data) => {
    const schema = Joi.object({
        email: Joi.string().email().required(),
        otp: Joi.string().length(6).required(),
        password: Joi.string().min(6).required(),
    });
    return schema.validate(data);
};
