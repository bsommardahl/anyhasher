export default async function getHashedValue(value) {
  const apiHost = process.env.REACT_APP_API_URL || 'http://localhost:5001';
  const response = await fetch(`${apiHost}/hash/${value}`);
  const hash = await response.text();
  return hash;
}
