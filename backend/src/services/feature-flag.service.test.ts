import featureFlagService from './feature-flag.service';

describe('FeatureFlagService', () => {

    describe('isEnabled', () => {
        it('should return false for unknown flags', () => {
            expect(featureFlagService.isEnabled('unknown_flag')).toBe(false);
        });

        it('should return default values for known flags', () => {
            expect(featureFlagService.isEnabled('enhanced_response')).toBe(false);
            expect(featureFlagService.isEnabled('hash_history')).toBe(false);
        });
    });

    describe('getAllFlags', () => {
        it('should return all flags with descriptions', () => {
            const flags = featureFlagService.getAllFlags();
            expect(flags).toHaveLength(0);
        });
    });
});