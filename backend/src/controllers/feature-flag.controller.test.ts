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