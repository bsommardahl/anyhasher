module.exports = {
    apps : [
        {
          name: "anyhasher",
          script: "./server.js",
          watch: true,
          env: {
              "PORT": 80,
              "NODE_ENV": "production"
          }
        }
    ]
  }