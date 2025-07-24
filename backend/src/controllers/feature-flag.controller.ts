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

  updateFlag(request, response) {
    try {
      const { flagName } = request.params;
      const { enabled } = request.body;

      if (typeof enabled !== 'boolean') {
        response.status(400).json({ error: 'enabled field must be a boolean' });
        return;
      }

      if (enabled) {
        featureFlagService.enableFlag(flagName);
      } else {
        featureFlagService.disableFlag(flagName);
      }

      response.status(200).json({
        flagName,
        enabled,
        message: `Feature flag '${flagName}' ${enabled ? 'enabled' : 'disabled'}`
      });
    } catch (error) {
      response.status(500).json({ error: 'Failed to update feature flag' });
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
