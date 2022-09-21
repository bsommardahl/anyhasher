"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const hash_controller_js_1 = require("../controllers/hash.controller.js");
const router = (0, express_1.Router)();
router
    .route('/:value')
    .get(hash_controller_js_1.default.getHash);
exports.default = router;
