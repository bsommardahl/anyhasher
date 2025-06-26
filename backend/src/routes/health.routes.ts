import { Router } from 'express';
import healthController from '../controllers/health.controller';

const router = Router();

router
  .route('/')
  .get(healthController.getHealth);

export default router;
