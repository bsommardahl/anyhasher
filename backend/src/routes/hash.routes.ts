import { Router } from 'express';
import hashController from '../controllers/hash.controller';

const router = Router();

router.get('/history', hashController.getHistory);

router
    .route('/:value')
    .get(hashController.getHash);

export default router;
