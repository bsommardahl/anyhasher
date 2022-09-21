import express from 'express';
import cors from 'cors';

import hashRoutes from './routes/hash.routes';

const app = express();
const port = process.env.PORT || 5001;

app.use(cors());
app.use('/hash', hashRoutes);

app.listen(port, () => {
    // tslint:disable-next-line
    console.log(`Host listening on port ${port}`);
});

