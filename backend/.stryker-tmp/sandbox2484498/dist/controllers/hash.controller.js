"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const crypto_1 = require("crypto");
class HashController {
    getHash(request, response) {
        const { value } = request.params;
        if (!value) {
            response.status(400).send('the value cannot be empty');
            return;
        }
        const hashedValue = (0, crypto_1.createHash)('md5').update(request.params.value).digest('hex');
        response.status(200).send(hashedValue);
    }
}
const hashController = new HashController();
exports.default = hashController;
