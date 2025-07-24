import { Router } from 'express';
import featureFlagController from '../controllers/feature-flag.controller';

const router = Router();

router.get('/', featureFlagController.getAllFlags);
router.get('/:flagName', featureFlagController.getFlag);
router.put('/:flagName', featureFlagController.updateFlag);

export default router;