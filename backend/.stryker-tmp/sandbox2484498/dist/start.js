"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const cors_1 = require("cors");
const hash_routes_js_1 = require("./routes/hash.routes.js");
const app = (0, express_1.default)();
const port = process.env.PORT || 5001;
app.use((0, cors_1.default)());
app.use('/hash', hash_routes_js_1.default);
app.listen(port, () => {
    // tslint:disable-next-line
    console.log(`Host listening at http://localhost:${port}`);
});
