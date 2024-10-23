module.exports = {
    apps : [
        {
          name: "anyhasher",
          script: "./server.js",
          watch: true,
          env: {
              "PORT": 5000,
              "NODE_ENV": "production"
          }
        }
    ]
  }