import { Router } from 'express';
import hashController from '../controllers/hash.controller';

const router = Router();

router
    .route('/:value')
    .get(hashController.getHash);

export default router;
