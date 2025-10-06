import featureFlagService from '../services/feature-flag.service';

class FeatureFlagController {
  getAllFlags(request, response) {
    try {
      const flags = featureFlagService.getAllFlags();
      response.status(200).json(flags);
    } catch (error) {
      response.status(500).json({ error: 'Failed to retrieve feature flags' });
    }
  }

  getFlag(request, response) {
    try {
      const { flagName } = request.params;
      const enabled = featureFlagService.isEnabled(flagName);

      response.status(200).json({
        flagName,
        enabled
      });
    } catch (error) {
      response.status(500).json({ error: 'Failed to retrieve feature flag' });
    }
  }
}

const featureFlagController = new FeatureFlagController();
export default featureFlagController;
