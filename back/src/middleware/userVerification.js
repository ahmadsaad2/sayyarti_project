import jwt from 'jsonwebtoken';

export function verifyToken(req, res, next) {
    const authHeader = req.headers.authorization;

    if (authHeader) {
        const token = authHeader.split(' ')[1]; // Extract token from 'Bearer <token>'
        try {
            const decoded = jwt.verify(token, process.env.SECRET_KEY);
            req.user = decoded; // Attach the decoded payload to req.user
            next();
        } catch (error) {
            res.status(401).json({ message: 'Invalid token' });
        }
    } else {
        res.status(401).json({ message: 'No token provided' });
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