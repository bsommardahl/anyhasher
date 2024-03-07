export async function getHashedValue(value) {
    const apiHost = 'http://localhost:5001';
    const response = await fetch(`${apiHost}/hash/${value}`);
    const hash = await response.text();
    return hash;
}
