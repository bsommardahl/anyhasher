import featureFlagService from './feature-flag.service';

describe('FeatureFlagService', () => {
    beforeEach(() => {
        featureFlagService.disableFlag('enhanced_response');
        featureFlagService.disableFlag('hash_history');
    });

    describe('isEnabled', () => {
        it('should return false for unknown flags', () => {
            expect(featureFlagService.isEnabled('unknown_flag')).toBe(false);
        });

        it('should return default values for known flags', () => {
            expect(featureFlagService.isEnabled('enhanced_response')).toBe(false);
            expect(featureFlagService.isEnabled('hash_history')).toBe(false);
        });
    });

    describe('enableFlag and disableFlag', () => {
        it('should enable a flag', () => {
            featureFlagService.enableFlag('enhanced_response');
            expect(featureFlagService.isEnabled('enhanced_response')).toBe(true);
            expect(process.env.FEATURE_ENHANCED_RESPONSE).toBe('true');
        });

        it('should disable a flag', () => {
            featureFlagService.enableFlag('hash_history');
            expect(featureFlagService.isEnabled('hash_history')).toBe(true);

            featureFlagService.disableFlag('hash_history');
            expect(featureFlagService.isEnabled('hash_history')).toBe(false);
            expect(process.env.FEATURE_HASH_HISTORY).toBe('false');
        });
    });

    describe('getAllFlags', () => {
        it('should return all flags with descriptions', () => {
            const flags = featureFlagService.getAllFlags();

            expect(flags).toHaveLength(2);
            expect(flags.find(f => f.name === 'enhanced_response')).toEqual({
                name: 'enhanced_response',
                enabled: false,
                description: 'Returns hash with additional metadata'
            });
            expect(flags.find(f => f.name === 'hash_history')).toEqual({
                name: 'hash_history',
                enabled: false,
                description: 'Enables hash operation logging'
            });
        });
    });
});