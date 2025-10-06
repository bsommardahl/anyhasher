import express from 'express';
import cors from 'cors';

import hashRoutes from './routes/hash.routes';
import healthRoutes from './routes/health.routes';
import featureFlagRoutes from './routes/feature-flag.routes';

import 'dotenv/config';

const app = express();
const port = process.env.PORT || 5001;

app.use(cors());
app.use(express.json());
app.use('/hash', hashRoutes);
app.use('/health', healthRoutes);
app.use('/feature-flags', featureFlagRoutes);

app.listen(port, () => {
  // tslint:disable-next-line
  console.log(`Host listening on port ${port}`);
});

