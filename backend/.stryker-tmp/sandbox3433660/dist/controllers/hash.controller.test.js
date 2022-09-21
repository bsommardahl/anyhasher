"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const hash_controller_1 = __importDefault(require("./hash.controller"));
function createResponse() {
    return {
        statusCode: null,
        body: null,
        status: function (code) {
            this.statusCode = code;
            return {
                send: function (body) {
                    this.body = body;
                }
            };
        }
    };
}
function createRequest(object) {
    return {
        params: {
            ...object.params
        }
    };
}
describe('hashController', () => {
    test('should return the hashed value with status 200', () => {
        // Arrange
        const value = 'byron sommardahl';
        const request = createRequest({
            params: {
                value
            }
        });
        const response = createResponse();
        // Act
        hash_controller_1.default.getHash(request, response);
        // Assert
        expect(response.statusCode).toEqual(200);
    });
    test('should return status 400', () => {
        // Arrange
        const value = '';
        const request = createRequest({
            params: {
                value
            }
        });
        const response = createResponse();
        // Act
        hash_controller_1.default.getHash(request, response);
        // Assert
        expect(response.statusCode).toEqual(400);
    });
});
//# sourceMappingURL=hash.controller.test.js.map