export async function getHashedValue(value) {
    const apiHost = process.env.REACT_APP_API_HOST || 'localhost';
    const response = await fetch(`http://${apiHost}:5000/hash/${value}`);
    const hash = await response.text();
    return hash;
}
