class HealthController {
  getHealth(request, response) {
    const healthStatus = {
      status: 'healthy',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      version: process.env.npm_package_version || '1.0.0'
    };

    response.status(200).send(healthStatus);
  }
}

const healthController = new HealthController();
export default healthController;
