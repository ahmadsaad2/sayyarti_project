import jwt from 'jsonwebtoken';

export function verifyToken(req, res, next) {
    const token = req.headers.token;
    if (token) {
        try {
            const decoded = jwt.verify(token, process.env.SECRET_KEY);
            req.user = decoded;
            next();
        } catch (error) {
            res.status(401).json({ message: 'invalid token ' })
        }
    } else {
        res.status(401).json({ message: 'no token provided' })
    }
}

//verify token & authorize the user
export function verifyTokenAndAuthorization(req, res, next) {
    verifyToken(req, res, () => {
        if (req.user.userId == req.params.id || req.user.role == 'admin') {
            next();
        } else {
            return res.status(403).json({ message: 'you are not allowed' });
        }
    });
}

//verify token & admin
export function verifyTokenAndAdmin(req, res, next) {
    verifyToken(req, res, () => {
        if (req.user.role === 'admin') {
            next();
        } else {
            return res.status(403).json({ message: 'you are not allowed, admin only' });
        }
    });
}

// module.exports = {
//     verifyToken,
//     verifyTokenAndAuthorization,
//     verifyTokenAndAdmin,
// }