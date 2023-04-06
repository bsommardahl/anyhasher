import './App.css';
import { useState } from 'react';
import { Button, TextField, Paper } from '@material-ui/core';
import getHashedValue from './services/api.client';

function App() {
  const [valeToHash, setValueToHash] = useState('');
  const [hashedValue, setHashedValue] = useState('');

  function updateValueToHash(e) {
    setValueToHash(e.target.value);
  }

  async function getHashedValueFromApi() {
    const hash = await getHashedValue(valeToHash);
    setHashedValue(hash);
  }

  return (
    <div className="Div">
      <h2 id="page-title">AnyHasher</h2>
      <Paper>
        <TextField
          fullWidth
          color="primary"
          size="medium"
          label="Enter value to hash"
          variant="outlined"
          value={valeToHash}
          onChange={updateValueToHash}
        />
      </Paper>
      <br />
      <Button
        variant="contained"
        color="primary"
        size="medium"
        disabled={!valeToHash}
        onClick={getHashedValueFromApi}
      >
        GET HASH
      </Button>
      <p style={{ fontWeight: 'bolder' }}>{hashedValue}</p>
    </div>
  );
}

export default App;
