import express from 'express';
import cors from 'cors';

import hashRoutes from './routes/hash.routes.js';

const app = express();
const port = process.env.PORT || 5000;

app.use(cors());
app.use('/hash', hashRoutes);

app.listen(port, () => {
    console.log(`Host listening at http://localhost:${port}`);
});

