import featureFlagController from './feature-flag.controller';
import featureFlagService from '../services/feature-flag.service';

jest.mock('../services/feature-flag.service');

describe('FeatureFlagController', () => {
    let mockRequest: any;
    let mockResponse: any;

    beforeEach(() => {
        mockRequest = {};
        mockResponse = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn(),
            send: jest.fn()
        };
        jest.clearAllMocks();
    });

    describe('getAllFlags', () => {
        it('should return all feature flags', () => {
            const mockFlags = [
                { name: 'enhanced_response', enabled: false, description: 'Returns hash with additional metadata' },
                { name: 'hash_history', enabled: true, description: 'Enables hash operation logging' }
            ];
            (featureFlagService.getAllFlags as jest.Mock).mockReturnValue(mockFlags);

            featureFlagController.getAllFlags(mockRequest, mockResponse);

            expect(mockResponse.status).toHaveBeenCalledWith(200);
            expect(mockResponse.json).toHaveBeenCalledWith(mockFlags);
        });
    });

    describe('updateFlag', () => {
        it('should enable a feature flag', () => {
            mockRequest.params = { flagName: 'enhanced_response' };
            mockRequest.body = { enabled: true };

            featureFlagController.updateFlag(mockRequest, mockResponse);

            expect(featureFlagService.enableFlag).toHaveBeenCalledWith('enhanced_response');
            expect(mockResponse.status).toHaveBeenCalledWith(200);
            expect(mockResponse.json).toHaveBeenCalledWith({
                flagName: 'enhanced_response',
                enabled: true,
                message: "Feature flag 'enhanced_response' enabled"
            });
        });

        it('should disable a feature flag', () => {
            mockRequest.params = { flagName: 'hash_history' };
            mockRequest.body = { enabled: false };

            featureFlagController.updateFlag(mockRequest, mockResponse);

            expect(featureFlagService.disableFlag).toHaveBeenCalledWith('hash_history');
            expect(mockResponse.status).toHaveBeenCalledWith(200);
            expect(mockResponse.json).toHaveBeenCalledWith({
                flagName: 'hash_history',
                enabled: false,
                message: "Feature flag 'hash_history' disabled"
            });
        });

        it('should return error for invalid enabled value', () => {
            mockRequest.params = { flagName: 'test_flag' };
            mockRequest.body = { enabled: 'invalid' };

            featureFlagController.updateFlag(mockRequest, mockResponse);

            expect(mockResponse.status).toHaveBeenCalledWith(400);
            expect(mockResponse.json).toHaveBeenCalledWith({
                error: 'enabled field must be a boolean'
            });
        });
    });

    describe('getFlag', () => {
        it('should return specific flag status', () => {
            mockRequest.params = { flagName: 'enhanced_response' };
            (featureFlagService.isEnabled as jest.Mock).mockReturnValue(true);

            featureFlagController.getFlag(mockRequest, mockResponse);

            expect(featureFlagService.isEnabled).toHaveBeenCalledWith('enhanced_response');
            expect(mockResponse.status).toHaveBeenCalledWith(200);
            expect(mockResponse.json).toHaveBeenCalledWith({
                flagName: 'enhanced_response',
                enabled: true
            });
        });
    });
});