import { createHash } from 'crypto';
import featureFlagService from '../services/feature-flag.service';
import hashHistoryService from '../services/hash-history.service';

class HashController {
    getHash(request, response) {
        const { value } = request.params;
        if(!value) {
            response.status(400).send('the value cannot be empty');
            return;
        }

        const hashedValue = createHash('md5').update(request.params.value).digest('hex');

        if (featureFlagService.isEnabled('hash_history')) {
            hashHistoryService.logHashOperation(value, hashedValue);
        }

        if (featureFlagService.isEnabled('enhanced_response')) {
            const enhancedResponse = {
                input: value,
                hash: hashedValue,
                algorithm: 'md5',
                timestamp: new Date().toISOString(),
                length: hashedValue.length
            };
            response.status(200).json(enhancedResponse);
        } else {
            response.status(200).send(hashedValue);
        }
    }

    getHistory(request, response) {
        if (!featureFlagService.isEnabled('hash_history')) {
            response.status(404).json({ error: 'Hash history feature is disabled' });
            return;
        }

        const limit = parseInt(request.query.limit as string, 10) || 10;
        const history = hashHistoryService.getRecentOperations(limit);
        response.status(200).json(history);
    }
}

const hashController = new HashController();
export default hashController;
